import 'package:flutter/foundation.dart';

import '../../../../core/database/app_database.dart';
import '../../data/leitura_ganhos_service.dart';

class LeituraGanhosController extends ChangeNotifier {
  final LeituraGanhosService _service;

  LeituraGanhosController(this._service);

  List<Plataforma> plataformas = const [];
  Map<int, LeiturasGanhoPlataformaData> sugestoes = const {};
  LeiturasGanho? ultimaLeituraSalva;
  List<LeiturasGanhoPlataformaData> ultimosItensSalvos = const [];
  bool carregando = false;

  Future<void> preparar(int jornadaId) async {
    await _executar(() async {
      plataformas = await _service.listarPlataformasAtivas();
      sugestoes = await _service.buscarSugestoes(jornadaId);
    });
  }

  Future<void> salvar({
    required int jornadaId,
    required int pausaId,
    required List<ItemLeituraGanhosEntrada> itens,
  }) async {
    await _executar(() async {
      final leituraId = await _service.salvarLeituraParcial(
        jornadaId: jornadaId,
        pausaId: pausaId,
        itens: itens,
      );
      ultimaLeituraSalva = await _service.buscarLeitura(leituraId);
      ultimosItensSalvos = await _service.listarItens(leituraId);
      sugestoes = await _service.buscarSugestoes(jornadaId);
    });
  }

  Future<void> _executar(Future<void> Function() operacao) async {
    carregando = true;
    notifyListeners();

    try {
      await operacao();
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
