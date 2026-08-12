import 'package:flutter/foundation.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/ganho_individual_dao.dart';
import '../../data/ganho_individual_service.dart';

class GanhoIndividualController extends ChangeNotifier {
  final GanhoIndividualService _service;
  List<Plataforma> plataformas = const [];
  List<TotalGanhoIndividual> totais = const [];
  bool carregando = false;

  GanhoIndividualController(this._service);

  Future<void> carregar(int? jornadaId) async {
    carregando = true;
    notifyListeners();
    try {
      plataformas = await _service.listarPlataformasAtivas();
      totais = jornadaId == null
          ? const []
          : await _service.totalizarPorJornada(jornadaId);
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> registrar({
    required int jornadaId,
    required int plataformaId,
    required int quantidadeViagens,
    required int valorTotalCentavos,
    String? observacao,
  }) async {
    carregando = true;
    notifyListeners();
    try {
      await _service.registrar(
        plataformaId: plataformaId,
        quantidadeViagens: quantidadeViagens,
        valorTotalCentavos: valorTotalCentavos,
        observacao: observacao,
      );
      totais = await _service.totalizarPorJornada(jornadaId);
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
