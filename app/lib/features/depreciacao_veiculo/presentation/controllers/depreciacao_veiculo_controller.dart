import 'package:flutter/foundation.dart';

import '../../../../core/constants/enums/fonte_referencia_depreciacao.dart';
import '../../../../core/constants/enums/metodo_depreciacao.dart';
import '../../../../core/database/app_database.dart';
import '../../data/depreciacao_veiculo_service.dart';
import '../../data/resultado_depreciacao.dart';

class DepreciacaoVeiculoController extends ChangeNotifier {
  final DepreciacaoVeiculoService _service;
  DepreciacaoVeiculo? dados;
  int? odometroSugerido;
  bool carregando = false;

  DepreciacaoVeiculoController(this._service);

  ResultadoDepreciacao get observada => _service.calcularObservada(dados);
  ResultadoDepreciacao get projetada => _service.calcularProjetada(dados);
  ResultadoDepreciacao? get selecionada => _service.resultadoSelecionado(dados);

  Future<void> carregar(int veiculoId) async {
    carregando = true;
    notifyListeners();
    try {
      final resultados = await Future.wait([
        _service.buscar(veiculoId),
        _service.ultimoOdometro(veiculoId),
      ]);
      dados = resultados[0] as DepreciacaoVeiculo?;
      odometroSugerido = resultados[1] as int?;
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> salvar({
    required int veiculoId,
    MetodoDepreciacao? metodoSelecionado,
    int? valorAquisicaoCentavos,
    bool valorAquisicaoEstimado = false,
    int? odometroAquisicao,
    int? valorReferenciaCentavos,
    bool valorReferenciaEstimado = false,
    FonteReferenciaDepreciacao? fonteReferencia,
    DateTime? dataReferencia,
    int? odometroReferencia,
    int? valorVendaProjetadoCentavos,
    bool valorVendaProjetadoEstimado = false,
    int? odometroVendaProjetado,
  }) async {
    await _service.salvar(
      veiculoId: veiculoId,
      metodoSelecionado: metodoSelecionado,
      valorAquisicaoCentavos: valorAquisicaoCentavos,
      valorAquisicaoEstimado: valorAquisicaoEstimado,
      odometroAquisicao: odometroAquisicao,
      valorReferenciaCentavos: valorReferenciaCentavos,
      valorReferenciaEstimado: valorReferenciaEstimado,
      fonteReferencia: fonteReferencia,
      dataReferencia: dataReferencia,
      odometroReferencia: odometroReferencia,
      valorVendaProjetadoCentavos: valorVendaProjetadoCentavos,
      valorVendaProjetadoEstimado: valorVendaProjetadoEstimado,
      odometroVendaProjetado: odometroVendaProjetado,
    );
    await carregar(veiculoId);
  }
}
