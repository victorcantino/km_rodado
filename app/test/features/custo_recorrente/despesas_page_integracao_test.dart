import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:km_rodado/core/database/app_database.dart';
import 'package:km_rodado/core/database/daos/custo_recorrente_dao.dart';
import 'package:km_rodado/core/database/daos/despesa_veiculo_dao.dart';
import 'package:km_rodado/core/database/daos/depreciacao_veiculo_dao.dart';
import 'package:km_rodado/core/database/daos/abastecimento_dao.dart';
import 'package:km_rodado/core/database/seeds/plataformas_seed.dart';
import 'package:km_rodado/core/database/seeds/seed.dart';
import 'package:km_rodado/core/constants/enums/metodo_depreciacao.dart';
import 'package:km_rodado/features/custo_recorrente/data/custo_recorrente_repository.dart';
import 'package:km_rodado/features/custo_recorrente/data/custo_recorrente_service.dart';
import 'package:km_rodado/features/custo_recorrente/presentation/controllers/custo_recorrente_controller.dart';
import 'package:km_rodado/features/despesa_veiculo/data/despesa_veiculo_repository.dart';
import 'package:km_rodado/features/despesa_veiculo/data/despesa_veiculo_service.dart';
import 'package:km_rodado/features/despesa_veiculo/presentation/controllers/despesa_veiculo_controller.dart';
import 'package:km_rodado/features/despesa_veiculo/presentation/pages/despesas_page.dart';
import 'package:km_rodado/features/abastecimento/data/abastecimento_repository.dart';
import 'package:km_rodado/features/depreciacao_veiculo/data/depreciacao_veiculo_repository.dart';
import 'package:km_rodado/features/depreciacao_veiculo/data/depreciacao_veiculo_service.dart';
import 'package:km_rodado/features/depreciacao_veiculo/presentation/controllers/depreciacao_veiculo_controller.dart';

void main() {
  testWidgets('tela única cria e atualiza as duas seções diretamente', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    await garantirDadosTemporarios(database);
    await garantirPlataformasPadrao(database);
    final despesaController = DespesaVeiculoController(
      DespesaVeiculoService(
        DespesaVeiculoRepository(DespesaVeiculoDao(database)),
      ),
    );
    final custoController = CustoRecorrenteController(
      CustoRecorrenteService(
        CustoRecorrenteRepository(CustoRecorrenteDao(database)),
      ),
    );
    final depreciacaoController = DepreciacaoVeiculoController(
      DepreciacaoVeiculoService(
        DepreciacaoVeiculoRepository(
          DepreciacaoVeiculoDao(database),
          AbastecimentoRepository(AbastecimentoDao(database)),
        ),
      ),
    );
    addTearDown(despesaController.dispose);
    addTearDown(custoController.dispose);
    addTearDown(depreciacaoController.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: DespesasPage(
          veiculoId: 1,
          controller: despesaController,
          custoRecorrenteController: custoController,
          depreciacaoController: depreciacaoController,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('despesas_safe_area')), findsOneWidget);
    expect(find.byKey(const ValueKey('despesas_scroll_unico')), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Despesas do veículo')).dy,
      lessThan(tester.getTopLeft(find.text('Custos recorrentes')).dy),
    );
    expect(
      tester.getTopLeft(find.text('Custos recorrentes')).dy,
      lessThan(tester.getTopLeft(find.text('Depreciação do veículo')).dy),
    );
    expect(
      tester.getTopLeft(find.text('Depreciação do veículo')).dy,
      lessThan(tester.getTopLeft(find.text('Cobertura dos custos').first).dy),
    );
    await tester.scrollUntilVisible(
      find.text('Despesas do veículo'),
      400,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Despesas do veículo'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Custos recorrentes'),
      400,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Custos recorrentes'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Depreciação do veículo'),
      400,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Depreciação do veículo'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('configurar_depreciacao')),
      400,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Depreciação ainda não calculada'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('configurar_depreciacao')),
      findsOneWidget,
    );
    expect(find.byType(Divider), findsNWidgets(4));
    expect(find.byType(ExpansionTile), findsNothing);
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(
      find.byKey(const ValueKey('configurar_depreciacao')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('configurar_depreciacao')));
    await tester.pumpAndSettle();
    expect(find.text('Depreciação do veículo'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('valor_aquisicao_depreciacao')),
      findsOneWidget,
    );
    await tester.pageBack();
    await tester.pumpAndSettle();

    await depreciacaoController.salvar(
      veiculoId: 1,
      metodoSelecionado: MetodoDepreciacao.observada,
      valorAquisicaoCentavos: 5000000,
      odometroAquisicao: 50000,
      valorReferenciaCentavos: 4000000,
      odometroReferencia: 100000,
      valorVendaProjetadoCentavos: 3000000,
      odometroVendaProjetado: 150000,
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('ver_calculo_depreciacao')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Observada'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('ver_calculo_depreciacao')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('alterar_depreciacao')), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const ValueKey('ver_calculo_depreciacao')));
    await tester.pumpAndSettle();
    expect(find.text('Depreciação observada'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('valor_aquisicao_depreciacao')),
      findsNothing,
    );
    await tester.tap(find.text('Fechar'));
    await tester.pumpAndSettle();

    Future<void> alterarMetodo(MetodoDepreciacao metodo) async {
      await tester.tap(find.byKey(const ValueKey('alterar_depreciacao')));
      await tester.pumpAndSettle();
      expect(find.text('50.000'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.byType(SegmentedButton<MetodoDepreciacao>),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.drag(find.byType(ListView), const Offset(0, -120));
      await tester.pumpAndSettle();
      final label = metodo == MetodoDepreciacao.observada
          ? 'Observada'
          : 'Projetada';
      await tester.tap(
        find.descendant(
          of: find.byType(SegmentedButton<MetodoDepreciacao>),
          matching: find.text(label),
        ),
      );
      await tester.scrollUntilVisible(
        find.text('Salvar'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Salvar'))
          .onPressed!();
      await tester.pumpAndSettle();
      expect(depreciacaoController.dados?.metodoSelecionado, metodo);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('alterar_depreciacao')),
        300,
        scrollable: find.byType(Scrollable).first,
      );
    }

    await alterarMetodo(MetodoDepreciacao.projetada);
    expect(find.text('Projetada'), findsOneWidget);
    await alterarMetodo(MetodoDepreciacao.observada);
    expect(find.text('Observada'), findsOneWidget);
    expect(
      await database.select(database.depreciacoesVeiculo).get(),
      hasLength(1),
    );
    expect(
      (await database.select(database.depreciacoesVeiculo).getSingle())
          .veiculoId,
      1,
    );
    expect(tester.takeException(), isNull);
    await tester.tap(find.byTooltip('Novo custo recorrente'));
    await tester.pumpAndSettle();
    expect(find.text('Novo custo recorrente'), findsOneWidget);
    expect(find.text('IPVA'), findsWidgets);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(
      await database.select(database.custosRecorrentes).get(),
      hasLength(1),
    );
    expect(find.text('IPVA'), findsWidgets);
    await tester.drag(find.byType(Scrollable), const Offset(0, 1000));
    await tester.pumpAndSettle();
    expect(find.text('Nenhuma despesa registrada.'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip('Nova despesa'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('descricao_despesa')),
      'Licenciamento pago',
    );
    await tester.enterText(
      find.byKey(const ValueKey('valor_despesa')),
      '15000',
    );
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(await database.select(database.despesasVeiculo).get(), hasLength(1));
    expect(
      await database.select(database.custosRecorrentes).get(),
      hasLength(1),
    );
    expect(find.text('Licenciamento pago'), findsOneWidget);

    await tester.tap(find.byTooltip('Editar custo recorrente'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('descricao_custo_recorrente')),
      'IPVA referência anual',
    );
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(find.text('IPVA referência anual'), findsOneWidget);
    expect(find.text('Licenciamento pago'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip('Novo custo recorrente'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(
      await database.select(database.custosRecorrentes).get(),
      hasLength(1),
    );
    expect(tester.takeException(), isNull);
  });
}
