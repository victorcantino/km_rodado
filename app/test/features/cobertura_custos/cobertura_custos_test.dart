import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:km_rodado/core/constants/enums/escopo_custo_recorrente.dart';
import 'package:km_rodado/core/constants/enums/metodo_depreciacao.dart';
import 'package:km_rodado/core/constants/enums/tipo_custo_recorrente.dart';
import 'package:km_rodado/core/constants/enums/tipo_combustivel.dart';
import 'package:km_rodado/core/database/app_database.dart';
import 'package:km_rodado/features/cobertura_custos/data/cobertura_custos.dart';
import 'package:km_rodado/features/cobertura_custos/presentation/cobertura_custos_card.dart';
import 'package:km_rodado/features/abastecimento/data/resumo_inteligencia_abastecimento.dart';
import 'package:km_rodado/features/depreciacao_veiculo/data/resultado_depreciacao.dart';
import 'package:km_rodado/features/planejamento_mensal/data/planejamento_mensal_service.dart';

void main() {
  final service = const CoberturaCustosService();
  final agora = DateTime(2026, 8, 20);

  CustoRecorrente custo(TipoCustoRecorrente tipo, {bool estimado = false}) =>
      CustoRecorrente(
        id: tipo.index + 1,
        tipo: tipo,
        descricao: tipo.label,
        escopo: EscopoCustoRecorrente.veiculo,
        valorReferenciaCentavos: 10000,
        valorEstimado: estimado,
        periodicidadeMeses: 1,
        parcelasPorCiclo: 1,
        ativo: true,
        dataCriacao: agora,
      );

  test('classifica informado, estimado e não informado sem percentual', () {
    final cobertura = service.avaliar(
      possuiAbastecimento: true,
      possuiManutencao: false,
      depreciacao: null,
      custos: [
        custo(TipoCustoRecorrente.seguro),
        custo(TipoCustoRecorrente.ipva, estimado: true),
      ],
    );

    expect(
      cobertura.itens.firstWhere((item) => item.nome == 'Combustível').estado,
      EstadoCoberturaCusto.informado,
    );
    expect(
      cobertura.itens.firstWhere((item) => item.nome == 'IPVA').estado,
      EstadoCoberturaCusto.estimado,
    );
    expect(
      cobertura.itens.firstWhere((item) => item.nome == 'Licenciamento').estado,
      EstadoCoberturaCusto.naoInformado,
    );
    expect(cobertura, isNot(isA<Map>()));
  });

  test(
    'depreciação estimada e custo recorrente estimado permanecem distintos',
    () {
      final cobertura = service.avaliar(
        possuiAbastecimento: false,
        possuiManutencao: true,
        depreciacao: const ResultadoDepreciacao(
          metodo: MetodoDepreciacao.observada,
          disponivel: true,
          valorPorKm: 0.5,
          estimado: true,
        ),
        custos: [custo(TipoCustoRecorrente.seguro, estimado: true)],
      );

      expect(
        cobertura.itens.firstWhere((item) => item.nome == 'Depreciação').estado,
        EstadoCoberturaCusto.estimado,
      );
      expect(
        cobertura.itens.firstWhere((item) => item.nome == 'Seguro').estado,
        EstadoCoberturaCusto.estimado,
      );
    },
  );

  test('deriva o último preço efetivo do abastecimento atual', () {
    Abastecimento abastecimento({required int id, required int dataDia}) =>
        Abastecimento(
          id: id,
          veiculoId: 1,
          dataHora: DateTime(2026, 8, dataDia),
          odometro: id == 1 ? 10000 : 10100,
          tipoCombustivel: TipoCombustivel.gasolina,
          volumeMililitros: 34000,
          valorTotalPagoCentavos: 12500,
          tanqueCheio: true,
          dataCriacao: DateTime(2026, 8, 20),
        );
    final inicio = abastecimento(id: 1, dataDia: 10);
    final fim = abastecimento(id: 2, dataDia: 20);
    final ciclo = ResumoCicloAbastecimento(
      abastecimentoInicio: inicio,
      abastecimentoFim: fim,
      distanciaKm: 100,
      volumeConsumidoMililitros: 34000,
      kmPorLitro: 2.94,
      quantidadeParciaisIntermediarios: 0,
      distanciaAtePrimeiroReabastecimentoKm: 100,
      custoTotalCentavos: 12500,
      tipoCombustivel: TipoCombustivel.gasolina,
    );
    final cobertura = service.avaliar(
      possuiAbastecimento: true,
      possuiManutencao: false,
      depreciacao: null,
      custos: const [],
      ultimoAbastecimento: fim,
      inteligenciaAbastecimento: ResumoInteligenciaAbastecimento(
        ciclosRecentes: [ciclo],
        ciclosHistoricos: [ciclo],
        mediaKmPorLitro: 2.94,
        kmPorLitroConservador: 2.94,
        capacidadeTanqueLitros: null,
        autonomiaMediaTanqueCheioKm: null,
        autonomiaConservadoraTanqueCheioKm: null,
        odometroReferenciaAbastecimento: null,
        ultimoOdometroConhecido: 10100,
        diasOperacaoAteReferencia: null,
      ),
    );

    expect(
      cobertura.itens.first.precoEfetivoReaisPorLitro,
      closeTo(3.676, 0.001),
    );
  });

  testWidgets('não repete R\$/km de depreciação na apresentação', (
    tester,
  ) async {
    final cobertura = const CoberturaCustos([
      ItemCoberturaCusto(
        nome: 'Depreciação',
        estado: EstadoCoberturaCusto.estimado,
        reaisPorKm: 0.42,
        valorAtualEstimadoCentavos: 3500000,
      ),
    ]);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: CoberturaCustosCard(cobertura: cobertura)),
      ),
    );

    expect(find.textContaining('Valor atual estimado'), findsOneWidget);
    expect(find.textContaining('R\$/km de depreciação'), findsNothing);
    expect(find.text('Custo por km'), findsOneWidget);
    expect(find.text('R\$ 0,42/km'), findsOneWidget);
  });

  test('agrega somente outros custos recorrentes elegíveis', () {
    final planejamento = PlanejamentoMensalResumo(
      planejamento: PlanejamentoMensal(
        id: 1,
        usuarioId: 1,
        mesReferencia: DateTime(2026, 8),
        diasPlanejados: 20,
        metaKmMensal: 1000,
      ),
      kmRealizados: 0,
      percentualMeta: 0,
      kmRestantes: 1000,
      diasTrabalhados: 0,
      diasPlanejadosRestantes: 20,
      mediaPlanejadaKmDia: 50,
      mediaNecessariaKmDia: 50,
    );
    CustoRecorrente outro({
      required int id,
      required int valor,
      int periodicidade = 1,
      bool estimado = false,
    }) => CustoRecorrente(
      id: id,
      tipo: TipoCustoRecorrente.outro,
      descricao: 'Outro $id',
      escopo: EscopoCustoRecorrente.atividade,
      valorReferenciaCentavos: valor,
      valorEstimado: estimado,
      periodicidadeMeses: periodicidade,
      parcelasPorCiclo: 1,
      ativo: true,
      dataCriacao: agora,
    );
    final cobertura = service.avaliar(
      possuiAbastecimento: false,
      possuiManutencao: false,
      depreciacao: null,
      planejamento: planejamento,
      custos: [
        outro(id: 1, valor: 800),
        outro(id: 2, valor: 1200, periodicidade: 2, estimado: true),
        custo(TipoCustoRecorrente.seguro),
        custo(TipoCustoRecorrente.parcelaVeiculo),
      ],
    );
    final outros = cobertura.itens.firstWhere(
      (item) => item.tipo == TipoCustoRecorrente.outro,
    );

    expect(outros.quantidadeItens, 2);
    expect(outros.reaisPorKm, closeTo(0.014, 0.0001));
    expect(outros.estado, EstadoCoberturaCusto.estimado);
  });

  testWidgets('ação de outros custos abre novo custo recorrente', (
    tester,
  ) async {
    var acionado = false;
    final cobertura = const CoberturaCustos([
      ItemCoberturaCusto(
        nome: 'Outro custo recorrente',
        tipo: TipoCustoRecorrente.outro,
        estado: EstadoCoberturaCusto.informado,
        reaisPorKm: 0.08,
        quantidadeItens: 3,
      ),
    ]);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CoberturaCustosCard(
            cobertura: cobertura,
            onNovoCustoRecorrente: () => acionado = true,
          ),
        ),
      ),
    );
    expect(find.text('Ver custos'), findsNothing);
    expect(find.byIcon(Icons.event_repeat), findsOneWidget);
    expect(find.byTooltip('Novo custo recorrente'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.event_repeat));
    expect(acionado, isTrue);
  });

  testWidgets('configuração usa lápis com Tooltip e Semantics', (tester) async {
    var acionado = false;
    const item = ItemCoberturaCusto(
      nome: 'Parcela do veículo',
      tipo: TipoCustoRecorrente.parcelaVeiculo,
      estado: EstadoCoberturaCusto.naoInformado,
      parcelaCaixa: true,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CoberturaCustosCard(
            cobertura: const CoberturaCustos([item]),
            onConfigurar: (_) => acionado = true,
          ),
        ),
      ),
    );

    expect(find.text('Configurar'), findsNothing);
    expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    expect(find.byTooltip('Configurar Parcela do veículo'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.edit_outlined));
    expect(acionado, isTrue);
  });

  test(
    'parcela é obrigação de caixa e multa não entra na lista estrutural',
    () {
      final cobertura = service.avaliar(
        possuiAbastecimento: false,
        possuiManutencao: false,
        depreciacao: null,
        custos: [custo(TipoCustoRecorrente.parcelaVeiculo)],
      );
      final parcela = cobertura.itens.firstWhere(
        (item) => item.nome == 'Parcela do veículo',
      );

      expect(parcela.parcelaCaixa, isTrue);
      expect(cobertura.itens.any((item) => item.nome == 'Multa'), isFalse);
    },
  );

  testWidgets('visualização cabe em tela estreita sem overflow', (
    tester,
  ) async {
    final cobertura = service.avaliar(
      possuiAbastecimento: true,
      possuiManutencao: true,
      depreciacao: null,
      custos: const [],
    );
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(children: [CoberturaCustosCard(cobertura: cobertura)]),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
