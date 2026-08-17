import 'package:drift/drift.dart';

import '../../../core/constants/enums/fonte_referencia_depreciacao.dart';
import '../../../core/constants/enums/metodo_depreciacao.dart';
import '../../../core/database/app_database.dart';
import 'depreciacao_veiculo_repository.dart';
import 'resultado_depreciacao.dart';

class DepreciacaoVeiculoService {
  final DepreciacaoVeiculoRepository _repository;
  final DateTime Function() _agora;

  DepreciacaoVeiculoService(this._repository, {DateTime Function()? agora})
    : _agora = agora ?? DateTime.now;

  Future<DepreciacaoVeiculo?> buscar(int veiculoId) =>
      _repository.buscarPorVeiculo(veiculoId);
  Future<int?> ultimoOdometro(int veiculoId) =>
      _repository.ultimoOdometro(veiculoId);

  ResultadoDepreciacao calcularObservada(DepreciacaoVeiculo? dados) =>
      _calcular(
        metodo: MetodoDepreciacao.observada,
        valorInicial: dados?.valorAquisicaoCentavos,
        valorFinal: dados?.valorReferenciaCentavos,
        odometroInicial: dados?.odometroAquisicao,
        odometroFinal: dados?.odometroReferencia,
        estimado:
            (dados?.valorAquisicaoEstimado ?? false) ||
            (dados?.valorReferenciaEstimado ?? false),
        motivoValor: 'Informe o valor atual de referência.',
        motivoOdometro: 'Informe o odômetro da avaliação.',
        motivoSemPerda:
            'Não há perda nominal de valor observada com os dados informados.',
      );

  ResultadoDepreciacao calcularProjetada(DepreciacaoVeiculo? dados) =>
      _calcular(
        metodo: MetodoDepreciacao.projetada,
        valorInicial: dados?.valorAquisicaoCentavos,
        valorFinal: dados?.valorVendaProjetadoCentavos,
        odometroInicial: dados?.odometroAquisicao,
        odometroFinal: dados?.odometroVendaProjetado,
        estimado:
            (dados?.valorAquisicaoEstimado ?? false) ||
            (dados?.valorVendaProjetadoEstimado ?? false),
        motivoValor: 'Informe o valor esperado na venda.',
        motivoOdometro: 'Informe o odômetro esperado na venda.',
        motivoSemPerda:
            'Não há perda projetada positiva com os dados informados.',
      );

  ResultadoDepreciacao? resultadoSelecionado(DepreciacaoVeiculo? dados) {
    final metodo = dados?.metodoSelecionado;
    if (metodo == null) return null;
    final resultado = metodo == MetodoDepreciacao.observada
        ? calcularObservada(dados)
        : calcularProjetada(dados);
    return resultado.disponivel ? resultado : null;
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
    if (!await _repository.veiculoExiste(veiculoId)) {
      throw Exception('O veículo não foi encontrado.');
    }
    for (final valor in [
      valorAquisicaoCentavos,
      valorReferenciaCentavos,
      valorVendaProjetadoCentavos,
    ]) {
      if (valor != null && valor <= 0) {
        throw Exception('Valores informados devem ser maiores que zero.');
      }
    }
    for (final odometro in [
      odometroAquisicao,
      odometroReferencia,
      odometroVendaProjetado,
    ]) {
      if (odometro != null && odometro < 0) {
        throw Exception('Odômetros não podem ser negativos.');
      }
    }
    if (dataReferencia != null && dataReferencia.isAfter(_agora())) {
      throw Exception('A data da referência não pode estar no futuro.');
    }

    final agora = _agora();
    final existente = await _repository.buscarPorVeiculo(veiculoId);
    var dados = DepreciacaoVeiculo(
      id: existente?.id ?? 0,
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
      dataCriacao: existente?.dataCriacao ?? agora,
      dataAtualizacao: existente == null ? null : agora,
    );
    if (metodoSelecionado != null && resultadoSelecionado(dados) == null) {
      dados = dados.copyWith(metodoSelecionado: const Value(null));
    }
    if (existente == null) {
      await _repository.inserir(
        DepreciacoesVeiculoCompanion.insert(
          veiculoId: veiculoId,
          metodoSelecionado: Value(dados.metodoSelecionado),
          valorAquisicaoCentavos: Value(valorAquisicaoCentavos),
          valorAquisicaoEstimado: Value(valorAquisicaoEstimado),
          odometroAquisicao: Value(odometroAquisicao),
          valorReferenciaCentavos: Value(valorReferenciaCentavos),
          valorReferenciaEstimado: Value(valorReferenciaEstimado),
          fonteReferencia: Value(fonteReferencia),
          dataReferencia: Value(dataReferencia),
          odometroReferencia: Value(odometroReferencia),
          valorVendaProjetadoCentavos: Value(valorVendaProjetadoCentavos),
          valorVendaProjetadoEstimado: Value(valorVendaProjetadoEstimado),
          odometroVendaProjetado: Value(odometroVendaProjetado),
          dataCriacao: Value(agora),
        ),
      );
    } else {
      await _repository.atualizar(dados);
    }
  }

  ResultadoDepreciacao _calcular({
    required MetodoDepreciacao metodo,
    required int? valorInicial,
    required int? valorFinal,
    required int? odometroInicial,
    required int? odometroFinal,
    required bool estimado,
    required String motivoValor,
    required String motivoOdometro,
    required String motivoSemPerda,
  }) {
    String? motivo;
    if (valorInicial == null) {
      motivo = 'Informe o valor do veículo na aquisição.';
    } else if (odometroInicial == null) {
      motivo = 'Informe o odômetro na aquisição.';
    } else if (valorFinal == null) {
      motivo = motivoValor;
    } else if (odometroFinal == null) {
      motivo = motivoOdometro;
    } else if (odometroFinal <= odometroInicial) {
      motivo = 'O odômetro final deve ser maior que o da aquisição.';
    } else if (valorFinal >= valorInicial) {
      motivo = motivoSemPerda;
    }
    final perda = motivo == null ? valorInicial! - valorFinal! : null;
    final distancia = motivo == null ? odometroFinal! - odometroInicial! : null;
    return ResultadoDepreciacao(
      metodo: metodo,
      disponivel: motivo == null,
      valorPorKm: motivo == null ? perda! / distancia! / 100 : null,
      estimado: estimado,
      motivoIndisponibilidade: motivo,
      valorInicialCentavos: valorInicial,
      valorFinalCentavos: valorFinal,
      perdaCentavos: perda,
      odometroInicial: odometroInicial,
      odometroFinal: odometroFinal,
      distanciaKm: distancia,
    );
  }
}
