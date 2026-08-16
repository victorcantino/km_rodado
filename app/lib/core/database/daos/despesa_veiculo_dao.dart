import 'package:drift/drift.dart';

import '../../constants/enums/tipo_despesa_veiculo.dart';
import '../app_database.dart';
import '../tables/despesa_veiculo.dart';
import '../tables/veiculo.dart';

part 'despesa_veiculo_dao.g.dart';

@DriftAccessor(tables: [DespesasVeiculo, Veiculos])
class DespesaVeiculoDao extends DatabaseAccessor<AppDatabase>
    with _$DespesaVeiculoDaoMixin {
  DespesaVeiculoDao(super.db);

  Future<int> inserir(DespesasVeiculoCompanion despesa) =>
      into(despesasVeiculo).insert(despesa);

  Future<bool> atualizar(DespesaVeiculo despesa) =>
      update(despesasVeiculo).replace(despesa);

  Future<DespesaVeiculo?> buscarPorId(int id) => (select(
    despesasVeiculo,
  )..where((d) => d.id.equals(id))).getSingleOrNull();

  Future<bool> veiculoExiste(int id) async =>
      await (select(
        veiculos,
      )..where((v) => v.id.equals(id))).getSingleOrNull() !=
      null;

  Future<List<DespesaVeiculo>> listarPorVeiculo(int veiculoId) =>
      (select(despesasVeiculo)
            ..where((d) => d.veiculoId.equals(veiculoId))
            ..orderBy([
              (d) => OrderingTerm.desc(d.dataHora),
              (d) => OrderingTerm.desc(d.id),
            ]))
          .get();

  Future<List<String>> listarDescricoes(
    int veiculoId,
    TipoDespesaVeiculo tipo,
  ) async {
    final registros =
        await (select(despesasVeiculo)
              ..where(
                (d) => d.veiculoId.equals(veiculoId) & d.tipo.equalsValue(tipo),
              )
              ..orderBy([
                (d) => OrderingTerm.desc(d.dataHora),
                (d) => OrderingTerm.desc(d.id),
              ]))
            .get();
    final chaves = <String>{};
    return registros
        .where(
          (registro) => chaves.add(registro.descricao.trim().toLowerCase()),
        )
        .map((registro) => registro.descricao)
        .toList();
  }
}
