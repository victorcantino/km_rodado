import 'package:flutter/foundation.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/passe_plataforma_dao.dart';
import '../../data/passe_plataforma_service.dart';
import '../../../../core/constants/enums/tipo_passe.dart';

class PassePlataformaController extends ChangeNotifier {
  final PassePlataformaService _service;
  List<Plataforma> plataformas = const [];
  Map<int, ConfiguracaoPasseRepetivel> ultimosRepetiveis = const {};
  List<PasseComPlataforma> passes = const [];
  bool carregando = false;

  PassePlataformaController(this._service);

  Future<void> carregar() async {
    plataformas = await _service.listarPlataformasAtivas();
    final configuracoes = <int, ConfiguracaoPasseRepetivel>{};
    for (final plataforma in plataformas) {
      final configuracao = await _service.buscarUltimoRepetivel(plataforma.id);
      if (configuracao != null) configuracoes[plataforma.id] = configuracao;
    }
    ultimosRepetiveis = configuracoes;
    notifyListeners();
  }

  Future<void> carregarHistorico() async {
    passes = await _service.listarTodos();
    passes.sort((a, b) {
      final porData = b.passe.dataHora.compareTo(a.passe.dataHora);
      return porData != 0 ? porData : b.passe.id.compareTo(a.passe.id);
    });
    notifyListeners();
  }

  Future<void> editar(PassesPlataformaData passe) async {
    await _service.atualizar(passe);
    await carregarHistorico();
  }

  Future<void> excluir(int id) async {
    await _service.excluir(id);
    await carregarHistorico();
  }

  Future<void> registrar({
    required int plataformaId,
    required DateTime dataHora,
    required int valorPagoCentavos,
    required TipoPasse tipo,
    int? duracaoHoras,
    int? limiteFaturamentoCentavos,
    String? observacao,
  }) async {
    carregando = true;
    notifyListeners();
    try {
      await _service.registrar(
        plataformaId: plataformaId,
        dataHora: dataHora,
        valorPagoCentavos: valorPagoCentavos,
        tipo: tipo,
        duracaoHoras: duracaoHoras,
        limiteFaturamentoCentavos: limiteFaturamentoCentavos,
        observacao: observacao,
      );
      final configuracao = await _service.buscarUltimoRepetivel(plataformaId);
      if (configuracao != null) {
        ultimosRepetiveis = {...ultimosRepetiveis, plataformaId: configuracao};
      }
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
