import 'dart:io';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:km_rodado/core/constants/enums/tipo_leitura_ganhos.dart';
import 'package:km_rodado/core/constants/enums/tipo_registro_ganhos.dart';
import 'package:km_rodado/core/database/app_database.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

void main() {
  late Directory diretorioTemporario;
  late File arquivoBanco;

  setUp(() async {
    diretorioTemporario = await Directory.systemTemp.createTemp(
      'km_rodado_migracao_',
    );
    arquivoBanco = File('${diretorioTemporario.path}/schema_1.db');
  });

  tearDown(() async {
    if (diretorioTemporario.existsSync()) {
      await diretorioTemporario.delete(recursive: true);
    }
  });

  test('migra schema 1 vazio para schema 3', () async {
    _criarBancoSchema1(arquivoBanco);

    final database = AppDatabase.forTesting(NativeDatabase(arquivoBanco));
    addTearDown(database.close);

    expect(await _contar(database, 'pausas'), 0);
    expect(await _contar(database, 'leituras_ganhos'), 0);
    expect(await _contar(database, 'leituras_ganho_plataforma'), 0);
    expect(await _userVersion(database), 3);
    expect(await _tabelaExiste(database, 'ganhos'), isFalse);
    expect(
      await _indiceExiste(database, 'idx_leituras_ganhos_jornada_data_hora'),
      isTrue,
    );
    expect(await _chavesEstrangeirasInvalidas(database), isEmpty);
  });

  test('preserva e converte os dados do schema 1', () async {
    _criarBancoSchema1(arquivoBanco, preenchido: true);

    final database = AppDatabase.forTesting(NativeDatabase(arquivoBanco));
    addTearDown(database.close);

    final pausas = await database.select(database.pausas).get();
    final leituras = await database.select(database.leiturasGanhos).get();
    final itens = await database.select(database.leiturasGanhoPlataforma).get();
    final plataformas = await database.select(database.plataformas).get();

    expect(pausas, hasLength(1));
    expect(pausas.single.id, 21);
    expect(pausas.single.jornadaId, 11);
    expect(pausas.single.titulo, 'Almoço');
    expect(pausas.single.observacao, 'Pausa principal');
    expect(pausas.single.odometroInicio, isNull);
    expect(pausas.single.odometroFim, isNull);

    expect(leituras, hasLength(3));
    expect(itens, hasLength(3));
    expect(leituras.map((leitura) => leitura.id), [41, 42, 43]);
    expect(itens.map((item) => item.id), [41, 42, 43]);
    expect(leituras.map((leitura) => leitura.jornadaId).toSet(), {11});
    expect(leituras.map((leitura) => leitura.pausaId).toSet(), {21});
    expect(itens.map((item) => item.leituraGanhosId), [41, 42, 43]);
    expect(itens.map((item) => item.plataformaId), [31, 32, 31]);
    expect(itens.map((item) => item.valorAcumuladoCentavos), [5025, 10000, 10]);
    expect(itens.map((item) => item.quantidadeViagensAcumulada), [5, 10, 0]);

    expect(leituras[0].tipo, TipoLeituraGanhos.parcial);
    expect(leituras[1].tipo, TipoLeituraGanhos.finalDaJornada);
    expect(leituras[2].tipo, TipoLeituraGanhos.parcial);
    expect(leituras[0].dataHora, leituras[0].dataCriacao);
    expect(leituras[1].dataHora, leituras[1].dataCriacao);
    expect(leituras[2].dataHora, leituras[2].dataCriacao);

    expect(plataformas, hasLength(2));
    expect(plataformas.map((plataforma) => plataforma.id), [31, 32]);
    expect(
      plataformas.map((plataforma) => plataforma.tipoRegistroGanhos).toSet(),
      {TipoRegistroGanhos.acumulado},
    );
    expect(await _userVersion(database), 3);
    expect(await _tabelaExiste(database, 'ganhos'), isFalse);
    expect(await _chavesEstrangeirasInvalidas(database), isEmpty);
  });

  test('impede plataforma repetida na mesma leitura', () async {
    _criarBancoSchema1(arquivoBanco, preenchido: true);

    final database = AppDatabase.forTesting(NativeDatabase(arquivoBanco));
    addTearDown(database.close);
    await _contar(database, 'leituras_ganhos');

    await expectLater(
      database.customStatement('''
        INSERT INTO leituras_ganho_plataforma (
          leitura_ganhos_id,
          plataforma_id,
          valor_acumulado_centavos,
          quantidade_viagens_acumulada
        ) VALUES (41, 31, 5025, 5)
      '''),
      throwsA(isA<Exception>()),
    );
  });

  test('permite a mesma plataforma em outra leitura', () async {
    _criarBancoSchema1(arquivoBanco, preenchido: true);

    final database = AppDatabase.forTesting(NativeDatabase(arquivoBanco));
    addTearDown(database.close);
    await _contar(database, 'leituras_ganhos');

    await database.customStatement('''
      INSERT INTO leituras_ganhos (
        id,
        jornada_id,
        pausa_id,
        data_hora,
        tipo,
        data_criacao
      ) VALUES (44, 11, NULL, 1700004000, 'parcial', 1700004001)
    ''');
    await database.customStatement('''
      INSERT INTO leituras_ganho_plataforma (
        leitura_ganhos_id,
        plataforma_id,
        valor_acumulado_centavos,
        quantidade_viagens_acumulada
      ) VALUES (44, 31, 12500, 12)
    ''');

    expect(await _contar(database, 'leituras_ganho_plataforma'), 4);
    expect(await _chavesEstrangeirasInvalidas(database), isEmpty);
  });

  test('impede acumulados negativos', () async {
    _criarBancoSchema1(arquivoBanco, preenchido: true);

    final database = AppDatabase.forTesting(NativeDatabase(arquivoBanco));
    addTearDown(database.close);
    await _contar(database, 'leituras_ganhos');

    await expectLater(
      database.customStatement('''
        INSERT INTO leituras_ganho_plataforma (
          leitura_ganhos_id,
          plataforma_id,
          valor_acumulado_centavos,
          quantidade_viagens_acumulada
        ) VALUES (41, 32, -1, 1)
      '''),
      throwsA(isA<Exception>()),
    );
    await expectLater(
      database.customStatement('''
        INSERT INTO leituras_ganho_plataforma (
          leitura_ganhos_id,
          plataforma_id,
          valor_acumulado_centavos,
          quantidade_viagens_acumulada
        ) VALUES (41, 32, 1, -1)
      '''),
      throwsA(isA<Exception>()),
    );
  });

  test('migra schema 2 preservando Pausa sem inventar odômetros', () async {
    final banco = sqlite.sqlite3.open(arquivoBanco.path);
    banco.execute('''
      CREATE TABLE pausas (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        jornada_id INTEGER NOT NULL,
        inicio INTEGER NOT NULL,
        fim INTEGER NULL,
        titulo TEXT NULL,
        observacao TEXT NULL,
        data_criacao INTEGER NOT NULL
      );
      INSERT INTO pausas VALUES (1, 1, 1700000000, 1700000100, 'Antiga', NULL, 1700000000);
      PRAGMA user_version = 2;
    ''');
    banco.close();

    final database = AppDatabase.forTesting(NativeDatabase(arquivoBanco));
    addTearDown(database.close);
    final pausa = (await database.select(database.pausas).get()).single;

    expect(await _userVersion(database), 3);
    expect(pausa.odometroInicio, isNull);
    expect(pausa.odometroFim, isNull);
  });
}

void _criarBancoSchema1(File arquivo, {bool preenchido = false}) {
  final database = sqlite.sqlite3.open(arquivo.path);

  try {
    database.execute('PRAGMA foreign_keys = ON');
    database.execute(_schema1);
    database.execute('PRAGMA user_version = 1');

    if (preenchido) {
      database.execute(_dadosSchema1);
    }
  } finally {
    database.close();
  }
}

Future<int> _userVersion(AppDatabase database) async {
  final resultado = await database
      .customSelect('PRAGMA user_version')
      .getSingle();
  return resultado.read<int>('user_version');
}

Future<int> _contar(AppDatabase database, String tabela) async {
  final resultado = await database
      .customSelect('SELECT COUNT(*) AS quantidade FROM $tabela')
      .getSingle();
  return resultado.read<int>('quantidade');
}

Future<bool> _tabelaExiste(AppDatabase database, String nome) async {
  final resultado = await database
      .customSelect(
        'SELECT COUNT(*) AS quantidade FROM sqlite_master '
        'WHERE type = ? AND name = ?',
        variables: [Variable('table'), Variable(nome)],
      )
      .getSingle();
  return resultado.read<int>('quantidade') == 1;
}

Future<bool> _indiceExiste(AppDatabase database, String nome) async {
  final resultado = await database
      .customSelect(
        'SELECT COUNT(*) AS quantidade FROM sqlite_master '
        'WHERE type = ? AND name = ?',
        variables: [Variable('index'), Variable(nome)],
      )
      .getSingle();
  return resultado.read<int>('quantidade') == 1;
}

Future<List<QueryRow>> _chavesEstrangeirasInvalidas(AppDatabase database) {
  return database.customSelect('PRAGMA foreign_key_check').get();
}

const _schema1 = '''
CREATE TABLE usuarios (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  email TEXT NULL,
  senha TEXT NULL,
  data_criacao INTEGER NOT NULL DEFAULT (CAST(strftime('%s', CURRENT_TIMESTAMP) AS INTEGER)),
  ativo INTEGER NOT NULL DEFAULT 1 CHECK (ativo IN (0, 1))
);
CREATE TABLE veiculos (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  usuario_id INTEGER NOT NULL,
  marca TEXT NOT NULL,
  modelo TEXT NOT NULL,
  ano INTEGER NOT NULL,
  placa TEXT NULL,
  data_compra INTEGER NULL,
  quilometragem_compra INTEGER NULL,
  valor_compra REAL NULL,
  valor_venda_estimado REAL NULL,
  capacidade_tanque REAL NOT NULL DEFAULT 41.0,
  ativo INTEGER NOT NULL DEFAULT 1 CHECK (ativo IN (0, 1)),
  observacoes TEXT NULL
);
CREATE TABLE configuracoes (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  usuario_id INTEGER NOT NULL,
  custo_km_base REAL NOT NULL DEFAULT 0.0,
  meta_km_dia INTEGER NOT NULL DEFAULT 0,
  capacidade_tanque REAL NOT NULL DEFAULT 41.0,
  cidade_padrao TEXT NULL
);
CREATE TABLE jornadas (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  usuario_id INTEGER NOT NULL REFERENCES usuarios (id),
  veiculo_id INTEGER NOT NULL REFERENCES veiculos (id),
  data_hora_inicio INTEGER NOT NULL,
  data_hora_fim INTEGER NULL,
  odometro_inicio INTEGER NOT NULL,
  odometro_fim INTEGER NULL,
  cidade_origem TEXT NOT NULL,
  cidade_destino TEXT NULL,
  status TEXT NOT NULL,
  odometro_alterado INTEGER NOT NULL DEFAULT 0 CHECK (odometro_alterado IN (0, 1)),
  observacoes TEXT NULL,
  data_criacao INTEGER NOT NULL DEFAULT (CAST(strftime('%s', CURRENT_TIMESTAMP) AS INTEGER)),
  data_atualizacao INTEGER NOT NULL DEFAULT (CAST(strftime('%s', CURRENT_TIMESTAMP) AS INTEGER)),
  quilometros_percorridos INTEGER NULL
);
CREATE INDEX idx_jornada_status ON jornadas (status);
CREATE TABLE pausas (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  jornada_id INTEGER NOT NULL REFERENCES jornadas (id),
  inicio INTEGER NOT NULL,
  fim INTEGER NULL,
  motivo TEXT NULL,
  observacao TEXT NULL,
  data_criacao INTEGER NOT NULL DEFAULT (CAST(strftime('%s', CURRENT_TIMESTAMP) AS INTEGER)),
  registrar_ganhos INTEGER NOT NULL DEFAULT 0 CHECK (registrar_ganhos IN (0, 1)),
  concluida INTEGER NOT NULL DEFAULT 0 CHECK (concluida IN (0, 1))
);
CREATE TABLE plataformas (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  icone TEXT NULL,
  cor TEXT NULL,
  ativa INTEGER NOT NULL DEFAULT 1 CHECK (ativa IN (0, 1)),
  ordem INTEGER NOT NULL DEFAULT 0,
  data_criacao INTEGER NOT NULL DEFAULT (CAST(strftime('%s', CURRENT_TIMESTAMP) AS INTEGER))
);
CREATE TABLE ganhos (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  pausa_id INTEGER NOT NULL REFERENCES pausas (id),
  plataforma_id INTEGER NOT NULL REFERENCES plataformas (id),
  valor REAL NOT NULL,
  quantidade_corridas INTEGER NOT NULL DEFAULT 0,
  registro_final INTEGER NOT NULL DEFAULT 0 CHECK (registro_final IN (0, 1)),
  data_criacao INTEGER NOT NULL DEFAULT (CAST(strftime('%s', CURRENT_TIMESTAMP) AS INTEGER))
);
''';

const _dadosSchema1 = '''
INSERT INTO usuarios (id, nome) VALUES (7, 'Motorista');
INSERT INTO veiculos (id, usuario_id, marca, modelo, ano)
VALUES (8, 7, 'Marca', 'Modelo', 2020);
INSERT INTO jornadas (
  id,
  usuario_id,
  veiculo_id,
  data_hora_inicio,
  odometro_inicio,
  cidade_origem,
  status
) VALUES (11, 7, 8, 1700000000, 100000, 'Curitiba', 'aberta');
INSERT INTO pausas (
  id,
  jornada_id,
  inicio,
  fim,
  motivo,
  observacao,
  data_criacao,
  registrar_ganhos,
  concluida
) VALUES (
  21,
  11,
  1700001000,
  1700002000,
  'Almoço',
  'Pausa principal',
  1700001001,
  1,
  1
);
INSERT INTO plataformas (id, nome) VALUES (31, 'Uber');
INSERT INTO plataformas (id, nome) VALUES (32, '99');
INSERT INTO ganhos (
  id,
  pausa_id,
  plataforma_id,
  valor,
  quantidade_corridas,
  registro_final,
  data_criacao
) VALUES (41, 21, 31, 50.25, 5, 0, 1700002100);
INSERT INTO ganhos (
  id,
  pausa_id,
  plataforma_id,
  valor,
  quantidade_corridas,
  registro_final,
  data_criacao
) VALUES (42, 21, 32, 100.00, 10, 1, 1700002200);
INSERT INTO ganhos (
  id,
  pausa_id,
  plataforma_id,
  valor,
  quantidade_corridas,
  registro_final,
  data_criacao
) VALUES (43, 21, 31, 0.10, 0, 0, 1700002300);
''';
