import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:km_rodado/core/constants/enums/status_jornada.dart';
import 'package:km_rodado/core/constants/enums/tipo_combustivel.dart';
import 'package:km_rodado/core/database/app_database.dart';
import 'package:km_rodado/core/database/daos/abastecimento_dao.dart';
import 'package:km_rodado/core/database/daos/jornada_dao.dart';
import 'package:km_rodado/core/database/daos/pausa_dao.dart';
import 'package:km_rodado/core/database/seeds/seed.dart';
import 'package:km_rodado/features/abastecimento/data/abastecimento_repository.dart';
import 'package:km_rodado/features/jornada/data/jornada_repository.dart';
import 'package:km_rodado/features/jornada/data/jornada_service.dart';
import 'package:km_rodado/features/pausa/data/pausa_repository.dart';

void main() {
  late AppDatabase database;
  late JornadaService service;
  late int jornadaId;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await garantirDadosTemporarios(database);
    jornadaId = await database
        .into(database.jornadas)
        .insert(
          JornadasCompanion.insert(
            usuarioId: 1,
            veiculoId: 1,
            dataHoraInicio: DateTime(2026, 8, 15, 8),
            odometroInicio: 52100,
            cidadeOrigem: 'Curitiba',
            status: StatusJornada.aberta,
          ),
        );
    service = JornadaService(
      JornadaRepository(JornadaDao(database)),
      PausaRepository(PausaDao(database)),
      null,
      null,
      null,
      null,
      AbastecimentoRepository(AbastecimentoDao(database)),
      () => DateTime(2026, 8, 16),
    );
  });

  tearDown(() => database.close());

  Future<void> inserirPausa({
    required DateTime inicio,
    required int odometroInicio,
    DateTime? fim,
    int? odometroFim,
  }) => database
      .into(database.pausas)
      .insert(
        PausasCompanion.insert(
          jornadaId: jornadaId,
          inicio: inicio,
          odometroInicio: Value(odometroInicio),
          fim: Value(fim),
          odometroFim: Value(odometroFim),
        ),
      );

  Future<void> inserirAbastecimento({
    required DateTime dataHora,
    required int odometro,
  }) => database
      .into(database.abastecimentos)
      .insert(
        AbastecimentosCompanion.insert(
          veiculoId: 1,
          jornadaId: Value(jornadaId),
          dataHora: dataHora,
          odometro: odometro,
          tipoCombustivel: TipoCombustivel.gasolina,
          volumeMililitros: 1000,
          valorTotalPagoCentavos: 500,
        ),
      );

  test('sugere o odômetro inicial quando é o único fato', () async {
    expect(await service.sugerirOdometroFechamento(), 52100);
  });

  test('sugere o fim da última Pausa concluída', () async {
    await inserirPausa(
      inicio: DateTime(2026, 8, 15, 12),
      odometroInicio: 52135,
      fim: DateTime(2026, 8, 15, 13),
      odometroFim: 52136,
    );

    expect(await service.sugerirOdometroFechamento(), 52136);
  });

  test('aceita Pausa iniciada e finalizada no mesmo odômetro', () async {
    await inserirPausa(
      inicio: DateTime(2026, 8, 15, 12),
      odometroInicio: 52135,
      fim: DateTime(2026, 8, 15, 13),
      odometroFim: 52135,
    );

    expect(await service.sugerirOdometroFechamento(), 52135);
  });

  test('Abastecimento posterior à Pausa fornece a sugestão', () async {
    await inserirPausa(
      inicio: DateTime(2026, 8, 15, 12),
      odometroInicio: 52135,
      fim: DateTime(2026, 8, 15, 13),
      odometroFim: 52135,
    );
    await inserirAbastecimento(
      dataHora: DateTime(2026, 8, 15, 18),
      odometro: 52142,
    );

    expect(await service.sugerirOdometroFechamento(), 52142);
  });

  test(
    'Manutenção posterior sugere e limita o fechamento da Jornada',
    () async {
      await database
          .into(database.manutencoes)
          .insert(
            ManutencoesCompanion.insert(
              veiculoId: 1,
              dataHora: DateTime(2026, 8, 15, 16),
              odometro: 52150,
            ),
          );

      expect(await service.sugerirOdometroFechamento(), 52150);
      await expectLater(
        service.validarFechamento(
          dataHoraFim: DateTime(2026, 8, 15, 18),
          odometroFim: 52149,
        ),
        throwsA(isA<Exception>()),
      );
    },
  );

  test('ordena fatos por horário e não pelo ID nem pelo maior valor', () async {
    await inserirAbastecimento(
      dataHora: DateTime(2026, 8, 15, 18),
      odometro: 52142,
    );
    await inserirAbastecimento(
      dataHora: DateTime(2026, 8, 15, 10),
      odometro: 52999,
    );

    expect(await service.sugerirOdometroFechamento(), 52142);
  });
}
