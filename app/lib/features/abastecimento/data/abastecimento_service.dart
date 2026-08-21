import 'package:drift/drift.dart';
import 'dart:math' as math;

import '../../../core/constants/enums/tipo_combustivel.dart';
import '../../../core/database/app_database.dart';
import '../../jornada/data/jornada_repository.dart';
import 'abastecimento_repository.dart';
import 'resumo_inteligencia_abastecimento.dart';

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
      _repository.buscarUltimoOdometroCronologico(veiculoId);

  Future<Abastecimento?> ultimoAbastecimento(int veiculoId) =>
      _repository.buscarUltimoPorVeiculo(veiculoId);

  Future<List<Abastecimento>> listar(int veiculoId) =>
      _repository.listarPorVeiculo(veiculoId);

  Future<bool> atualizar(Abastecimento abastecimento) =>
      _repository.atualizar(abastecimento);

  Future<int> excluir(int id) => _repository.excluir(id);

  Future<ResumoInteligenciaAbastecimento> calcularInteligencia(
    int veiculoId,
  ) async {
    final abastecimentos = await _repository.listarPorVeiculo(veiculoId);
    final ciclosValidos = _calcularCiclosValidos(abastecimentos);
    final ciclosRecentes = ciclosValidos.length <= 3
        ? ciclosValidos.reversed.toList()
        : ciclosValidos.sublist(ciclosValidos.length - 3).reversed.toList();
    final media = ciclosRecentes.isEmpty
        ? null
        : ciclosRecentes.fold<double>(
                0,
                (total, ciclo) => total + ciclo.kmPorLitro,
              ) /
              ciclosRecentes.length;
    final conservador = ciclosRecentes.isEmpty
        ? null
        : ciclosRecentes.map((ciclo) => ciclo.kmPorLitro).reduce(math.min);
    final capacidadeLida = await _repository.buscarCapacidadeTanque(veiculoId);
    final capacidade = capacidadeLida != null && capacidadeLida > 0
        ? capacidadeLida
        : null;
    final autonomiaMedia = capacidade == null || media == null
        ? null
        : capacidade * media;
    final autonomiaConservadora = capacidade == null || conservador == null
        ? null
        : capacidade * conservador;
    final ultimoOdometro = await _repository.buscarUltimoOdometroCronologico(
      veiculoId,
    );
    final referencia = _calcularReferenciaAbastecimento(
      abastecimentos,
      ciclosRecentes,
    );
    final atingida =
        referencia != null &&
        ultimoOdometro != null &&
        ultimoOdometro >= referencia;
    final diasOperacao =
        referencia == null || ultimoOdometro == null || atingida
        ? null
        : await _calcularDiasOperacaoAteReferencia(
            veiculoId,
            referencia - ultimoOdometro,
          );

    return ResumoInteligenciaAbastecimento(
      ciclosRecentes: ciclosRecentes,
      mediaKmPorLitro: media,
      kmPorLitroConservador: conservador,
      capacidadeTanqueLitros: capacidade,
      autonomiaMediaTanqueCheioKm: autonomiaMedia,
      autonomiaConservadoraTanqueCheioKm: autonomiaConservadora,
      odometroReferenciaAbastecimento: referencia,
      ultimoOdometroConhecido: ultimoOdometro,
      diasOperacaoAteReferencia: diasOperacao,
    );
  }

  List<ResumoCicloAbastecimento> _calcularCiclosValidos(
    List<Abastecimento> abastecimentos,
  ) {
    final ciclos = <ResumoCicloAbastecimento>[];
    var indiceInicio = -1;
    for (var indice = 0; indice < abastecimentos.length; indice++) {
      final abastecimento = abastecimentos[indice];
      if (!abastecimento.tanqueCheio) continue;
      if (indiceInicio >= 0) {
        final trecho = abastecimentos.sublist(indiceInicio, indice + 1);
        final inicio = trecho.first;
        final fim = trecho.last;
        final odometrosCoerentes = <Abastecimento>[...trecho]
          ..sort((a, b) => a.dataHora.compareTo(b.dataHora));
        var progressaoCoerente = true;
        for (var item = 1; item < odometrosCoerentes.length; item++) {
          if (odometrosCoerentes[item].odometro <
              odometrosCoerentes[item - 1].odometro) {
            progressaoCoerente = false;
            break;
          }
        }
        final posteriores = trecho.skip(1).toList();
        final volumesValidos = posteriores.every(
          (item) => item.volumeMililitros > 0,
        );
        final distancia = fim.odometro - inicio.odometro;
        final volume = posteriores.fold<int>(
          0,
          (total, item) => total + item.volumeMililitros,
        );
        final distanciaPrimeiro = posteriores.isEmpty
            ? 0
            : posteriores.first.odometro - inicio.odometro;
        if (progressaoCoerente &&
            volumesValidos &&
            distancia > 0 &&
            volume > 0 &&
            distanciaPrimeiro >= 0) {
          ciclos.add(
            ResumoCicloAbastecimento(
              abastecimentoInicio: inicio,
              abastecimentoFim: fim,
              distanciaKm: distancia,
              volumeConsumidoMililitros: volume,
              kmPorLitro: distancia / (volume / 1000),
              quantidadeParciaisIntermediarios: posteriores
                  .where((item) => !item.tanqueCheio)
                  .length,
              distanciaAtePrimeiroReabastecimentoKm: distanciaPrimeiro,
            ),
          );
        }
      }
      indiceInicio = indice;
    }
    return ciclos;
  }

  int? _calcularReferenciaAbastecimento(
    List<Abastecimento> abastecimentos,
    List<ResumoCicloAbastecimento> ciclosRecentes,
  ) {
    if (ciclosRecentes.length < 2 || abastecimentos.isEmpty) return null;
    final indiceUltimoCheio = abastecimentos.lastIndexWhere(
      (item) => item.tanqueCheio,
    );
    if (indiceUltimoCheio < 0) return null;
    final ultimoCheio = abastecimentos[indiceUltimoCheio];
    final possuiParcialPosterior = abastecimentos
        .skip(indiceUltimoCheio + 1)
        .any((item) => !item.tanqueCheio);
    if (possuiParcialPosterior) return null;
    final distancias = ciclosRecentes
        .map((ciclo) => ciclo.distanciaAtePrimeiroReabastecimentoKm)
        .where((distancia) => distancia > 0)
        .toList();
    if (distancias.length < 2) return null;
    return ultimoCheio.odometro + distancias.reduce(math.min);
  }

  Future<double?> _calcularDiasOperacaoAteReferencia(
    int veiculoId,
    int distanciaKm,
  ) async {
    final jornadas =
        (await _jornadaRepository.listar())
            .where(
              (jornada) =>
                  jornada.veiculoId == veiculoId &&
                  jornada.dataHoraFim != null &&
                  jornada.odometroFim != null &&
                  jornada.odometroFim! >= jornada.odometroInicio,
            )
            .toList()
          ..sort((a, b) => a.dataHoraInicio.compareTo(b.dataHoraInicio));
    final porDia = <DateTime, int>{};
    for (final jornada in jornadas) {
      final dia = DateTime(
        jornada.dataHoraInicio.year,
        jornada.dataHoraInicio.month,
        jornada.dataHoraInicio.day,
      );
      porDia.update(
        dia,
        (total) => total + jornada.odometroFim! - jornada.odometroInicio,
        ifAbsent: () => jornada.odometroFim! - jornada.odometroInicio,
      );
    }
    final dias = porDia.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final recentes = dias.length <= 7 ? dias : dias.sublist(dias.length - 7);
    if (recentes.length < 3) return null;
    final mediaPorDiaOperacional =
        recentes.fold<int>(0, (total, item) => total + item.value) /
        recentes.length;
    if (mediaPorDiaOperacional <= 0) return null;
    return distanciaKm / mediaPorDiaOperacional;
  }

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
