import 'package:drift/drift.dart';

import '../../../core/constants/enums/tipo_passe.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/daos/passe_plataforma_dao.dart';
import '../../jornada/data/jornada_repository.dart';
import 'passe_plataforma_repository.dart';

typedef ConfiguracaoPasseRepetivel = ({
  TipoPasse tipo,
  int valorPagoCentavos,
  int? limiteFaturamentoCentavos,
  int? duracaoHoras,
});

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
  Future<List<PasseComPlataforma>> listarTodos() => _repository.listarTodos();
  Future<bool> atualizar(PassesPlataformaData passe) =>
      _repository.atualizar(passe);
  Future<int> excluir(int id) => _repository.excluir(id);

  Future<ConfiguracaoPasseRepetivel?> buscarUltimoRepetivel(
    int plataformaId,
  ) async {
    final passe = await _repository.buscarUltimoPorPlataforma(plataformaId);
    return passe == null ? null : configuracaoRepetivel(passe);
  }

  static ConfiguracaoPasseRepetivel? configuracaoRepetivel(
    PassesPlataformaData passe,
  ) {
    if (passe.modalidade == TipoPasse.faturamento.name &&
        passe.limiteFaturamentoCentavos != null &&
        passe.limiteFaturamentoCentavos! > 0) {
      return (
        tipo: TipoPasse.faturamento,
        valorPagoCentavos: passe.valorPagoCentavos,
        limiteFaturamentoCentavos: passe.limiteFaturamentoCentavos,
        duracaoHoras: null,
      );
    }
    if (passe.modalidade == TipoPasse.tempo.name && passe.validadeAte != null) {
      final horas = passe.validadeAte!.difference(passe.dataHora).inHours;
      final exata =
          passe.validadeAte!.difference(passe.dataHora) ==
          Duration(hours: horas);
      if (exata && (horas == 24 || horas == 72)) {
        return (
          tipo: TipoPasse.tempo,
          valorPagoCentavos: passe.valorPagoCentavos,
          limiteFaturamentoCentavos: null,
          duracaoHoras: horas,
        );
      }
    }
    return null;
  }

  Future<int> registrar({
    required int plataformaId,
    required DateTime dataHora,
    required int valorPagoCentavos,
    required TipoPasse tipo,
    int? duracaoHoras,
    int? limiteFaturamentoCentavos,
    String? observacao,
  }) async {
    if (valorPagoCentavos <= 0) {
      throw Exception('O valor pago deve ser maior que zero.');
    }
    if (tipo == TipoPasse.faturamento &&
        (limiteFaturamentoCentavos == null || limiteFaturamentoCentavos <= 0)) {
      throw Exception('O limite de faturamento deve ser maior que zero.');
    }
    if (tipo == TipoPasse.tempo && duracaoHoras != 24 && duracaoHoras != 72) {
      throw Exception('A duração deve ser de 24 ou 72 horas.');
    }
    if (await _repository.buscarPlataforma(plataformaId) == null) {
      throw Exception('A plataforma informada não existe.');
    }
    final agora = _agora();
    final jornada = await _jornadaRepository.buscarJornadaAberta();
    final jornadaId =
        jornada != null &&
            !dataHora.isBefore(jornada.dataHoraInicio) &&
            !dataHora.isAfter(agora)
        ? jornada.id
        : null;
    final validadeAte = tipo == TipoPasse.faturamento
        ? dataHora.add(const Duration(days: 180))
        : dataHora.add(Duration(hours: duracaoHoras!));
    return _repository.inserir(
      PassesPlataformaCompanion.insert(
        plataformaId: plataformaId,
        jornadaId: Value(jornadaId),
        dataHora: dataHora,
        valorPagoCentavos: valorPagoCentavos,
        modalidade: Value(tipo.name),
        validadeAte: Value(validadeAte),
        limiteFaturamentoCentavos: Value(
          tipo == TipoPasse.faturamento ? limiteFaturamentoCentavos : null,
        ),
        observacao: Value(_normalizar(observacao)),
        dataCriacao: Value(agora),
      ),
    );
  }

  String? _normalizar(String? texto) {
    final valor = texto?.trim();
    return valor == null || valor.isEmpty ? null : valor;
  }
}
