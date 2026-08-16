import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:km_rodado/core/database/app_database.dart';
import 'package:km_rodado/core/database/daos/custo_recorrente_dao.dart';
import 'package:km_rodado/core/database/daos/despesa_veiculo_dao.dart';
import 'package:km_rodado/core/database/seeds/plataformas_seed.dart';
import 'package:km_rodado/core/database/seeds/seed.dart';
import 'package:km_rodado/features/custo_recorrente/data/custo_recorrente_repository.dart';
import 'package:km_rodado/features/custo_recorrente/data/custo_recorrente_service.dart';
import 'package:km_rodado/features/custo_recorrente/presentation/controllers/custo_recorrente_controller.dart';
import 'package:km_rodado/features/despesa_veiculo/data/despesa_veiculo_repository.dart';
import 'package:km_rodado/features/despesa_veiculo/data/despesa_veiculo_service.dart';
import 'package:km_rodado/features/despesa_veiculo/presentation/controllers/despesa_veiculo_controller.dart';
import 'package:km_rodado/features/despesa_veiculo/presentation/pages/despesas_page.dart';

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
    addTearDown(despesaController.dispose);
    addTearDown(custoController.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: DespesasPage(
          veiculoId: 1,
          controller: despesaController,
          custoRecorrenteController: custoController,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('despesas_safe_area')), findsOneWidget);
    expect(find.byKey(const ValueKey('despesas_scroll_unico')), findsOneWidget);
    expect(find.text('Despesas do veículo'), findsOneWidget);
    expect(find.text('Custos recorrentes'), findsOneWidget);
    expect(find.byType(Divider), findsNWidgets(2));
    expect(find.byType(ExpansionTile), findsNothing);
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
