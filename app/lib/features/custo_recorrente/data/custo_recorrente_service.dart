import 'package:drift/drift.dart';

import '../../../core/constants/enums/escopo_custo_recorrente.dart';
import '../../../core/constants/enums/tipo_custo_recorrente.dart';
import '../../../core/database/app_database.dart';
import 'custo_recorrente_repository.dart';

typedef PadraoCustoRecorrente = ({
  EscopoCustoRecorrente? escopo,
  int? periodicidadeMeses,
});

class CustoRecorrenteService {
  final CustoRecorrenteRepository _repository;
  final DateTime Function() _agora;

  CustoRecorrenteService(this._repository, {DateTime Function()? agora})
    : _agora = agora ?? DateTime.now;

  Future<List<CustoRecorrente>> listar() => _repository.listar();
  Future<List<Veiculo>> listarVeiculos() => _repository.listarVeiculos();
  Future<List<Plataforma>> listarPlataformas() =>
      _repository.listarPlataformas();
  Future<List<String>> sugestoes(TipoCustoRecorrente tipo) =>
      _repository.listarDescricoes(tipo);

  PadraoCustoRecorrente padraoPara(TipoCustoRecorrente tipo) => switch (tipo) {
    TipoCustoRecorrente.ipva || TipoCustoRecorrente.licenciamento => (
      escopo: EscopoCustoRecorrente.veiculo,
      periodicidadeMeses: 12,
    ),
    TipoCustoRecorrente.seguro ||
    TipoCustoRecorrente.parcelaVeiculo ||
    TipoCustoRecorrente.depreciacao => (
      escopo: EscopoCustoRecorrente.veiculo,
      periodicidadeMeses: 1,
    ),
    TipoCustoRecorrente.telefoneProfissional => (
      escopo: EscopoCustoRecorrente.atividade,
      periodicidadeMeses: 1,
    ),
    TipoCustoRecorrente.contaPlataforma => (
      escopo: EscopoCustoRecorrente.plataforma,
      periodicidadeMeses: 1,
    ),
    TipoCustoRecorrente.outro => (escopo: null, periodicidadeMeses: null),
  };

  double? equivalenteMensalReais({
    required int? valorReferenciaCentavos,
    required int periodicidadeMeses,
  }) => valorReferenciaCentavos == null
      ? null
      : valorReferenciaCentavos / periodicidadeMeses / 100;

  Future<int> criar({
    required TipoCustoRecorrente? tipo,
    required String descricao,
    required EscopoCustoRecorrente? escopo,
    int? veiculoId,
    int? plataformaId,
    int? valorReferenciaCentavos,
    bool valorEstimado = false,
    required int periodicidadeMeses,
    int parcelasPorCiclo = 1,
    bool ativo = true,
    int? quantidadeCiclosPrevista,
    String? observacao,
  }) async {
    final texto = await _validar(
      tipo: tipo,
      descricao: descricao,
      escopo: escopo,
      veiculoId: veiculoId,
      plataformaId: plataformaId,
      valorReferenciaCentavos: valorReferenciaCentavos,
      periodicidadeMeses: periodicidadeMeses,
      parcelasPorCiclo: parcelasPorCiclo,
      quantidadeCiclosPrevista: quantidadeCiclosPrevista,
    );
    return _repository.inserir(
      CustosRecorrentesCompanion.insert(
        tipo: tipo!,
        descricao: texto,
        escopo: escopo!,
        veiculoId: Value(veiculoId),
        plataformaId: Value(plataformaId),
        valorReferenciaCentavos: Value(valorReferenciaCentavos),
        valorEstimado: Value(valorEstimado),
        periodicidadeMeses: periodicidadeMeses,
        parcelasPorCiclo: Value(parcelasPorCiclo),
        ativo: Value(ativo),
        quantidadeCiclosPrevista: Value(quantidadeCiclosPrevista),
        observacao: Value(_opcional(observacao)),
        dataCriacao: Value(_agora()),
      ),
    );
  }

  Future<void> editar({
    required int id,
    required TipoCustoRecorrente? tipo,
    required String descricao,
    required EscopoCustoRecorrente? escopo,
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
    final existente = await _repository.buscarPorId(id);
    if (existente == null) {
      throw Exception('O custo recorrente não foi encontrado.');
    }
    final texto = await _validar(
      tipo: tipo,
      descricao: descricao,
      escopo: escopo,
      veiculoId: veiculoId,
      plataformaId: plataformaId,
      valorReferenciaCentavos: valorReferenciaCentavos,
      periodicidadeMeses: periodicidadeMeses,
      parcelasPorCiclo: parcelasPorCiclo,
      quantidadeCiclosPrevista: quantidadeCiclosPrevista,
    );
    await _repository.atualizar(
      existente.copyWith(
        tipo: tipo!,
        descricao: texto,
        escopo: escopo!,
        veiculoId: Value(veiculoId),
        plataformaId: Value(plataformaId),
        valorReferenciaCentavos: Value(valorReferenciaCentavos),
        valorEstimado: valorEstimado,
        periodicidadeMeses: periodicidadeMeses,
        parcelasPorCiclo: parcelasPorCiclo,
        ativo: ativo,
        quantidadeCiclosPrevista: Value(quantidadeCiclosPrevista),
        observacao: Value(_opcional(observacao)),
        dataAtualizacao: Value(_agora()),
      ),
    );
  }

  Future<String> _validar({
    required TipoCustoRecorrente? tipo,
    required String descricao,
    required EscopoCustoRecorrente? escopo,
    required int? veiculoId,
    required int? plataformaId,
    required int? valorReferenciaCentavos,
    required int periodicidadeMeses,
    required int parcelasPorCiclo,
    required int? quantidadeCiclosPrevista,
  }) async {
    if (tipo == null) throw Exception('Informe o tipo do custo recorrente.');
    final texto = descricao.trim();
    if (texto.isEmpty) {
      throw Exception('Informe a descrição do custo recorrente.');
    }
    if (valorReferenciaCentavos != null && valorReferenciaCentavos <= 0) {
      throw Exception('O valor de referência deve ser maior que zero.');
    }
    if (periodicidadeMeses <= 0) {
      throw Exception('A periodicidade deve ser maior que zero.');
    }
    if (parcelasPorCiclo < 1) {
      throw Exception('As parcelas por ciclo devem ser pelo menos 1.');
    }
    if (quantidadeCiclosPrevista != null && quantidadeCiclosPrevista <= 0) {
      throw Exception('A quantidade prevista deve ser maior que zero.');
    }
    if (escopo == null) {
      throw Exception('Informe o escopo do custo recorrente.');
    }
    switch (escopo) {
      case EscopoCustoRecorrente.veiculo:
        if (veiculoId == null || !await _repository.veiculoExiste(veiculoId)) {
          throw Exception('Informe um veículo válido.');
        }
        if (plataformaId != null) {
          throw Exception('Um custo do veículo não pode ter Plataforma.');
        }
      case EscopoCustoRecorrente.atividade:
        if (veiculoId != null || plataformaId != null) {
          throw Exception(
            'Um custo da atividade não pertence a veículo ou Plataforma.',
          );
        }
      case EscopoCustoRecorrente.plataforma:
        if (plataformaId == null ||
            !await _repository.plataformaExiste(plataformaId)) {
          throw Exception('Informe uma Plataforma válida.');
        }
        if (veiculoId != null) {
          throw Exception('Um custo da Plataforma não pode ter veículo.');
        }
    }
    return texto;
  }

  String? _opcional(String? valor) {
    final texto = valor?.trim() ?? '';
    return texto.isEmpty ? null : texto;
  }
}
