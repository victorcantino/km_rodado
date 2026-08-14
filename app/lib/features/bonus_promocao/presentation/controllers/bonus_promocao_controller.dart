import 'package:flutter/foundation.dart';

import '../../../../core/constants/enums/tipo_bonus_promocao.dart';
import '../../../../core/database/app_database.dart';
import '../../data/bonus_promocao_service.dart';

class BonusPromocaoController extends ChangeNotifier {
  final BonusPromocaoService _service;
  List<Plataforma> plataformas = const [];
  bool carregando = false;

  BonusPromocaoController(this._service);

  Future<void> carregar() async {
    plataformas = await _service.listarPlataformasAtivas();
    notifyListeners();
  }

  Future<void> registrar({
    required int plataformaId,
    required DateTime dataHora,
    required int valorCentavos,
    required TipoBonusPromocao tipo,
    String? observacao,
  }) async {
    carregando = true;
    notifyListeners();
    try {
      await _service.registrar(
        plataformaId: plataformaId,
        dataHora: dataHora,
        valorCentavos: valorCentavos,
        tipo: tipo,
        observacao: observacao,
      );
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
