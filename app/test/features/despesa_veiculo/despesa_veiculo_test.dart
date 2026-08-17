import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:km_rodado/core/constants/enums/tipo_despesa_veiculo.dart';
import 'package:km_rodado/core/database/app_database.dart';
import 'package:km_rodado/core/database/daos/despesa_veiculo_dao.dart';
import 'package:km_rodado/core/database/seeds/seed.dart';
import 'package:km_rodado/features/despesa_veiculo/data/despesa_veiculo_repository.dart';
import 'package:km_rodado/features/despesa_veiculo/data/despesa_veiculo_service.dart';
import 'package:km_rodado/features/despesa_veiculo/presentation/widgets/editar_despesa_veiculo_dialog.dart';

void main() {
  late AppDatabase database;
  late DespesaVeiculoService service;
  final agora = DateTime(2026, 8, 15, 12);

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await garantirDadosTemporarios(database);
    service = DespesaVeiculoService(
      DespesaVeiculoRepository(DespesaVeiculoDao(database)),
      agora: () => agora,
    );
  });

  tearDown(() => database.close());

  test('salva fato pago em centavos, normaliza textos e usa agora', () async {
    await service.criar(
      veiculoId: 1,
      tipo: TipoDespesaVeiculo.estacionamento,
      descricao: '  Estacionamento Centro  ',
      valorCentavos: 1350,
      observacao: '  Trabalho  ',
    );

    final despesa = (await service.listar(1)).single;
    expect(despesa.descricao, 'Estacionamento Centro');
    expect(despesa.valorCentavos, 1350);
    expect(despesa.observacao, 'Trabalho');
    expect(despesa.dataHora, agora);
    expect(despesa.dataCriacao, agora);
    expect(despesa.dataAtualizacao, isNull);
  });

  test('todos os tipos do domínio podem ser persistidos', () async {
    for (final tipo in TipoDespesaVeiculo.values) {
      await service.criar(
        veiculoId: 1,
        tipo: tipo,
        descricao: tipo.label,
        valorCentavos: 1,
        dataHora: agora.subtract(Duration(minutes: tipo.index)),
      );
    }
    expect(
      await service.listar(1),
      hasLength(TipoDespesaVeiculo.values.length),
    );
    expect(
      TipoDespesaVeiculo.values.map((tipo) => tipo.name),
      isNot(containsAll(<String>['abastecimento', 'manutencao'])),
    );
    expect(TipoDespesaVeiculo.ipva.label, 'IPVA');
    expect(TipoDespesaVeiculo.licenciamento.label, 'Licenciamento');
    expect(TipoDespesaVeiculo.seguro.label, 'Seguro');
  });

  testWidgets('novo cadastro oferece somente despesas esporádicas', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditarDespesaVeiculoDialog(
            buscarSugestoes: (_) async => const [],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('tipo_despesa')));
    await tester.pumpAndSettle();

    for (final label in const [
      'Multa',
      'Pedágio',
      'Estacionamento',
      'Lavagem',
      'Taxa/documentação eventual',
      'Outra despesa',
    ]) {
      expect(find.text(label), findsWidgets);
    }
    for (final label in const ['IPVA', 'Licenciamento', 'Seguro']) {
      expect(find.text(label), findsNothing);
    }
    expect(find.text('Parcela do veículo'), findsNothing);
    expect(find.text('Depreciação'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tipo recorrente legado permanece legível e editável', (
    tester,
  ) async {
    for (final tipo in const [
      TipoDespesaVeiculo.ipva,
      TipoDespesaVeiculo.licenciamento,
      TipoDespesaVeiculo.seguro,
    ]) {
      final id = await service.criar(
        veiculoId: 1,
        tipo: tipo,
        descricao: '${tipo.label} legado',
        valorCentavos: 100,
        dataHora: agora.subtract(Duration(minutes: tipo.index + 1)),
      );
      final existente = (await service.listar(
        1,
      )).singleWhere((despesa) => despesa.id == id);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EditarDespesaVeiculoDialog(
              key: ValueKey(tipo),
              existente: existente,
              buscarSugestoes: (_) async => const [],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(tipo.label), findsOneWidget);
      expect(find.text('${tipo.label} legado'), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });

  test(
    'aceita retroativo e rejeita futuro, zero, descrição e tipo ausentes',
    () async {
      await service.criar(
        veiculoId: 1,
        tipo: TipoDespesaVeiculo.ipva,
        descricao: 'IPVA 2025',
        valorCentavos: 100,
        dataHora: DateTime(2025),
      );
      for (final chamada in <Future<void> Function()>[
        () async => service.criar(
          veiculoId: 1,
          tipo: TipoDespesaVeiculo.ipva,
          descricao: 'Futuro',
          valorCentavos: 100,
          dataHora: agora.add(const Duration(minutes: 1)),
        ),
        () async => service.criar(
          veiculoId: 1,
          tipo: TipoDespesaVeiculo.ipva,
          descricao: 'Zero',
          valorCentavos: 0,
        ),
        () async => service.criar(
          veiculoId: 1,
          tipo: TipoDespesaVeiculo.ipva,
          descricao: '   ',
          valorCentavos: 1,
        ),
        () async => service.criar(
          veiculoId: 1,
          tipo: null,
          descricao: 'Sem tipo',
          valorCentavos: 1,
        ),
        () async => service.criar(
          veiculoId: 999,
          tipo: TipoDespesaVeiculo.outro,
          descricao: 'Sem veículo',
          valorCentavos: 1,
        ),
      ]) {
        await expectLater(chamada(), throwsA(isA<Exception>()));
      }
    },
  );

  test(
    'histórico é isolado por veículo e ordenado por data operacional',
    () async {
      await database
          .into(database.veiculos)
          .insert(
            VeiculosCompanion.insert(
              usuarioId: 1,
              marca: 'Outra',
              modelo: 'Carro',
              ano: 2020,
            ),
          );
      await service.criar(
        veiculoId: 1,
        tipo: TipoDespesaVeiculo.outro,
        descricao: 'Nova',
        valorCentavos: 1,
        dataHora: DateTime(2026, 8, 14),
      );
      await service.criar(
        veiculoId: 1,
        tipo: TipoDespesaVeiculo.outro,
        descricao: 'Antiga cadastrada depois',
        valorCentavos: 1,
        dataHora: DateTime(2026, 8, 13),
      );
      await service.criar(
        veiculoId: 2,
        tipo: TipoDespesaVeiculo.outro,
        descricao: 'Outro veículo',
        valorCentavos: 1,
      );
      expect((await service.listar(1)).map((d) => d.descricao), [
        'Nova',
        'Antiga cadastrada depois',
      ]);
      expect((await service.listar(2)).single.descricao, 'Outro veículo');
    },
  );

  test(
    'edição persiste, marca atualização e falha sem alterar o original',
    () async {
      final id = await service.criar(
        veiculoId: 1,
        tipo: TipoDespesaVeiculo.lavagem,
        descricao: 'Lavagem',
        valorCentavos: 3000,
        dataHora: DateTime(2026, 8, 14),
      );
      await service.editar(
        id: id,
        veiculoId: 1,
        tipo: TipoDespesaVeiculo.documentacao,
        descricao: '  Taxa anual ',
        valorCentavos: 4500,
        dataHora: DateTime(2026, 8, 13),
        observacao: '   ',
      );
      var despesa = (await service.listar(1)).single;
      expect(despesa.descricao, 'Taxa anual');
      expect(despesa.tipo, TipoDespesaVeiculo.documentacao);
      expect(despesa.observacao, isNull);
      expect(despesa.dataAtualizacao, agora);

      await expectLater(
        service.editar(
          id: id,
          veiculoId: 1,
          tipo: TipoDespesaVeiculo.ipva,
          descricao: '',
          valorCentavos: 0,
          dataHora: agora,
        ),
        throwsA(isA<Exception>()),
      );
      despesa = (await service.listar(1)).single;
      expect(despesa.descricao, 'Taxa anual');
      expect(despesa.valorCentavos, 4500);
    },
  );

  test('sugestões usam somente descrições históricas do mesmo tipo', () async {
    await service.criar(
      veiculoId: 1,
      tipo: TipoDespesaVeiculo.pedagio,
      descricao: 'Pedágio BR-116',
      valorCentavos: 1200,
    );
    await service.criar(
      veiculoId: 1,
      tipo: TipoDespesaVeiculo.lavagem,
      descricao: 'Lava-car',
      valorCentavos: 9000,
    );
    expect(await service.sugestoes(1, TipoDespesaVeiculo.pedagio), [
      'Pedágio BR-116',
    ]);
  });

  test(
    'registro permanece acessível ao recriar repository e service',
    () async {
      await service.criar(
        veiculoId: 1,
        tipo: TipoDespesaVeiculo.seguro,
        descricao: 'Seguro anual',
        valorCentavos: 10000,
      );
      final novoService = DespesaVeiculoService(
        DespesaVeiculoRepository(DespesaVeiculoDao(database)),
        agora: () => agora,
      );
      expect((await novoService.listar(1)).single.descricao, 'Seguro anual');
    },
  );

  testWidgets('formulário usa centavos, foco sequencial e conclui sem salvar', (
    tester,
  ) async {
    EditarDespesaVeiculoResultado? resultado;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () async {
                resultado = await showDialog<EditarDespesaVeiculoResultado>(
                  context: context,
                  builder: (_) => EditarDespesaVeiculoDialog(
                    buscarSugestoes: (_) async => const ['IPVA anual'],
                  ),
                );
              },
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();

    final descricao = find.byKey(const ValueKey('descricao_despesa'));
    expect(
      tester
          .widget<EditableText>(
            find.descendant(of: descricao, matching: find.byType(EditableText)),
          )
          .focusNode
          .hasFocus,
      isTrue,
    );
    await tester.enterText(descricao, 'Seguro');
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.enterText(find.byKey(const ValueKey('valor_despesa')), '1350');
    expect(find.text('13,50'), findsOneWidget);
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.enterText(
      find.byKey(const ValueKey('observacao_despesa')),
      'Anual',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    expect(find.text('Nova despesa'), findsOneWidget);
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(resultado?.valorCentavos, 1350);
    expect(resultado?.descricao, 'Seguro');
    expect(tester.takeException(), isNull);
  });

  testWidgets('cancelar com campo focado não retorna nem persiste alteração', (
    tester,
  ) async {
    EditarDespesaVeiculoResultado? resultado;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () async {
                resultado = await showDialog<EditarDespesaVeiculoResultado>(
                  context: context,
                  builder: (_) => EditarDespesaVeiculoDialog(
                    buscarSugestoes: (_) async => const [],
                  ),
                );
              },
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('descricao_despesa')),
      'Não salvar',
    );
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(resultado, isNull);
    expect(await service.listar(1), isEmpty);
    expect(tester.takeException(), isNull);
  });
}
