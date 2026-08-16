import 'package:drift/drift.dart';

import '../../../core/constants/enums/tipo_despesa_veiculo.dart';
import '../../../core/database/app_database.dart';
import 'despesa_veiculo_repository.dart';

class DespesaVeiculoService {
  final DespesaVeiculoRepository _repository;
  final DateTime Function() _agora;

  DespesaVeiculoService(this._repository, {DateTime Function()? agora})
    : _agora = agora ?? DateTime.now;

  Future<List<DespesaVeiculo>> listar(int veiculoId) =>
      _repository.listarPorVeiculo(veiculoId);

  Future<List<String>> sugestoes(int veiculoId, TipoDespesaVeiculo tipo) =>
      _repository.listarDescricoes(veiculoId, tipo);

  Future<int> criar({
    required int veiculoId,
    required TipoDespesaVeiculo? tipo,
    required String descricao,
    required int valorCentavos,
    DateTime? dataHora,
    String? observacao,
  }) async {
    final agora = _agora();
    final instante = dataHora ?? agora;
    final texto = await _validar(
      veiculoId: veiculoId,
      tipo: tipo,
      descricao: descricao,
      valorCentavos: valorCentavos,
      dataHora: instante,
      agora: agora,
    );
    return _repository.inserir(
      DespesasVeiculoCompanion.insert(
        veiculoId: veiculoId,
        tipo: tipo!,
        descricao: texto,
        valorCentavos: valorCentavos,
        dataHora: instante,
        observacao: Value(_opcional(observacao)),
        dataCriacao: Value(agora),
      ),
    );
  }

  Future<void> editar({
    required int id,
    required int veiculoId,
    required TipoDespesaVeiculo? tipo,
    required String descricao,
    required int valorCentavos,
    required DateTime dataHora,
    String? observacao,
  }) async {
    final existente = await _repository.buscarPorId(id);
    if (existente == null || existente.veiculoId != veiculoId) {
      throw Exception('A despesa não foi encontrada.');
    }
    final agora = _agora();
    final texto = await _validar(
      veiculoId: veiculoId,
      tipo: tipo,
      descricao: descricao,
      valorCentavos: valorCentavos,
      dataHora: dataHora,
      agora: agora,
    );
    await _repository.atualizar(
      existente.copyWith(
        tipo: tipo!,
        descricao: texto,
        valorCentavos: valorCentavos,
        dataHora: dataHora,
        observacao: Value(_opcional(observacao)),
        dataAtualizacao: Value(agora),
      ),
    );
  }

  Future<String> _validar({
    required int veiculoId,
    required TipoDespesaVeiculo? tipo,
    required String descricao,
    required int valorCentavos,
    required DateTime dataHora,
    required DateTime agora,
  }) async {
    if (!await _repository.veiculoExiste(veiculoId)) {
      throw Exception('O veículo não foi encontrado.');
    }
    if (tipo == null) throw Exception('Informe o tipo da despesa.');
    final texto = descricao.trim();
    if (texto.isEmpty) throw Exception('Informe a descrição da despesa.');
    if (valorCentavos <= 0) {
      throw Exception('O valor da despesa deve ser maior que zero.');
    }
    if (dataHora.isAfter(agora)) {
      throw Exception('A data da despesa não pode estar no futuro.');
    }
    return texto;
  }

  String? _opcional(String? valor) {
    final texto = valor?.trim() ?? '';
    return texto.isEmpty ? null : texto;
  }
}
