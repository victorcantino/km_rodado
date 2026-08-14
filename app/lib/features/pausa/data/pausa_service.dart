import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../abastecimento/data/abastecimento_repository.dart';
import '../../jornada/data/jornada_repository.dart';
import 'pausa_repository.dart';

class PausaService {
  final PausaRepository _repository;
  final JornadaRepository _jornadaRepository;
  final AbastecimentoRepository _abastecimentoRepository;
  final DateTime Function() _agora;

  PausaService(
    this._repository,
    this._jornadaRepository,
    this._abastecimentoRepository, {
    DateTime Function()? agora,
  }) : _agora = agora ?? DateTime.now;

  Future<List<Pausa>> listarPorJornada(int jornadaId) {
    return _repository.listarPorJornada(jornadaId);
  }

  Future<Pausa?> buscarAbertaPorJornada(int jornadaId) {
    return _repository.buscarAbertaPorJornada(jornadaId);
  }

  Future<int> iniciarPausa({required int odometroInicio}) async {
    final jornada = await _jornadaRepository.buscarJornadaAberta();

    if (jornada == null) {
      throw Exception('Não existe Jornada aberta para iniciar uma Pausa.');
    }

    if (odometroInicio < 0) {
      throw Exception('O odômetro não pode ser negativo.');
    }
    final pausas = await _repository.listarPorJornada(jornada.id);
    final ultimoOdometro = _ultimoOdometroConhecido(jornada, pausas);
    if (odometroInicio < ultimoOdometro) {
      throw Exception('O odômetro não pode ser menor que o último registrado.');
    }

    final pausaId = await _repository.inserirSeNaoHouverAberta(
      PausasCompanion.insert(
        jornadaId: jornada.id,
        inicio: _agora(),
        odometroInicio: Value(odometroInicio),
      ),
    );

    if (pausaId == null) {
      throw Exception('Já existe uma Pausa aberta nesta Jornada.');
    }

    return pausaId;
  }

  Future<bool> finalizarPausa(int jornadaId, {required int odometroFim}) async {
    final pausa = await _repository.buscarAbertaPorJornada(jornadaId);

    if (pausa == null) {
      throw Exception('Não existe Pausa aberta nesta Jornada.');
    }

    final fim = _agora();

    if (fim.isBefore(pausa.inicio)) {
      throw Exception('O fim da Pausa não pode ser anterior ao início.');
    }

    if (odometroFim < 0) {
      throw Exception('O odômetro não pode ser negativo.');
    }
    var odometroMinimo = pausa.odometroInicio;
    if (odometroMinimo == null) {
      final jornada = await _jornadaRepository.buscarJornadaAberta();
      if (jornada == null || jornada.id != jornadaId) {
        throw Exception('Não existe Jornada aberta para finalizar a Pausa.');
      }
      final pausas = await _repository.listarPorJornada(jornadaId);
      odometroMinimo = _ultimoOdometroConhecido(
        jornada,
        pausas.where((registro) => registro.id != pausa.id).toList(),
      );
    }
    if (odometroFim < odometroMinimo) {
      throw Exception(
        'O odômetro final da Pausa não pode ser menor que o último registrado.',
      );
    }

    return _repository.atualizar(
      pausa.copyWith(fim: Value(fim), odometroFim: Value(odometroFim)),
    );
  }

  Future<bool> editarPausa({
    required Pausa pausa,
    required DateTime inicio,
    required int? odometroInicio,
    required DateTime? fim,
    required int? odometroFim,
    String? titulo,
    String? observacao,
  }) async {
    final jornada = await _jornadaRepository.buscarPorId(pausa.jornadaId);
    if (jornada == null) {
      throw Exception('A Jornada desta Pausa não foi encontrada.');
    }

    final pausas = await _repository.listarPorJornada(jornada.id);
    final pausaPersistida = pausas
        .where((item) => item.id == pausa.id)
        .firstOrNull;
    if (pausaPersistida == null) {
      throw Exception('A Pausa não foi encontrada.');
    }

    final aberta = pausaPersistida.fim == null;
    if (aberta && (fim != null || odometroFim != null)) {
      throw Exception(
        'Uma Pausa aberta deve ser encerrada ao retomar a Jornada.',
      );
    }
    if (!aberta && fim == null) {
      throw Exception('Informe o fim da Pausa concluída.');
    }
    if (pausaPersistida.odometroInicio != null && odometroInicio == null) {
      throw Exception('Informe o odômetro inicial da Pausa.');
    }
    if (pausaPersistida.odometroFim != null && odometroFim == null) {
      throw Exception('Informe o odômetro final da Pausa.');
    }
    if (odometroInicio != null && odometroInicio < 0 ||
        odometroFim != null && odometroFim < 0) {
      throw Exception('O odômetro não pode ser negativo.');
    }
    if (inicio.isBefore(jornada.dataHoraInicio)) {
      throw Exception(
        'O início da Pausa não pode ser anterior ao início da Jornada.',
      );
    }
    if (jornada.dataHoraFim == null && inicio.isAfter(_agora())) {
      throw Exception('O início da Pausa não pode estar no futuro.');
    }
    if (fim != null && fim.isBefore(inicio)) {
      throw Exception('O fim da Pausa não pode ser anterior ao início.');
    }
    if (fim != null &&
        jornada.dataHoraFim != null &&
        fim.isAfter(jornada.dataHoraFim!)) {
      throw Exception('O fim da Pausa não pode ultrapassar o fim da Jornada.');
    }
    if (fim != null && jornada.dataHoraFim == null && fim.isAfter(_agora())) {
      throw Exception('O fim da Pausa não pode estar no futuro.');
    }
    if (odometroInicio != null && odometroInicio < jornada.odometroInicio) {
      throw Exception(
        'O odômetro inicial da Pausa não pode ser menor que o da Jornada.',
      );
    }
    if (odometroInicio != null &&
        odometroFim != null &&
        odometroFim < odometroInicio) {
      throw Exception(
        'O odômetro final da Pausa não pode ser menor que o inicial.',
      );
    }
    if (jornada.odometroFim != null &&
        (odometroInicio != null && odometroInicio > jornada.odometroFim! ||
            odometroFim != null && odometroFim > jornada.odometroFim!)) {
      throw Exception(
        'O odômetro da Pausa não pode ultrapassar o fim da Jornada.',
      );
    }

    final outrasPausas = pausas
        .where((item) => item.id != pausaPersistida.id)
        .toList();
    _validarSobreposicao(inicio, fim, outrasPausas);

    final limiteConsulta = jornada.dataHoraFim ?? _agora();
    final abastecimentos = await _abastecimentoRepository
        .listarPorVeiculoNoIntervalo(
          jornada.veiculoId,
          jornada.dataHoraInicio,
          limiteConsulta,
        );
    final fatos = <_FatoOdometro>[
      _FatoOdometro(jornada.dataHoraInicio, jornada.odometroInicio),
      if (jornada.dataHoraFim != null && jornada.odometroFim != null)
        _FatoOdometro(jornada.dataHoraFim!, jornada.odometroFim!),
      for (final outra in outrasPausas) ...[
        if (outra.odometroInicio != null)
          _FatoOdometro(outra.inicio, outra.odometroInicio!),
        if (outra.fim != null && outra.odometroFim != null)
          _FatoOdometro(outra.fim!, outra.odometroFim!),
      ],
      for (final abastecimento in abastecimentos)
        _FatoOdometro(abastecimento.dataHora, abastecimento.odometro),
    ];
    if (odometroInicio != null) {
      _validarOdometro(inicio, odometroInicio, fatos);
    }
    if (fim != null && odometroFim != null) {
      _validarOdometro(fim, odometroFim, fatos);
    }

    final atualizada = pausaPersistida.copyWith(
      inicio: inicio,
      fim: Value(aberta ? null : fim),
      odometroInicio: Value(odometroInicio),
      odometroFim: Value(aberta ? null : odometroFim),
      titulo: Value(_normalizar(titulo)),
      observacao: Value(_normalizar(observacao)),
    );
    final sucesso = await _repository.atualizar(atualizada);
    if (!sucesso) throw Exception('Não foi possível atualizar a Pausa.');
    return true;
  }

  void _validarSobreposicao(
    DateTime inicio,
    DateTime? fim,
    List<Pausa> outras,
  ) {
    for (final outra in outras) {
      final outraFim = outra.fim;
      final comecaAntesDoFimDaOutra =
          outraFim == null || inicio.isBefore(outraFim);
      final terminaDepoisDoInicioDaOutra =
          fim == null || fim.isAfter(outra.inicio);
      if (comecaAntesDoFimDaOutra && terminaDepoisDoInicioDaOutra) {
        throw Exception('A Pausa não pode sobrepor outra Pausa.');
      }
    }
  }

  void _validarOdometro(
    DateTime instante,
    int odometro,
    List<_FatoOdometro> fatos,
  ) {
    final anteriores = fatos.where((fato) => !fato.instante.isAfter(instante));
    if (anteriores.any((fato) => fato.odometro > odometro)) {
      throw Exception(
        'O odômetro não pode regredir em relação ao registro anterior.',
      );
    }
    final posteriores = fatos.where(
      (fato) => !fato.instante.isBefore(instante),
    );
    if (posteriores.any((fato) => fato.odometro < odometro)) {
      throw Exception('O odômetro não pode ultrapassar um registro posterior.');
    }
  }

  String? _normalizar(String? texto) {
    final normalizado = texto?.trim();
    return normalizado == null || normalizado.isEmpty ? null : normalizado;
  }

  int _ultimoOdometroConhecido(Jornada jornada, List<Pausa> pausas) {
    for (final pausa in pausas.reversed) {
      final odometro = pausa.odometroFim ?? pausa.odometroInicio;
      if (odometro != null) return odometro;
    }
    return jornada.odometroInicio;
  }
}

class _FatoOdometro {
  final DateTime instante;
  final int odometro;

  const _FatoOdometro(this.instante, this.odometro);
}
