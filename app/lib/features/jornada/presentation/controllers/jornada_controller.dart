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

  Future<int?> sugerirOdometroFechamento() =>
      _service.sugerirOdometroFechamento();

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
    required DateTime dataHoraInicio,
  }) async {
    carregando = true;
    notifyListeners();

    try {
      await _service.abrirJornada(
        usuarioId: usuarioId,
        veiculoId: veiculoId,
        odometro: odometro,
        cidadeOrigem: cidadeOrigem,
        dataHoraInicio: dataHoraInicio,
      );

      jornadaAtual = await _service.jornadaAberta();
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> editarJornada({
    required Jornada jornada,
    required DateTime dataHoraInicio,
    required int odometroInicio,
    required String cidadeOrigem,
    DateTime? dataHoraFim,
    int? odometroFim,
    String? cidadeDestino,
    String? observacoes,
  }) async {
    carregando = true;
    notifyListeners();
    try {
      await _service.editarJornada(
        jornadaId: jornada.id,
        dataHoraInicio: dataHoraInicio,
        odometroInicio: odometroInicio,
        cidadeOrigem: cidadeOrigem,
        dataHoraFim: dataHoraFim,
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

  Future<void> validarFechamento({
    required DateTime dataHoraFim,
    required int odometroFim,
    String? cidadeDestino,
    String? observacoes,
  }) => _service.validarFechamento(
    dataHoraFim: dataHoraFim,
    odometroFim: odometroFim,
    cidadeDestino: cidadeDestino,
    observacoes: observacoes,
  );
}
