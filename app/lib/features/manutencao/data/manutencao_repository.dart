import '../../../core/database/app_database.dart';
import '../../../core/database/daos/manutencao_dao.dart';

class ManutencaoRepository {
  final ManutencaoDao _dao;
  ManutencaoRepository(this._dao);

  Future<List<ManutencaoComItens>> listarPorVeiculo(int veiculoId) =>
      _dao.listarPorVeiculo(veiculoId);
  Future<ManutencaoComItens?> buscarPorId(int id) => _dao.buscarPorId(id);
  Future<List<String>> listarDescricoes(int veiculoId) =>
      _dao.listarDescricoes(veiculoId);
  Future<int> inserirAtomico(
    ManutencoesCompanion manutencao,
    List<ItensManutencaoCompanion Function(int)> itens,
  ) => _dao.inserirAtomico(manutencao, itens);
  Future<void> atualizarAtomico(
    Manutencao manutencao,
    List<ItensManutencaoCompanion Function(int)> itens,
  ) => _dao.atualizarAtomico(manutencao, itens);
}
