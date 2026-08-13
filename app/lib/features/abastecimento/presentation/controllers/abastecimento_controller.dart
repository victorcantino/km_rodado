import 'package:flutter/foundation.dart';

import '../../../../core/constants/enums/tipo_combustivel.dart';
import '../../../../core/database/app_database.dart';
import '../../data/abastecimento_service.dart';

class AbastecimentoController extends ChangeNotifier {
  final AbastecimentoService _service;
  Abastecimento? ultimo;
  bool carregando = false;

  AbastecimentoController(this._service);

  Future<int?> ultimoOdometro(int veiculoId) =>
      _service.ultimoOdometro(veiculoId);

  Future<void> carregar(int veiculoId) async {
    ultimo = await _service.ultimoAbastecimento(veiculoId);
    notifyListeners();
  }

  Future<void> registrar({
    required int veiculoId,
    required int odometro,
    required TipoCombustivel tipoCombustivel,
    required int volumeMililitros,
    required int valorTotalPagoCentavos,
    required bool tanqueCheio,
    required DateTime dataHora,
    int? precoBombaMilesimosRealPorLitro,
    String? cidade,
    String? nomePosto,
    String? bandeiraPosto,
    String? observacao,
  }) async {
    carregando = true;
    notifyListeners();
    try {
      await _service.registrar(
        veiculoId: veiculoId,
        odometro: odometro,
        tipoCombustivel: tipoCombustivel,
        volumeMililitros: volumeMililitros,
        valorTotalPagoCentavos: valorTotalPagoCentavos,
        tanqueCheio: tanqueCheio,
        dataHora: dataHora,
        precoBombaMilesimosRealPorLitro: precoBombaMilesimosRealPorLitro,
        cidade: cidade,
        nomePosto: nomePosto,
        bandeiraPosto: bandeiraPosto,
        observacao: observacao,
      );
      ultimo = await _service.ultimoAbastecimento(veiculoId);
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
