import '../../../core/database/app_database.dart';
import '../../../core/database/daos/ganho_individual_dao.dart';

class GanhoIndividualRepository {
  final GanhoIndividualDao _dao;

  GanhoIndividualRepository(this._dao);

  Future<Plataforma?> buscarPlataforma(int id) => _dao.buscarPlataforma(id);
  Future<List<Plataforma>> listarPlataformasAtivas() =>
      _dao.listarPlataformasIndividuaisAtivas();
  Future<int> inserir(LancamentosGanhoIndividualCompanion lancamento) =>
      _dao.inserir(lancamento);
  Future<LancamentosGanhoIndividualData?> buscarPorId(int id) =>
      _dao.buscarPorId(id);
  Future<bool> atualizar(LancamentosGanhoIndividualData lancamento) =>
      _dao.atualizar(lancamento);
  Future<List<LancamentosGanhoIndividualData>> listarPorJornada(
    int jornadaId,
  ) => _dao.listarPorJornada(jornadaId);
  Future<List<TotalGanhoIndividual>> totalizarPorJornada(int jornadaId) =>
      _dao.totalizarPorJornada(jornadaId);
  Future<List<TotalGanhoIndividual>> totalizarPorJornadaNoIntervalo(
    int jornadaId,
    DateTime inicio,
    DateTime fim,
  ) => _dao.totalizarPorJornadaNoIntervalo(jornadaId, inicio, fim);
}
