import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:km_rodado/core/constants/enums/status_jornada.dart';
import 'package:km_rodado/core/database/app_database.dart';
import 'package:km_rodado/core/database/daos/jornada_dao.dart';
import 'package:km_rodado/core/database/daos/planejamento_mensal_dao.dart';
import 'package:km_rodado/core/database/seeds/seed.dart';
import 'package:km_rodado/features/jornada/data/jornada_repository.dart';
import 'package:km_rodado/features/planejamento_mensal/data/planejamento_mensal_repository.dart';
import 'package:km_rodado/features/planejamento_mensal/data/planejamento_mensal_service.dart';
import 'package:km_rodado/features/planejamento_mensal/presentation/controllers/planejamento_mensal_controller.dart';
import 'package:km_rodado/features/planejamento_mensal/presentation/pages/planejamento_mensal_page.dart';

void main() {
  late AppDatabase database;
  late PlanejamentoMensalService service;

  setUpAll(() => initializeDateFormatting('pt_BR'));

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await garantirDadosTemporarios(database);
    service = PlanejamentoMensalService(
      PlanejamentoMensalRepository(PlanejamentoMensalDao(database)),
      JornadaRepository(JornadaDao(database)),
    );
  });

  tearDown(() => database.close());

  test('deriva médias e progresso das Jornadas distintas do mês', () async {
    final jornadaDao = JornadaDao(database);
    await jornadaDao.inserir(
      JornadasCompanion.insert(
        usuarioId: 1,
        veiculoId: 1,
        dataHoraInicio: DateTime(2026, 8, 31, 22),
        dataHoraFim: Value(DateTime(2026, 9, 1, 2)),
        odometroInicio: 1000,
        odometroFim: const Value(1200),
        cidadeOrigem: 'Curitiba',
        status: StatusJornada.finalizada,
        quilometrosPercorridos: const Value(200),
      ),
    );
    await jornadaDao.inserir(
      JornadasCompanion.insert(
        usuarioId: 1,
        veiculoId: 1,
        dataHoraInicio: DateTime(2026, 8, 31, 8),
        dataHoraFim: Value(DateTime(2026, 8, 31, 12)),
        odometroInicio: 1200,
        odometroFim: const Value(1300),
        cidadeOrigem: 'Curitiba',
        status: StatusJornada.finalizada,
        quilometrosPercorridos: const Value(100),
      ),
    );
    await service.salvar(
      usuarioId: 1,
      mes: DateTime(2026, 8, 12),
      diasPlanejados: 20,
      metaKmMensal: 3000,
    );

    final resumo = await service.calcular(usuarioId: 1, mes: DateTime(2026, 8));
    expect(resumo.kmRealizados, 300);
    expect(resumo.mediaPlanejadaKmDia, 150);
    expect(resumo.kmRestantes, 2700);
    expect(resumo.diasTrabalhados, 1);
    expect(resumo.diasPlanejadosRestantes, 19);
    expect(resumo.mediaNecessariaKmDia, closeTo(2700 / 19, 0.001));
  });

  test(
    'trata meta atingida, ultrapassada e ausência de planejamento',
    () async {
      final semPlanejamento = await service.calcular(
        usuarioId: 1,
        mes: DateTime(2026, 8),
      );
      expect(semPlanejamento.possuiPlanejamento, isFalse);
      expect(semPlanejamento.percentualMeta, isNull);

      await service.salvar(
        usuarioId: 1,
        mes: DateTime(2026, 8),
        diasPlanejados: 0,
        metaKmMensal: 0,
      );
      final resumo = await service.calcular(
        usuarioId: 1,
        mes: DateTime(2026, 8),
      );
      expect(resumo.mediaPlanejadaKmDia, isNull);
      expect(resumo.mediaNecessariaKmDia, 0);
      expect(resumo.kmRestantes, 0);
    },
  );

  testWidgets('tela estreita permanece sem overflow', (tester) async {
    final controller = PlanejamentoMensalController(service, usuarioId: 1);
    await tester.pumpWidget(
      MaterialApp(home: PlanejamentoMensalPage(controller: controller)),
    );
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });

  testWidgets('inicia e limita dias planejados ao mês selecionado', (
    tester,
  ) async {
    final controller = PlanejamentoMensalController(service, usuarioId: 1)
      ..mes = DateTime(2028, 2);
    await tester.pumpWidget(
      MaterialApp(home: PlanejamentoMensalPage(controller: controller)),
    );
    await tester.pumpAndSettle();

    final dias = find.byType(TextField).first;
    expect(tester.widget<TextField>(dias).controller!.text, '29');
    expect(find.text('de 29 dias'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pump();
    expect(tester.widget<TextField>(dias).controller!.text, '29');
    await tester.tap(find.byIcon(Icons.remove_circle_outline));
    await tester.pump();
    expect(tester.widget<TextField>(dias).controller!.text, '28');

    await tester.enterText(dias, '0');
    await tester.tap(find.byIcon(Icons.remove_circle_outline));
    await tester.pump();
    expect(tester.widget<TextField>(dias).controller!.text, '0');

    await controller.alterarMes(DateTime(2027, 2));
    await tester.pumpAndSettle();
    expect(find.text('de 28 dias'), findsOneWidget);
    await controller.alterarMes(DateTime(2026, 9));
    await tester.pumpAndSettle();
    expect(find.text('de 30 dias'), findsOneWidget);
    await controller.alterarMes(DateTime(2026, 8));
    await tester.pumpAndSettle();
    expect(find.text('de 31 dias'), findsOneWidget);
  });
}
