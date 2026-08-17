import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/depreciacao_veiculo.dart';
import '../tables/veiculo.dart';

part 'depreciacao_veiculo_dao.g.dart';

@DriftAccessor(tables: [DepreciacoesVeiculo, Veiculos])
class DepreciacaoVeiculoDao extends DatabaseAccessor<AppDatabase>
    with _$DepreciacaoVeiculoDaoMixin {
  DepreciacaoVeiculoDao(super.db);

  Future<DepreciacaoVeiculo?> buscarPorVeiculo(int veiculoId) => (select(
    depreciacoesVeiculo,
  )..where((d) => d.veiculoId.equals(veiculoId))).getSingleOrNull();

  Future<int> inserir(DepreciacoesVeiculoCompanion dados) =>
      into(depreciacoesVeiculo).insert(dados);

  Future<bool> atualizar(DepreciacaoVeiculo dados) =>
      update(depreciacoesVeiculo).replace(dados);

  Future<bool> veiculoExiste(int veiculoId) async =>
      await (select(
        veiculos,
      )..where((v) => v.id.equals(veiculoId))).getSingleOrNull() !=
      null;
}
