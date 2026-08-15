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
  bool leituraInicialConcluida = false;
  bool carregando = false;

  Future<void> carregarEstado(int? jornadaId) async {
    if (jornadaId == null) {
      leituraInicialConcluida = false;
      sugestoes = const {};
      notifyListeners();
      return;
    }

    await _executar(() async {
      leituraInicialConcluida =
          await _service.buscarLeituraInicial(jornadaId) != null;
    });
  }

  Future<void> preparar(int jornadaId, {required bool usarSugestoes}) async {
    await _executar(() async {
      plataformas = await _service.listarPlataformasParaLeitura(
        jornadaId,
        leituraInicial: !usarSugestoes,
      );
      sugestoes = usarSugestoes
          ? await _service.buscarSugestoes(jornadaId)
          : const {};
    });
  }

  Future<List<Plataforma>> configurarPlataformas(
    int jornadaId,
    Map<int, bool> ativacoes, {
    required bool leituraInicial,
  }) async {
    await _service.atualizarAtivacao(ativacoes);
    plataformas = await _service.listarPlataformasParaLeitura(
      jornadaId,
      leituraInicial: leituraInicial,
    );
    notifyListeners();
    return plataformas;
  }

  Future<List<Plataforma>> listarTodasPlataformas() =>
      _service.listarPlataformas();

  Future<void> salvarInicial({
    required int jornadaId,
    required List<ItemLeituraGanhosEntrada> itens,
  }) async {
    await _executar(() async {
      final leituraId = await _service.salvarLeituraInicial(
        jornadaId: jornadaId,
        itens: itens,
      );
      await _carregarLeituraSalva(leituraId, jornadaId);
      leituraInicialConcluida = true;
    });
  }

  Future<void> salvarParcial({
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
      await _carregarLeituraSalva(leituraId, jornadaId);
    });
  }

  Future<void> finalizarJornada({
    required int jornadaId,
    required int odometroFim,
    required List<ItemLeituraGanhosEntrada> itens,
    String? cidadeDestino,
    String? observacoes,
    DateTime? dataHoraFim,
  }) async {
    await _executar(() async {
      final leituraId = await _service.finalizarJornada(
        jornadaId: jornadaId,
        odometroFim: odometroFim,
        cidadeDestino: cidadeDestino,
        observacoes: observacoes,
        dataHoraFim: dataHoraFim,
        itens: itens,
      );
      ultimaLeituraSalva = await _service.buscarLeitura(leituraId);
      ultimosItensSalvos = await _service.listarItens(leituraId);
      sugestoes = const {};
      leituraInicialConcluida = false;
    });
  }

  Future<void> _carregarLeituraSalva(int leituraId, int jornadaId) async {
    ultimaLeituraSalva = await _service.buscarLeitura(leituraId);
    ultimosItensSalvos = await _service.listarItens(leituraId);
    sugestoes = await _service.buscarSugestoes(jornadaId);
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
