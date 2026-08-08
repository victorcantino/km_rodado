import 'package:drift/drift.dart';
import '../../../core/constants/enums/status_jornada.dart';
import '../../../core/database/app_database.dart';

import 'jornada_repository.dart';

class JornadaService {
  final JornadaRepository _repository;

  JornadaService(this._repository);

  Future<Jornada?> jornadaAberta() {
    return _repository.buscarJornadaAberta();
  }

  Future<Jornada?> ultimaJornadaFinalizada() {
    return _repository.buscarUltimaJornadaFinalizada();
  }

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

    if (odometroFim <= jornada.odometroInicio) {
      throw Exception('O odômetro final deve ser maior que o inicial.');
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
