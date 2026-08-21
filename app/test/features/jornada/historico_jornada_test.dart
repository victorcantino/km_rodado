import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:km_rodado/core/constants/enums/status_jornada.dart';
import 'package:km_rodado/core/constants/enums/tipo_registro_ganhos.dart';
import 'package:km_rodado/core/database/app_database.dart';
import 'package:km_rodado/core/database/daos/abastecimento_dao.dart';
import 'package:km_rodado/core/database/daos/bonus_promocao_dao.dart';
import 'package:km_rodado/core/database/daos/despesa_veiculo_dao.dart';
import 'package:km_rodado/core/database/daos/ganho_individual_dao.dart';
import 'package:km_rodado/core/database/daos/jornada_dao.dart';
import 'package:km_rodado/core/database/daos/leitura_ganhos_dao.dart';
import 'package:km_rodado/core/database/daos/manutencao_dao.dart';
import 'package:km_rodado/core/database/daos/passe_plataforma_dao.dart';
import 'package:km_rodado/core/database/daos/pausa_dao.dart';
import 'package:km_rodado/core/database/seeds/seed.dart';
import 'package:km_rodado/features/bonus_promocao/data/bonus_promocao_repository.dart';
import 'package:km_rodado/features/abastecimento/data/abastecimento_repository.dart';
import 'package:km_rodado/features/despesa_veiculo/data/despesa_veiculo_repository.dart';
import 'package:km_rodado/features/ganho_individual/data/ganho_individual_repository.dart';
import 'package:km_rodado/features/jornada/data/historico_jornada.dart';
import 'package:km_rodado/features/jornada/data/jornada_repository.dart';
import 'package:km_rodado/features/jornada/data/jornada_service.dart';
import 'package:km_rodado/features/leitura_ganhos/data/leitura_ganhos_repository.dart';
import 'package:km_rodado/features/manutencao/data/manutencao_repository.dart';
import 'package:km_rodado/features/passe_plataforma/data/passe_plataforma_repository.dart';
import 'package:km_rodado/features/pausa/data/pausa_repository.dart';
import 'package:km_rodado/features/jornada/presentation/pages/jornada_page.dart';

void main() {
  late AppDatabase database;
  late JornadaService service;
  late Jornada jornada;

  setUpAll(() => initializeDateFormatting('pt_BR'));

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await garantirDadosTemporarios(database);
    final inicio = DateTime(2026, 8, 13, 8);
    final fim = DateTime(2026, 8, 13, 18);
    final id = await database
        .into(database.jornadas)
        .insert(
          JornadasCompanion.insert(
            usuarioId: 1,
            veiculoId: 1,
            dataHoraInicio: inicio,
            dataHoraFim: Value(fim),
            odometroInicio: 1000,
            odometroFim: const Value(1100),
            cidadeOrigem: 'Curitiba',
            status: StatusJornada.finalizada,
          ),
        );
    jornada = (await JornadaDao(database).buscarPorId(id))!;
    service = JornadaService(
      JornadaRepository(JornadaDao(database)),
      PausaRepository(PausaDao(database)),
      LeituraGanhosRepository(LeituraGanhosDao(database)),
      GanhoIndividualRepository(GanhoIndividualDao(database)),
      PassePlataformaRepository(PassePlataformaDao(database)),
      BonusPromocaoRepository(BonusPromocaoDao(database)),
      AbastecimentoRepository(AbastecimentoDao(database)),
      null,
      ManutencaoRepository(ManutencaoDao(database)),
      DespesaVeiculoRepository(DespesaVeiculoDao(database)),
    );
  });

  tearDown(() => database.close());

  test(
    'ordena fatos cronologicamente e ignora fatos fora do intervalo',
    () async {
      final plataforma = await database
          .into(database.plataformas)
          .insert(
            PlataformasCompanion.insert(
              nome: 'Particular',
              tipoRegistroGanhos: TipoRegistroGanhos.individual,
            ),
          );
      await database
          .into(database.lancamentosGanhoIndividual)
          .insert(
            LancamentosGanhoIndividualCompanion.insert(
              plataformaId: plataforma,
              jornadaId: Value(jornada.id),
              quantidadeViagens: 2,
              valorTotalCentavos: 5000,
              dataHora: Value(DateTime(2026, 8, 13, 12)),
            ),
          );
      await database
          .into(database.lancamentosGanhoIndividual)
          .insert(
            LancamentosGanhoIndividualCompanion.insert(
              plataformaId: plataforma,
              jornadaId: Value(jornada.id),
              quantidadeViagens: 1,
              valorTotalCentavos: 1000,
              dataHora: Value(DateTime(2026, 8, 14, 9)),
            ),
          );

      final eventos = await service.historicoJornada(jornada);
      expect(eventos.first.titulo, 'Início da Jornada');
      expect(eventos.any((e) => e.detalhe == '2 viagens'), isTrue);
      expect(eventos.any((e) => e.detalhe == '1 viagem'), isFalse);
      expect(
        eventos.every(
          (evento) =>
              !evento.dataHora.isBefore(jornada.dataHoraInicio) &&
              !evento.dataHora.isAfter(jornada.dataHoraFim!),
        ),
        isTrue,
      );
    },
  );

  test(
    'desempata mesmo horário por ordem e id sem inventar detalhe de lote',
    () async {
      final plataforma = await database
          .into(database.plataformas)
          .insert(
            PlataformasCompanion.insert(
              nome: 'Particular',
              tipoRegistroGanhos: TipoRegistroGanhos.individual,
            ),
          );
      final hora = DateTime(2026, 8, 13, 10);
      await database
          .into(database.lancamentosGanhoIndividual)
          .insert(
            LancamentosGanhoIndividualCompanion.insert(
              plataformaId: plataforma,
              jornadaId: Value(jornada.id),
              quantidadeViagens: 3,
              valorTotalCentavos: 7000,
              dataHora: Value(hora),
            ),
          );
      final eventos = await service.historicoJornada(jornada);
      final ganho = eventos.singleWhere((e) => e.titulo == 'Ganho individual');
      expect(ganho.detalhe, '3 viagens');
      expect(
        eventos.map((e) => e.dataHora).toList(),
        orderedEquals([...eventos.map((e) => e.dataHora).toList()..sort()]),
      );
    },
  );

  testWidgets('timeline cabe em tela estreita sem overflow', (tester) async {
    final eventos = List.generate(
      20,
      (index) => HistoricoJornadaEvento(
        dataHora: DateTime(2026, 8, 13, 8 + index ~/ 2, index.isEven ? 0 : 30),
        ordem: index,
        id: index,
        titulo: 'Evento $index',
        detalhe: 'Informação essencial',
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: HistoricoJornadaPage(jornada: jornada, eventos: eventos),
      ),
    );
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    await tester.pump();
    expect(tester.takeException(), isNull);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  });

  testWidgets('agrupa eventos por dia ao atravessar a meia-noite', (
    tester,
  ) async {
    final eventos = [
      HistoricoJornadaEvento(
        dataHora: DateTime(2026, 8, 21, 23, 30),
        ordem: 1,
        id: 1,
        titulo: 'Evento antes da meia-noite',
      ),
      HistoricoJornadaEvento(
        dataHora: DateTime(2026, 8, 22, 0, 15),
        ordem: 2,
        id: 2,
        titulo: 'Evento depois da meia-noite',
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: HistoricoJornadaPage(jornada: jornada, eventos: eventos),
      ),
    );

    expect(find.text('21/08/2026 — sexta-feira'), findsOneWidget);
    expect(find.text('22/08/2026 — sábado'), findsOneWidget);
    expect(find.text('23:30'), findsOneWidget);
    expect(find.text('00:15'), findsOneWidget);
    expect(find.text('21/08/2026 — sexta-feira'), findsOneWidget);
  });
}
