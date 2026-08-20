import 'package:drift/drift.dart';

import '../../../core/constants/enums/tipo_registro_ganhos.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/daos/ganho_individual_dao.dart';
import '../../jornada/data/jornada_repository.dart';
import 'ganho_individual_repository.dart';

class GanhoIndividualService {
  final GanhoIndividualRepository _repository;
  final JornadaRepository _jornadaRepository;
  final DateTime Function() _agora;

  GanhoIndividualService(
    this._repository,
    this._jornadaRepository, {
    DateTime Function()? agora,
  }) : _agora = agora ?? DateTime.now;

  Future<List<Plataforma>> listarPlataformasAtivas() =>
      _repository.listarPlataformasAtivas();

  Future<List<TotalGanhoIndividual>> totalizarPorJornada(int jornadaId) =>
      _repository.totalizarPorJornada(jornadaId);

  Future<int> registrar({
    required int plataformaId,
    required int quantidadeViagens,
    required int valorTotalCentavos,
    String? observacao,
    DateTime? dataHora,
  }) async {
    if (quantidadeViagens < 1) {
      throw Exception('A quantidade de viagens deve ser pelo menos 1.');
    }
    if (valorTotalCentavos < 0) {
      throw Exception('O valor total não pode ser negativo.');
    }
    final jornada = await _jornadaRepository.buscarJornadaAberta();
    if (jornada == null) {
      throw Exception('É necessária uma Jornada aberta para registrar.');
    }
    final agora = _agora();
    final instanteOperacional = dataHora ?? agora;
    _validarDataHora(instanteOperacional, jornada, agora);
    final plataforma = await _repository.buscarPlataforma(plataformaId);
    if (plataforma == null ||
        plataforma.tipoRegistroGanhos != TipoRegistroGanhos.individual) {
      throw Exception('A plataforma deve usar registro individual.');
    }
    if (!plataforma.ativa) {
      throw Exception('A plataforma está inativa para novos lançamentos.');
    }
    final texto = observacao?.trim();
    return _repository.inserir(
      LancamentosGanhoIndividualCompanion.insert(
        plataformaId: plataformaId,
        jornadaId: Value(jornada.id),
        quantidadeViagens: quantidadeViagens,
        valorTotalCentavos: valorTotalCentavos,
        observacao: Value(texto == null || texto.isEmpty ? null : texto),
        dataHora: Value(instanteOperacional),
        dataCriacao: Value(agora),
      ),
    );
  }

  Future<bool> editarDataHora({
    required int lancamentoId,
    required DateTime dataHora,
  }) async {
    final lancamento = await _repository.buscarPorId(lancamentoId);
    if (lancamento == null) throw Exception('O lançamento não foi encontrado.');
    final jornadaId = lancamento.jornadaId;
    if (jornadaId == null) {
      if (dataHora.isAfter(_agora())) {
        throw Exception('A data e hora não podem estar no futuro.');
      }
    } else {
      final jornada = await _jornadaRepository.buscarPorId(jornadaId);
      if (jornada == null) throw Exception('A Jornada não foi encontrada.');
      _validarDataHora(dataHora, jornada, _agora());
    }
    return _repository.atualizar(lancamento.copyWith(dataHora: dataHora));
  }

  void _validarDataHora(DateTime dataHora, Jornada jornada, DateTime agora) {
    if (dataHora.isAfter(agora)) {
      throw Exception('A data e hora não podem estar no futuro.');
    }
    if (dataHora.isBefore(jornada.dataHoraInicio)) {
      throw Exception('A data e hora não podem ser anteriores à Jornada.');
    }
    if (jornada.dataHoraFim != null && dataHora.isAfter(jornada.dataHoraFim!)) {
      throw Exception('A data e hora não podem ser posteriores à Jornada.');
    }
  }
}
