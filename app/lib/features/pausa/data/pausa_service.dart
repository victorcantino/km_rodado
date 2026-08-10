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

  Future<int> iniciarPausa() async {
    final jornada = await _jornadaRepository.buscarJornadaAberta();

    if (jornada == null) {
      throw Exception('Não existe Jornada aberta para iniciar uma Pausa.');
    }

    final pausaId = await _repository.inserirSeNaoHouverAberta(
      PausasCompanion.insert(jornadaId: jornada.id, inicio: _agora()),
    );

    if (pausaId == null) {
      throw Exception('Já existe uma Pausa aberta nesta Jornada.');
    }

    return pausaId;
  }

  Future<bool> finalizarPausa(int jornadaId) async {
    final pausa = await _repository.buscarAbertaPorJornada(jornadaId);

    if (pausa == null) {
      throw Exception('Não existe Pausa aberta nesta Jornada.');
    }

    final fim = _agora();

    if (fim.isBefore(pausa.inicio)) {
      throw Exception('O fim da Pausa não pode ser anterior ao início.');
    }

    return _repository.atualizar(pausa.copyWith(fim: Value(fim)));
  }

  Future<bool> editarTitulo(Pausa pausa, String titulo) {
    final tituloNormalizado = titulo.trim();

    return _repository.atualizar(
      pausa.copyWith(
        titulo: Value(tituloNormalizado.isEmpty ? null : tituloNormalizado),
      ),
    );
  }
}
