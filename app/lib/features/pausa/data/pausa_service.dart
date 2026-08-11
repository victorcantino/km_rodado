import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../jornada/data/jornada_repository.dart';
import 'pausa_repository.dart';

class PausaService {
  final PausaRepository _repository;
  final JornadaRepository _jornadaRepository;
  final DateTime Function() _agora;

  PausaService(
    this._repository,
    this._jornadaRepository, {
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

  Future<bool> editarTitulo(Pausa pausa, String titulo) {
    final tituloNormalizado = titulo.trim();

    return _repository.atualizar(
      pausa.copyWith(
        titulo: Value(tituloNormalizado.isEmpty ? null : tituloNormalizado),
      ),
    );
  }

  int _ultimoOdometroConhecido(Jornada jornada, List<Pausa> pausas) {
    for (final pausa in pausas.reversed) {
      final odometro = pausa.odometroFim ?? pausa.odometroInicio;
      if (odometro != null) return odometro;
    }
    return jornada.odometroInicio;
  }
}
