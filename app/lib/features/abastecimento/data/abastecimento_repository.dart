import '../../../core/database/app_database.dart';
import '../../../core/database/daos/abastecimento_dao.dart';

class AbastecimentoRepository {
  final AbastecimentoDao _dao;

  AbastecimentoRepository(this._dao);

  Future<int> inserir(AbastecimentosCompanion abastecimento) =>
      _dao.inserir(abastecimento);
  Future<Abastecimento?> buscarUltimoPorVeiculo(int veiculoId) =>
      _dao.buscarUltimoPorVeiculo(veiculoId);
  Future<int?> buscarUltimoOdometroOperacional(int veiculoId) =>
      _dao.buscarUltimoOdometroOperacional(veiculoId);
  Future<LimitesOdometro> buscarLimitesOdometro(
    int veiculoId,
    DateTime dataHora,
  ) => _dao.buscarLimitesOdometro(veiculoId, dataHora);
}
