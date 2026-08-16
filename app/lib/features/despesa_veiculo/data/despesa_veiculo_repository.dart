import '../../../core/constants/enums/tipo_despesa_veiculo.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/daos/despesa_veiculo_dao.dart';

class DespesaVeiculoRepository {
  final DespesaVeiculoDao _dao;
  DespesaVeiculoRepository(this._dao);

  Future<int> inserir(DespesasVeiculoCompanion despesa) =>
      _dao.inserir(despesa);
  Future<bool> atualizar(DespesaVeiculo despesa) => _dao.atualizar(despesa);
  Future<DespesaVeiculo?> buscarPorId(int id) => _dao.buscarPorId(id);
  Future<bool> veiculoExiste(int id) => _dao.veiculoExiste(id);
  Future<List<DespesaVeiculo>> listarPorVeiculo(int veiculoId) =>
      _dao.listarPorVeiculo(veiculoId);
  Future<List<String>> listarDescricoes(
    int veiculoId,
    TipoDespesaVeiculo tipo,
  ) => _dao.listarDescricoes(veiculoId, tipo);
}
