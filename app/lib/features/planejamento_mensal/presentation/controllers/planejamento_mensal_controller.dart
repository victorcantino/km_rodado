import 'package:flutter/foundation.dart';

import '../../data/planejamento_mensal_service.dart';

class PlanejamentoMensalController extends ChangeNotifier {
  final PlanejamentoMensalService _service;
  final int usuarioId;

  PlanejamentoMensalController(this._service, {required this.usuarioId});

  DateTime mes = DateTime(DateTime.now().year, DateTime.now().month);
  PlanejamentoMensalResumo? resumo;
  bool carregando = false;

  Future<void> carregar() async {
    carregando = true;
    notifyListeners();
    try {
      resumo = await _service.calcular(usuarioId: usuarioId, mes: mes);
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> salvar({
    required int diasPlanejados,
    required int metaKmMensal,
  }) async {
    await _service.salvar(
      usuarioId: usuarioId,
      mes: mes,
      diasPlanejados: diasPlanejados,
      metaKmMensal: metaKmMensal,
    );
    await carregar();
  }

  Future<void> alterarMes(DateTime novoMes) async {
    mes = DateTime(novoMes.year, novoMes.month);
    await carregar();
  }
}
