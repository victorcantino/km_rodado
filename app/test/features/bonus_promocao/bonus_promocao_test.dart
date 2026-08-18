import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:km_rodado/core/constants/enums/status_jornada.dart';
import 'package:km_rodado/core/constants/enums/tipo_bonus_promocao.dart';
import 'package:km_rodado/core/constants/enums/tipo_registro_ganhos.dart';
import 'package:km_rodado/core/database/app_database.dart';
import 'package:km_rodado/core/database/daos/bonus_promocao_dao.dart';
import 'package:km_rodado/core/database/daos/jornada_dao.dart';
import 'package:km_rodado/core/database/seeds/seed.dart';
import 'package:km_rodado/features/bonus_promocao/data/bonus_promocao_repository.dart';
import 'package:km_rodado/features/bonus_promocao/data/bonus_promocao_service.dart';
import 'package:km_rodado/features/bonus_promocao/presentation/controllers/bonus_promocao_controller.dart';
import 'package:km_rodado/features/jornada/data/jornada_repository.dart';
import 'package:km_rodado/features/bonus_promocao/presentation/widgets/registrar_bonus_promocao_dialog.dart';

void main() {
  late AppDatabase database;
  late BonusPromocaoRepository repository;
  late BonusPromocaoService service;
  final criacao = DateTime(2026, 8, 15, 12);

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await garantirDadosTemporarios(database);
    repository = BonusPromocaoRepository(BonusPromocaoDao(database));
    service = BonusPromocaoService(
      repository,
      JornadaRepository(JornadaDao(database)),
      agora: () => criacao,
    );
  });
  tearDown(() => database.close());

  Future<int> plataforma({bool ativa = true}) => database
      .into(database.plataformas)
      .insert(
        PlataformasCompanion.insert(
          nome: 'Plataforma',
          tipoRegistroGanhos: TipoRegistroGanhos.acumulado,
          ativa: Value(ativa),
        ),
      );

  Future<int> jornadaAberta() => database
      .into(database.jornadas)
      .insert(
        JornadasCompanion.insert(
          usuarioId: 1,
          veiculoId: 1,
          dataHoraInicio: DateTime(2026, 8, 15, 8),
          odometroInicio: 100,
          cidadeOrigem: 'Curitiba',
          status: StatusJornada.aberta,
        ),
      );

  test('registro histórico promoção permanece legível', () async {
    final plataformaId = await plataforma();
    final operacional = DateTime(2026, 8, 14, 18);
    await service.registrar(
      plataformaId: plataformaId,
      dataHora: operacional,
      valorCentavos: 2000,
      tipo: TipoBonusPromocao.promocao,
      observacao: '  Meta semanal  ',
    );

    final bonus = (await database.select(database.bonusPromocoes).get()).single;
    expect(bonus.jornadaId, isNull);
    expect(bonus.dataHora, operacional);
    expect(bonus.dataCriacao, criacao);
    expect(bonus.valorCentavos, 2000);
    expect(bonus.tipo, TipoBonusPromocao.promocao);
    expect(bonus.observacao, 'Meta semanal');
    expect(await database.select(database.leiturasGanhos).get(), isEmpty);
  });

  test('controller persiste novo crédito com tipo técnico canônico', () async {
    final plataformaId = await plataforma();
    final controller = BonusPromocaoController(service);
    await controller.registrar(
      plataformaId: plataformaId,
      dataHora: DateTime(2026, 8, 15, 10),
      valorCentavos: 800,
    );

    final credito =
        (await database.select(database.bonusPromocoes).get()).single;
    expect(credito.tipo, TipoBonusPromocao.bonus);
    controller.dispose();
  });

  test('associa automaticamente à Jornada aberta', () async {
    final plataformaId = await plataforma();
    final jornadaId = await jornadaAberta();
    await service.registrar(
      plataformaId: plataformaId,
      dataHora: DateTime(2026, 8, 15, 10),
      valorCentavos: 500,
      tipo: TipoBonusPromocao.bonus,
      observacao: '   ',
    );
    final item = (await repository.listarPorJornada(jornadaId)).single;
    expect(item.bonusPromocao.jornadaId, jornadaId);
    expect(item.bonusPromocao.observacao, isNull);
  });

  test(
    'retroativo anterior à Jornada aberta permanece sem associação',
    () async {
      final plataformaId = await plataforma();
      final jornadaId = await jornadaAberta();

      await service.registrar(
        plataformaId: plataformaId,
        dataHora: DateTime(2026, 8, 14, 23),
        valorCentavos: 500,
        tipo: TipoBonusPromocao.bonus,
      );

      final bonus =
          (await database.select(database.bonusPromocoes).get()).single;
      expect(bonus.jornadaId, isNull);
      expect(await repository.listarPorJornada(jornadaId), isEmpty);
    },
  );

  test('exige plataforma existente e valor positivo', () async {
    final plataformaId = await plataforma();
    for (final valor in [0, -1]) {
      await expectLater(
        service.registrar(
          plataformaId: plataformaId,
          dataHora: DateTime.now(),
          valorCentavos: valor,
          tipo: TipoBonusPromocao.bonus,
        ),
        throwsException,
      );
    }
    await expectLater(
      service.registrar(
        plataformaId: 999,
        dataHora: DateTime.now(),
        valorCentavos: 1,
        tipo: TipoBonusPromocao.bonus,
      ),
      throwsException,
    );
  });

  test('plataforma inativa preserva histórico ao recriar service', () async {
    final plataformaId = await plataforma();
    final jornadaId = await jornadaAberta();
    await service.registrar(
      plataformaId: plataformaId,
      dataHora: DateTime(2026, 8, 15, 9),
      valorCentavos: 1000,
      tipo: TipoBonusPromocao.bonus,
    );
    await (database.update(database.plataformas)
          ..where((p) => p.id.equals(plataformaId)))
        .write(const PlataformasCompanion(ativa: Value(false)));
    final novoRepository = BonusPromocaoRepository(BonusPromocaoDao(database));
    final novoService = BonusPromocaoService(
      novoRepository,
      JornadaRepository(JornadaDao(database)),
    );
    expect(await novoService.listarPlataformasAtivas(), isEmpty);
    expect(await novoService.listarPorJornada(jornadaId), hasLength(1));
  });

  testWidgets('diálogo usa entrada monetária móvel e retorna o crédito', (
    tester,
  ) async {
    final plataformaId = await plataforma();
    final plataformas = await repository.listarPlataformasAtivas();
    RegistrarBonusPromocaoResultado? resultado;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pt', 'BR'),
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [Locale('pt', 'BR')],
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                resultado = await showDialog<RegistrarBonusPromocaoResultado>(
                  context: context,
                  builder: (_) =>
                      RegistrarBonusPromocaoDialog(plataformas: plataformas),
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
    expect(find.text('Tipo'), findsNothing);
    expect(find.text('Promoção'), findsNothing);
    final campo = find.byKey(const ValueKey('valor_bonus_promocao'));
    expect(
      tester
          .widget<EditableText>(
            find.descendant(of: campo, matching: find.byType(EditableText)),
          )
          .focusNode
          .hasFocus,
      isTrue,
    );
    await tester.enterText(campo, '2000');
    expect(find.text('20,00'), findsOneWidget);
    await tester.tap(find.text('Registrar'));
    await tester.pumpAndSettle();
    expect(resultado?.plataformaId, plataformaId);
    expect(resultado?.valorCentavos, 2000);
    expect(tester.takeException(), isNull);
  });
}
