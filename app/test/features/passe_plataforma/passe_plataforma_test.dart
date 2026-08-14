import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:km_rodado/core/constants/enums/status_jornada.dart';
import 'package:km_rodado/core/constants/enums/tipo_registro_ganhos.dart';
import 'package:km_rodado/core/database/app_database.dart';
import 'package:km_rodado/core/database/daos/jornada_dao.dart';
import 'package:km_rodado/core/database/daos/passe_plataforma_dao.dart';
import 'package:km_rodado/core/database/seeds/seed.dart';
import 'package:km_rodado/features/jornada/data/jornada_repository.dart';
import 'package:km_rodado/features/passe_plataforma/data/passe_plataforma_repository.dart';
import 'package:km_rodado/features/passe_plataforma/data/passe_plataforma_service.dart';

void main() {
  late AppDatabase database;
  late PassePlataformaRepository repository;
  late PassePlataformaService service;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await garantirDadosTemporarios(database);
    repository = PassePlataformaRepository(PassePlataformaDao(database));
    service = PassePlataformaService(
      repository,
      JornadaRepository(JornadaDao(database)),
      agora: () => DateTime(2026, 8, 14, 12),
    );
  });
  tearDown(() => database.close());

  Future<int> plataforma() => database
      .into(database.plataformas)
      .insert(
        PlataformasCompanion.insert(
          nome: 'Plataforma',
          tipoRegistroGanhos: TipoRegistroGanhos.acumulado,
        ),
      );

  Future<int> jornadaAberta() => database
      .into(database.jornadas)
      .insert(
        JornadasCompanion.insert(
          usuarioId: 1,
          veiculoId: 1,
          dataHoraInicio: DateTime(2026, 8, 14, 8),
          odometroInicio: 100,
          cidadeOrigem: 'Curitiba',
          status: StatusJornada.aberta,
        ),
      );

  test(
    'registra fora de Jornada com instante operacional e opcionais',
    () async {
      final id = await plataforma();
      final operacional = DateTime(2026, 8, 13, 18);
      await service.registrar(
        plataformaId: id,
        dataHora: operacional,
        valorPagoCentavos: 1990,
        modalidade: '  Diário  ',
        validadeAte: DateTime(2026, 8, 15),
        limiteFaturamentoCentavos: 20000,
        observacao: '   ',
      );
      final passe =
          (await database.select(database.passesPlataforma).get()).single;
      expect(passe.jornadaId, isNull);
      expect(passe.dataHora, operacional);
      expect(passe.dataCriacao, DateTime(2026, 8, 14, 12));
      expect(passe.valorPagoCentavos, 1990);
      expect(passe.modalidade, 'Diário');
      expect(passe.validadeAte, DateTime(2026, 8, 15));
      expect(passe.limiteFaturamentoCentavos, 20000);
      expect(passe.observacao, isNull);
    },
  );

  test('associa automaticamente e soma múltiplos passes da Jornada', () async {
    final id = await plataforma();
    final jornadaId = await jornadaAberta();
    for (final valor in [1000, 2500]) {
      await service.registrar(
        plataformaId: id,
        dataHora: DateTime(2026, 8, 14, 9),
        valorPagoCentavos: valor,
      );
    }
    final itens = await repository.listarPorJornada(jornadaId);
    expect(itens, hasLength(2));
    expect(
      itens.fold<int>(
        0,
        (total, item) => total + item.passe.valorPagoCentavos.toInt(),
      ),
      3500,
    );
  });

  test('exige plataforma existente e valor positivo', () async {
    final id = await plataforma();
    for (final valor in [0, -1]) {
      await expectLater(
        service.registrar(
          plataformaId: id,
          dataHora: DateTime.now(),
          valorPagoCentavos: valor,
        ),
        throwsException,
      );
    }
    await expectLater(
      service.registrar(
        plataformaId: 999,
        dataHora: DateTime.now(),
        valorPagoCentavos: 1,
      ),
      throwsException,
    );
  });

  test('preserva histórico após desativar e recriar service', () async {
    final id = await plataforma();
    final jornadaId = await jornadaAberta();
    await service.registrar(
      plataformaId: id,
      dataHora: DateTime(2026, 8, 14, 9),
      valorPagoCentavos: 1000,
    );
    await (database.update(database.plataformas)..where((p) => p.id.equals(id)))
        .write(const PlataformasCompanion(ativa: Value(false)));
    final novo = PassePlataformaService(
      PassePlataformaRepository(PassePlataformaDao(database)),
      JornadaRepository(JornadaDao(database)),
    );
    expect(await novo.listarPlataformasAtivas(), isEmpty);
    expect(await novo.listarPorJornada(jornadaId), hasLength(1));
  });
}
