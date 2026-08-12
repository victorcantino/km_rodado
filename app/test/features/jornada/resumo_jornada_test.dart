import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:km_rodado/core/constants/enums/status_jornada.dart';
import 'package:km_rodado/core/constants/enums/tipo_leitura_ganhos.dart';
import 'package:km_rodado/core/constants/enums/tipo_registro_ganhos.dart';
import 'package:km_rodado/core/database/app_database.dart';
import 'package:km_rodado/core/database/daos/jornada_dao.dart';
import 'package:km_rodado/core/database/daos/ganho_individual_dao.dart';
import 'package:km_rodado/core/database/daos/leitura_ganhos_dao.dart';
import 'package:km_rodado/core/database/daos/pausa_dao.dart';
import 'package:km_rodado/core/database/seeds/seed.dart';
import 'package:km_rodado/features/jornada/data/jornada_repository.dart';
import 'package:km_rodado/features/ganho_individual/data/ganho_individual_repository.dart';
import 'package:km_rodado/features/jornada/data/jornada_service.dart';
import 'package:km_rodado/features/leitura_ganhos/data/leitura_ganhos_repository.dart';
import 'package:km_rodado/features/pausa/data/pausa_repository.dart';

void main() {
  late AppDatabase database;
  late JornadaRepository jornadaRepository;
  late PausaRepository pausaRepository;
  late LeituraGanhosRepository leituraRepository;
  late GanhoIndividualRepository ganhoIndividualRepository;
  late JornadaService service;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await garantirDadosTemporarios(database);
    jornadaRepository = JornadaRepository(JornadaDao(database));
    pausaRepository = PausaRepository(PausaDao(database));
    leituraRepository = LeituraGanhosRepository(LeituraGanhosDao(database));
    ganhoIndividualRepository = GanhoIndividualRepository(
      GanhoIndividualDao(database),
    );
    service = JornadaService(
      jornadaRepository,
      pausaRepository,
      leituraRepository,
      ganhoIndividualRepository,
    );
  });

  tearDown(() => database.close());

  Future<int> inserirJornada({
    DateTime? inicio,
    DateTime? fim,
    int odometroInicio = 1000,
    int odometroFim = 1187,
  }) {
    return database
        .into(database.jornadas)
        .insert(
          JornadasCompanion.insert(
            usuarioId: 1,
            veiculoId: 1,
            dataHoraInicio: inicio ?? DateTime(2026, 8, 10, 8),
            dataHoraFim: Value(fim ?? DateTime(2026, 8, 10, 16, 6)),
            odometroInicio: odometroInicio,
            odometroFim: Value(odometroFim),
            cidadeOrigem: 'Curitiba',
            cidadeDestino: const Value('Curitiba'),
            status: StatusJornada.finalizada,
            quilometrosPercorridos: Value(odometroFim - odometroInicio),
          ),
        );
  }

  Future<int> inserirPlataforma(String nome) {
    return database
        .into(database.plataformas)
        .insert(
          PlataformasCompanion.insert(
            nome: nome,
            tipoRegistroGanhos: TipoRegistroGanhos.acumulado,
          ),
        );
  }

  Future<void> inserirPausa(
    int jornadaId, {
    required DateTime inicio,
    required DateTime fim,
    int? odometroInicio,
    int? odometroFim,
  }) async {
    await database
        .into(database.pausas)
        .insert(
          PausasCompanion.insert(
            jornadaId: jornadaId,
            inicio: inicio,
            fim: Value(fim),
            odometroInicio: Value(odometroInicio),
            odometroFim: Value(odometroFim),
          ),
        );
  }

  Future<void> inserirLeitura(
    int jornadaId,
    TipoLeituraGanhos tipo,
    DateTime dataHora,
    Map<int, (int, int)> valores,
  ) async {
    final leituraId = await database
        .into(database.leiturasGanhos)
        .insert(
          LeiturasGanhosCompanion.insert(
            jornadaId: jornadaId,
            dataHora: dataHora,
            tipo: tipo,
          ),
        );
    for (final entrada in valores.entries) {
      await database
          .into(database.leiturasGanhoPlataforma)
          .insert(
            LeiturasGanhoPlataformaCompanion.insert(
              leituraGanhosId: leituraId,
              plataformaId: entrada.key,
              valorAcumuladoCentavos: entrada.value.$1,
              quantidadeViagensAcumulada: entrada.value.$2,
            ),
          );
    }
  }

  test('calcula resumo completo com múltiplas Pausas e plataformas', () async {
    final jornadaId = await inserirJornada();
    final uberId = await inserirPlataforma('Uber');
    final noventaNoveId = await inserirPlataforma('99');
    await inserirPausa(
      jornadaId,
      inicio: DateTime(2026, 8, 10, 10),
      fim: DateTime(2026, 8, 10, 10, 30),
      odometroInicio: 1040,
      odometroFim: 1040,
    );
    await inserirPausa(
      jornadaId,
      inicio: DateTime(2026, 8, 10, 12),
      fim: DateTime(2026, 8, 10, 12, 42),
      odometroInicio: 1080,
      odometroFim: 1085,
    );
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.inicial,
      DateTime(2026, 8, 10, 8, 1),
      {uberId: (10000, 10), noventaNoveId: (5000, 4)},
    );
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.parcial,
      DateTime(2026, 8, 10, 12, 5),
      {uberId: (18000, 15), noventaNoveId: (8000, 6)},
    );
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.finalDaJornada,
      DateTime(2026, 8, 10, 16, 5),
      {uberId: (26840, 21), noventaNoveId: (13030, 11)},
    );

    final resumo = await service.resumoUltimaJornada();

    expect(resumo, isNotNull);
    expect(resumo!.duracaoTotal, const Duration(hours: 8, minutes: 6));
    expect(resumo.tempoPausa, const Duration(hours: 1, minutes: 12));
    expect(resumo.tempoAtivo, const Duration(hours: 6, minutes: 54));
    expect(resumo.quilometrosTotal, 187);
    expect(resumo.quilometrosEmPausa, 5);
    expect(resumo.quilometrosAtivos, 182);
    expect(resumo.receitaTotalCentavos, 24870);
    expect(resumo.quantidadeTotalViagens, 18);
    expect(resumo.receitaPorHoraAtiva, closeTo(36.043, 0.001));
    expect(resumo.receitaPorKmAtivo, closeTo(1.366, 0.001));
    expect(resumo.ticketMedioGeral, closeTo(13.816, 0.001));
    final uber = resumo.resultadosPlataformas.singleWhere(
      (resultado) => resultado.nome == 'Uber',
    );
    expect(uber.receitaCentavos, 16840);
    expect(uber.quantidadeViagens, 11);
    expect(uber.ticketMedio, closeTo(15.309, 0.001));
  });

  test('sem Pausas aceita receita, viagens e quilômetros zero', () async {
    final jornadaId = await inserirJornada(
      fim: DateTime(2026, 8, 10, 8),
      odometroFim: 1000,
    );
    final uberId = await inserirPlataforma('Uber');
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.inicial,
      DateTime(2026, 8, 10, 8),
      {uberId: (0, 0)},
    );
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.finalDaJornada,
      DateTime(2026, 8, 10, 8, 1),
      {uberId: (0, 0)},
    );

    final resumo = (await service.resumoUltimaJornada())!;

    expect(resumo.tempoPausa, Duration.zero);
    expect(resumo.tempoAtivo, Duration.zero);
    expect(resumo.quilometrosEmPausa, 0);
    expect(resumo.quilometrosAtivos, 0);
    expect(resumo.receitaTotalCentavos, 0);
    expect(resumo.quantidadeTotalViagens, 0);
    expect(resumo.receitaPorHoraAtiva, isNull);
    expect(resumo.receitaPorKmAtivo, isNull);
    expect(resumo.ticketMedioGeral, isNull);
    expect(resumo.resultadosPlataformas.single.ticketMedio, isNull);
  });

  test('uma Pausa sem deslocamento não reduz os quilômetros ativos', () async {
    final jornadaId = await inserirJornada();
    final uberId = await inserirPlataforma('Uber');
    await inserirPausa(
      jornadaId,
      inicio: DateTime(2026, 8, 10, 12),
      fim: DateTime(2026, 8, 10, 12, 46),
      odometroInicio: 1080,
      odometroFim: 1080,
    );
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.inicial,
      DateTime(2026, 8, 10, 8),
      {uberId: (1000, 1)},
    );
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.finalDaJornada,
      DateTime(2026, 8, 10, 16),
      {uberId: (2000, 2)},
    );

    final resumo = (await service.resumoUltimaJornada())!;

    expect(resumo.tempoPausa, const Duration(minutes: 46));
    expect(resumo.quilometrosEmPausa, 0);
    expect(resumo.quilometrosAtivos, 187);
  });

  test(
    'Pausa histórica sem odômetro deixa distância ativa incompleta',
    () async {
      final jornadaId = await inserirJornada();
      final uberId = await inserirPlataforma('Uber');
      await inserirPausa(
        jornadaId,
        inicio: DateTime(2026, 8, 10, 12),
        fim: DateTime(2026, 8, 10, 12, 46),
      );
      await inserirLeitura(
        jornadaId,
        TipoLeituraGanhos.inicial,
        DateTime(2026, 8, 10, 8),
        {uberId: (1000, 1)},
      );
      await inserirLeitura(
        jornadaId,
        TipoLeituraGanhos.finalDaJornada,
        DateTime(2026, 8, 10, 16),
        {uberId: (2000, 2)},
      );

      final resumo = (await service.resumoUltimaJornada())!;

      expect(resumo.quilometrosTotal, 187);
      expect(resumo.quilometrosEmPausa, isNull);
      expect(resumo.quilometrosAtivos, isNull);
      expect(resumo.receitaPorKmAtivo, isNull);
    },
  );

  test('detecta regressões e ignora parcial anterior à inicial', () async {
    final jornadaId = await inserirJornada();
    final uberId = await inserirPlataforma('Uber');
    final noventaNoveId = await inserirPlataforma('99');
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.parcial,
      DateTime(2026, 8, 10, 7, 50),
      {uberId: (99999, 99), noventaNoveId: (99999, 99)},
    );
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.inicial,
      DateTime(2026, 8, 10, 8),
      {uberId: (10000, 10), noventaNoveId: (5000, 5)},
    );
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.parcial,
      DateTime(2026, 8, 10, 12),
      {uberId: (9000, 12), noventaNoveId: (7000, 4)},
    );
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.finalDaJornada,
      DateTime(2026, 8, 10, 16),
      {uberId: (15000, 15), noventaNoveId: (9000, 9)},
    );

    final resumo = (await service.resumoUltimaJornada())!;

    expect(resumo.resultadosPlataformas, hasLength(2));
    expect(resumo.resultadosPlataformas.every((r) => !r.calculavel), isTrue);
    expect(
      resumo.resultadosPlataformas.every((r) => r.ticketMedio == null),
      isTrue,
    );
    expect(resumo.receitaTotalCentavos, isNull);
    expect(resumo.quantidadeTotalViagens, isNull);
    expect(resumo.receitaPorHoraAtiva, isNull);
    expect(resumo.ticketMedioGeral, isNull);
  });

  test('recalcula resultado ao recriar repositories e service', () async {
    final jornadaId = await inserirJornada();
    final uberId = await inserirPlataforma('Uber');
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.inicial,
      DateTime(2026, 8, 10, 8),
      {uberId: (1000, 1)},
    );
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.finalDaJornada,
      DateTime(2026, 8, 10, 16),
      {uberId: (3500, 4)},
    );

    final novoService = JornadaService(
      JornadaRepository(JornadaDao(database)),
      PausaRepository(PausaDao(database)),
      LeituraGanhosRepository(LeituraGanhosDao(database)),
      GanhoIndividualRepository(GanhoIndividualDao(database)),
    );
    final resumo = (await novoService.resumoUltimaJornada())!;

    expect(resumo.receitaTotalCentavos, 2500);
    expect(resumo.quantidadeTotalViagens, 3);
  });

  test('inclui lançamentos individuais nos totais e indicadores', () async {
    final jornadaId = await inserirJornada(
      inicio: DateTime(2026, 8, 10, 8),
      fim: DateTime(2026, 8, 10, 10),
      odometroInicio: 100,
      odometroFim: 200,
    );
    final uberId = await inserirPlataforma('Uber');
    final particularId = await database
        .into(database.plataformas)
        .insert(
          PlataformasCompanion.insert(
            nome: 'Particular',
            tipoRegistroGanhos: TipoRegistroGanhos.individual,
          ),
        );
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.inicial,
      DateTime(2026, 8, 10, 8),
      {uberId: (1000, 1)},
    );
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.finalDaJornada,
      DateTime(2026, 8, 10, 10),
      {uberId: (5000, 3)},
    );
    await database
        .into(database.lancamentosGanhoIndividual)
        .insert(
          LancamentosGanhoIndividualCompanion.insert(
            plataformaId: particularId,
            jornadaId: Value(jornadaId),
            quantidadeViagens: 3,
            valorTotalCentavos: 12500,
          ),
        );

    final resumo = (await service.resumoUltimaJornada())!;
    final particular = resumo.resultadosPlataformas.singleWhere(
      (resultado) => resultado.nome == 'Particular',
    );

    expect(particular.receitaCentavos, 12500);
    expect(particular.quantidadeViagens, 3);
    expect(particular.ticketMedio, closeTo(41.666, 0.001));
    expect(resumo.receitaTotalCentavos, 16500);
    expect(resumo.quantidadeTotalViagens, 5);
    expect(resumo.ticketMedioGeral, 33);
    expect(resumo.receitaPorHoraAtiva, 82.5);
    expect(resumo.receitaPorKmAtivo, 1.65);
  });
}
