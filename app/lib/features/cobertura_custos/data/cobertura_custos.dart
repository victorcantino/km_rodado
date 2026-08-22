import 'package:km_rodado/core/constants/enums/escopo_custo_recorrente.dart';
import 'package:km_rodado/core/constants/enums/metodo_depreciacao.dart';
import 'package:km_rodado/core/constants/enums/tipo_combustivel.dart';
import 'package:km_rodado/core/constants/enums/tipo_custo_recorrente.dart';
import 'package:km_rodado/core/database/app_database.dart';
import 'package:km_rodado/features/abastecimento/data/resumo_inteligencia_abastecimento.dart';
import 'package:km_rodado/features/depreciacao_veiculo/data/resultado_depreciacao.dart';
import 'package:km_rodado/features/planejamento_mensal/data/planejamento_mensal_service.dart';
import 'package:km_rodado/core/database/daos/manutencao_dao.dart';

enum EstadoCoberturaCusto { informado, estimado, naoInformado }

class ItemCoberturaCusto {
  final String nome;
  final EstadoCoberturaCusto estado;
  final bool parcelaCaixa;
  final TipoCustoRecorrente? tipo;
  final double? reaisPorKm;
  final double? precoEfetivoReaisPorLitro;
  final int? valorAtualEstimadoCentavos;
  final int? quantidadeItens;
  final String? referencia;

  const ItemCoberturaCusto({
    required this.nome,
    required this.estado,
    this.parcelaCaixa = false,
    this.tipo,
    this.reaisPorKm,
    this.precoEfetivoReaisPorLitro,
    this.valorAtualEstimadoCentavos,
    this.quantidadeItens,
    this.referencia,
  });
}

class CoberturaCustos {
  final List<ItemCoberturaCusto> itens;

  const CoberturaCustos(this.itens);

  bool get possuiDados =>
      itens.any((item) => item.estado != EstadoCoberturaCusto.naoInformado);
  bool get possuiLacunas =>
      itens.any((item) => item.estado == EstadoCoberturaCusto.naoInformado);
}

class CoberturaCustosService {
  const CoberturaCustosService();

  CoberturaCustos avaliar({
    required bool possuiAbastecimento,
    required bool possuiManutencao,
    required ResultadoDepreciacao? depreciacao,
    required List<CustoRecorrente> custos,
    Abastecimento? ultimoAbastecimento,
    ResumoInteligenciaAbastecimento? inteligenciaAbastecimento,
    List<ManutencaoComItens> manutencoes = const [],
    int? veiculoId,
    PlanejamentoMensalResumo? planejamento,
  }) {
    final manutencaoPorKm = _custoManutencaoPorKm(manutencoes);
    final itens = <ItemCoberturaCusto>[
      _avaliarCombustivel(
        possuiAbastecimento: possuiAbastecimento,
        ultimo: ultimoAbastecimento,
        inteligencia: inteligenciaAbastecimento,
      ),
      ItemCoberturaCusto(
        nome: 'Manutenção',
        estado: possuiManutencao
            ? EstadoCoberturaCusto.informado
            : EstadoCoberturaCusto.naoInformado,
        reaisPorKm: manutencaoPorKm,
        referencia: manutencaoPorKm == null ? null : 'por intervalo de km',
      ),
      ItemCoberturaCusto(
        nome: 'Depreciação',
        estado: depreciacao == null || !depreciacao.disponivel
            ? EstadoCoberturaCusto.naoInformado
            : depreciacao.estimado
            ? EstadoCoberturaCusto.estimado
            : EstadoCoberturaCusto.informado,
        tipo: TipoCustoRecorrente.depreciacao,
        reaisPorKm: depreciacao?.disponivel == true
            ? depreciacao!.valorPorKm
            : null,
        valorAtualEstimadoCentavos:
            depreciacao?.disponivel == true &&
                depreciacao?.metodo == MetodoDepreciacao.observada
            ? depreciacao?.valorFinalCentavos
            : null,
      ),
    ];
    const tipos = [
      TipoCustoRecorrente.seguro,
      TipoCustoRecorrente.ipva,
      TipoCustoRecorrente.licenciamento,
      TipoCustoRecorrente.telefoneProfissional,
    ];
    for (final tipo in tipos) {
      itens.add(
        _avaliarCusto(
          tipo,
          custos,
          veiculoId: veiculoId,
          planejamento: planejamento,
        ),
      );
    }
    itens.add(
      _avaliarOutrosCustos(
        custos,
        veiculoId: veiculoId,
        planejamento: planejamento,
      ),
    );
    itens.add(
      _avaliarCusto(
        TipoCustoRecorrente.parcelaVeiculo,
        custos,
        parcelaCaixa: true,
        veiculoId: veiculoId,
        planejamento: planejamento,
      ),
    );
    return CoberturaCustos(itens);
  }

  ItemCoberturaCusto _avaliarCusto(
    TipoCustoRecorrente tipo,
    List<CustoRecorrente> custos, {
    bool parcelaCaixa = false,
    int? veiculoId,
    PlanejamentoMensalResumo? planejamento,
  }) {
    final registro = custos
        .where(
          (custo) =>
              custo.tipo == tipo &&
              custo.ativo &&
              custo.escopo != EscopoCustoRecorrente.plataforma &&
              (custo.escopo != EscopoCustoRecorrente.veiculo ||
                  custo.veiculoId == veiculoId),
        )
        .firstOrNull;
    final estado = registro == null || registro.valorReferenciaCentavos == null
        ? EstadoCoberturaCusto.naoInformado
        : registro.valorEstimado
        ? EstadoCoberturaCusto.estimado
        : EstadoCoberturaCusto.informado;
    final meta = planejamento?.planejamento?.metaKmMensal;
    final reaisPorKm =
        registro?.valorReferenciaCentavos == null || meta == null || meta <= 0
        ? null
        : registro!.valorReferenciaCentavos! /
              registro.periodicidadeMeses /
              100 /
              meta;
    return ItemCoberturaCusto(
      nome: tipo.label,
      estado: estado,
      parcelaCaixa: parcelaCaixa,
      tipo: tipo,
      reaisPorKm: reaisPorKm,
      referencia: reaisPorKm == null ? null : 'R\$/km planejado',
    );
  }

  ItemCoberturaCusto _avaliarCombustivel({
    required bool possuiAbastecimento,
    required Abastecimento? ultimo,
    required ResumoInteligenciaAbastecimento? inteligencia,
  }) {
    final nome = ultimo == null
        ? 'Combustível'
        : _nomeCombustivel(ultimo.tipoCombustivel);
    if (inteligencia == null && possuiAbastecimento) {
      return ItemCoberturaCusto(
        nome: nome,
        estado: EstadoCoberturaCusto.informado,
      );
    }
    final ciclos = inteligencia?.ciclosHistoricos ?? const [];
    final atual = ultimo == null
        ? null
        : ciclos
              .where(
                (ciclo) =>
                    ciclo.abastecimentoFim.id == ultimo.id &&
                    ciclo.tipoCombustivel == ultimo.tipoCombustivel &&
                    !ciclo.misturaCombustiveis,
              )
              .firstOrNull;
    if (atual != null &&
        atual.distanciaKm > 0 &&
        atual.custoTotalCentavos > 0) {
      return ItemCoberturaCusto(
        nome: nome,
        estado: EstadoCoberturaCusto.informado,
        reaisPorKm: atual.custoTotalCentavos / 100 / atual.distanciaKm,
        precoEfetivoReaisPorLitro: _precoEfetivo(atual.abastecimentoFim),
        referencia: 'ciclo atual · ${atual.kmPorLitro.toStringAsFixed(1)} km/L',
      );
    }
    final historico = ultimo == null
        ? null
        : ciclos
              .where(
                (ciclo) =>
                    ciclo.tipoCombustivel == ultimo.tipoCombustivel &&
                    !ciclo.misturaCombustiveis,
              )
              .lastOrNull;
    return ItemCoberturaCusto(
      nome: possuiAbastecimento ? nome : 'Combustível',
      estado: historico == null
          ? EstadoCoberturaCusto.naoInformado
          : EstadoCoberturaCusto.estimado,
      reaisPorKm: historico == null || historico.distanciaKm <= 0
          ? null
          : historico.custoTotalCentavos / 100 / historico.distanciaKm,
      precoEfetivoReaisPorLitro: historico == null
          ? null
          : _precoEfetivo(historico.abastecimentoFim),
      referencia: historico == null
          ? 'Sem ciclo válido suficiente para estimar o combustível atual'
          : 'Último ciclo válido histórico · ${_mesAno(historico.abastecimentoFim.dataHora)}',
    );
  }

  ItemCoberturaCusto _avaliarOutrosCustos(
    List<CustoRecorrente> custos, {
    int? veiculoId,
    PlanejamentoMensalResumo? planejamento,
  }) {
    final meta = planejamento?.planejamento?.metaKmMensal;
    final registros = custos.where(
      (custo) =>
          custo.tipo == TipoCustoRecorrente.outro &&
          custo.ativo &&
          custo.escopo != EscopoCustoRecorrente.plataforma &&
          (custo.escopo != EscopoCustoRecorrente.veiculo ||
              custo.veiculoId == veiculoId),
    );
    final incluidos = meta == null || meta <= 0
        ? const <CustoRecorrente>[]
        : registros
              .where(
                (custo) =>
                    custo.valorReferenciaCentavos != null &&
                    custo.periodicidadeMeses > 0,
              )
              .toList();
    final reaisPorKm = incluidos.isEmpty
        ? null
        : incluidos.fold<double>(
            0,
            (total, custo) =>
                total +
                custo.valorReferenciaCentavos! /
                    custo.periodicidadeMeses /
                    100 /
                    meta!,
          );
    final estado = incluidos.isEmpty
        ? EstadoCoberturaCusto.naoInformado
        : incluidos.any((custo) => custo.valorEstimado)
        ? EstadoCoberturaCusto.estimado
        : EstadoCoberturaCusto.informado;
    return ItemCoberturaCusto(
      nome: TipoCustoRecorrente.outro.label,
      estado: estado,
      tipo: TipoCustoRecorrente.outro,
      reaisPorKm: reaisPorKm,
      quantidadeItens: incluidos.length,
    );
  }

  double? _custoManutencaoPorKm(List<ManutencaoComItens> manutencoes) {
    for (final manutencao in manutencoes) {
      for (final item in manutencao.itens) {
        if (item.valorCentavos != null &&
            item.intervaloKm != null &&
            item.intervaloKm! > 0) {
          return item.valorCentavos! / 100 / item.intervaloKm!;
        }
      }
    }
    return null;
  }

  String _nomeCombustivel(TipoCombustivel tipo) => switch (tipo) {
    TipoCombustivel.gasolina => 'Gasolina',
    TipoCombustivel.etanol => 'Etanol',
    TipoCombustivel.outro => 'Outro combustível',
  };

  String _mesAno(DateTime data) =>
      '${data.month.toString().padLeft(2, '0')}/${data.year}';

  double? _precoEfetivo(Abastecimento abastecimento) {
    if (abastecimento.volumeMililitros <= 0) return null;
    return abastecimento.valorTotalPagoCentavos *
        10 /
        abastecimento.volumeMililitros;
  }
}
