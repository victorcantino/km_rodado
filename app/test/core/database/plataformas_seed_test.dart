import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:km_rodado/core/constants/enums/tipo_registro_ganhos.dart';
import 'package:km_rodado/core/database/app_database.dart';
import 'package:km_rodado/core/database/seeds/plataformas_seed.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() => database.close());

  Future<List<Plataforma>> listar() {
    return (database.select(
      database.plataformas,
    )..orderBy([(plataforma) => OrderingTerm.asc(plataforma.ordem)])).get();
  }

  test('primeira execução cria as quatro plataformas padrão', () async {
    await garantirPlataformasPadrao(database);

    final plataformas = await listar();
    expect(plataformas.map((plataforma) => plataforma.nome), [
      'Uber',
      '99',
      'inDrive',
      'Particular',
    ]);
    expect(plataformas.map((plataforma) => plataforma.ordem), [0, 1, 2, 3]);
    expect(plataformas.every((plataforma) => plataforma.ativa), isTrue);
    expect(plataformas.map((plataforma) => plataforma.tipoRegistroGanhos), [
      TipoRegistroGanhos.acumulado,
      TipoRegistroGanhos.acumulado,
      TipoRegistroGanhos.acumulado,
      TipoRegistroGanhos.individual,
    ]);
  });

  test('segunda execução não duplica plataformas', () async {
    await garantirPlataformasPadrao(database);
    await garantirPlataformasPadrao(database);

    expect(await listar(), hasLength(4));
  });

  test('preserva integralmente uma plataforma padrão já existente', () async {
    final dataCriacao = DateTime(2025, 1, 2, 3, 4);
    final uberId = await database
        .into(database.plataformas)
        .insert(
          PlataformasCompanion.insert(
            nome: '  UBER  ',
            tipoRegistroGanhos: TipoRegistroGanhos.individual,
            ativa: const Value(false),
            ordem: const Value(99),
            icone: const Value('icone-personalizado'),
            cor: const Value('#123456'),
            dataCriacao: Value(dataCriacao),
          ),
        );

    await garantirPlataformasPadrao(database);

    final plataformas = await listar();
    final uber = plataformas.singleWhere(
      (plataforma) => plataforma.id == uberId,
    );
    expect(plataformas, hasLength(4));
    expect(uber.nome, '  UBER  ');
    expect(uber.tipoRegistroGanhos, TipoRegistroGanhos.individual);
    expect(uber.ativa, isFalse);
    expect(uber.ordem, 99);
    expect(uber.icone, 'icone-personalizado');
    expect(uber.cor, '#123456');
    expect(uber.dataCriacao, dataCriacao);
  });
}
