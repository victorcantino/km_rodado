import '../../../core/database/app_database.dart';
import '../../../core/database/daos/planejamento_mensal_dao.dart';

class PlanejamentoMensalRepository {
  final PlanejamentoMensalDao _dao;

  PlanejamentoMensalRepository(this._dao);

  Future<PlanejamentoMensal?> buscar(int usuarioId, DateTime mes) =>
      _dao.buscar(usuarioId, mes);

  Future<int> inserir(PlanejamentosMensaisCompanion planejamento) =>
      _dao.inserir(planejamento);

  Future<bool> atualizar(PlanejamentoMensal planejamento) =>
      _dao.atualizar(planejamento);
}
