import 'package:flutter/foundation.dart';

import '../../../../core/database/app_database.dart';
import '../../data/passe_plataforma_service.dart';
import '../../../../core/constants/enums/tipo_passe.dart';

class PassePlataformaController extends ChangeNotifier {
  final PassePlataformaService _service;
  List<Plataforma> plataformas = const [];
  Map<int, ConfiguracaoPasseRepetivel> ultimosRepetiveis = const {};
  bool carregando = false;

  PassePlataformaController(this._service);

  Future<void> carregar() async {
    plataformas = await _service.listarPlataformasAtivas();
    final configuracoes = <int, ConfiguracaoPasseRepetivel>{};
    for (final plataforma in plataformas) {
      final configuracao = await _service.buscarUltimoRepetivel(plataforma.id);
      if (configuracao != null) configuracoes[plataforma.id] = configuracao;
    }
    ultimosRepetiveis = configuracoes;
    notifyListeners();
  }

  Future<void> registrar({
    required int plataformaId,
    required DateTime dataHora,
    required int valorPagoCentavos,
    required TipoPasse tipo,
    int? duracaoHoras,
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
        tipo: tipo,
        duracaoHoras: duracaoHoras,
        limiteFaturamentoCentavos: limiteFaturamentoCentavos,
        observacao: observacao,
      );
      final configuracao = await _service.buscarUltimoRepetivel(plataformaId);
      if (configuracao != null) {
        ultimosRepetiveis = {...ultimosRepetiveis, plataformaId: configuracao};
      }
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
