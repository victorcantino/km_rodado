import 'package:flutter/foundation.dart';

import '../../../../core/constants/enums/escopo_custo_recorrente.dart';
import '../../../../core/constants/enums/tipo_custo_recorrente.dart';
import '../../../../core/database/app_database.dart';
import '../../data/custo_recorrente_service.dart';

class CustoRecorrenteController extends ChangeNotifier {
  final CustoRecorrenteService _service;
  List<CustoRecorrente> historico = const [];
  List<Veiculo> veiculos = const [];
  List<Plataforma> plataformas = const [];
  bool carregando = false;

  CustoRecorrenteController(this._service);

  Future<void> carregar() async {
    carregando = true;
    notifyListeners();
    try {
      final resultados = await Future.wait([
        _service.listar(),
        _service.listarVeiculos(),
        _service.listarPlataformas(),
      ]);
      historico = resultados[0] as List<CustoRecorrente>;
      veiculos = resultados[1] as List<Veiculo>;
      plataformas = resultados[2] as List<Plataforma>;
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  PadraoCustoRecorrente padraoPara(TipoCustoRecorrente tipo) =>
      _service.padraoPara(tipo);
  Future<List<String>> sugestoes(TipoCustoRecorrente tipo) =>
      _service.sugestoes(tipo);
  double? equivalenteMensal(int? valor, int meses) =>
      _service.equivalenteMensalReais(
        valorReferenciaCentavos: valor,
        periodicidadeMeses: meses,
      );

  Future<void> salvar({
    int? id,
    required TipoCustoRecorrente tipo,
    required String descricao,
    required EscopoCustoRecorrente escopo,
    int? veiculoId,
    int? plataformaId,
    int? valorReferenciaCentavos,
    required bool valorEstimado,
    required int periodicidadeMeses,
    required int parcelasPorCiclo,
    required bool ativo,
    int? quantidadeCiclosPrevista,
    String? observacao,
  }) async {
    if (id == null) {
      await _service.criar(
        tipo: tipo,
        descricao: descricao,
        escopo: escopo,
        veiculoId: veiculoId,
        plataformaId: plataformaId,
        valorReferenciaCentavos: valorReferenciaCentavos,
        valorEstimado: valorEstimado,
        periodicidadeMeses: periodicidadeMeses,
        parcelasPorCiclo: parcelasPorCiclo,
        ativo: ativo,
        quantidadeCiclosPrevista: quantidadeCiclosPrevista,
        observacao: observacao,
      );
    } else {
      await _service.editar(
        id: id,
        tipo: tipo,
        descricao: descricao,
        escopo: escopo,
        veiculoId: veiculoId,
        plataformaId: plataformaId,
        valorReferenciaCentavos: valorReferenciaCentavos,
        valorEstimado: valorEstimado,
        periodicidadeMeses: periodicidadeMeses,
        parcelasPorCiclo: parcelasPorCiclo,
        ativo: ativo,
        quantidadeCiclosPrevista: quantidadeCiclosPrevista,
        observacao: observacao,
      );
    }
    await carregar();
  }
}
