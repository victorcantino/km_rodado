import 'package:drift/drift.dart';

import '../../../core/constants/enums/tipo_combustivel.dart';
import '../../../core/database/app_database.dart';
import '../../jornada/data/jornada_repository.dart';
import 'abastecimento_repository.dart';

class AbastecimentoService {
  final AbastecimentoRepository _repository;
  final JornadaRepository _jornadaRepository;
  final DateTime Function() _agora;

  AbastecimentoService(
    this._repository,
    this._jornadaRepository, {
    DateTime Function()? agora,
  }) : _agora = agora ?? DateTime.now;

  static int calcularTotalCentavos({
    required int volumeMililitros,
    required int precoMilesimosRealPorLitro,
  }) => _dividirArredondando(
    volumeMililitros * precoMilesimosRealPorLitro,
    10000,
  );

  static int calcularVolumeMililitros({
    required int valorTotalCentavos,
    required int precoMilesimosRealPorLitro,
  }) {
    if (precoMilesimosRealPorLitro <= 0) {
      throw ArgumentError('O preço por litro deve ser maior que zero.');
    }
    return _dividirArredondando(
      valorTotalCentavos * 10000,
      precoMilesimosRealPorLitro,
    );
  }

  static int calcularPrecoEfetivoMilesimos({
    required int valorTotalCentavos,
    required int volumeMililitros,
  }) {
    if (volumeMililitros <= 0) {
      throw ArgumentError('O volume deve ser maior que zero.');
    }
    return _dividirArredondando(valorTotalCentavos * 10000, volumeMililitros);
  }

  static int _dividirArredondando(int numerador, int denominador) =>
      (numerador + denominador ~/ 2) ~/ denominador;

  Future<int?> ultimoOdometro(int veiculoId) =>
      _repository.buscarUltimoOdometroOperacional(veiculoId);

  Future<Abastecimento?> ultimoAbastecimento(int veiculoId) =>
      _repository.buscarUltimoPorVeiculo(veiculoId);

  Future<int> registrar({
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
    if (odometro < 0) throw Exception('O odômetro não pode ser negativo.');
    if (volumeMililitros <= 0) {
      throw Exception('O volume deve ser maior que zero.');
    }
    if (valorTotalPagoCentavos < 0) {
      throw Exception('O valor total não pode ser negativo.');
    }
    if (precoBombaMilesimosRealPorLitro != null &&
        precoBombaMilesimosRealPorLitro < 0) {
      throw Exception('O preço da bomba não pode ser negativo.');
    }
    final limites = await _repository.buscarLimitesOdometro(
      veiculoId,
      dataHora,
    );
    if (limites.anterior != null && odometro < limites.anterior!) {
      throw Exception(
        'O odômetro não pode ser menor que o registro anterior a essa data.',
      );
    }
    if (limites.posterior != null && odometro > limites.posterior!) {
      throw Exception(
        'O odômetro não pode ser maior que o registro posterior a essa data.',
      );
    }
    final jornada = await _jornadaRepository.buscarJornadaAberta();
    if (jornada != null && jornada.veiculoId != veiculoId) {
      throw Exception('A Jornada aberta pertence a outro veículo.');
    }
    return _repository.inserir(
      AbastecimentosCompanion.insert(
        veiculoId: veiculoId,
        jornadaId: Value(jornada?.id),
        dataHora: dataHora,
        odometro: odometro,
        tipoCombustivel: tipoCombustivel,
        volumeMililitros: volumeMililitros,
        valorTotalPagoCentavos: valorTotalPagoCentavos,
        precoBombaMilesimosRealPorLitro: Value(precoBombaMilesimosRealPorLitro),
        tanqueCheio: Value(tanqueCheio),
        cidade: Value(_normalizar(cidade)),
        nomePosto: Value(_normalizar(nomePosto)),
        bandeiraPosto: Value(_normalizar(bandeiraPosto)),
        observacao: Value(_normalizar(observacao)),
        dataCriacao: Value(_agora()),
      ),
    );
  }

  String? _normalizar(String? texto) {
    final normalizado = texto?.trim();
    return normalizado == null || normalizado.isEmpty ? null : normalizado;
  }
}
