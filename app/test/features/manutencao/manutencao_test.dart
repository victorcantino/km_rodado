import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:km_rodado/core/constants/enums/tipo_combustivel.dart';
import 'package:km_rodado/core/database/app_database.dart';
import 'package:km_rodado/core/database/daos/abastecimento_dao.dart';
import 'package:km_rodado/core/database/daos/jornada_dao.dart';
import 'package:km_rodado/core/database/daos/manutencao_dao.dart';
import 'package:km_rodado/core/database/seeds/seed.dart';
import 'package:km_rodado/features/abastecimento/data/abastecimento_repository.dart';
import 'package:km_rodado/features/abastecimento/data/abastecimento_service.dart';
import 'package:km_rodado/features/jornada/data/jornada_repository.dart';
import 'package:km_rodado/features/manutencao/data/manutencao_repository.dart';
import 'package:km_rodado/features/manutencao/data/manutencao_service.dart';
import 'package:km_rodado/features/manutencao/presentation/widgets/editar_manutencao_dialog.dart';

void main() {
  late AppDatabase database;
  late ManutencaoService service;
  final agora = DateTime(2026, 8, 15, 12);

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await garantirDadosTemporarios(database);
    service = ManutencaoService(
      ManutencaoRepository(ManutencaoDao(database)),
      AbastecimentoRepository(AbastecimentoDao(database)),
      agora: () => agora,
    );
  });

  tearDown(() => database.close());

  ItemManutencaoEntrada item(
    String descricao, {
    int? valor,
    int? intervalo,
    DateTime? vencimento,
  }) => (
    descricao: descricao,
    valorCentavos: valor,
    intervaloKm: intervalo,
    vencimentoEm: vencimento,
  );

  test(
    'cria cabeçalho com vários itens e custo completo em centavos',
    () async {
      await service.criar(
        veiculoId: 1,
        dataHora: DateTime(2026, 8, 14),
        odometro: 130000,
        oficina: '  Oficina A  ',
        itens: [item(' Óleo ', valor: 20000), item('Filtro', valor: 5000)],
      );

      final registro = (await service.listar(1)).single;
      expect(registro.manutencao.oficina, 'Oficina A');
      expect(registro.itens.map((i) => i.descricao), ['Óleo', 'Filtro']);
      final custo = service.resumirCusto(registro.itens);
      expect(custo.custoConhecidoCentavos, 25000);
      expect(custo.custoCompleto, isTrue);
    },
  );

  test('valor ausente permanece nulo e produz custo parcial', () async {
    await service.criar(
      veiculoId: 1,
      dataHora: DateTime(2026, 8, 14),
      odometro: 130000,
      itens: [item('Óleo', valor: 20000), item('Mão de obra')],
    );
    final itens = (await service.listar(1)).single.itens;
    expect(itens.last.valorCentavos, isNull);
    final custo = service.resumirCusto(itens);
    expect(custo.custoConhecidoCentavos, 20000);
    expect(custo.itensSemValor, 1);
    expect(custo.custoCompleto, isFalse);
  });

  test('valida itens antes da transação e não salva parcialmente', () async {
    await expectLater(
      service.criar(
        veiculoId: 1,
        dataHora: DateTime(2026, 8, 14),
        odometro: 10,
        itens: [item('Válido'), item('   ')],
      ),
      throwsA(isA<Exception>()),
    );
    expect(await database.select(database.manutencoes).get(), isEmpty);
    expect(await database.select(database.itensManutencao).get(), isEmpty);
    await expectLater(
      service.criar(
        veiculoId: 1,
        dataHora: DateTime(2026, 8, 14),
        odometro: 10,
        itens: const [],
      ),
      throwsA(isA<Exception>()),
    );
  });

  test(
    'registro tardio vale, futuro e recorrências inválidas são rejeitados',
    () async {
      await service.criar(
        veiculoId: 1,
        dataHora: DateTime(2025),
        odometro: 100,
        itens: [item('Livre', vencimento: DateTime(2026))],
      );
      for (final entrada in [
        item('Zero', intervalo: 0),
        item('Negativo', intervalo: -1),
        item('Vencido', vencimento: DateTime(2024)),
      ]) {
        await expectLater(
          service.criar(
            veiculoId: 1,
            dataHora: DateTime(2025),
            odometro: 100,
            itens: [entrada],
          ),
          throwsA(isA<Exception>()),
        );
      }
      await expectLater(
        service.criar(
          veiculoId: 1,
          dataHora: agora.add(const Duration(minutes: 1)),
          odometro: 100,
          itens: [item('Futuro')],
        ),
        throwsA(isA<Exception>()),
      );
    },
  );

  test(
    'valida odômetro por cronologia, aceita igualdade e sugere Manutenção',
    () async {
      await database
          .into(database.abastecimentos)
          .insert(
            AbastecimentosCompanion.insert(
              veiculoId: 1,
              dataHora: DateTime(2026, 8, 10),
              odometro: 1000,
              tipoCombustivel: TipoCombustivel.gasolina,
              volumeMililitros: 1000,
              valorTotalPagoCentavos: 100,
            ),
          );
      await database
          .into(database.abastecimentos)
          .insert(
            AbastecimentosCompanion.insert(
              veiculoId: 1,
              dataHora: DateTime(2026, 8, 12),
              odometro: 1200,
              tipoCombustivel: TipoCombustivel.gasolina,
              volumeMililitros: 1000,
              valorTotalPagoCentavos: 100,
            ),
          );
      await service.criar(
        veiculoId: 1,
        dataHora: DateTime(2026, 8, 11),
        odometro: 1000,
        itens: [item('Pneu')],
      );
      expect(await service.sugerirOdometro(1), 1200);
      await expectLater(
        service.criar(
          veiculoId: 1,
          dataHora: DateTime(2026, 8, 11),
          odometro: 999,
          itens: [item('Regressivo')],
        ),
        throwsA(isA<Exception>()),
      );
      await expectLater(
        service.criar(
          veiculoId: 1,
          dataHora: DateTime(2026, 8, 11),
          odometro: 1201,
          itens: [item('Além')],
        ),
        throwsA(isA<Exception>()),
      );
    },
  );

  test('Abastecimento posterior respeita odômetro da Manutenção', () async {
    await service.criar(
      veiculoId: 1,
      dataHora: DateTime(2026, 8, 14, 10),
      odometro: 130200,
      itens: [item('Conserto de Pneu')],
    );
    final abastecimentoService = AbastecimentoService(
      AbastecimentoRepository(AbastecimentoDao(database)),
      JornadaRepository(JornadaDao(database)),
      agora: () => agora,
    );

    await expectLater(
      abastecimentoService.registrar(
        veiculoId: 1,
        odometro: 130199,
        tipoCombustivel: TipoCombustivel.gasolina,
        volumeMililitros: 1000,
        valorTotalPagoCentavos: 500,
        tanqueCheio: true,
        dataHora: DateTime(2026, 8, 14, 11),
      ),
      throwsA(isA<Exception>()),
    );
    await abastecimentoService.registrar(
      veiculoId: 1,
      odometro: 130200,
      tipoCombustivel: TipoCombustivel.gasolina,
      volumeMililitros: 1000,
      valorTotalPagoCentavos: 500,
      tanqueCheio: true,
      dataHora: DateTime(2026, 8, 14, 11),
    );
  });

  test(
    'sugestões reutilizam descrição e intervalo, nunca valor ou vencimento',
    () async {
      await service.criar(
        veiculoId: 1,
        dataHora: DateTime(2026, 8, 14),
        odometro: 1000,
        itens: [
          item(
            'Troca de Óleo',
            valor: 32000,
            intervalo: 10000,
            vencimento: DateTime(2027),
          ),
        ],
      );
      expect(await service.sugestoes(1), contains('Troca de Óleo'));
      expect(await service.sugerirIntervalo(1, ' troca de óleo '), 10000);
      expect(await service.sugerirIntervalo(1, 'Litro de óleo'), isNull);
    },
  );

  test(
    'recorrência ativa usa somente ocorrência mais recente normalizada',
    () async {
      await service.criar(
        veiculoId: 1,
        dataHora: DateTime(2026, 8, 10),
        odometro: 1000,
        itens: [item('Troca de Óleo', intervalo: 10000)],
      );
      await service.criar(
        veiculoId: 1,
        dataHora: DateTime(2026, 8, 14),
        odometro: 2000,
        itens: [
          item(' troca de óleo ', intervalo: 12000),
          item('Litro de óleo'),
        ],
      );
      final proximas = await service.proximas(1);
      expect(proximas, hasLength(1));
      expect(proximas.single.proximoOdometro, 14000);
      expect(proximas.single.kmRestantes, 12000);
    },
  );

  test(
    'edição substitui itens atomicamente e persiste ao recriar service',
    () async {
      final id = await service.criar(
        veiculoId: 1,
        dataHora: DateTime(2026, 8, 14),
        odometro: 1000,
        itens: [item('Antigo')],
      );
      await service.editar(
        id: id,
        veiculoId: 1,
        dataHora: DateTime(2026, 8, 14),
        odometro: 1000,
        itens: [item('Novo', valor: 0), item('Outro')],
      );
      final novoService = ManutencaoService(
        ManutencaoRepository(ManutencaoDao(database)),
        AbastecimentoRepository(AbastecimentoDao(database)),
        agora: () => agora,
      );
      final registro = (await novoService.listar(1)).single;
      expect(registro.itens.map((i) => i.descricao), ['Novo', 'Outro']);
      expect(registro.itens.first.valorCentavos, 0);
    },
  );

  testWidgets(
    'formulário inicia preenchido, descrição focada e aceita vários itens',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => showDialog<EditarManutencaoResultado>(
                context: context,
                builder: (_) => EditarManutencaoDialog(
                  odometroInicial: 130200,
                  sugestoes: const ['Conserto de Pneu'],
                  sugerirIntervalo: (_) async => null,
                ),
              ),
              child: const Text('Abrir'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Abrir'));
      await tester.pumpAndSettle();
      expect(find.text('130.200'), findsOneWidget);
      expect(
        find.textContaining(DateTime.now().year.toString()),
        findsOneWidget,
      );
      final descricao = find.byKey(const ValueKey('descricao_item_manutencao'));
      expect(descricao, findsOneWidget);
      final editavel = find.descendant(
        of: descricao,
        matching: find.byType(EditableText),
      );
      expect(tester.widget<EditableText>(editavel).focusNode.hasFocus, isTrue);
      await tester.enterText(descricao, 'Serviço novo');
      await tester.ensureVisible(find.text('Adicionar item'));
      await tester.tap(find.text('Adicionar item'));
      await tester.pump();
      expect(
        find.byKey(const ValueKey('descricao_item_manutencao')),
        findsNWidgets(2),
      );
      expect(tester.takeException(), isNull);
    },
  );
}
