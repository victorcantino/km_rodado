import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/abastecimento.dart';
import '../tables/jornada.dart';
import '../tables/pausa.dart';

part 'abastecimento_dao.g.dart';

typedef LimitesOdometro = ({int? anterior, int? posterior});

@DriftAccessor(tables: [Abastecimentos, Jornadas, Pausas])
class AbastecimentoDao extends DatabaseAccessor<AppDatabase>
    with _$AbastecimentoDaoMixin {
  AbastecimentoDao(super.db);

  Future<int> inserir(AbastecimentosCompanion abastecimento) =>
      into(abastecimentos).insert(abastecimento);

  Future<Abastecimento?> buscarUltimoPorVeiculo(int veiculoId) =>
      (select(abastecimentos)
            ..where((a) => a.veiculoId.equals(veiculoId))
            ..orderBy([
              (a) => OrderingTerm.desc(a.dataHora),
              (a) => OrderingTerm.desc(a.id),
            ])
            ..limit(1))
          .getSingleOrNull();

  Future<LimitesOdometro> buscarLimitesOdometro(
    int veiculoId,
    DateTime dataHora,
  ) async {
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
      )
      SELECT
        (SELECT MAX(odometro) FROM fatos WHERE data_hora <= ?) AS anterior,
        (SELECT MIN(odometro) FROM fatos WHERE data_hora >= ?) AS posterior
      ''',
      variables: [
        ...List.generate(5, (_) => Variable<int>(veiculoId)),
        Variable<int>(instante),
        Variable<int>(instante),
      ],
      readsFrom: {jornadas, pausas, abastecimentos},
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
      )
      ''',
      variables: List.generate(5, (_) => Variable<int>(veiculoId)),
      readsFrom: {jornadas, pausas, abastecimentos},
    ).getSingle();
    return linha.readNullable<int>('odometro');
  }
}
