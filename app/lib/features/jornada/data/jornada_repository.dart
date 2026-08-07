import '../../../core/database/app_database.dart';
import '../../../core/database/daos/jornada_dao.dart';

class JornadaRepository {
  final JornadaDao _dao;

  JornadaRepository(this._dao);

  Future<Jornada?> buscarJornadaAberta() {
    return _dao.buscarJornadaAberta();
  }

  Future<int> inserir(JornadasCompanion jornada) {
    return _dao.inserir(jornada);
  }

  Future<bool> atualizar(Jornada jornada) {
    return _dao.atualizar(jornada);
  }

  Future<int> remover(int id) {
    return _dao.remover(id);
  }

  Future<List<Jornada>> listar() {
    return _dao.listar();
  }

  Stream<List<Jornada>> observar() {
    return _dao.observar();
  }
}
