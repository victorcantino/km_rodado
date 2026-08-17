import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:km_rodado/core/constants/enums/fonte_referencia_depreciacao.dart';
import 'package:km_rodado/core/constants/enums/metodo_depreciacao.dart';
import 'package:km_rodado/core/database/app_database.dart';
import 'package:km_rodado/core/database/daos/abastecimento_dao.dart';
import 'package:km_rodado/core/database/daos/depreciacao_veiculo_dao.dart';
import 'package:km_rodado/core/database/seeds/seed.dart';
import 'package:km_rodado/core/formatters/quilometragem_input_formatter.dart';
import 'package:km_rodado/features/abastecimento/data/abastecimento_repository.dart';
import 'package:km_rodado/features/depreciacao_veiculo/data/depreciacao_veiculo_repository.dart';
import 'package:km_rodado/features/depreciacao_veiculo/data/depreciacao_veiculo_service.dart';
import 'package:km_rodado/features/depreciacao_veiculo/presentation/controllers/depreciacao_veiculo_controller.dart';
import 'package:km_rodado/features/depreciacao_veiculo/presentation/pages/depreciacao_veiculo_page.dart';

void main() {
  late AppDatabase database;
  late DepreciacaoVeiculoService service;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await garantirDadosTemporarios(database);
    service = DepreciacaoVeiculoService(
      DepreciacaoVeiculoRepository(
        DepreciacaoVeiculoDao(database),
        AbastecimentoRepository(AbastecimentoDao(database)),
      ),
      agora: () => DateTime(2026, 8, 17, 12),
    );
  });

  tearDown(() => database.close());

  test(
    r'calcula depreciação observada e projetada sem persistir R$/km',
    () async {
      await service.salvar(
        veiculoId: 1,
        metodoSelecionado: MetodoDepreciacao.observada,
        valorAquisicaoCentavos: 5600000,
        odometroAquisicao: 75000,
        valorReferenciaCentavos: 4200000,
        fonteReferencia: FonteReferenciaDepreciacao.tabelaFipe,
        dataReferencia: DateTime(2026, 8, 17),
        odometroReferencia: 125000,
        valorVendaProjetadoCentavos: 2500000,
        valorVendaProjetadoEstimado: true,
        odometroVendaProjetado: 200000,
      );

      final dados = await service.buscar(1);
      expect(
        service.calcularObservada(dados).valorPorKm,
        closeTo(0.28, 0.0001),
      );
      expect(
        service.calcularProjetada(dados).valorPorKm,
        closeTo(0.248, 0.0001),
      );
      expect(
        service.resultadoSelecionado(dados)?.metodo,
        MetodoDepreciacao.observada,
      );
      final colunas = await database
          .customSelect('PRAGMA table_info(depreciacoes_veiculo)')
          .get();
      expect(
        colunas.map((linha) => linha.read<String>('name')),
        isNot(contains('valor_por_km')),
      );
    },
  );

  test('mantém configuração parcial e explica cálculo indisponível', () async {
    await service.salvar(veiculoId: 1, valorAquisicaoCentavos: 5600000);
    final dados = await service.buscar(1);
    expect(dados, isNotNull);
    expect(service.calcularObservada(dados).disponivel, isFalse);
    expect(service.calcularProjetada(dados).disponivel, isFalse);
  });

  test('rejeita valores inválidos, odômetro inválido e data futura', () async {
    expect(
      () => service.salvar(veiculoId: 1, valorAquisicaoCentavos: 0),
      throwsException,
    );
    expect(
      () => service.salvar(veiculoId: 1, odometroAquisicao: -1),
      throwsException,
    );
    expect(
      () => service.salvar(veiculoId: 1, dataReferencia: DateTime(2026, 8, 18)),
      throwsException,
    );
  });

  test('não calcula perda negativa nem distância nula', () async {
    await service.salvar(
      veiculoId: 1,
      valorAquisicaoCentavos: 5000000,
      odometroAquisicao: 100000,
      valorReferenciaCentavos: 5100000,
      odometroReferencia: 100000,
    );
    final resultado = service.calcularObservada(await service.buscar(1));
    expect(resultado.disponivel, isFalse);
    expect(resultado.valorPorKm, isNull);
  });

  test(
    'atualiza o único snapshot do veículo e troca método selecionado',
    () async {
      await service.salvar(
        veiculoId: 1,
        metodoSelecionado: MetodoDepreciacao.observada,
        valorAquisicaoCentavos: 5000000,
        odometroAquisicao: 50000,
        valorReferenciaCentavos: 4000000,
        odometroReferencia: 100000,
      );
      await service.salvar(
        veiculoId: 1,
        metodoSelecionado: MetodoDepreciacao.projetada,
        valorAquisicaoCentavos: 5000000,
        odometroAquisicao: 50000,
        valorVendaProjetadoCentavos: 3000000,
        odometroVendaProjetado: 150000,
      );
      expect(
        await database.select(database.depreciacoesVeiculo).get(),
        hasLength(1),
      );
      expect(
        (await service.buscar(1))?.metodoSelecionado,
        MetodoDepreciacao.projetada,
      );
    },
  );

  testWidgets('campos de quilometragem exibem máscara e salvam inteiros', (
    tester,
  ) async {
    await service.salvar(
      veiculoId: 1,
      valorAquisicaoCentavos: 5600000,
      odometroAquisicao: 75000,
      valorReferenciaCentavos: 4200000,
      odometroReferencia: 125000,
      valorVendaProjetadoCentavos: 2500000,
      odometroVendaProjetado: 200000,
    );
    final controller = DepreciacaoVeiculoController(service);
    addTearDown(controller.dispose);
    await controller.carregar(1);
    await tester.pumpWidget(
      MaterialApp(
        home: DepreciacaoVeiculoPage(veiculoId: 1, controller: controller),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('75.000'), findsOneWidget);
    expect(find.text('125.000'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('odometro_venda_depreciacao')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('200.000'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('odometro_referencia_depreciacao')),
      -300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(
      find.byKey(const ValueKey('odometro_referencia_depreciacao')),
      '130000',
    );
    expect(find.text('130.000'), findsOneWidget);
    final campo = tester.widget<TextFormField>(
      find.byKey(const ValueKey('odometro_referencia_depreciacao')),
    );
    expect(parseQuilometragem(campo.controller!.text), 130000);
    expect(tester.takeException(), isNull);
  });
}
