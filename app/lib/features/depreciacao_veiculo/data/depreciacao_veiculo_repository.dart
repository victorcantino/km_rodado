import '../../../core/database/app_database.dart';
import '../../../core/database/daos/depreciacao_veiculo_dao.dart';
import '../../abastecimento/data/abastecimento_repository.dart';

class DepreciacaoVeiculoRepository {
  final DepreciacaoVeiculoDao _dao;
  final AbastecimentoRepository _odometros;

  DepreciacaoVeiculoRepository(this._dao, this._odometros);

  Future<DepreciacaoVeiculo?> buscarPorVeiculo(int veiculoId) =>
      _dao.buscarPorVeiculo(veiculoId);
  Future<int> inserir(DepreciacoesVeiculoCompanion dados) =>
      _dao.inserir(dados);
  Future<bool> atualizar(DepreciacaoVeiculo dados) => _dao.atualizar(dados);
  Future<bool> veiculoExiste(int veiculoId) => _dao.veiculoExiste(veiculoId);
  Future<int?> ultimoOdometro(int veiculoId) =>
      _odometros.buscarUltimoOdometroOperacional(veiculoId);
}
