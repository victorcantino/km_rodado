import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../constants/enums/status_jornada.dart';
import '../constants/enums/tipo_leitura_ganhos.dart';
import '../constants/enums/tipo_registro_ganhos.dart';
import '../constants/enums/tipo_combustivel.dart';
import '../constants/enums/tipo_bonus_promocao.dart';
import '../constants/enums/tipo_despesa_veiculo.dart';
import '../constants/enums/tipo_custo_recorrente.dart';
import '../constants/enums/escopo_custo_recorrente.dart';
import 'tables/usuario.dart';
import 'tables/veiculo.dart';
import 'tables/configuracao.dart';
import 'tables/jornada.dart';
import 'tables/pausa.dart';
import 'tables/plataforma.dart';
import 'tables/leitura_ganhos.dart';
import 'tables/leitura_ganho_plataforma.dart';
import 'tables/lancamento_ganho_individual.dart';
import 'tables/abastecimento.dart';
import 'tables/passe_plataforma.dart';
import 'tables/bonus_promocao.dart';
import 'tables/manutencao.dart';
import 'tables/item_manutencao.dart';
import 'tables/despesa_veiculo.dart';
import 'tables/custo_recorrente.dart';

import 'daos/jornada_dao.dart';
import 'daos/leitura_ganhos_dao.dart';
import 'daos/pausa_dao.dart';
import 'daos/ganho_individual_dao.dart';
import 'daos/abastecimento_dao.dart';
import 'daos/passe_plataforma_dao.dart';
import 'daos/bonus_promocao_dao.dart';
import 'daos/manutencao_dao.dart';
import 'daos/despesa_veiculo_dao.dart';
import 'daos/custo_recorrente_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Usuarios,
    Veiculos,
    Configuracoes,
    Jornadas,
    Pausas,
    Plataformas,
    LeiturasGanhos,
    LeiturasGanhoPlataforma,
    LancamentosGanhoIndividual,
    Abastecimentos,
    PassesPlataforma,
    BonusPromocoes,
    Manutencoes,
    ItensManutencao,
    DespesasVeiculo,
    CustosRecorrentes,
  ],
  daos: [
    JornadaDao,
    PausaDao,
    LeituraGanhosDao,
    GanhoIndividualDao,
    AbastecimentoDao,
    PassePlataformaDao,
    BonusPromocaoDao,
    ManutencaoDao,
    DespesaVeiculoDao,
    CustoRecorrenteDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 11;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await _migrarSchema1Para2(migrator);
      }
      if (from >= 2 && from < 3) {
        await migrator.addColumn(pausas, pausas.odometroInicio);
        await migrator.addColumn(pausas, pausas.odometroFim);
      }
      if (from < 4) {
        await migrator.createTable(lancamentosGanhoIndividual);
      }
      if (from < 5) {
        await migrator.createTable(abastecimentos);
      }
      if (from == 5) {
        await _migrarSchema5Para6(migrator);
      }
      if (from < 7) {
        await migrator.createTable(passesPlataforma);
      }
      if (from < 8) {
        await migrator.createTable(bonusPromocoes);
      }
      if (from < 9) {
        await migrator.createTable(manutencoes);
        await migrator.createTable(itensManutencao);
      }
      if (from < 10) {
        await migrator.createTable(despesasVeiculo);
      }
      if (from < 11) {
        await migrator.createTable(custosRecorrentes);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> _migrarSchema5Para6(Migrator migrator) async {
    await customStatement(
      'ALTER TABLE abastecimentos RENAME TO abastecimentos_schema_5',
    );
    await migrator.createTable(abastecimentos);
    await customStatement('''
      INSERT INTO abastecimentos (
        id, veiculo_id, jornada_id, data_hora, odometro, tipo_combustivel,
        volume_mililitros, valor_total_pago_centavos,
        preco_bomba_milesimos_real_por_litro, tanque_cheio, cidade,
        nome_posto, bandeira_posto, observacao, data_criacao
      )
      SELECT
        id, veiculo_id, jornada_id, data_criacao, odometro, tipo_combustivel,
        volume_mililitros, valor_total_pago_centavos,
        preco_bomba_milesimos_real_por_litro, tanque_cheio, cidade,
        nome_posto, bandeira_posto, observacao, data_criacao
      FROM abastecimentos_schema_5
    ''');
    await customStatement('DROP TABLE abastecimentos_schema_5');
  }

  Future<void> _migrarSchema1Para2(Migrator migrator) async {
    final pausasLegadas = await _contarRegistros('pausas');
    final ganhosLegados = await _contarRegistros('ganhos');
    final plataformasLegadas = await _contarRegistros('plataformas');
    final referenciasInvalidas = await customSelect('''
      SELECT COUNT(*) AS quantidade
      FROM ganhos
      LEFT JOIN pausas ON pausas.id = ganhos.pausa_id
      LEFT JOIN jornadas ON jornadas.id = pausas.jornada_id
      LEFT JOIN plataformas ON plataformas.id = ganhos.plataforma_id
      WHERE pausas.id IS NULL
         OR jornadas.id IS NULL
         OR plataformas.id IS NULL
    ''').getSingle();

    if (referenciasInvalidas.read<int>('quantidade') > 0) {
      throw StateError(
        'Não foi possível migrar ganhos com referências inválidas.',
      );
    }

    await customStatement('ALTER TABLE ganhos RENAME TO ganhos_schema_1');
    await customStatement('ALTER TABLE pausas RENAME TO pausas_schema_1');
    await customStatement(
      'ALTER TABLE plataformas RENAME TO plataformas_schema_1',
    );

    await migrator.createTable(pausas);
    await migrator.createTable(plataformas);
    await migrator.createTable(leiturasGanhos);
    await migrator.createTable(leiturasGanhoPlataforma);
    await customStatement(
      'CREATE INDEX idx_leituras_ganhos_jornada_data_hora '
      'ON leituras_ganhos (jornada_id, data_hora)',
    );

    await customStatement('''
      INSERT INTO plataformas (
        id,
        nome,
        tipo_registro_ganhos,
        icone,
        cor,
        ativa,
        ordem,
        data_criacao
      )
      SELECT
        id,
        nome,
        'acumulado',
        icone,
        cor,
        ativa,
        ordem,
        data_criacao
      FROM plataformas_schema_1
    ''');

    await customStatement('''
      INSERT INTO pausas (
        id,
        jornada_id,
        inicio,
        fim,
        titulo,
        observacao,
        data_criacao
      )
      SELECT
        id,
        jornada_id,
        inicio,
        fim,
        motivo,
        observacao,
        data_criacao
      FROM pausas_schema_1
    ''');

    await customStatement('''
      INSERT INTO leituras_ganhos (
        id,
        jornada_id,
        pausa_id,
        data_hora,
        tipo,
        data_criacao
      )
      SELECT
        ganhos_schema_1.id,
        pausas_schema_1.jornada_id,
        ganhos_schema_1.pausa_id,
        ganhos_schema_1.data_criacao,
        CASE ganhos_schema_1.registro_final
          WHEN 1 THEN 'finalDaJornada'
          ELSE 'parcial'
        END,
        ganhos_schema_1.data_criacao
      FROM ganhos_schema_1
      INNER JOIN pausas_schema_1
        ON pausas_schema_1.id = ganhos_schema_1.pausa_id
    ''');

    await customStatement('''
      INSERT INTO leituras_ganho_plataforma (
        id,
        leitura_ganhos_id,
        plataforma_id,
        valor_acumulado_centavos,
        quantidade_viagens_acumulada
      )
      SELECT
        id,
        id,
        plataforma_id,
        CAST(ROUND(valor * 100.0) AS INTEGER),
        quantidade_corridas
      FROM ganhos_schema_1
    ''');

    if (await _contarRegistros('plataformas') != plataformasLegadas ||
        await _contarRegistros('pausas') != pausasLegadas ||
        await _contarRegistros('leituras_ganhos') != ganhosLegados ||
        await _contarRegistros('leituras_ganho_plataforma') != ganhosLegados) {
      throw StateError('A migração não preservou todos os registros legados.');
    }

    await customStatement('DROP TABLE ganhos_schema_1');
    await customStatement('DROP TABLE pausas_schema_1');
    await customStatement('DROP TABLE plataformas_schema_1');
  }

  Future<int> _contarRegistros(String tabela) async {
    final resultado = await customSelect(
      'SELECT COUNT(*) AS quantidade FROM $tabela',
    ).getSingle();
    return resultado.read<int>('quantidade');
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();

    final file = File(p.join(dir.path, 'km_rodado.db'));

    return NativeDatabase(file);
  });
}
