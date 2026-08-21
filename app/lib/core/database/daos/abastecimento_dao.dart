import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/abastecimento.dart';
import '../tables/jornada.dart';
import '../tables/pausa.dart';
import '../tables/manutencao.dart';

part 'abastecimento_dao.g.dart';

typedef LimitesOdometro = ({int? anterior, int? posterior});

@DriftAccessor(tables: [Abastecimentos, Jornadas, Pausas, Manutencoes])
class AbastecimentoDao extends DatabaseAccessor<AppDatabase>
    with _$AbastecimentoDaoMixin {
  AbastecimentoDao(super.db);

  Future<int> inserir(AbastecimentosCompanion abastecimento) =>
      into(abastecimentos).insert(abastecimento);
  Future<bool> atualizar(Abastecimento abastecimento) =>
      update(abastecimentos).replace(abastecimento);
  Future<int> excluir(int id) =>
      (delete(abastecimentos)..where((a) => a.id.equals(id))).go();

  Future<Abastecimento?> buscarUltimoPorVeiculo(int veiculoId) =>
      (select(abastecimentos)
            ..where((a) => a.veiculoId.equals(veiculoId))
            ..orderBy([
              (a) => OrderingTerm.desc(a.dataHora),
              (a) => OrderingTerm.desc(a.id),
            ])
            ..limit(1))
          .getSingleOrNull();

  Future<List<Abastecimento>> listarPorVeiculo(int veiculoId) =>
      (select(abastecimentos)
            ..where(
              (abastecimento) => abastecimento.veiculoId.equals(veiculoId),
            )
            ..orderBy([
              (abastecimento) => OrderingTerm.asc(abastecimento.dataHora),
              (abastecimento) => OrderingTerm.asc(abastecimento.id),
            ]))
          .get();

  Future<double?> buscarCapacidadeTanque(int veiculoId) async {
    final linha = await customSelect(
      'SELECT capacidade_tanque FROM veiculos WHERE id = ? LIMIT 1',
      variables: [Variable<int>(veiculoId)],
    ).getSingleOrNull();
    return linha?.readNullable<double>('capacidade_tanque');
  }

  Future<int?> buscarUltimoOdometroCronologico(int veiculoId) async {
    final linha = await customSelect(
      '''
      SELECT odometro FROM (
        SELECT data_hora_inicio AS data_hora, odometro_inicio AS odometro, 0 AS ordem
          FROM jornadas WHERE veiculo_id = ?
        UNION ALL
        SELECT data_hora_fim, odometro_fim, 1 FROM jornadas
          WHERE veiculo_id = ? AND data_hora_fim IS NOT NULL
            AND odometro_fim IS NOT NULL
        UNION ALL
        SELECT pausas.inicio, pausas.odometro_inicio, 2 FROM pausas
          INNER JOIN jornadas ON jornadas.id = pausas.jornada_id
          WHERE jornadas.veiculo_id = ? AND pausas.odometro_inicio IS NOT NULL
        UNION ALL
        SELECT pausas.fim, pausas.odometro_fim, 3 FROM pausas
          INNER JOIN jornadas ON jornadas.id = pausas.jornada_id
          WHERE jornadas.veiculo_id = ? AND pausas.fim IS NOT NULL
            AND pausas.odometro_fim IS NOT NULL
        UNION ALL
        SELECT data_hora, odometro, 4 FROM abastecimentos WHERE veiculo_id = ?
        UNION ALL
        SELECT data_hora, odometro, 5 FROM manutencoes WHERE veiculo_id = ?
      ) ORDER BY data_hora DESC, ordem DESC LIMIT 1
      ''',
      variables: List.generate(6, (_) => Variable<int>(veiculoId)),
      readsFrom: {jornadas, pausas, abastecimentos, manutencoes},
    ).getSingleOrNull();
    return linha?.readNullable<int>('odometro');
  }

  Future<List<Abastecimento>> listarPorJornada(int jornadaId) =>
      (select(abastecimentos)
            ..where(
              (abastecimento) => abastecimento.jornadaId.equals(jornadaId),
            )
            ..orderBy([
              (abastecimento) => OrderingTerm.asc(abastecimento.dataHora),
              (abastecimento) => OrderingTerm.asc(abastecimento.id),
            ]))
          .get();

  Future<List<Abastecimento>> listarPorVeiculoNoIntervalo(
    int veiculoId,
    DateTime inicio,
    DateTime? fim,
  ) {
    final consulta = select(abastecimentos)
      ..where(
        (abastecimento) =>
            abastecimento.veiculoId.equals(veiculoId) &
            abastecimento.dataHora.isBiggerOrEqualValue(inicio),
      )
      ..orderBy([
        (abastecimento) => OrderingTerm.asc(abastecimento.dataHora),
        (abastecimento) => OrderingTerm.asc(abastecimento.id),
      ]);
    if (fim != null) {
      consulta.where(
        (abastecimento) => abastecimento.dataHora.isSmallerOrEqualValue(fim),
      );
    }
    return consulta.get();
  }

  Future<LimitesOdometro> buscarLimitesOdometro(
    int veiculoId,
    DateTime dataHora, {
    int? ignorarManutencaoId,
  }) async {
    final instante = dataHora.millisecondsSinceEpoch ~/ 1000;
    final linha = await customSelect(
      '''
      WITH fatos AS (
        SELECT data_hora_inicio AS data_hora, odometro_inicio AS odometro
          FROM jornadas WHERE veiculo_id = ?
        UNION ALL
        SELECT data_hora_fim, odometro_fim FROM jornadas
          WHERE veiculo_id = ? AND data_hora_fim IS NOT NULL
            AND odometro_fim IS NOT NULL
        UNION ALL
        SELECT pausas.inicio, pausas.odometro_inicio FROM pausas
          INNER JOIN jornadas ON jornadas.id = pausas.jornada_id
          WHERE jornadas.veiculo_id = ? AND pausas.odometro_inicio IS NOT NULL
        UNION ALL
        SELECT pausas.fim, pausas.odometro_fim FROM pausas
          INNER JOIN jornadas ON jornadas.id = pausas.jornada_id
          WHERE jornadas.veiculo_id = ? AND pausas.fim IS NOT NULL
            AND pausas.odometro_fim IS NOT NULL
        UNION ALL
        SELECT data_hora, odometro FROM abastecimentos WHERE veiculo_id = ?
        UNION ALL
        SELECT data_hora, odometro FROM manutencoes
          WHERE veiculo_id = ? AND (? IS NULL OR id != ?)
      )
      SELECT
        (SELECT odometro FROM fatos
          WHERE data_hora <= ?
          ORDER BY data_hora DESC
          LIMIT 1) AS anterior,
        (SELECT odometro FROM fatos
          WHERE data_hora >= ?
          ORDER BY data_hora ASC
          LIMIT 1) AS posterior
      ''',
      variables: [
        ...List.generate(6, (_) => Variable<int>(veiculoId)),
        Variable<int>(ignorarManutencaoId),
        Variable<int>(ignorarManutencaoId),
        Variable<int>(instante),
        Variable<int>(instante),
      ],
      readsFrom: {jornadas, pausas, abastecimentos, manutencoes},
    ).getSingle();
    return (
      anterior: linha.readNullable<int>('anterior'),
      posterior: linha.readNullable<int>('posterior'),
    );
  }

  Future<int?> buscarUltimoOdometroOperacional(int veiculoId) async {
    final linha = await customSelect(
      '''
      SELECT MAX(odometro) AS odometro FROM (
        SELECT odometro_inicio AS odometro FROM jornadas
          WHERE veiculo_id = ?
        UNION ALL
        SELECT odometro_fim FROM jornadas
          WHERE veiculo_id = ? AND odometro_fim IS NOT NULL
        UNION ALL
        SELECT pausas.odometro_inicio FROM pausas
          INNER JOIN jornadas ON jornadas.id = pausas.jornada_id
          WHERE jornadas.veiculo_id = ? AND pausas.odometro_inicio IS NOT NULL
        UNION ALL
        SELECT pausas.odometro_fim FROM pausas
          INNER JOIN jornadas ON jornadas.id = pausas.jornada_id
          WHERE jornadas.veiculo_id = ? AND pausas.odometro_fim IS NOT NULL
        UNION ALL
        SELECT odometro FROM abastecimentos WHERE veiculo_id = ?
        UNION ALL
        SELECT odometro FROM manutencoes WHERE veiculo_id = ?
      )
      ''',
      variables: List.generate(6, (_) => Variable<int>(veiculoId)),
      readsFrom: {jornadas, pausas, abastecimentos, manutencoes},
    ).getSingle();
    return linha.readNullable<int>('odometro');
  }
}
