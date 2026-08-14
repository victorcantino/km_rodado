import 'package:drift/drift.dart';

import '../../../core/constants/enums/tipo_bonus_promocao.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/daos/bonus_promocao_dao.dart';
import '../../jornada/data/jornada_repository.dart';
import 'bonus_promocao_repository.dart';

class BonusPromocaoService {
  final BonusPromocaoRepository _repository;
  final JornadaRepository _jornadaRepository;
  final DateTime Function() _agora;

  BonusPromocaoService(
    this._repository,
    this._jornadaRepository, {
    DateTime Function()? agora,
  }) : _agora = agora ?? DateTime.now;

  Future<List<Plataforma>> listarPlataformasAtivas() =>
      _repository.listarPlataformasAtivas();
  Future<List<BonusPromocaoComPlataforma>> listarPorJornada(int jornadaId) =>
      _repository.listarPorJornada(jornadaId);

  Future<int> registrar({
    required int plataformaId,
    required DateTime dataHora,
    required int valorCentavos,
    required TipoBonusPromocao tipo,
    String? observacao,
  }) async {
    if (valorCentavos <= 0) {
      throw Exception('O valor do crédito deve ser maior que zero.');
    }
    if (await _repository.buscarPlataforma(plataformaId) == null) {
      throw Exception('A plataforma informada não existe.');
    }
    final agora = _agora();
    final jornada = await _jornadaRepository.buscarJornadaAberta();
    final jornadaId =
        jornada != null &&
            !dataHora.isBefore(jornada.dataHoraInicio) &&
            !dataHora.isAfter(agora)
        ? jornada.id
        : null;
    return _repository.inserir(
      BonusPromocoesCompanion.insert(
        plataformaId: plataformaId,
        jornadaId: Value(jornadaId),
        dataHora: dataHora,
        valorCentavos: valorCentavos,
        tipo: tipo,
        observacao: Value(_normalizar(observacao)),
        dataCriacao: Value(agora),
      ),
    );
  }

  String? _normalizar(String? texto) {
    final valor = texto?.trim();
    return valor == null || valor.isEmpty ? null : valor;
  }
}
