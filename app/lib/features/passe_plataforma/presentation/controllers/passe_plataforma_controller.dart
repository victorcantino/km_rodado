import 'package:flutter/foundation.dart';

import '../../../../core/database/app_database.dart';
import '../../data/passe_plataforma_service.dart';

class PassePlataformaController extends ChangeNotifier {
  final PassePlataformaService _service;
  List<Plataforma> plataformas = const [];
  bool carregando = false;

  PassePlataformaController(this._service);

  Future<void> carregar() async {
    plataformas = await _service.listarPlataformasAtivas();
    notifyListeners();
  }

  Future<void> registrar({
    required int plataformaId,
    required DateTime dataHora,
    required int valorPagoCentavos,
    String? modalidade,
    DateTime? validadeAte,
    int? limiteFaturamentoCentavos,
    String? observacao,
  }) async {
    carregando = true;
    notifyListeners();
    try {
      await _service.registrar(
        plataformaId: plataformaId,
        dataHora: dataHora,
        valorPagoCentavos: valorPagoCentavos,
        modalidade: modalidade,
        validadeAte: validadeAte,
        limiteFaturamentoCentavos: limiteFaturamentoCentavos,
        observacao: observacao,
      );
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
