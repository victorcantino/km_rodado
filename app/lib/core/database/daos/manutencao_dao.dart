import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/item_manutencao.dart';
import '../tables/manutencao.dart';

part 'manutencao_dao.g.dart';

typedef ManutencaoComItens = ({
  Manutencao manutencao,
  List<ItemManutencao> itens,
});

@DriftAccessor(tables: [Manutencoes, ItensManutencao])
class ManutencaoDao extends DatabaseAccessor<AppDatabase>
    with _$ManutencaoDaoMixin {
  ManutencaoDao(super.db);

  Future<List<ManutencaoComItens>> listarPorVeiculo(int veiculoId) async {
    final cabecalhos =
        await (select(manutencoes)
              ..where((m) => m.veiculoId.equals(veiculoId))
              ..orderBy([
                (m) => OrderingTerm.desc(m.dataHora),
                (m) => OrderingTerm.desc(m.id),
              ]))
            .get();
    return Future.wait(cabecalhos.map(buscarComItens));
  }

  Future<ManutencaoComItens> buscarComItens(Manutencao manutencao) async => (
    manutencao: manutencao,
    itens:
        await (select(itensManutencao)
              ..where((i) => i.manutencaoId.equals(manutencao.id))
              ..orderBy([(i) => OrderingTerm.asc(i.id)]))
            .get(),
  );

  Future<ManutencaoComItens?> buscarPorId(int id) async {
    final manutencao = await (select(
      manutencoes,
    )..where((m) => m.id.equals(id))).getSingleOrNull();
    return manutencao == null ? null : buscarComItens(manutencao);
  }

  Future<int> inserirAtomico(
    ManutencoesCompanion manutencao,
    List<ItensManutencaoCompanion Function(int)> itens,
  ) => transaction(() async {
    final id = await into(manutencoes).insert(manutencao);
    for (final item in itens) {
      await into(itensManutencao).insert(item(id));
    }
    return id;
  });

  Future<void> atualizarAtomico(
    Manutencao manutencao,
    List<ItensManutencaoCompanion Function(int)> itens,
  ) => transaction(() async {
    await update(manutencoes).replace(manutencao);
    await (delete(
      itensManutencao,
    )..where((item) => item.manutencaoId.equals(manutencao.id))).go();
    for (final item in itens) {
      await into(itensManutencao).insert(item(manutencao.id));
    }
  });

  Future<List<String>> listarDescricoes(int veiculoId) async {
    final linhas = await customSelect(
      '''
      SELECT i.descricao, MAX(m.data_hora) AS ultima
      FROM itens_manutencao i
      INNER JOIN manutencoes m ON m.id = i.manutencao_id
      WHERE m.veiculo_id = ?
      GROUP BY LOWER(TRIM(i.descricao))
      ORDER BY ultima DESC
      ''',
      variables: [Variable<int>(veiculoId)],
      readsFrom: {manutencoes, itensManutencao},
    ).get();
    return linhas.map((linha) => linha.read<String>('descricao')).toList();
  }
}
