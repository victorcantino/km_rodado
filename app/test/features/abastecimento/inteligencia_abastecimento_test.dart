import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:km_rodado/core/constants/enums/status_jornada.dart';
import 'package:km_rodado/core/constants/enums/tipo_combustivel.dart';
import 'package:km_rodado/core/database/app_database.dart';
import 'package:km_rodado/core/database/daos/abastecimento_dao.dart';
import 'package:km_rodado/core/database/daos/jornada_dao.dart';
import 'package:km_rodado/core/database/seeds/seed.dart';
import 'package:km_rodado/features/abastecimento/data/abastecimento_repository.dart';
import 'package:km_rodado/features/abastecimento/data/abastecimento_service.dart';
import 'package:km_rodado/features/jornada/data/jornada_repository.dart';
import 'package:km_rodado/features/jornada/presentation/pages/jornada_page.dart';

void main() {
  late AppDatabase database;
  late AbastecimentoService service;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await garantirDadosTemporarios(database);
    service = AbastecimentoService(
      AbastecimentoRepository(AbastecimentoDao(database)),
      JornadaRepository(JornadaDao(database)),
    );
  });

  tearDown(() => database.close());

  Future<int> inserir({
    required int odometro,
    required DateTime dataHora,
    required int volumeMl,
    required bool cheio,
    int veiculoId = 1,
  }) => database
      .into(database.abastecimentos)
      .insert(
        AbastecimentosCompanion.insert(
          veiculoId: veiculoId,
          dataHora: dataHora,
          odometro: odometro,
          tipoCombustivel: TipoCombustivel.gasolina,
          volumeMililitros: volumeMl,
          valorTotalPagoCentavos: 1000,
          tanqueCheio: Value(cheio),
        ),
      );

  Future<void> ciclo(
    int dia,
    int inicio,
    int fim,
    int volumeFimMl, {
    int veiculoId = 1,
  }) async {
    await inserir(
      odometro: inicio,
      dataHora: DateTime(2026, 8, dia, 8),
      volumeMl: 9999,
      cheio: true,
      veiculoId: veiculoId,
    );
    await inserir(
      odometro: fim,
      dataHora: DateTime(2026, 8, dia + 1, 8),
      volumeMl: volumeFimMl,
      cheio: true,
      veiculoId: veiculoId,
    );
  }

  test('cheio a cheio usa distância e somente volume posterior', () async {
    await ciclo(1, 50000, 50300, 40000);

    final resumo = await service.calcularInteligencia(1);
    final cicloCalculado = resumo.ciclosRecentes.single;

    expect(cicloCalculado.distanciaKm, 300);
    expect(cicloCalculado.volumeConsumidoMililitros, 40000);
    expect(cicloCalculado.kmPorLitro, 7.5);
    expect(cicloCalculado.quantidadeParciaisIntermediarios, 0);
    expect(cicloCalculado.potencialmenteMisto, isFalse);
  });

  test('soma múltiplos parciais e marca ciclo potencialmente misto', () async {
    await inserir(
      odometro: 50000,
      dataHora: DateTime(2026, 8, 1, 8),
      volumeMl: 40000,
      cheio: true,
    );
    await inserir(
      odometro: 50100,
      dataHora: DateTime(2026, 8, 1, 12),
      volumeMl: 5000,
      cheio: false,
    );
    await inserir(
      odometro: 50200,
      dataHora: DateTime(2026, 8, 1, 16),
      volumeMl: 5000,
      cheio: false,
    );
    await inserir(
      odometro: 50300,
      dataHora: DateTime(2026, 8, 2, 8),
      volumeMl: 30000,
      cheio: true,
    );

    final calculado = (await service.calcularInteligencia(
      1,
    )).ciclosRecentes.single;
    expect(calculado.volumeConsumidoMililitros, 40000);
    expect(calculado.kmPorLitro, 7.5);
    expect(calculado.quantidadeParciaisIntermediarios, 2);
    expect(calculado.distanciaAtePrimeiroReabastecimentoKm, 100);
    expect(calculado.potencialmenteMisto, isTrue);
  });

  test(
    'ordena por dataHora, ignora ciclo regressivo e separa veículos',
    () async {
      await inserir(
        odometro: 10300,
        dataHora: DateTime(2026, 8, 3),
        volumeMl: 30000,
        cheio: true,
      );
      await inserir(
        odometro: 10000,
        dataHora: DateTime(2026, 8, 1),
        volumeMl: 30000,
        cheio: true,
      );
      await inserir(
        odometro: 10200,
        dataHora: DateTime(2026, 8, 2),
        volumeMl: 20000,
        cheio: true,
      );
      await database
          .into(database.veiculos)
          .insert(
            VeiculosCompanion.insert(
              id: const Value(2),
              usuarioId: 1,
              marca: 'Outra',
              modelo: 'Outro',
              ano: 2026,
            ),
          );
      await ciclo(5, 9000, 9100, 10000, veiculoId: 2);
      await inserir(
        odometro: 10100,
        dataHora: DateTime(2026, 8, 4),
        volumeMl: 10000,
        cheio: true,
      );

      final resumo = await service.calcularInteligencia(1);
      expect(resumo.ciclosRecentes, hasLength(2));
      expect(resumo.ciclosRecentes.map((item) => item.distanciaKm), [100, 200]);
    },
  );

  test(
    'usa até três ciclos recentes na média e o menor como conservador',
    () async {
      await inserir(
        odometro: 1000,
        dataHora: DateTime(2026, 8, 1),
        volumeMl: 10000,
        cheio: true,
      );
      for (final item in [
        (1100, 10000), // 10 km/L, fica fora dos três recentes
        (1220, 10000), // 12 km/L
        (1300, 10000), // 8 km/L
        (1410, 10000), // 11 km/L
      ].indexed) {
        await inserir(
          odometro: item.$2.$1,
          dataHora: DateTime(2026, 8, item.$1 + 2),
          volumeMl: item.$2.$2,
          cheio: true,
        );
      }

      final resumo = await service.calcularInteligencia(1);
      expect(resumo.ciclosRecentes, hasLength(3));
      expect(resumo.mediaKmPorLitro, closeTo((12 + 8 + 11) / 3, 0.0001));
      expect(resumo.kmPorLitroConservador, 8);
    },
  );

  test('um e dois ciclos usam a amostra disponível', () async {
    await ciclo(1, 1000, 1100, 10000);
    var resumo = await service.calcularInteligencia(1);
    expect(resumo.mediaKmPorLitro, 10);
    expect(resumo.ciclosRecentes, hasLength(1));
    expect(resumo.odometroReferenciaAbastecimento, isNull);

    await inserir(
      odometro: 1220,
      dataHora: DateTime(2026, 8, 3),
      volumeMl: 15000,
      cheio: true,
    );
    resumo = await service.calcularInteligencia(1);
    expect(resumo.ciclosRecentes, hasLength(2));
    expect(resumo.mediaKmPorLitro, 9);
    expect(resumo.kmPorLitroConservador, 8);
  });

  test(
    'capacidade do veículo calcula autonomias sem hardcode no serviço',
    () async {
      await (database.update(database.veiculos)..where((v) => v.id.equals(1)))
          .write(const VeiculosCompanion(capacidadeTanque: Value(50)));
      await ciclo(1, 1000, 1100, 10000);

      var resumo = await service.calcularInteligencia(1);
      expect(resumo.capacidadeTanqueLitros, 50);
      expect(resumo.autonomiaMediaTanqueCheioKm, 500);
      expect(resumo.autonomiaConservadoraTanqueCheioKm, 500);

      await (database.update(database.veiculos)..where((v) => v.id.equals(1)))
          .write(const VeiculosCompanion(capacidadeTanque: Value(0)));
      resumo = await service.calcularInteligencia(1);
      expect(resumo.capacidadeTanqueLitros, isNull);
      expect(resumo.autonomiaConservadoraTanqueCheioKm, isNull);
      expect(resumo.mediaKmPorLitro, 10);
    },
  );

  test(
    'referência usa menor distância observada, não autonomia teórica',
    () async {
      await (database.update(database.veiculos)..where((v) => v.id.equals(1)))
          .write(const VeiculosCompanion(capacidadeTanque: Value(100)));
      await inserir(
        odometro: 1000,
        dataHora: DateTime(2026, 8, 1),
        volumeMl: 10000,
        cheio: true,
      );
      await inserir(
        odometro: 1200,
        dataHora: DateTime(2026, 8, 2),
        volumeMl: 20000,
        cheio: true,
      );
      await inserir(
        odometro: 1350,
        dataHora: DateTime(2026, 8, 3),
        volumeMl: 15000,
        cheio: true,
      );

      final resumo = await service.calcularInteligencia(1);
      expect(resumo.autonomiaConservadoraTanqueCheioKm, 1000);
      expect(resumo.odometroReferenciaAbastecimento, 1500);
      expect(resumo.distanciaAteReferenciaKm, 150);
      expect(resumo.referenciaAtingida, isFalse);
    },
  );

  test('parcial após o último cheio omite referência insegura', () async {
    await ciclo(1, 1000, 1100, 10000);
    await inserir(
      odometro: 1200,
      dataHora: DateTime(2026, 8, 3),
      volumeMl: 10000,
      cheio: true,
    );
    await inserir(
      odometro: 1250,
      dataHora: DateTime(2026, 8, 4),
      volumeMl: 5000,
      cheio: false,
    );

    final resumo = await service.calcularInteligencia(1);
    expect(resumo.mediaKmPorLitro, isNotNull);
    expect(resumo.odometroReferenciaAbastecimento, isNull);
    expect(resumo.distanciaAteReferenciaKm, isNull);
  });

  Future<void> prepararReferencia({required int odometroAtual}) async {
    await inserir(
      odometro: 1000,
      dataHora: DateTime(2026, 8, 1),
      volumeMl: 10000,
      cheio: true,
    );
    await inserir(
      odometro: 1100,
      dataHora: DateTime(2026, 8, 2),
      volumeMl: 10000,
      cheio: true,
    );
    await inserir(
      odometro: 1200,
      dataHora: DateTime(2026, 8, 3),
      volumeMl: 10000,
      cheio: true,
    );
    await database
        .into(database.jornadas)
        .insert(
          JornadasCompanion.insert(
            usuarioId: 1,
            veiculoId: 1,
            dataHoraInicio: DateTime(2026, 8, 4, 8),
            dataHoraFim: Value(DateTime(2026, 8, 4, 18)),
            odometroInicio: 1200,
            odometroFim: Value(odometroAtual),
            cidadeOrigem: 'Curitiba',
            status: StatusJornada.finalizada,
          ),
        );
  }

  test(
    'odômetro abaixo da referência informa distância comportamental',
    () async {
      await prepararReferencia(odometroAtual: 1250);
      final resumo = await service.calcularInteligencia(1);
      expect(resumo.odometroReferenciaAbastecimento, 1300);
      expect(resumo.referenciaAtingida, isFalse);
      expect(resumo.distanciaAteReferenciaKm, 50);
    },
  );

  test('odômetro exatamente na referência marca estado atingido', () async {
    await prepararReferencia(odometroAtual: 1300);
    final resumo = await service.calcularInteligencia(1);
    expect(resumo.referenciaAtingida, isTrue);
    expect(resumo.distanciaAteReferenciaKm, isNull);
    expect(resumo.diasOperacaoAteReferencia, isNull);
  });

  test('odômetro acima da referência não simula tanque vazio', () async {
    await prepararReferencia(odometroAtual: 1320);
    final resumo = await service.calcularInteligencia(1);
    expect(resumo.referenciaAtingida, isTrue);
    expect(resumo.odometroReferenciaAbastecimento, 1300);
    expect(resumo.distanciaAteReferenciaKm, isNull);
    expect(resumo.diasOperacaoAteReferencia, isNull);
  });

  testWidgets('interface distingue referência atingida de tanque vazio', (
    tester,
  ) async {
    await prepararReferencia(odometroAtual: 1320);
    final resumo = await service.calcularInteligencia(1);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ResumoInteligenciaAbastecimentoCard(
            resumo: resumo,
            locale: 'pt_BR',
          ),
        ),
      ),
    );

    expect(find.text('Referência para abastecer'), findsOneWidget);
    expect(find.text('Atingida · ~1.300 km'), findsOneWidget);
    expect(find.textContaining('tanque vazio'), findsNothing);
    expect(find.textContaining('dias de operação'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  test('estima dias de operação, mas não cria data de calendário', () async {
    await inserir(
      odometro: 1000,
      dataHora: DateTime(2026, 8, 1),
      volumeMl: 10000,
      cheio: true,
    );
    await inserir(
      odometro: 1200,
      dataHora: DateTime(2026, 8, 2),
      volumeMl: 20000,
      cheio: true,
    );
    await inserir(
      odometro: 1400,
      dataHora: DateTime(2026, 8, 3),
      volumeMl: 20000,
      cheio: true,
    );
    for (var dia = 4; dia <= 6; dia++) {
      await database
          .into(database.jornadas)
          .insert(
            JornadasCompanion.insert(
              usuarioId: 1,
              veiculoId: 1,
              dataHoraInicio: DateTime(2026, 8, dia, 8),
              dataHoraFim: Value(DateTime(2026, 8, dia, 18)),
              odometroInicio: 1400 + (dia - 4) * 50,
              odometroFim: Value(1450 + (dia - 4) * 50),
              cidadeOrigem: 'Curitiba',
              status: StatusJornada.finalizada,
            ),
          );
    }

    final resumo = await service.calcularInteligencia(1);
    expect(resumo.odometroReferenciaAbastecimento, 1600);
    expect(resumo.ultimoOdometroConhecido, 1550);
    expect(resumo.diasOperacaoAteReferencia, 1);
  });

  test('menos de três dias operacionais não inventa previsão', () async {
    await prepararReferencia(odometroAtual: 1250);
    final resumo = await service.calcularInteligencia(1);
    expect(resumo.diasOperacaoAteReferencia, isNull);
  });

  test('recriar service recalcula sem persistir indicadores', () async {
    await ciclo(1, 1000, 1100, 10000);
    final primeiro = await service.calcularInteligencia(1);
    final novo = AbastecimentoService(
      AbastecimentoRepository(AbastecimentoDao(database)),
      JornadaRepository(JornadaDao(database)),
    );
    final segundo = await novo.calcularInteligencia(1);

    expect(segundo.mediaKmPorLitro, primeiro.mediaKmPorLitro);
    expect(await database.select(database.abastecimentos).get(), hasLength(2));
  });
}
