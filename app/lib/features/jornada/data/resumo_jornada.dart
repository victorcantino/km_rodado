import '../../../core/database/app_database.dart';
import '../../../core/database/daos/passe_plataforma_dao.dart';

class ResultadoPlataformaJornada {
  final int plataformaId;
  final String nome;
  final int? receitaCentavos;
  final int? quantidadeViagens;

  const ResultadoPlataformaJornada({
    required this.plataformaId,
    required this.nome,
    required this.receitaCentavos,
    required this.quantidadeViagens,
  });

  bool get calculavel => receitaCentavos != null && quantidadeViagens != null;

  double? get ticketMedio {
    final receita = receitaCentavos;
    final viagens = quantidadeViagens;
    if (receita == null || viagens == null || viagens <= 0) return null;
    return receita / 100 / viagens;
  }
}

class ResumoJornada {
  final Jornada jornada;
  final Duration duracaoTotal;
  final Duration tempoPausa;
  final Duration tempoAtivo;
  final int quilometrosTotal;
  final int? quilometrosEmPausa;
  final int? quilometrosAtivos;
  final List<ResultadoPlataformaJornada> resultadosPlataformas;
  final List<PasseComPlataforma> passes;

  const ResumoJornada({
    required this.jornada,
    required this.duracaoTotal,
    required this.tempoPausa,
    required this.tempoAtivo,
    required this.quilometrosTotal,
    required this.quilometrosEmPausa,
    required this.quilometrosAtivos,
    required this.resultadosPlataformas,
    this.passes = const [],
  });

  int get custoPassesCentavos => passes.fold<int>(
    0,
    (total, item) => total + item.passe.valorPagoCentavos.toInt(),
  );

  bool get financeiroCompleto =>
      resultadosPlataformas.isNotEmpty &&
      resultadosPlataformas.every((resultado) => resultado.calculavel);

  int? get receitaTotalCentavos => financeiroCompleto
      ? resultadosPlataformas.fold<int>(
          0,
          (total, resultado) => total + resultado.receitaCentavos!,
        )
      : null;

  int? get quantidadeTotalViagens => financeiroCompleto
      ? resultadosPlataformas.fold<int>(
          0,
          (total, resultado) => total + resultado.quantidadeViagens!,
        )
      : null;

  double? get ticketMedioGeral {
    final receita = receitaTotalCentavos;
    final viagens = quantidadeTotalViagens;
    if (receita == null || viagens == null || viagens <= 0) return null;
    return receita / 100 / viagens;
  }

  double? get receitaPorHoraAtiva {
    final receita = receitaTotalCentavos;
    if (receita == null || tempoAtivo <= Duration.zero) return null;
    return receita /
        100 /
        (tempoAtivo.inMilliseconds / Duration.millisecondsPerHour);
  }

  double? get receitaPorKmAtivo {
    final receita = receitaTotalCentavos;
    final quilometros = quilometrosAtivos;
    if (receita == null || quilometros == null || quilometros <= 0) {
      return null;
    }
    return receita / 100 / quilometros;
  }
}
