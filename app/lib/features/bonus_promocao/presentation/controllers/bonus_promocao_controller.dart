import 'package:flutter/foundation.dart';

import '../../../../core/constants/enums/tipo_bonus_promocao.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/bonus_promocao_dao.dart';
import '../../data/bonus_promocao_service.dart';

class BonusPromocaoController extends ChangeNotifier {
  final BonusPromocaoService _service;
  List<Plataforma> plataformas = const [];
  bool carregando = false;
  List<BonusPromocaoComPlataforma> bonusPromocoes = const [];

  BonusPromocaoController(this._service);

  Future<void> carregar() async {
    plataformas = await _service.listarPlataformasAtivas();
    notifyListeners();
  }

  Future<void> carregarHistorico() async {
    bonusPromocoes = await _service.listarTodos();
    bonusPromocoes.sort((a, b) {
      final porData = b.bonusPromocao.dataHora.compareTo(
        a.bonusPromocao.dataHora,
      );
      return porData != 0
          ? porData
          : b.bonusPromocao.id.compareTo(a.bonusPromocao.id);
    });
    notifyListeners();
  }

  Future<void> editar(BonusPromocao bonus) async {
    await _service.atualizar(bonus);
    await carregarHistorico();
  }

  Future<void> excluir(int id) async {
    await _service.excluir(id);
    await carregarHistorico();
  }

  Future<void> registrar({
    required int plataformaId,
    required DateTime dataHora,
    required int valorCentavos,
    String? observacao,
  }) async {
    carregando = true;
    notifyListeners();
    try {
      await _service.registrar(
        plataformaId: plataformaId,
        dataHora: dataHora,
        valorCentavos: valorCentavos,
        tipo: TipoBonusPromocao.bonus,
        observacao: observacao,
      );
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
