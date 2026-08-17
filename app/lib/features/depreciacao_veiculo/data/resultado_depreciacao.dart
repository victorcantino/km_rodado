import '../../../core/constants/enums/metodo_depreciacao.dart';

class ResultadoDepreciacao {
  final MetodoDepreciacao metodo;
  final bool disponivel;
  final double? valorPorKm;
  final bool estimado;
  final String? motivoIndisponibilidade;
  final int? valorInicialCentavos;
  final int? valorFinalCentavos;
  final int? perdaCentavos;
  final int? odometroInicial;
  final int? odometroFinal;
  final int? distanciaKm;

  const ResultadoDepreciacao({
    required this.metodo,
    required this.disponivel,
    this.valorPorKm,
    required this.estimado,
    this.motivoIndisponibilidade,
    this.valorInicialCentavos,
    this.valorFinalCentavos,
    this.perdaCentavos,
    this.odometroInicial,
    this.odometroFinal,
    this.distanciaKm,
  });
}
