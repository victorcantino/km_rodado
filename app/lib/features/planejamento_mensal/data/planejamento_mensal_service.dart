import '../../../core/constants/enums/status_jornada.dart';
import '../../../core/database/app_database.dart';
import '../../jornada/data/jornada_repository.dart';
import 'planejamento_mensal_repository.dart';

class PlanejamentoMensalResumo {
  final PlanejamentoMensal? planejamento;
  final int kmRealizados;
  final double? percentualMeta;
  final int kmRestantes;
  final int diasTrabalhados;
  final int diasPlanejadosRestantes;
  final double? mediaPlanejadaKmDia;
  final double? mediaNecessariaKmDia;

  const PlanejamentoMensalResumo({
    required this.planejamento,
    required this.kmRealizados,
    required this.percentualMeta,
    required this.kmRestantes,
    required this.diasTrabalhados,
    required this.diasPlanejadosRestantes,
    required this.mediaPlanejadaKmDia,
    required this.mediaNecessariaKmDia,
  });

  bool get possuiPlanejamento => planejamento != null;
}

class PlanejamentoMensalService {
  final PlanejamentoMensalRepository _repository;
  final JornadaRepository _jornadaRepository;

  PlanejamentoMensalService(this._repository, this._jornadaRepository);

  DateTime normalizarMes(DateTime data) => DateTime(data.year, data.month);

  Future<PlanejamentoMensalResumo> calcular({
    required int usuarioId,
    required DateTime mes,
  }) async {
    final referencia = normalizarMes(mes);
    final planejamento = await _repository.buscar(usuarioId, referencia);
    final jornadas = await _jornadaRepository.listar();
    final jornadasDoMes = jornadas.where((jornada) {
      final inicio = jornada.dataHoraInicio;
      return jornada.usuarioId == usuarioId &&
          jornada.status == StatusJornada.finalizada &&
          inicio.year == referencia.year &&
          inicio.month == referencia.month;
    });

    var kmRealizados = 0;
    final diasTrabalhados = <DateTime>{};
    for (final jornada in jornadasDoMes) {
      kmRealizados +=
          jornada.quilometrosPercorridos ??
          ((jornada.odometroFim ?? jornada.odometroInicio) -
              jornada.odometroInicio);
      final inicio = jornada.dataHoraInicio;
      diasTrabalhados.add(DateTime(inicio.year, inicio.month, inicio.day));
    }

    final diasPlanejados = planejamento?.diasPlanejados ?? 0;
    final metaKm = planejamento?.metaKmMensal ?? 0;
    final diasRestantes = diasPlanejados > diasTrabalhados.length
        ? diasPlanejados - diasTrabalhados.length
        : 0;
    final kmRestantes = metaKm > kmRealizados ? metaKm - kmRealizados : 0;

    return PlanejamentoMensalResumo(
      planejamento: planejamento,
      kmRealizados: kmRealizados,
      percentualMeta: metaKm > 0 ? kmRealizados * 100 / metaKm : null,
      kmRestantes: kmRestantes,
      diasTrabalhados: diasTrabalhados.length,
      diasPlanejadosRestantes: diasRestantes,
      mediaPlanejadaKmDia: diasPlanejados > 0 ? metaKm / diasPlanejados : null,
      mediaNecessariaKmDia: diasRestantes > 0 && kmRestantes > 0
          ? kmRestantes / diasRestantes
          : 0,
    );
  }

  Future<void> salvar({
    required int usuarioId,
    required DateTime mes,
    required int diasPlanejados,
    required int metaKmMensal,
  }) async {
    if (diasPlanejados < 0 || metaKmMensal < 0) {
      throw ArgumentError('Dias e meta não podem ser negativos.');
    }
    final referencia = normalizarMes(mes);
    final existente = await _repository.buscar(usuarioId, referencia);
    if (existente == null) {
      await _repository.inserir(
        PlanejamentosMensaisCompanion.insert(
          usuarioId: usuarioId,
          mesReferencia: referencia,
          diasPlanejados: diasPlanejados,
          metaKmMensal: metaKmMensal,
        ),
      );
    } else {
      await _repository.atualizar(
        existente.copyWith(
          diasPlanejados: diasPlanejados,
          metaKmMensal: metaKmMensal,
        ),
      );
    }
  }
}
