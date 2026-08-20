import '../../../core/database/app_database.dart';
import '../../../core/database/daos/bonus_promocao_dao.dart';

class BonusPromocaoRepository {
  final BonusPromocaoDao _dao;

  BonusPromocaoRepository(this._dao);

  Future<int> inserir(BonusPromocoesCompanion bonusPromocao) =>
      _dao.inserir(bonusPromocao);
  Future<Plataforma?> buscarPlataforma(int id) => _dao.buscarPlataforma(id);
  Future<List<Plataforma>> listarPlataformasAtivas() =>
      _dao.listarPlataformasAtivas();
  Future<List<BonusPromocaoComPlataforma>> listarPorJornada(int jornadaId) =>
      _dao.listarPorJornada(jornadaId);
  Future<List<BonusPromocaoComPlataforma>> listarTodos() => _dao.listarTodos();
  Future<bool> atualizar(BonusPromocao bonus) => _dao.atualizar(bonus);
  Future<int> excluir(int id) => _dao.excluir(id);
}
