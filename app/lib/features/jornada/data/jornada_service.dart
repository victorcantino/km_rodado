import 'package:drift/drift.dart';
import '../../../core/constants/enums/status_jornada.dart';
import '../../../core/database/app_database.dart';
import '../../pausa/data/pausa_repository.dart';

import 'jornada_repository.dart';

class JornadaService {
  final JornadaRepository _repository;
  final PausaRepository _pausaRepository;

  JornadaService(this._repository, this._pausaRepository);

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
