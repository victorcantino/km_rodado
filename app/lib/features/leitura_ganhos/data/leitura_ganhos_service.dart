import 'package:drift/drift.dart';

import '../../../core/constants/enums/status_jornada.dart';
import '../../../core/constants/enums/tipo_leitura_ganhos.dart';
import '../../../core/constants/enums/tipo_registro_ganhos.dart';
import '../../../core/database/app_database.dart';
import '../../jornada/data/jornada_repository.dart';
import '../../pausa/data/pausa_repository.dart';
import 'leitura_ganhos_repository.dart';

typedef ItemLeituraGanhosEntrada = ({
  int plataformaId,
  int valorAcumuladoCentavos,
  int quantidadeViagensAcumulada,
});

class LeituraGanhosService {
  final LeituraGanhosRepository _repository;
  final JornadaRepository _jornadaRepository;
  final PausaRepository _pausaRepository;
  final DateTime Function() _agora;

  LeituraGanhosService(
    this._repository,
    this._jornadaRepository,
    this._pausaRepository, {
    DateTime Function()? agora,
  }) : _agora = agora ?? DateTime.now;

  Future<List<Plataforma>> listarPlataformasAtivas() {
    return _repository.listarPlataformasAtivas();
  }

  Future<List<Plataforma>> listarPlataformas() =>
      _repository.listarPlataformas();

  Future<void> atualizarAtivacao(Map<int, bool> ativacoes) =>
      _repository.atualizarAtivacao(ativacoes);

  Future<List<Plataforma>> listarPlataformasParaLeitura(
    int jornadaId, {
    required bool leituraInicial,
  }) async {
    if (leituraInicial) return listarPlataformasAtivas();
    final acumuladas = await _repository.listarPlataformasDaLeituraInicial(
      jornadaId,
    );
    final individuaisAtivas = (await listarPlataformasAtivas()).where(
      (p) => p.tipoRegistroGanhos == TipoRegistroGanhos.individual,
    );
    return [...acumuladas, ...individuaisAtivas];
  }

  Future<Map<int, LeiturasGanhoPlataformaData>> buscarSugestoes(int jornadaId) {
    return _repository.buscarUltimosItensPorPlataforma(jornadaId);
  }

  Future<LeiturasGanho?> buscarLeituraInicial(int jornadaId) {
    return _repository.buscarPorTipo(jornadaId, TipoLeituraGanhos.inicial);
  }

  Future<LeiturasGanho?> buscarLeituraFinal(int jornadaId) {
    return _repository.buscarPorTipo(
      jornadaId,
      TipoLeituraGanhos.finalDaJornada,
    );
  }

  Future<LeiturasGanho?> buscarUltimaLeitura(int jornadaId) {
    return _repository.buscarUltimaLeitura(jornadaId);
  }

  Future<int> salvarLeituraInicial({
    required int jornadaId,
    required List<ItemLeituraGanhosEntrada> itens,
  }) async {
    await _validarJornadaAberta(jornadaId);
    await _validarItens(jornadaId, itens, usarLeituraInicial: false);

    if (await buscarLeituraInicial(jornadaId) != null) {
      throw Exception('Os ganhos iniciais desta Jornada já foram registrados.');
    }

    final agora = _agora();
    return _repository.salvarLeituraUnica(
      _criarLeitura(jornadaId, TipoLeituraGanhos.inicial, agora),
      TipoLeituraGanhos.inicial,
      (leituraId) => _criarItens(leituraId, itens),
    );
  }

  Future<int> salvarLeituraParcial({
    required int jornadaId,
    required int pausaId,
    required List<ItemLeituraGanhosEntrada> itens,
  }) async {
    await _validarJornadaAberta(jornadaId);

    if (await buscarLeituraInicial(jornadaId) == null) {
      throw Exception(
        'Registre os ganhos iniciais antes de uma leitura parcial.',
      );
    }

    if (await buscarLeituraFinal(jornadaId) != null) {
      throw Exception('A Jornada já possui uma leitura final.');
    }

    final pausa = await _repository.buscarPausa(pausaId);
    if (pausa == null || pausa.jornadaId != jornadaId) {
      throw Exception('A Pausa não pertence à Jornada da leitura.');
    }

    await _validarItens(jornadaId, itens, usarLeituraInicial: true);
    final agora = _agora();
    return _repository.salvarLeitura(
      _criarLeitura(
        jornadaId,
        TipoLeituraGanhos.parcial,
        agora,
        pausaId: pausaId,
      ),
      (leituraId) => _criarItens(leituraId, itens),
    );
  }

  Future<int> finalizarJornada({
    required int jornadaId,
    required int odometroFim,
    required List<ItemLeituraGanhosEntrada> itens,
    String? cidadeDestino,
    String? observacoes,
  }) async {
    final jornada = await _validarJornadaAberta(jornadaId);

    if (await buscarLeituraInicial(jornadaId) == null) {
      throw Exception(
        'Registre os ganhos iniciais antes de finalizar a Jornada.',
      );
    }

    if (await buscarLeituraFinal(jornadaId) != null) {
      throw Exception('A leitura final desta Jornada já foi registrada.');
    }

    if (await _pausaRepository.buscarAbertaPorJornada(jornadaId) != null) {
      throw Exception(
        'A Jornada não pode ser finalizada enquanto houver uma Pausa aberta.',
      );
    }

    final pausas = await _pausaRepository.listarPorJornada(jornadaId);
    var ultimoOdometro = jornada.odometroInicio;
    for (final pausa in pausas) {
      ultimoOdometro =
          pausa.odometroFim ?? pausa.odometroInicio ?? ultimoOdometro;
    }
    if (odometroFim < ultimoOdometro) {
      throw Exception(
        'O odômetro final não pode ser menor que o último registrado.',
      );
    }

    await _validarItens(jornadaId, itens, usarLeituraInicial: true);
    final agora = _agora();
    final jornadaFinalizada = jornada.copyWith(
      dataHoraFim: Value(agora),
      odometroFim: Value(odometroFim),
      cidadeDestino: Value(cidadeDestino),
      observacoes: Value(observacoes),
      status: StatusJornada.finalizada,
      quilometrosPercorridos: Value(odometroFim - jornada.odometroInicio),
      dataAtualizacao: agora,
    );

    return _repository.salvarLeituraFinalEFecharJornada(
      _criarLeitura(jornadaId, TipoLeituraGanhos.finalDaJornada, agora),
      (leituraId) => _criarItens(leituraId, itens),
      jornadaFinalizada,
    );
  }

  Future<Jornada> _validarJornadaAberta(int jornadaId) async {
    final jornada = await _jornadaRepository.buscarJornadaAberta();
    if (jornada == null || jornada.id != jornadaId) {
      throw Exception('A leitura exige uma Jornada aberta.');
    }
    return jornada;
  }

  Future<void> _validarItens(
    int jornadaId,
    List<ItemLeituraGanhosEntrada> itens, {
    required bool usarLeituraInicial,
  }) async {
    if (itens.isEmpty) {
      throw Exception('Informe ao menos uma plataforma acumulada.');
    }

    final ids = itens.map((item) => item.plataformaId).toSet();
    if (ids.length != itens.length) {
      throw Exception('Uma plataforma não pode se repetir na mesma leitura.');
    }
    if (itens.any((item) => item.valorAcumuladoCentavos < 0)) {
      throw Exception('O valor acumulado não pode ser negativo.');
    }
    if (itens.any((item) => item.quantidadeViagensAcumulada < 0)) {
      throw Exception('A quantidade acumulada não pode ser negativa.');
    }

    final plataformas = usarLeituraInicial
        ? await _repository.listarPlataformasDaLeituraInicial(jornadaId)
        : await _repository.listarPlataformasAtivas();
    final idsAcumulados = plataformas
        .where(
          (plataforma) =>
              plataforma.tipoRegistroGanhos == TipoRegistroGanhos.acumulado,
        )
        .map((plataforma) => plataforma.id)
        .toSet();
    if (ids.length != idsAcumulados.length || !ids.containsAll(idsAcumulados)) {
      throw Exception('Informe uma vez cada plataforma acumulada ativa.');
    }
  }

  LeiturasGanhosCompanion _criarLeitura(
    int jornadaId,
    TipoLeituraGanhos tipo,
    DateTime agora, {
    int? pausaId,
  }) {
    return LeiturasGanhosCompanion.insert(
      jornadaId: jornadaId,
      pausaId: Value(pausaId),
      dataHora: agora,
      tipo: tipo,
      dataCriacao: Value(agora),
    );
  }

  List<LeiturasGanhoPlataformaCompanion> _criarItens(
    int leituraId,
    List<ItemLeituraGanhosEntrada> itens,
  ) {
    return [
      for (final item in itens)
        LeiturasGanhoPlataformaCompanion.insert(
          leituraGanhosId: leituraId,
          plataformaId: item.plataformaId,
          valorAcumuladoCentavos: item.valorAcumuladoCentavos,
          quantidadeViagensAcumulada: item.quantidadeViagensAcumulada,
        ),
    ];
  }

  Future<LeiturasGanho?> buscarLeitura(int leituraId) {
    return _repository.buscarLeitura(leituraId);
  }

  Future<List<LeiturasGanhoPlataformaData>> listarItens(int leituraId) {
    return _repository.listarItens(leituraId);
  }
}
