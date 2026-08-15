import '../../../core/database/app_database.dart';
import '../../../core/database/daos/passe_plataforma_dao.dart';

class PassePlataformaRepository {
  final PassePlataformaDao _dao;
  PassePlataformaRepository(this._dao);

  Future<int> inserir(PassesPlataformaCompanion passe) => _dao.inserir(passe);
  Future<Plataforma?> buscarPlataforma(int id) => _dao.buscarPlataforma(id);
  Future<List<Plataforma>> listarPlataformasAtivas() =>
      _dao.listarPlataformasAtivas();
  Future<List<PasseComPlataforma>> listarPorJornada(int jornadaId) =>
      _dao.listarPorJornada(jornadaId);
  Future<PassesPlataformaData?> buscarUltimoPorPlataforma(int plataformaId) =>
      _dao.buscarUltimoPorPlataforma(plataformaId);
}
