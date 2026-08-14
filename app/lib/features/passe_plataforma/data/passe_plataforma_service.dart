import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/daos/passe_plataforma_dao.dart';
import '../../jornada/data/jornada_repository.dart';
import 'passe_plataforma_repository.dart';

class PassePlataformaService {
  final PassePlataformaRepository _repository;
  final JornadaRepository _jornadaRepository;
  final DateTime Function() _agora;

  PassePlataformaService(
    this._repository,
    this._jornadaRepository, {
    DateTime Function()? agora,
  }) : _agora = agora ?? DateTime.now;

  Future<List<Plataforma>> listarPlataformasAtivas() =>
      _repository.listarPlataformasAtivas();
  Future<List<PasseComPlataforma>> listarPorJornada(int jornadaId) =>
      _repository.listarPorJornada(jornadaId);

  Future<int> registrar({
    required int plataformaId,
    required DateTime dataHora,
    required int valorPagoCentavos,
    String? modalidade,
    DateTime? validadeAte,
    int? limiteFaturamentoCentavos,
    String? observacao,
  }) async {
    if (valorPagoCentavos <= 0) {
      throw Exception('O valor pago deve ser maior que zero.');
    }
    if (limiteFaturamentoCentavos != null && limiteFaturamentoCentavos < 0) {
      throw Exception('O limite de faturamento não pode ser negativo.');
    }
    if (await _repository.buscarPlataforma(plataformaId) == null) {
      throw Exception('A plataforma informada não existe.');
    }
    final jornada = await _jornadaRepository.buscarJornadaAberta();
    return _repository.inserir(
      PassesPlataformaCompanion.insert(
        plataformaId: plataformaId,
        jornadaId: Value(jornada?.id),
        dataHora: dataHora,
        valorPagoCentavos: valorPagoCentavos,
        modalidade: Value(_normalizar(modalidade)),
        validadeAte: Value(validadeAte),
        limiteFaturamentoCentavos: Value(limiteFaturamentoCentavos),
        observacao: Value(_normalizar(observacao)),
        dataCriacao: Value(_agora()),
      ),
    );
  }

  String? _normalizar(String? texto) {
    final valor = texto?.trim();
    return valor == null || valor.isEmpty ? null : valor;
  }
}
