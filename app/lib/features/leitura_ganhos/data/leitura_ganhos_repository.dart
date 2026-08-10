import '../../../core/database/app_database.dart';
import '../../../core/database/daos/leitura_ganhos_dao.dart';

class LeituraGanhosRepository {
  final LeituraGanhosDao _dao;

  LeituraGanhosRepository(this._dao);

  Future<List<Plataforma>> listarPlataformasAtivas() {
    return _dao.listarPlataformasAtivas();
  }

  Future<Pausa?> buscarPausa(int pausaId) {
    return _dao.buscarPausa(pausaId);
  }

  Future<Map<int, LeiturasGanhoPlataformaData>> buscarUltimosItensPorPlataforma(
    int jornadaId,
  ) {
    return _dao.buscarUltimosItensPorPlataforma(jornadaId);
  }

  Future<int> salvarLeitura(
    LeiturasGanhosCompanion leitura,
    List<LeiturasGanhoPlataformaCompanion> Function(int leituraId) criarItens,
  ) {
    return _dao.salvarLeitura(leitura, criarItens);
  }

  Future<LeiturasGanho?> buscarLeitura(int leituraId) {
    return _dao.buscarLeitura(leituraId);
  }

  Future<List<LeiturasGanhoPlataformaData>> listarItens(int leituraId) {
    return _dao.listarItens(leituraId);
  }
}
