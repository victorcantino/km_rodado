import '../../../core/constants/enums/tipo_custo_recorrente.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/daos/custo_recorrente_dao.dart';

class CustoRecorrenteRepository {
  final CustoRecorrenteDao _dao;
  CustoRecorrenteRepository(this._dao);

  Future<int> inserir(CustosRecorrentesCompanion custo) => _dao.inserir(custo);
  Future<bool> atualizar(CustoRecorrente custo) => _dao.atualizar(custo);
  Future<CustoRecorrente?> buscarPorId(int id) => _dao.buscarPorId(id);
  Future<List<CustoRecorrente>> listar() => _dao.listar();
  Future<bool> veiculoExiste(int id) => _dao.veiculoExiste(id);
  Future<bool> plataformaExiste(int id) => _dao.plataformaExiste(id);
  Future<List<Veiculo>> listarVeiculos() => _dao.listarVeiculos();
  Future<List<Plataforma>> listarPlataformas() => _dao.listarPlataformas();
  Future<List<String>> listarDescricoes(TipoCustoRecorrente tipo) =>
      _dao.listarDescricoes(tipo);
}
