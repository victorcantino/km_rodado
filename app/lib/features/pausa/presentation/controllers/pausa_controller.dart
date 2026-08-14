import 'package:flutter/foundation.dart';

import '../../../../core/database/app_database.dart';
import '../../data/pausa_service.dart';

class PausaController extends ChangeNotifier {
  final PausaService _service;

  PausaController(this._service);

  List<Pausa> pausas = const [];
  bool carregando = false;

  Pausa? get pausaAberta {
    for (final pausa in pausas) {
      if (pausa.fim == null) {
        return pausa;
      }
    }

    return null;
  }

  bool get possuiPausaAberta => pausaAberta != null;

  Future<void> carregar(int? jornadaId) async {
    if (jornadaId == null) {
      pausas = const [];
      notifyListeners();
      return;
    }

    await _executar(() async {
      pausas = await _service.listarPorJornada(jornadaId);
    });
  }

  Future<void> iniciar(int jornadaId, {required int odometroInicio}) async {
    await _executar(() async {
      await _service.iniciarPausa(odometroInicio: odometroInicio);
      pausas = await _service.listarPorJornada(jornadaId);
    });
  }

  Future<void> finalizar(int jornadaId, {required int odometroFim}) async {
    await _executar(() async {
      await _service.finalizarPausa(jornadaId, odometroFim: odometroFim);
      pausas = await _service.listarPorJornada(jornadaId);
    });
  }

  Future<void> editarPausa({
    required Pausa pausa,
    required DateTime inicio,
    required int? odometroInicio,
    required DateTime? fim,
    required int? odometroFim,
    String? titulo,
    String? observacao,
  }) async {
    await _executar(() async {
      await _service.editarPausa(
        pausa: pausa,
        inicio: inicio,
        odometroInicio: odometroInicio,
        fim: fim,
        odometroFim: odometroFim,
        titulo: titulo,
        observacao: observacao,
      );
      pausas = await _service.listarPorJornada(pausa.jornadaId);
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
