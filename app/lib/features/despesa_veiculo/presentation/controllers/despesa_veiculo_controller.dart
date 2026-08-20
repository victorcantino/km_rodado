import 'package:flutter/foundation.dart';

import '../../../../core/constants/enums/tipo_despesa_veiculo.dart';
import '../../../../core/database/app_database.dart';
import '../../data/despesa_veiculo_service.dart';

class DespesaVeiculoController extends ChangeNotifier {
  final DespesaVeiculoService _service;
  List<DespesaVeiculo> historico = const [];
  bool carregando = false;

  DespesaVeiculoController(this._service);

  Future<void> carregar(int veiculoId) async {
    carregando = true;
    notifyListeners();
    try {
      historico = await _service.listar(veiculoId);
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<List<String>> sugestoes(int veiculoId, TipoDespesaVeiculo tipo) =>
      _service.sugestoes(veiculoId, tipo);

  Future<void> salvar({
    int? id,
    required int veiculoId,
    required TipoDespesaVeiculo tipo,
    required String descricao,
    required int valorCentavos,
    required DateTime dataHora,
    String? observacao,
  }) async {
    if (id == null) {
      await _service.criar(
        veiculoId: veiculoId,
        tipo: tipo,
        descricao: descricao,
        valorCentavos: valorCentavos,
        dataHora: dataHora,
        observacao: observacao,
      );
    } else {
      await _service.editar(
        id: id,
        veiculoId: veiculoId,
        tipo: tipo,
        descricao: descricao,
        valorCentavos: valorCentavos,
        dataHora: dataHora,
        observacao: observacao,
      );
    }
    await carregar(veiculoId);
  }

  Future<void> excluir({required int id, required int veiculoId}) async {
    await _service.excluir(id);
    await carregar(veiculoId);
  }
}
