import '../../../core/database/app_database.dart';

class ResumoCicloAbastecimento {
  final Abastecimento abastecimentoInicio;
  final Abastecimento abastecimentoFim;
  final int distanciaKm;
  final int volumeConsumidoMililitros;
  final double kmPorLitro;
  final int quantidadeParciaisIntermediarios;
  final int distanciaAtePrimeiroReabastecimentoKm;

  const ResumoCicloAbastecimento({
    required this.abastecimentoInicio,
    required this.abastecimentoFim,
    required this.distanciaKm,
    required this.volumeConsumidoMililitros,
    required this.kmPorLitro,
    required this.quantidadeParciaisIntermediarios,
    required this.distanciaAtePrimeiroReabastecimentoKm,
  });

  bool get potencialmenteMisto => quantidadeParciaisIntermediarios > 0;
}

class ResumoInteligenciaAbastecimento {
  final List<ResumoCicloAbastecimento> ciclosRecentes;
  final double? mediaKmPorLitro;
  final double? kmPorLitroConservador;
  final double? capacidadeTanqueLitros;
  final double? autonomiaMediaTanqueCheioKm;
  final double? autonomiaConservadoraTanqueCheioKm;
  final int? odometroReferenciaAbastecimento;
  final int? ultimoOdometroConhecido;
  final double? diasOperacaoAteReferencia;

  const ResumoInteligenciaAbastecimento({
    required this.ciclosRecentes,
    required this.mediaKmPorLitro,
    required this.kmPorLitroConservador,
    required this.capacidadeTanqueLitros,
    required this.autonomiaMediaTanqueCheioKm,
    required this.autonomiaConservadoraTanqueCheioKm,
    required this.odometroReferenciaAbastecimento,
    required this.ultimoOdometroConhecido,
    required this.diasOperacaoAteReferencia,
  });

  bool get possuiDados => ciclosRecentes.isNotEmpty;

  bool get referenciaAtingida =>
      odometroReferenciaAbastecimento != null &&
      ultimoOdometroConhecido != null &&
      ultimoOdometroConhecido! >= odometroReferenciaAbastecimento!;

  int? get distanciaAteReferenciaKm {
    final referencia = odometroReferenciaAbastecimento;
    final atual = ultimoOdometroConhecido;
    if (referencia == null || atual == null || atual >= referencia) return null;
    return referencia - atual;
  }
}
