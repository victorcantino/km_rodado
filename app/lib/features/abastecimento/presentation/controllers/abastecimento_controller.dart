import 'package:flutter/foundation.dart';

import '../../../../core/constants/enums/tipo_combustivel.dart';
import '../../../../core/database/app_database.dart';
import '../../data/abastecimento_service.dart';
import '../../data/resumo_inteligencia_abastecimento.dart';

class AbastecimentoController extends ChangeNotifier {
  final AbastecimentoService _service;
  Abastecimento? ultimo;
  List<Abastecimento> historico = const [];
  ResumoInteligenciaAbastecimento? inteligencia;
  bool carregando = false;

  AbastecimentoController(this._service);

  Future<int?> ultimoOdometro(int veiculoId) =>
      _service.ultimoOdometro(veiculoId);

  Future<void> carregar(int veiculoId) async {
    historico = (await _service.listar(veiculoId))
      ..sort((a, b) {
        final porData = b.dataHora.compareTo(a.dataHora);
        return porData != 0 ? porData : b.id.compareTo(a.id);
      });
    ultimo = await _service.ultimoAbastecimento(veiculoId);
    inteligencia = await _service.calcularInteligencia(veiculoId);
    notifyListeners();
  }

  Future<int?> ultimoOdometroOperacional(int veiculoId) =>
      _service.ultimoOdometro(veiculoId);

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
      inteligencia = await _service.calcularInteligencia(veiculoId);
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> editar(Abastecimento abastecimento) async {
    carregando = true;
    notifyListeners();
    try {
      await _service.atualizar(abastecimento);
      await carregar(abastecimento.veiculoId);
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> excluir(Abastecimento abastecimento) async {
    carregando = true;
    notifyListeners();
    try {
      await _service.excluir(abastecimento.id);
      await carregar(abastecimento.veiculoId);
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
