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
}
