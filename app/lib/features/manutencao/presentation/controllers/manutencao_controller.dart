import 'package:flutter/foundation.dart';

import '../../../../core/database/daos/manutencao_dao.dart';
import '../../data/manutencao_service.dart';

class ManutencaoController extends ChangeNotifier {
  final ManutencaoService _service;
  List<ManutencaoComItens> historico = const [];
  List<ProximaManutencao> proximas = const [];
  List<String> sugestoes = const [];
  bool carregando = false;

  ManutencaoController(this._service);

  Future<void> carregar(int veiculoId) async {
    carregando = true;
    notifyListeners();
    try {
      historico = await _service.listar(veiculoId);
      sugestoes = await _service.sugestoes(veiculoId);
      proximas = await _service.proximas(veiculoId);
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<int?> sugerirOdometro(int veiculoId) =>
      _service.sugerirOdometro(veiculoId);
  Future<int?> sugerirIntervalo(int veiculoId, String descricao) =>
      _service.sugerirIntervalo(veiculoId, descricao);

  Future<void> salvar({
    int? id,
    required int veiculoId,
    required DateTime dataHora,
    required int odometro,
    required List<ItemManutencaoEntrada> itens,
    String? oficina,
    String? observacao,
  }) async {
    if (id == null) {
      await _service.criar(
        veiculoId: veiculoId,
        dataHora: dataHora,
        odometro: odometro,
        itens: itens,
        oficina: oficina,
        observacao: observacao,
      );
    } else {
      await _service.editar(
        id: id,
        veiculoId: veiculoId,
        dataHora: dataHora,
        odometro: odometro,
        itens: itens,
        oficina: oficina,
        observacao: observacao,
      );
    }
    await carregar(veiculoId);
  }
}
