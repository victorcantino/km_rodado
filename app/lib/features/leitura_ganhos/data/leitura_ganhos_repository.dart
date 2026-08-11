import '../../../core/database/app_database.dart';
import '../../../core/database/daos/leitura_ganhos_dao.dart';
import '../../../core/constants/enums/tipo_leitura_ganhos.dart';

class LeituraGanhosRepository {
  final LeituraGanhosDao _dao;

  LeituraGanhosRepository(this._dao);

  Future<List<Plataforma>> listarPlataformasAtivas() {
    return _dao.listarPlataformasAtivas();
  }

  Future<List<Plataforma>> listarPlataformas() => _dao.listarPlataformas();

  Future<void> atualizarAtivacao(Map<int, bool> ativacoes) =>
      _dao.atualizarAtivacao(ativacoes);

  Future<List<Plataforma>> listarPlataformasDaLeituraInicial(int jornadaId) =>
      _dao.listarPlataformasDaLeituraInicial(jornadaId);

  Future<Pausa?> buscarPausa(int pausaId) {
    return _dao.buscarPausa(pausaId);
  }

  Future<Map<int, LeiturasGanhoPlataformaData>> buscarUltimosItensPorPlataforma(
    int jornadaId,
  ) {
    return _dao.buscarUltimosItensPorPlataforma(jornadaId);
  }

  Future<LeiturasGanho?> buscarPorTipo(int jornadaId, TipoLeituraGanhos tipo) {
    return _dao.buscarPorTipo(jornadaId, tipo);
  }

  Future<LeiturasGanho?> buscarUltimaLeitura(int jornadaId) {
    return _dao.buscarUltimaLeitura(jornadaId);
  }

  Future<int> salvarLeitura(
    LeiturasGanhosCompanion leitura,
    List<LeiturasGanhoPlataformaCompanion> Function(int leituraId) criarItens,
  ) {
    return _dao.salvarLeitura(leitura, criarItens);
  }

  Future<int> salvarLeituraUnica(
    LeiturasGanhosCompanion leitura,
    TipoLeituraGanhos tipo,
    List<LeiturasGanhoPlataformaCompanion> Function(int leituraId) criarItens,
  ) {
    return _dao.salvarLeituraUnica(leitura, tipo, criarItens);
  }

  Future<int> salvarLeituraFinalEFecharJornada(
    LeiturasGanhosCompanion leitura,
    List<LeiturasGanhoPlataformaCompanion> Function(int leituraId) criarItens,
    Jornada jornadaFinalizada,
  ) {
    return _dao.salvarLeituraFinalEFecharJornada(
      leitura,
      criarItens,
      jornadaFinalizada,
    );
  }

  Future<LeiturasGanho?> buscarLeitura(int leituraId) {
    return _dao.buscarLeitura(leituraId);
  }

  Future<List<LeiturasGanhoPlataformaData>> listarItens(int leituraId) {
    return _dao.listarItens(leituraId);
  }
}
