import 'package:drift/drift.dart';
import '../../../core/constants/enums/status_jornada.dart';
import '../../../core/constants/enums/tipo_leitura_ganhos.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/daos/leitura_ganhos_dao.dart';
import '../../../core/database/daos/passe_plataforma_dao.dart';
import '../../leitura_ganhos/data/leitura_ganhos_repository.dart';
import '../../ganho_individual/data/ganho_individual_repository.dart';
import '../../pausa/data/pausa_repository.dart';
import '../../passe_plataforma/data/passe_plataforma_repository.dart';

import 'jornada_repository.dart';
import 'resumo_jornada.dart';

class JornadaService {
  final JornadaRepository _repository;
  final PausaRepository _pausaRepository;
  final LeituraGanhosRepository? _leituraGanhosRepository;
  final GanhoIndividualRepository? _ganhoIndividualRepository;
  final PassePlataformaRepository? _passePlataformaRepository;

  JornadaService(
    this._repository,
    this._pausaRepository, [
    this._leituraGanhosRepository,
    this._ganhoIndividualRepository,
    this._passePlataformaRepository,
  ]);

  Future<Jornada?> jornadaAberta() {
    return _repository.buscarJornadaAberta();
  }

  Future<Jornada?> ultimaJornadaFinalizada() {
    return _repository.buscarUltimaJornadaFinalizada();
  }

  Future<ResumoJornada?> resumoUltimaJornada() async {
    final jornada = await _repository.buscarUltimaJornadaFinalizada();
    final leituraRepository = _leituraGanhosRepository;
    if (jornada == null ||
        jornada.dataHoraFim == null ||
        jornada.odometroFim == null ||
        leituraRepository == null) {
      return null;
    }

    final pausas = await _pausaRepository.listarPorJornada(jornada.id);
    final snapshots = await leituraRepository.listarSnapshotsDaJornada(
      jornada.id,
    );
    final totaisIndividuais =
        await _ganhoIndividualRepository?.totalizarPorJornada(jornada.id) ??
        const [];
    final passes =
        await _passePlataformaRepository?.listarPorJornada(jornada.id) ??
        const [];
    final duracaoTotal = _duracaoNaoNegativa(
      jornada.dataHoraFim!.difference(jornada.dataHoraInicio),
    );
    final tempoPausa = pausas.fold(Duration.zero, (total, pausa) {
      final fim = pausa.fim;
      if (fim == null) return total;
      return total + _duracaoNaoNegativa(fim.difference(pausa.inicio));
    });
    final tempoAtivo = _duracaoNaoNegativa(duracaoTotal - tempoPausa);
    final quilometrosTotal = (jornada.odometroFim! - jornada.odometroInicio)
        .clamp(0, 1 << 62);
    final odometrosCompletos = pausas.every(
      (pausa) => pausa.odometroInicio != null && pausa.odometroFim != null,
    );
    final quilometrosEmPausa = odometrosCompletos
        ? pausas.fold<int>(
            0,
            (total, pausa) =>
                total +
                (pausa.odometroFim! - pausa.odometroInicio!).clamp(0, 1 << 62),
          )
        : null;
    final quilometrosAtivos = quilometrosEmPausa == null
        ? null
        : (quilometrosTotal - quilometrosEmPausa).clamp(0, 1 << 62);

    return ResumoJornada(
      jornada: jornada,
      duracaoTotal: duracaoTotal,
      tempoPausa: tempoPausa,
      tempoAtivo: tempoAtivo,
      quilometrosTotal: quilometrosTotal,
      quilometrosEmPausa: quilometrosEmPausa,
      quilometrosAtivos: quilometrosAtivos,
      resultadosPlataformas: [
        ..._calcularResultadosPlataformas(snapshots, passes),
        for (final total in totaisIndividuais)
          ResultadoPlataformaJornada(
            plataformaId: total.plataforma.id,
            nome: total.plataforma.nome,
            receitaCentavos: total.valorTotalCentavos,
            quantidadeViagens: total.quantidadeViagens,
          ),
      ]..sort((a, b) => a.nome.compareTo(b.nome)),
      passes: passes,
    );
  }

  List<ResultadoPlataformaJornada> _calcularResultadosPlataformas(
    List<SnapshotPlataforma> snapshots,
    List<PasseComPlataforma> passes,
  ) {
    final leituras = <int, LeiturasGanho>{};
    for (final snapshot in snapshots) {
      leituras[snapshot.leitura.id] = snapshot.leitura;
    }
    final ordenadas = leituras.values.toList()
      ..sort((a, b) {
        final porData = a.dataHora.compareTo(b.dataHora);
        return porData != 0 ? porData : a.id.compareTo(b.id);
      });
    final indiceInicial = ordenadas.indexWhere(
      (leitura) => leitura.tipo == TipoLeituraGanhos.inicial,
    );
    final indiceFinal = ordenadas.lastIndexWhere(
      (leitura) => leitura.tipo == TipoLeituraGanhos.finalDaJornada,
    );
    if (indiceInicial < 0 || indiceFinal < indiceInicial) return const [];

    final sequencia = ordenadas.sublist(indiceInicial, indiceFinal + 1);
    final inicio = sequencia.first.dataHora;
    final fim = sequencia.last.dataHora;
    final plataformasComPasse = passes
        .where(
          (item) =>
              !item.passe.dataHora.isBefore(inicio) &&
              !item.passe.dataHora.isAfter(fim),
        )
        .map<int>((item) => item.passe.plataformaId)
        .toSet();
    final idsSequencia = sequencia.map((leitura) => leitura.id).toSet();
    final itensPorLeitura = <int, Map<int, SnapshotPlataforma>>{};
    for (final snapshot in snapshots) {
      if (!idsSequencia.contains(snapshot.leitura.id)) continue;
      itensPorLeitura.putIfAbsent(
        snapshot.leitura.id,
        () => {},
      )[snapshot.plataforma.id] = snapshot;
    }
    final itensIniciais = itensPorLeitura[sequencia.first.id] ?? const {};

    return [
      for (final inicial in itensIniciais.values)
        _calcularResultadoPlataforma(
          inicial,
          sequencia,
          itensPorLeitura,
          possuiPasse: plataformasComPasse.contains(inicial.plataforma.id),
        ),
    ]..sort((a, b) => a.nome.compareTo(b.nome));
  }

  ResultadoPlataformaJornada _calcularResultadoPlataforma(
    SnapshotPlataforma inicial,
    List<LeiturasGanho> sequencia,
    Map<int, Map<int, SnapshotPlataforma>> itensPorLeitura, {
    required bool possuiPasse,
  }) {
    var valorAnterior = inicial.item.valorAcumuladoCentavos;
    var viagensAnteriores = inicial.item.quantidadeViagensAcumulada;
    var calculavel = !possuiPasse;
    SnapshotPlataforma? finalSnapshot;

    for (final leitura in sequencia) {
      final atual = itensPorLeitura[leitura.id]?[inicial.plataforma.id];
      if (atual == null) {
        calculavel = false;
        continue;
      }
      if (atual.item.valorAcumuladoCentavos < valorAnterior ||
          atual.item.quantidadeViagensAcumulada < viagensAnteriores) {
        calculavel = false;
      }
      valorAnterior = atual.item.valorAcumuladoCentavos;
      viagensAnteriores = atual.item.quantidadeViagensAcumulada;
      if (leitura.tipo == TipoLeituraGanhos.finalDaJornada) {
        finalSnapshot = atual;
      }
    }

    return ResultadoPlataformaJornada(
      plataformaId: inicial.plataforma.id,
      nome: inicial.plataforma.nome,
      receitaCentavos: calculavel && finalSnapshot != null
          ? finalSnapshot.item.valorAcumuladoCentavos -
                inicial.item.valorAcumuladoCentavos
          : null,
      quantidadeViagens: calculavel && finalSnapshot != null
          ? finalSnapshot.item.quantidadeViagensAcumulada -
                inicial.item.quantidadeViagensAcumulada
          : null,
    );
  }

  Duration _duracaoNaoNegativa(Duration duracao) =>
      duracao.isNegative ? Duration.zero : duracao;

  Future<int> abrirJornada({
    required int usuarioId,
    required int veiculoId,
    required int odometro,
    required String cidadeOrigem,
  }) async {
    final aberta = await _repository.buscarJornadaAberta();

    if (aberta != null) {
      throw Exception('Já existe uma jornada aberta.');
    }

    final ultimaJornada = await _repository.buscarUltimaJornadaFinalizada();
    final ultimoOdometro = ultimaJornada?.odometroFim;

    if (ultimoOdometro != null && odometro < ultimoOdometro) {
      throw Exception(
        'O odômetro inicial não pode ser menor que o último registrado.',
      );
    }

    final jornada = JornadasCompanion.insert(
      usuarioId: usuarioId,
      veiculoId: veiculoId,
      dataHoraInicio: DateTime.now(),
      odometroInicio: odometro,
      cidadeOrigem: cidadeOrigem,
      status: StatusJornada.aberta,
    );

    return _repository.inserir(jornada);
  }

  Future<bool> fecharJornada({
    required int odometroFim,
    String? cidadeDestino,
    String? observacoes,
  }) async {
    final jornada = await _repository.buscarJornadaAberta();

    if (jornada == null) {
      throw Exception('Não existe jornada aberta.');
    }

    final pausaAberta = await _pausaRepository.buscarAbertaPorJornada(
      jornada.id,
    );

    if (pausaAberta != null) {
      throw Exception(
        'A Jornada não pode ser finalizada enquanto houver uma Pausa aberta.',
      );
    }

    final pausas = await _pausaRepository.listarPorJornada(jornada.id);
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

    final jornadaAtualizada = jornada.copyWith(
      dataHoraFim: Value(DateTime.now()),
      odometroFim: Value(odometroFim),
      cidadeDestino: Value(cidadeDestino),
      observacoes: Value(observacoes),
      status: StatusJornada.finalizada,
      quilometrosPercorridos: Value(odometroFim - jornada.odometroInicio),
      dataAtualizacao: DateTime.now(),
    );

    return _repository.atualizar(jornadaAtualizada);
  }
}
