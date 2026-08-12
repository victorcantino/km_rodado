import 'package:flutter/material.dart';

import '../../../../core/database/app_database.dart';
import '../../data/jornada_service.dart';
import '../../data/resumo_jornada.dart';

class JornadaController extends ChangeNotifier {
  final JornadaService _service;

  JornadaController(this._service);

  Jornada? jornadaAtual;
  Jornada? ultimaJornadaFinalizada;
  ResumoJornada? resumoUltimaJornada;

  bool carregando = false;

  bool get possuiJornadaAberta => jornadaAtual != null;

  Future<void> carregarJornadaAberta() async {
    carregando = true;
    notifyListeners();

    try {
      jornadaAtual = await _service.jornadaAberta();
      ultimaJornadaFinalizada = await _service.ultimaJornadaFinalizada();
      resumoUltimaJornada = await _service.resumoUltimaJornada();
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> abrirJornada({
    required int usuarioId,
    required int veiculoId,
    required int odometro,
    required String cidadeOrigem,
  }) async {
    carregando = true;
    notifyListeners();

    try {
      await _service.abrirJornada(
        usuarioId: usuarioId,
        veiculoId: veiculoId,
        odometro: odometro,
        cidadeOrigem: cidadeOrigem,
      );

      jornadaAtual = await _service.jornadaAberta();
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> fecharJornada({
    required int odometroFim,
    String? cidadeDestino,
    String? observacoes,
  }) async {
    carregando = true;
    notifyListeners();

    try {
      await _service.fecharJornada(
        odometroFim: odometroFim,
        cidadeDestino: cidadeDestino,
        observacoes: observacoes,
      );

      jornadaAtual = await _service.jornadaAberta();
      ultimaJornadaFinalizada = await _service.ultimaJornadaFinalizada();
      resumoUltimaJornada = await _service.resumoUltimaJornada();
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
