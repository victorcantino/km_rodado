import 'package:drift/drift.dart';

import '../../constants/enums/tipo_custo_recorrente.dart';
import '../app_database.dart';
import '../tables/custo_recorrente.dart';
import '../tables/plataforma.dart';
import '../tables/veiculo.dart';

part 'custo_recorrente_dao.g.dart';

@DriftAccessor(tables: [CustosRecorrentes, Veiculos, Plataformas])
class CustoRecorrenteDao extends DatabaseAccessor<AppDatabase>
    with _$CustoRecorrenteDaoMixin {
  CustoRecorrenteDao(super.db);

  Future<int> inserir(CustosRecorrentesCompanion custo) =>
      into(custosRecorrentes).insert(custo);

  Future<bool> atualizar(CustoRecorrente custo) =>
      update(custosRecorrentes).replace(custo);

  Future<CustoRecorrente?> buscarPorId(int id) => (select(
    custosRecorrentes,
  )..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<List<CustoRecorrente>> listar() =>
      (select(custosRecorrentes)..orderBy([
            (c) => OrderingTerm.desc(c.ativo),
            (c) => OrderingTerm.desc(c.dataAtualizacao),
            (c) => OrderingTerm.desc(c.dataCriacao),
            (c) => OrderingTerm.desc(c.id),
          ]))
          .get();

  Future<bool> veiculoExiste(int id) async =>
      await (select(
        veiculos,
      )..where((v) => v.id.equals(id))).getSingleOrNull() !=
      null;

  Future<bool> plataformaExiste(int id) async =>
      await (select(
        plataformas,
      )..where((p) => p.id.equals(id))).getSingleOrNull() !=
      null;

  Future<List<Veiculo>> listarVeiculos() =>
      (select(veiculos)..orderBy([(v) => OrderingTerm.asc(v.id)])).get();

  Future<List<Plataforma>> listarPlataformas() =>
      (select(plataformas)..orderBy([
            (p) => OrderingTerm.asc(p.ordem),
            (p) => OrderingTerm.asc(p.nome),
          ]))
          .get();

  Future<List<String>> listarDescricoes(TipoCustoRecorrente tipo) async {
    final registros =
        await (select(custosRecorrentes)
              ..where((c) => c.tipo.equalsValue(tipo))
              ..orderBy([
                (c) => OrderingTerm.desc(c.dataAtualizacao),
                (c) => OrderingTerm.desc(c.dataCriacao),
                (c) => OrderingTerm.desc(c.id),
              ]))
            .get();
    final chaves = <String>{};
    return registros
        .where((custo) => chaves.add(custo.descricao.trim().toLowerCase()))
        .map((custo) => custo.descricao)
        .toList();
  }
}
