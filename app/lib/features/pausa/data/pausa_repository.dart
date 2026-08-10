import '../../../core/database/app_database.dart';
import '../../../core/database/daos/pausa_dao.dart';

class PausaRepository {
  final PausaDao _dao;

  PausaRepository(this._dao);

  Future<Pausa?> buscarAbertaPorJornada(int jornadaId) {
    return _dao.buscarAbertaPorJornada(jornadaId);
  }

  Future<List<Pausa>> listarPorJornada(int jornadaId) {
    return _dao.listarPorJornada(jornadaId);
  }

  Future<int?> inserirSeNaoHouverAberta(PausasCompanion pausa) {
    return _dao.inserirSeNaoHouverAberta(pausa);
  }

  Future<bool> atualizar(Pausa pausa) {
    return _dao.atualizar(pausa);
  }
}
