import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:km_rodado/core/constants/enums/escopo_custo_recorrente.dart';
import 'package:km_rodado/core/constants/enums/tipo_custo_recorrente.dart';
import 'package:km_rodado/core/database/app_database.dart';
import 'package:km_rodado/core/database/daos/custo_recorrente_dao.dart';
import 'package:km_rodado/core/database/seeds/plataformas_seed.dart';
import 'package:km_rodado/core/database/seeds/seed.dart';
import 'package:km_rodado/features/custo_recorrente/data/custo_recorrente_repository.dart';
import 'package:km_rodado/features/custo_recorrente/data/custo_recorrente_service.dart';
import 'package:km_rodado/features/custo_recorrente/presentation/widgets/editar_custo_recorrente_dialog.dart';

void main() {
  late AppDatabase database;
  late CustoRecorrenteService service;
  final agora = DateTime(2026, 8, 16, 12);

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await garantirDadosTemporarios(database);
    await garantirPlataformasPadrao(database);
    service = CustoRecorrenteService(
      CustoRecorrenteRepository(CustoRecorrenteDao(database)),
      agora: () => agora,
    );
  });

  tearDown(() => database.close());

  test(
    'cria referências mensal, anual e personalizada sem gerar Despesa',
    () async {
      await service.criar(
        tipo: TipoCustoRecorrente.seguro,
        descricao: '  Seguro veículo  ',
        escopo: EscopoCustoRecorrente.veiculo,
        veiculoId: 1,
        valorReferenciaCentavos: 22000,
        valorEstimado: true,
        periodicidadeMeses: 1,
        quantidadeCiclosPrevista: 24,
      );
      await service.criar(
        tipo: TipoCustoRecorrente.ipva,
        descricao: 'IPVA',
        escopo: EscopoCustoRecorrente.veiculo,
        veiculoId: 1,
        valorReferenciaCentavos: 91000,
        periodicidadeMeses: 12,
        parcelasPorCiclo: 3,
      );
      await service.criar(
        tipo: TipoCustoRecorrente.outro,
        descricao: 'Contrato especial',
        escopo: EscopoCustoRecorrente.atividade,
        periodicidadeMeses: 6,
      );

      final custos = await service.listar();
      expect(custos, hasLength(3));
      final seguro = custos.singleWhere(
        (custo) => custo.tipo == TipoCustoRecorrente.seguro,
      );
      final ipva = custos.singleWhere(
        (custo) => custo.tipo == TipoCustoRecorrente.ipva,
      );
      expect(seguro.descricao, 'Seguro veículo');
      expect(seguro.valorEstimado, isTrue);
      expect(seguro.quantidadeCiclosPrevista, 24);
      expect(seguro.ativo, isTrue);
      expect(ipva.periodicidadeMeses, 12);
      expect(ipva.parcelasPorCiclo, 3);
      expect(await database.select(database.despesasVeiculo).get(), isEmpty);
    },
  );

  test('valor nulo é desconhecido e zero é rejeitado', () async {
    await service.criar(
      tipo: TipoCustoRecorrente.telefoneProfissional,
      descricao: 'Linha profissional',
      escopo: EscopoCustoRecorrente.atividade,
      periodicidadeMeses: 1,
    );
    expect((await service.listar()).single.valorReferenciaCentavos, isNull);
    expect(
      service.equivalenteMensalReais(
        valorReferenciaCentavos: null,
        periodicidadeMeses: 1,
      ),
      isNull,
    );
    await expectLater(
      service.criar(
        tipo: TipoCustoRecorrente.telefoneProfissional,
        descricao: 'Zero',
        escopo: EscopoCustoRecorrente.atividade,
        valorReferenciaCentavos: 0,
        periodicidadeMeses: 1,
      ),
      throwsA(isA<Exception>()),
    );
  });

  test('valida descrição, periodicidade, parcelas e quantidade', () async {
    for (final chamada in <Future<void> Function()>[
      () => service.criar(
        tipo: TipoCustoRecorrente.outro,
        descricao: '   ',
        escopo: EscopoCustoRecorrente.atividade,
        periodicidadeMeses: 1,
      ),
      () => service.criar(
        tipo: TipoCustoRecorrente.outro,
        descricao: 'Inválido',
        escopo: EscopoCustoRecorrente.atividade,
        periodicidadeMeses: 0,
      ),
      () => service.criar(
        tipo: TipoCustoRecorrente.outro,
        descricao: 'Inválido',
        escopo: EscopoCustoRecorrente.atividade,
        periodicidadeMeses: 1,
        parcelasPorCiclo: 0,
      ),
      () => service.criar(
        tipo: TipoCustoRecorrente.outro,
        descricao: 'Inválido',
        escopo: EscopoCustoRecorrente.atividade,
        periodicidadeMeses: 1,
        quantidadeCiclosPrevista: 0,
      ),
    ]) {
      await expectLater(chamada(), throwsA(isA<Exception>()));
    }
    expect(await service.listar(), isEmpty);
  });

  test('valida os três escopos e suas FKs condicionais', () async {
    final plataforma =
        (await database.select(database.plataformas).get()).first;
    await service.criar(
      tipo: TipoCustoRecorrente.ipva,
      descricao: 'Veículo',
      escopo: EscopoCustoRecorrente.veiculo,
      veiculoId: 1,
      periodicidadeMeses: 12,
    );
    await service.criar(
      tipo: TipoCustoRecorrente.telefoneProfissional,
      descricao: 'Atividade',
      escopo: EscopoCustoRecorrente.atividade,
      periodicidadeMeses: 1,
    );
    await service.criar(
      tipo: TipoCustoRecorrente.contaPlataforma,
      descricao: 'Plataforma',
      escopo: EscopoCustoRecorrente.plataforma,
      plataformaId: plataforma.id,
      periodicidadeMeses: 1,
    );
    expect(await service.listar(), hasLength(3));

    for (final chamada in <Future<void> Function()>[
      () => service.criar(
        tipo: TipoCustoRecorrente.ipva,
        descricao: 'Sem veículo',
        escopo: EscopoCustoRecorrente.veiculo,
        periodicidadeMeses: 12,
      ),
      () => service.criar(
        tipo: TipoCustoRecorrente.contaPlataforma,
        descricao: 'Sem plataforma',
        escopo: EscopoCustoRecorrente.plataforma,
        periodicidadeMeses: 1,
      ),
      () => service.criar(
        tipo: TipoCustoRecorrente.outro,
        descricao: 'Misturado',
        escopo: EscopoCustoRecorrente.atividade,
        veiculoId: 1,
        plataformaId: plataforma.id,
        periodicidadeMeses: 1,
      ),
    ]) {
      await expectLater(chamada(), throwsA(isA<Exception>()));
    }
  });

  test('todos os tipos existem sem domínios excluídos', () {
    expect(TipoCustoRecorrente.values.map((tipo) => tipo.name), [
      'ipva',
      'licenciamento',
      'seguro',
      'parcelaVeiculo',
      'depreciacao',
      'telefoneProfissional',
      'contaPlataforma',
      'outro',
    ]);
  });

  test('defaults são editáveis e coerentes por tipo', () {
    expect(service.padraoPara(TipoCustoRecorrente.ipva).periodicidadeMeses, 12);
    expect(
      service.padraoPara(TipoCustoRecorrente.licenciamento).periodicidadeMeses,
      12,
    );
    expect(
      service.padraoPara(TipoCustoRecorrente.seguro).periodicidadeMeses,
      1,
    );
    for (final tipo in const [
      TipoCustoRecorrente.parcelaVeiculo,
      TipoCustoRecorrente.depreciacao,
    ]) {
      final padrao = service.padraoPara(tipo);
      expect(padrao.escopo, EscopoCustoRecorrente.veiculo);
      expect(padrao.periodicidadeMeses, 1);
    }
    expect(
      service.padraoPara(TipoCustoRecorrente.telefoneProfissional).escopo,
      EscopoCustoRecorrente.atividade,
    );
    expect(
      service.padraoPara(TipoCustoRecorrente.contaPlataforma).escopo,
      EscopoCustoRecorrente.plataforma,
    );
    expect(service.padraoPara(TipoCustoRecorrente.outro).escopo, isNull);
  });

  test('equivalente mensal deriva do ciclo e ignora parcelas', () {
    expect(
      service.equivalenteMensalReais(
        valorReferenciaCentavos: 91000,
        periodicidadeMeses: 12,
      ),
      closeTo(75.833333, 0.0001),
    );
    expect(
      service.equivalenteMensalReais(
        valorReferenciaCentavos: 15000,
        periodicidadeMeses: 12,
      ),
      12.5,
    );
    expect(
      service.equivalenteMensalReais(
        valorReferenciaCentavos: 22000,
        periodicidadeMeses: 1,
      ),
      220,
    );
  });

  test(
    'parcela não gera lançamentos e depreciação técnica não inventa valor',
    () async {
      await service.criar(
        tipo: TipoCustoRecorrente.parcelaVeiculo,
        descricao: 'Parcela do veículo',
        escopo: EscopoCustoRecorrente.veiculo,
        veiculoId: 1,
        valorReferenciaCentavos: 121000,
        periodicidadeMeses: 1,
        quantidadeCiclosPrevista: 48,
      );
      await service.criar(
        tipo: TipoCustoRecorrente.depreciacao,
        descricao: 'Depreciação',
        escopo: EscopoCustoRecorrente.veiculo,
        veiculoId: 1,
        periodicidadeMeses: 1,
      );

      final custos = await service.listar();
      expect(custos, hasLength(2));
      final depreciacao = custos.singleWhere(
        (custo) => custo.tipo == TipoCustoRecorrente.depreciacao,
      );
      expect(depreciacao.valorReferenciaCentavos, isNull);
      expect(
        custos
            .singleWhere(
              (custo) => custo.tipo == TipoCustoRecorrente.parcelaVeiculo,
            )
            .quantidadeCiclosPrevista,
        48,
      );
      expect(await database.select(database.despesasVeiculo).get(), isEmpty);
    },
  );

  test('edita, desativa e preserva em novo service', () async {
    final id = await service.criar(
      tipo: TipoCustoRecorrente.parcelaVeiculo,
      descricao: 'Parcela do veículo',
      escopo: EscopoCustoRecorrente.veiculo,
      veiculoId: 1,
      valorReferenciaCentavos: 22000,
      periodicidadeMeses: 1,
    );
    await service.editar(
      id: id,
      tipo: TipoCustoRecorrente.parcelaVeiculo,
      descricao: '  Parcela encerrada ',
      escopo: EscopoCustoRecorrente.veiculo,
      veiculoId: 1,
      valorReferenciaCentavos: 22050,
      valorEstimado: false,
      periodicidadeMeses: 2,
      parcelasPorCiclo: 1,
      ativo: false,
      observacao: '  fim do contrato ',
    );
    final novoService = CustoRecorrenteService(
      CustoRecorrenteRepository(CustoRecorrenteDao(database)),
    );
    final custo = (await novoService.listar()).single;
    expect(custo.descricao, 'Parcela encerrada');
    expect(custo.ativo, isFalse);
    expect(custo.periodicidadeMeses, 2);
    expect(custo.observacao, 'fim do contrato');
    expect(custo.dataAtualizacao, agora);
  });

  test('sugestão é só descrição do mesmo tipo', () async {
    await service.criar(
      tipo: TipoCustoRecorrente.ipva,
      descricao: 'IPVA referência',
      escopo: EscopoCustoRecorrente.veiculo,
      veiculoId: 1,
      valorReferenciaCentavos: 91000,
      periodicidadeMeses: 12,
    );
    await service.criar(
      tipo: TipoCustoRecorrente.seguro,
      descricao: 'Seguro referência',
      escopo: EscopoCustoRecorrente.veiculo,
      veiculoId: 1,
      valorReferenciaCentavos: 22000,
      periodicidadeMeses: 1,
    );
    expect(await service.sugestoes(TipoCustoRecorrente.ipva), [
      'IPVA referência',
    ]);
  });

  testWidgets('formulário deriva IPVA/licenciamento e mantém defaults', (
    tester,
  ) async {
    EditarCustoRecorrenteResultado? resultado;
    final veiculos = await database.select(database.veiculos).get();
    final plataformas = await database.select(database.plataformas).get();
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () async {
                resultado = await showDialog<EditarCustoRecorrenteResultado>(
                  context: context,
                  builder: (_) => EditarCustoRecorrenteDialog(
                    veiculoIdInicial: 1,
                    veiculos: veiculos,
                    plataformas: plataformas,
                    padraoPara: service.padraoPara,
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
    expect(find.text('Anual'), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('valor_custo_recorrente')),
      '91000',
    );
    await tester.pump();
    final equivalente = tester.widget<Text>(
      find.byKey(const ValueKey('equivalente_mensal'), skipOffstage: false),
    );
    expect(equivalente.data, contains('75,83'));
    await tester.tap(find.byKey(const ValueKey('tipo_custo_recorrente')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Licenciamento').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('valor_custo_recorrente')),
      '15000',
    );
    await tester.pump();
    expect(
      tester
          .widget<Text>(
            find.byKey(
              const ValueKey('equivalente_mensal'),
              skipOffstage: false,
            ),
          )
          .data,
      contains('12,50'),
    );
    await tester.enterText(
      find.byKey(const ValueKey('valor_custo_recorrente')),
      '91000',
    );
    await tester.tap(find.text('Personalizado'));
    await tester.pump();
    await tester.enterText(
      find.byKey(const ValueKey('meses_custo_recorrente')),
      '10',
    );
    await tester.enterText(
      find.byKey(const ValueKey('parcelas_custo_recorrente')),
      '3',
    );
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(resultado?.periodicidadeMeses, 10);
    expect(resultado?.parcelasPorCiclo, 3);
    expect(resultado?.valorReferenciaCentavos, 91000);
  });

  testWidgets(
    'formulário alterna atividade/plataforma e aceita valor ausente',
    (tester) async {
      final veiculos = await database.select(database.veiculos).get();
      final plataformas = await database.select(database.plataformas).get();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EditarCustoRecorrenteDialog(
              veiculoIdInicial: 1,
              veiculos: veiculos,
              plataformas: plataformas,
              padraoPara: service.padraoPara,
              buscarSugestoes: (_) async => const [],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('tipo_custo_recorrente')));
      await tester.pumpAndSettle();
      for (final tipo in TipoCustoRecorrente.values.where(
        (tipo) => tipo.disponivelEmNovoCadastro,
      )) {
        expect(find.text(tipo.label), findsWidgets);
      }
      expect(find.text('Parcela do veículo'), findsWidgets);
      expect(find.text('Depreciação'), findsNothing);
      await tester.tap(find.text('Telefone profissional').last);
      await tester.pumpAndSettle();
      expect(find.text('Valor não informado'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('veiculo_custo_recorrente')),
        findsNothing,
      );
      await tester.tap(find.byKey(const ValueKey('tipo_custo_recorrente')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Conta de plataforma').last);
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('plataforma_custo_recorrente')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('edição móvel abre preenchida e permite desativar', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await service.criar(
      tipo: TipoCustoRecorrente.seguro,
      descricao: 'Seguro veículo',
      escopo: EscopoCustoRecorrente.veiculo,
      veiculoId: 1,
      valorReferenciaCentavos: 22000,
      valorEstimado: true,
      periodicidadeMeses: 1,
      quantidadeCiclosPrevista: 24,
    );
    final existente = (await service.listar()).single;
    final veiculos = await database.select(database.veiculos).get();
    final plataformas = await database.select(database.plataformas).get();
    EditarCustoRecorrenteResultado? resultado;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () async {
                resultado = await showDialog<EditarCustoRecorrenteResultado>(
                  context: context,
                  builder: (_) => EditarCustoRecorrenteDialog(
                    existente: existente,
                    veiculoIdInicial: 1,
                    veiculos: veiculos,
                    plataformas: plataformas,
                    padraoPara: service.padraoPara,
                    buscarSugestoes: (_) async => const [],
                  ),
                );
              },
              child: const Text('Editar'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();
    expect(find.text('Seguro veículo'), findsOneWidget);
    expect(find.text('Mensal'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Ativo'),
      150,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Ativo'));
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(resultado?.ativo, isFalse);
    expect(resultado?.quantidadeCiclosPrevista, 24);
    expect(tester.takeException(), isNull);
  });

  testWidgets('depreciação técnica legada permanece legível', (tester) async {
    await service.criar(
      tipo: TipoCustoRecorrente.depreciacao,
      descricao: 'Depreciação legada',
      escopo: EscopoCustoRecorrente.veiculo,
      veiculoId: 1,
      periodicidadeMeses: 1,
    );
    final existente = (await service.listar()).single;
    final veiculos = await database.select(database.veiculos).get();
    final plataformas = await database.select(database.plataformas).get();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EditarCustoRecorrenteDialog(
            existente: existente,
            veiculoIdInicial: 1,
            veiculos: veiculos,
            plataformas: plataformas,
            padraoPara: service.padraoPara,
            buscarSugestoes: (_) async => const [],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Depreciação'), findsOneWidget);
    expect(find.text('Depreciação legada'), findsOneWidget);
    expect(find.text('Valor não informado'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
