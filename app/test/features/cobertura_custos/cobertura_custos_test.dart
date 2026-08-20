import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:km_rodado/core/constants/enums/escopo_custo_recorrente.dart';
import 'package:km_rodado/core/constants/enums/metodo_depreciacao.dart';
import 'package:km_rodado/core/constants/enums/tipo_custo_recorrente.dart';
import 'package:km_rodado/core/database/app_database.dart';
import 'package:km_rodado/features/cobertura_custos/data/cobertura_custos.dart';
import 'package:km_rodado/features/cobertura_custos/presentation/cobertura_custos_card.dart';
import 'package:km_rodado/features/depreciacao_veiculo/data/resultado_depreciacao.dart';

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
