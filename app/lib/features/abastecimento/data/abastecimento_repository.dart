import '../../../core/database/app_database.dart';
import '../../../core/database/daos/abastecimento_dao.dart';

class AbastecimentoRepository {
  final AbastecimentoDao _dao;

  AbastecimentoRepository(this._dao);

  Future<int> inserir(AbastecimentosCompanion abastecimento) =>
      _dao.inserir(abastecimento);
  Future<Abastecimento?> buscarUltimoPorVeiculo(int veiculoId) =>
      _dao.buscarUltimoPorVeiculo(veiculoId);
  Future<List<Abastecimento>> listarPorVeiculo(int veiculoId) =>
      _dao.listarPorVeiculo(veiculoId);
  Future<double?> buscarCapacidadeTanque(int veiculoId) =>
      _dao.buscarCapacidadeTanque(veiculoId);
  Future<int?> buscarUltimoOdometroCronologico(int veiculoId) =>
      _dao.buscarUltimoOdometroCronologico(veiculoId);
  Future<List<Abastecimento>> listarPorJornada(int jornadaId) =>
      _dao.listarPorJornada(jornadaId);
  Future<List<Abastecimento>> listarPorVeiculoNoIntervalo(
    int veiculoId,
    DateTime inicio,
    DateTime? fim,
  ) => _dao.listarPorVeiculoNoIntervalo(veiculoId, inicio, fim);
  Future<int?> buscarUltimoOdometroOperacional(int veiculoId) =>
      _dao.buscarUltimoOdometroOperacional(veiculoId);
  Future<LimitesOdometro> buscarLimitesOdometro(
    int veiculoId,
    DateTime dataHora, {
    int? ignorarManutencaoId,
  }) => _dao.buscarLimitesOdometro(
    veiculoId,
    dataHora,
    ignorarManutencaoId: ignorarManutencaoId,
  );
}
