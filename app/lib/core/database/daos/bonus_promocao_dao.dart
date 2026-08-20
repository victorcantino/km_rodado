import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/bonus_promocao.dart';
import '../tables/plataforma.dart';

part 'bonus_promocao_dao.g.dart';

typedef BonusPromocaoComPlataforma = ({
  BonusPromocao bonusPromocao,
  Plataforma plataforma,
});

@DriftAccessor(tables: [BonusPromocoes, Plataformas])
class BonusPromocaoDao extends DatabaseAccessor<AppDatabase>
    with _$BonusPromocaoDaoMixin {
  BonusPromocaoDao(super.db);

  Future<int> inserir(BonusPromocoesCompanion bonusPromocao) =>
      into(bonusPromocoes).insert(bonusPromocao);
  Future<bool> atualizar(BonusPromocao bonus) =>
      update(bonusPromocoes).replace(bonus);
  Future<int> excluir(int id) =>
      (delete(bonusPromocoes)..where((b) => b.id.equals(id))).go();

  Future<Plataforma?> buscarPlataforma(int id) =>
      (select(plataformas)..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<List<Plataforma>> listarPlataformasAtivas() =>
      (select(plataformas)
            ..where((p) => p.ativa.equals(true))
            ..orderBy([
              (p) => OrderingTerm.asc(p.ordem),
              (p) => OrderingTerm.asc(p.nome),
            ]))
          .get();

  Future<List<BonusPromocaoComPlataforma>> listarPorJornada(
    int jornadaId,
  ) async {
    final consulta =
        select(bonusPromocoes).join([
            innerJoin(
              plataformas,
              plataformas.id.equalsExp(bonusPromocoes.plataformaId),
            ),
          ])
          ..where(bonusPromocoes.jornadaId.equals(jornadaId))
          ..orderBy([
            OrderingTerm.asc(bonusPromocoes.dataHora),
            OrderingTerm.asc(bonusPromocoes.id),
          ]);
    return (await consulta.get())
        .map(
          (linha) => (
            bonusPromocao: linha.readTable(bonusPromocoes),
            plataforma: linha.readTable(plataformas),
          ),
        )
        .toList();
  }

  Future<List<BonusPromocaoComPlataforma>> listarTodos() async {
    final consulta =
        select(bonusPromocoes).join([
          innerJoin(
            plataformas,
            plataformas.id.equalsExp(bonusPromocoes.plataformaId),
          ),
        ])..orderBy([
          OrderingTerm.desc(bonusPromocoes.dataHora),
          OrderingTerm.desc(bonusPromocoes.id),
        ]);
    return (await consulta.get())
        .map(
          (linha) => (
            bonusPromocao: linha.readTable(bonusPromocoes),
            plataforma: linha.readTable(plataformas),
          ),
        )
        .toList();
  }
}
