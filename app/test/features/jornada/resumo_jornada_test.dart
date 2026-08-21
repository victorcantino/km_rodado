import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:km_rodado/core/constants/enums/status_jornada.dart';
import 'package:km_rodado/core/constants/enums/tipo_leitura_ganhos.dart';
import 'package:km_rodado/core/constants/enums/tipo_registro_ganhos.dart';
import 'package:km_rodado/core/constants/enums/tipo_bonus_promocao.dart';
import 'package:km_rodado/core/database/app_database.dart';
import 'package:km_rodado/core/database/daos/jornada_dao.dart';
import 'package:km_rodado/core/database/daos/ganho_individual_dao.dart';
import 'package:km_rodado/core/database/daos/leitura_ganhos_dao.dart';
import 'package:km_rodado/core/database/daos/pausa_dao.dart';
import 'package:km_rodado/core/database/daos/passe_plataforma_dao.dart';
import 'package:km_rodado/core/database/daos/bonus_promocao_dao.dart';
import 'package:km_rodado/core/database/seeds/seed.dart';
import 'package:km_rodado/features/jornada/data/jornada_repository.dart';
import 'package:km_rodado/features/ganho_individual/data/ganho_individual_repository.dart';
import 'package:km_rodado/features/ganho_individual/data/ganho_individual_service.dart';
import 'package:km_rodado/features/jornada/data/jornada_service.dart';
import 'package:km_rodado/features/leitura_ganhos/data/leitura_ganhos_repository.dart';
import 'package:km_rodado/features/pausa/data/pausa_repository.dart';
import 'package:km_rodado/features/passe_plataforma/data/passe_plataforma_repository.dart';
import 'package:km_rodado/features/bonus_promocao/data/bonus_promocao_repository.dart';

void main() {
  late AppDatabase database;
  late JornadaRepository jornadaRepository;
  late PausaRepository pausaRepository;
  late LeituraGanhosRepository leituraRepository;
  late GanhoIndividualRepository ganhoIndividualRepository;
  late PassePlataformaRepository passeRepository;
  late BonusPromocaoRepository bonusRepository;
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
    passeRepository = PassePlataformaRepository(PassePlataformaDao(database));
    bonusRepository = BonusPromocaoRepository(BonusPromocaoDao(database));
    service = JornadaService(
      jornadaRepository,
      pausaRepository,
      leituraRepository,
      ganhoIndividualRepository,
      passeRepository,
      bonusRepository,
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
    Map<int, (int, int)> valores, {
    int? pausaId,
  }) async {
    final leituraId = await database
        .into(database.leiturasGanhos)
        .insert(
          LeiturasGanhosCompanion.insert(
            jornadaId: jornadaId,
            pausaId: Value(pausaId),
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

  Future<int> inserirBonus(
    int jornadaId,
    int plataformaId,
    DateTime dataHora,
    int valor, {
    TipoBonusPromocao tipo = TipoBonusPromocao.bonus,
  }) => database
      .into(database.bonusPromocoes)
      .insert(
        BonusPromocoesCompanion.insert(
          plataformaId: plataformaId,
          jornadaId: Value(jornadaId),
          dataHora: dataHora,
          valorCentavos: valor,
          tipo: tipo,
        ),
      );

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
      DateTime(2026, 8, 10, 8),
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

  test(
    'intraday acumula desde o início na referência do último checkpoint',
    () async {
      final jornadaId = await database
          .into(database.jornadas)
          .insert(
            JornadasCompanion.insert(
              usuarioId: 1,
              veiculoId: 1,
              dataHoraInicio: DateTime(2026, 8, 10, 7),
              odometroInicio: 1000,
              cidadeOrigem: 'Curitiba',
              status: StatusJornada.aberta,
            ),
          );
      final uberId = await inserirPlataforma('Uber');
      await inserirLeitura(
        jornadaId,
        TipoLeituraGanhos.inicial,
        DateTime(2026, 8, 10, 7),
        {uberId: (0, 0)},
      );
      final pausa1 = await database
          .into(database.pausas)
          .insert(
            PausasCompanion.insert(
              jornadaId: jornadaId,
              inicio: DateTime(2026, 8, 10, 9),
              fim: Value(DateTime(2026, 8, 10, 9, 30)),
              odometroInicio: const Value(1030),
              odometroFim: const Value(1030),
            ),
          );
      await inserirLeitura(
        jornadaId,
        TipoLeituraGanhos.parcial,
        DateTime(2026, 8, 10, 12),
        {uberId: (5000, 4)},
        pausaId: pausa1,
      );
      final pausaAberta = await database
          .into(database.pausas)
          .insert(
            PausasCompanion.insert(
              jornadaId: jornadaId,
              inicio: DateTime(2026, 8, 10, 13, 30),
              odometroInicio: const Value(1080),
            ),
          );
      await inserirLeitura(
        jornadaId,
        TipoLeituraGanhos.parcial,
        DateTime(2026, 8, 10, 14),
        {uberId: (8000, 7)},
        pausaId: pausaAberta,
      );
      await database
          .into(database.pausas)
          .insert(
            PausasCompanion.insert(
              jornadaId: jornadaId,
              inicio: DateTime(2026, 8, 10, 15),
              fim: Value(DateTime(2026, 8, 10, 16)),
            ),
          );

      final resumo = (await service.resumoJornadaAberta())!;
      final snapshots = await leituraRepository.listarSnapshotsDaJornada(
        jornadaId,
      );

      expect(resumo.dataHoraReferencia, DateTime(2026, 8, 10, 14));
      expect(resumo.duracaoTotal, const Duration(hours: 7));
      expect(resumo.tempoPausa, const Duration(hours: 1));
      expect(resumo.tempoAtivo, const Duration(hours: 6));
      expect(resumo.quilometros, 80);
      expect(resumo.receitaTotalCentavos, 8000);
      expect(resumo.quantidadeTotalViagens, 7);
      expect(resumo.ticketMedio, closeTo(11.428, 0.001));
      expect(resumo.receitaPorHoraAtiva, closeTo(13.333, 0.001));
      expect(resumo.receitaPorKm, 1);
      expect(snapshots.map((item) => item.leitura.id).toSet(), hasLength(3));
      expect(
        snapshots.last.item.valorAcumuladoCentavos -
            snapshots[1].item.valorAcumuladoCentavos,
        3000,
      );
    },
  );

  test('intraday inicial aceita baseline zerado e distância zero', () async {
    final jornadaId = await database
        .into(database.jornadas)
        .insert(
          JornadasCompanion.insert(
            usuarioId: 1,
            veiculoId: 1,
            dataHoraInicio: DateTime(2026, 8, 10, 7),
            odometroInicio: 1000,
            cidadeOrigem: 'Curitiba',
            status: StatusJornada.aberta,
          ),
        );
    final plataformaId = await inserirPlataforma('Uber');
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.inicial,
      DateTime(2026, 8, 10, 7),
      {plataformaId: (0, 0)},
    );

    final resumo = (await service.resumoJornadaAberta())!;

    expect(resumo.duracaoTotal, Duration.zero);
    expect(resumo.tempoPausa, Duration.zero);
    expect(resumo.tempoAtivo, Duration.zero);
    expect(resumo.quilometros, 0);
    expect(resumo.receitaTotalCentavos, 0);
    expect(resumo.quantidadeTotalViagens, 0);
    expect(resumo.ticketMedio, isNull);
    expect(resumo.receitaPorHoraAtiva, isNull);
    expect(resumo.receitaPorKm, isNull);
  });

  test('intraday preserva finanças sem odômetro seguro', () async {
    final jornadaId = await database
        .into(database.jornadas)
        .insert(
          JornadasCompanion.insert(
            usuarioId: 1,
            veiculoId: 1,
            dataHoraInicio: DateTime(2026, 8, 10, 7),
            odometroInicio: 1000,
            cidadeOrigem: 'Curitiba',
            status: StatusJornada.aberta,
          ),
        );
    final plataformaId = await inserirPlataforma('Uber');
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.inicial,
      DateTime(2026, 8, 10, 7),
      {plataformaId: (0, 0)},
    );
    final pausaId = await database
        .into(database.pausas)
        .insert(
          PausasCompanion.insert(
            jornadaId: jornadaId,
            inicio: DateTime(2026, 8, 10, 12),
          ),
        );
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.parcial,
      DateTime(2026, 8, 10, 12),
      {plataformaId: (5000, 4)},
      pausaId: pausaId,
    );

    final resumo = (await service.resumoJornadaAberta())!;

    expect(resumo.receitaTotalCentavos, 5000);
    expect(resumo.quantidadeTotalViagens, 4);
    expect(resumo.quilometros, isNull);
    expect(resumo.receitaPorKm, isNull);
  });

  test(
    'intraday filtra fatos posteriores e reconcilia 99, Uber e bônus',
    () async {
      final jornadaId = await database
          .into(database.jornadas)
          .insert(
            JornadasCompanion.insert(
              usuarioId: 1,
              veiculoId: 1,
              dataHoraInicio: DateTime(2026, 8, 10, 7),
              odometroInicio: 1000,
              cidadeOrigem: 'Curitiba',
              status: StatusJornada.aberta,
            ),
          );
      final noventaNoveId = await inserirPlataforma('99');
      final uberId = await inserirPlataforma('Uber');
      await inserirLeitura(
        jornadaId,
        TipoLeituraGanhos.inicial,
        DateTime(2026, 8, 10, 7),
        {noventaNoveId: (0, 0), uberId: (0, 0)},
      );
      final pausaId = await database
          .into(database.pausas)
          .insert(
            PausasCompanion.insert(
              jornadaId: jornadaId,
              inicio: DateTime(2026, 8, 10, 12),
              odometroInicio: const Value(1050),
            ),
          );
      await inserirLeitura(
        jornadaId,
        TipoLeituraGanhos.parcial,
        DateTime(2026, 8, 10, 12),
        {noventaNoveId: (5000, 5), uberId: (5000, 5)},
        pausaId: pausaId,
      );
      for (final plataformaId in [noventaNoveId, uberId]) {
        await database
            .into(database.passesPlataforma)
            .insert(
              PassesPlataformaCompanion.insert(
                plataformaId: plataformaId,
                jornadaId: Value(jornadaId),
                dataHora: DateTime(2026, 8, 10, 10),
                valorPagoCentavos: 2000,
              ),
            );
      }
      await inserirBonus(jornadaId, uberId, DateTime(2026, 8, 10, 11), 1000);
      await inserirBonus(jornadaId, uberId, DateTime(2026, 8, 10, 13), 9000);

      final resumo = (await service.resumoJornadaAberta())!;
      final noventaNove = resumo.resultadosPlataformas.singleWhere(
        (item) => item.nome == '99',
      );
      final uber = resumo.resultadosPlataformas.singleWhere(
        (item) => item.nome == 'Uber',
      );

      expect(noventaNove.receitaCentavos, 7000);
      expect(noventaNove.resultadoOperacionalCentavos, 5000);
      expect(uber.receitaCentavos, 4000);
      expect(uber.bonusPromocoesCentavos, 1000);
      expect(uber.resultadoOperacionalCentavos, 3000);
      expect(resumo.bonusPromocoes, hasLength(1));
      expect(resumo.resultadoOperacionalCentavos, 8000);
    },
  );

  test(
    'intraday inclui ganho individual pelo horário operacional até checkpoint',
    () async {
      final jornadaId = await database
          .into(database.jornadas)
          .insert(
            JornadasCompanion.insert(
              usuarioId: 1,
              veiculoId: 1,
              dataHoraInicio: DateTime(2026, 8, 10, 7),
              odometroInicio: 1000,
              cidadeOrigem: 'Curitiba',
              status: StatusJornada.aberta,
            ),
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
        DateTime(2026, 8, 10, 7),
        {uberId: (0, 0)},
      );
      await inserirLeitura(
        jornadaId,
        TipoLeituraGanhos.parcial,
        DateTime(2026, 8, 10, 11, 40),
        {uberId: (5000, 5)},
      );
      await database
          .into(database.lancamentosGanhoIndividual)
          .insert(
            LancamentosGanhoIndividualCompanion.insert(
              plataformaId: particularId,
              jornadaId: Value(jornadaId),
              quantidadeViagens: 2,
              valorTotalCentavos: 3000,
              dataHora: Value(DateTime(2026, 8, 10, 10, 25)),
              dataCriacao: Value(DateTime(2026, 8, 10, 14)),
            ),
          );
      final posteriorId = await database
          .into(database.lancamentosGanhoIndividual)
          .insert(
            LancamentosGanhoIndividualCompanion.insert(
              plataformaId: particularId,
              jornadaId: Value(jornadaId),
              quantidadeViagens: 1,
              valorTotalCentavos: 9000,
              dataHora: Value(DateTime(2026, 8, 10, 12)),
            ),
          );

      final resumo = (await service.resumoJornadaAberta())!;

      expect(resumo.receitaTotalCentavos, 8000);
      expect(resumo.quantidadeTotalViagens, 7);
      expect(resumo.ticketMedio, closeTo(11.428, 0.001));
      final particular = resumo.resultadosPlataformas.singleWhere(
        (item) => item.nome == 'Particular',
      );
      expect(particular.receitaCentavos, 3000);
      expect(particular.quantidadeViagens, 2);

      final ganhoService = GanhoIndividualService(
        ganhoIndividualRepository,
        jornadaRepository,
        agora: () => DateTime(2026, 8, 10, 15),
      );
      await ganhoService.editarDataHora(
        lancamentoId: posteriorId,
        dataHora: DateTime(2026, 8, 10, 11),
      );
      final aposEdicao = (await service.resumoJornadaAberta())!;
      expect(aposEdicao.receitaTotalCentavos, 17000);
      expect(aposEdicao.quantidadeTotalViagens, 8);

      await inserirLeitura(
        jornadaId,
        TipoLeituraGanhos.parcial,
        DateTime(2026, 8, 10, 14),
        {uberId: (7000, 7)},
      );
      final posterior = (await service.resumoJornadaAberta())!;
      expect(posterior.receitaTotalCentavos, 19000);
      expect(posterior.quantidadeTotalViagens, 10);
    },
  );

  test('timestamp legado posterior não bloqueia indicadores', () async {
    final jornadaId = await inserirJornada(
      inicio: DateTime(2026, 8, 10, 8),
      fim: DateTime(2026, 8, 10, 18),
      odometroFim: 1200,
    );
    final uberId = await inserirPlataforma('Uber');
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.inicial,
      DateTime(2026, 8, 10, 8, 30),
      {uberId: (5000, 5)},
    );
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.finalDaJornada,
      DateTime(2026, 8, 10, 18),
      {uberId: (15000, 15)},
    );

    final resumo = (await service.resumoUltimaJornada())!;

    expect(resumo.financeiroCompleto, isTrue);
    expect(resumo.receitaTotalCentavos, 10000);
    expect(resumo.quantidadeTotalViagens, 10);
    expect(resumo.ticketMedioGeral, 10);
    expect(resumo.receitaPorHoraAtiva, 10);
    expect(resumo.receitaPorKmAtivo, 0.5);
    expect(resumo.resultadoOperacionalCentavos, 10000);
    expect(resumo.resultadosPlataformas.single.receitaCentavos, 10000);
    expect(resumo.resultadosPlataformas.single.quantidadeViagens, 10);
  });

  test('ausência de Leitura Inicial mantém resultado incompleto', () async {
    await inserirJornada(
      inicio: DateTime(2026, 8, 10, 8),
      fim: DateTime(2026, 8, 10, 18),
      odometroFim: 1200,
    );

    final resumo = (await service.resumoUltimaJornada())!;

    expect(resumo.financeiroCompleto, isFalse);
    expect(resumo.receitaTotalCentavos, isNull);
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
    await inserirBonus(jornadaId, uberId, DateTime(2026, 8, 10, 12), 500);

    final novoService = JornadaService(
      JornadaRepository(JornadaDao(database)),
      PausaRepository(PausaDao(database)),
      LeituraGanhosRepository(LeituraGanhosDao(database)),
      GanhoIndividualRepository(GanhoIndividualDao(database)),
      PassePlataformaRepository(PassePlataformaDao(database)),
      BonusPromocaoRepository(BonusPromocaoDao(database)),
    );
    final resumo = (await novoService.resumoUltimaJornada())!;

    expect(resumo.receitaTotalCentavos, 2000);
    expect(resumo.bonusPromocoesCentavos, 500);
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
            dataHora: Value(DateTime(2026, 8, 10, 9)),
          ),
        );
    await inserirBonus(jornadaId, particularId, DateTime(2026, 8, 10, 9), 500);

    final resumo = (await service.resumoUltimaJornada())!;
    final particular = resumo.resultadosPlataformas.singleWhere(
      (resultado) => resultado.nome == 'Particular',
    );

    expect(particular.receitaCentavos, 12500);
    expect(particular.bonusPromocoesCentavos, 500);
    expect(particular.resultadoOperacionalCentavos, 13000);
    expect(particular.quantidadeViagens, 3);
    expect(particular.ticketMedio, closeTo(41.666, 0.001));
    expect(resumo.receitaTotalCentavos, 16500);
    expect(resumo.quantidadeTotalViagens, 5);
    expect(resumo.ticketMedioGeral, 33);
    expect(resumo.receitaPorHoraAtiva, 82.5);
    expect(resumo.receitaPorKmAtivo, 1.65);
  });

  test('reconcilia bônus e exclui crédito do ticket médio', () async {
    final jornadaId = await inserirJornada(fim: DateTime(2026, 8, 10, 18));
    final plataformaId = await inserirPlataforma('Acumulada');
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.inicial,
      DateTime(2026, 8, 10, 8),
      {plataformaId: (10000, 5)},
    );
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.finalDaJornada,
      DateTime(2026, 8, 10, 16),
      {plataformaId: (18000, 10)},
    );
    await inserirBonus(
      jornadaId,
      plataformaId,
      DateTime(2026, 8, 10, 12),
      2000,
    );
    await database
        .into(database.bonusPromocoes)
        .insert(
          BonusPromocoesCompanion.insert(
            plataformaId: plataformaId,
            dataHora: DateTime(2026, 8, 10, 13),
            valorCentavos: 3000,
            tipo: TipoBonusPromocao.bonus,
          ),
        );
    await database
        .into(database.bonusPromocoes)
        .insert(
          BonusPromocoesCompanion.insert(
            plataformaId: plataformaId,
            dataHora: DateTime(2026, 8, 10, 17),
            valorCentavos: 1000,
            tipo: TipoBonusPromocao.bonus,
          ),
        );

    final resumo = (await service.resumoUltimaJornada())!;
    final resultado = resumo.resultadosPlataformas.single;
    expect(resultado.receitaCentavos, 3000);
    expect(resultado.bonusPromocoesCentavos, 6000);
    expect(resultado.ticketMedio, 6);
    expect(resultado.resultadoOperacionalCentavos, 9000);
    expect(resumo.bonusPromocoesCentavos, 6000);
    expect(resumo.resultadoOperacionalCentavos, 9000);
  });

  test(
    'bônus anterior ao baseline não é associado nem subtraído novamente',
    () async {
      final jornadaId = await inserirJornada(
        inicio: DateTime(2026, 8, 10, 8),
        fim: DateTime(2026, 8, 10, 20),
      );
      final plataformaId = await inserirPlataforma('99');
      final bonusId = await database
          .into(database.bonusPromocoes)
          .insert(
            BonusPromocoesCompanion.insert(
              plataformaId: plataformaId,
              dataHora: DateTime(2026, 8, 10, 7, 55),
              valorCentavos: 800,
              tipo: TipoBonusPromocao.bonus,
            ),
          );
      await inserirLeitura(
        jornadaId,
        TipoLeituraGanhos.inicial,
        DateTime(2026, 8, 10, 8),
        {plataformaId: (800, 0)},
      );
      await inserirLeitura(
        jornadaId,
        TipoLeituraGanhos.finalDaJornada,
        DateTime(2026, 8, 10, 20),
        {plataformaId: (10800, 10)},
      );

      final resumo = (await service.resumoUltimaJornada())!;
      final bonus = await (database.select(
        database.bonusPromocoes,
      )..where((item) => item.id.equals(bonusId))).getSingle();

      expect(bonus.jornadaId, isNull);
      expect(resumo.resultadosPlataformas.single.receitaCentavos, 10000);
      expect(resumo.resultadosPlataformas.single.bonusPromocoesCentavos, 0);
      expect(resumo.bonusPromocoes, isEmpty);
      expect(resumo.receitaTotalCentavos, 10000);
    },
  );

  test('sem bônus mantém a variação integral como receita', () async {
    final jornadaId = await inserirJornada();
    final plataformaId = await inserirPlataforma('Acumulada');
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.inicial,
      DateTime(2026, 8, 10, 8),
      {plataformaId: (10000, 5)},
    );
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.finalDaJornada,
      DateTime(2026, 8, 10, 16),
      {plataformaId: (18000, 10)},
    );
    expect(
      (await service.resumoUltimaJornada())!
          .resultadosPlataformas
          .single
          .receitaCentavos,
      8000,
    );
  });

  test(
    'distribui múltiplos bônus entre intervalos sem dupla contagem',
    () async {
      final jornadaId = await inserirJornada();
      final plataformaId = await inserirPlataforma('Acumulada');
      await inserirLeitura(
        jornadaId,
        TipoLeituraGanhos.inicial,
        DateTime(2026, 8, 10, 8),
        {plataformaId: (10000, 5)},
      );
      await inserirLeitura(
        jornadaId,
        TipoLeituraGanhos.parcial,
        DateTime(2026, 8, 10, 12),
        {plataformaId: (15000, 8)},
      );
      await inserirLeitura(
        jornadaId,
        TipoLeituraGanhos.finalDaJornada,
        DateTime(2026, 8, 10, 16),
        {plataformaId: (21000, 12)},
      );
      await inserirBonus(
        jornadaId,
        plataformaId,
        DateTime(2026, 8, 10, 10),
        1000,
      );
      await inserirBonus(
        jornadaId,
        plataformaId,
        DateTime(2026, 8, 10, 11),
        500,
      );
      await inserirBonus(
        jornadaId,
        plataformaId,
        DateTime(2026, 8, 10, 14),
        2000,
        tipo: TipoBonusPromocao.promocao,
      );

      final resultado =
          (await service.resumoUltimaJornada())!.resultadosPlataformas.single;
      expect(resultado.receitaCentavos, 7500);
      expect(resultado.bonusPromocoesCentavos, 3500);
      expect(resultado.quantidadeViagens, 7);
    },
  );

  test('fronteira é aberta no anterior e fechada no posterior', () async {
    final jornadaId = await inserirJornada();
    final plataformaId = await inserirPlataforma('Acumulada');
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.inicial,
      DateTime(2026, 8, 10, 8),
      {plataformaId: (10000, 5)},
    );
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.parcial,
      DateTime(2026, 8, 10, 12),
      {plataformaId: (15000, 8)},
    );
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.finalDaJornada,
      DateTime(2026, 8, 10, 16),
      {plataformaId: (20000, 10)},
    );
    await inserirBonus(jornadaId, plataformaId, DateTime(2026, 8, 10, 8), 1000);
    await inserirBonus(
      jornadaId,
      plataformaId,
      DateTime(2026, 8, 10, 12),
      2000,
    );

    final resultado =
        (await service.resumoUltimaJornada())!.resultadosPlataformas.single;
    expect(resultado.receitaCentavos, 8000);
    expect(resultado.bonusPromocoesCentavos, 2000);
  });

  test('bônus maior que variação mantém revisão', () async {
    final jornadaId = await inserirJornada();
    final plataformaId = await inserirPlataforma('Acumulada');
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.inicial,
      DateTime(2026, 8, 10, 8),
      {plataformaId: (10000, 5)},
    );
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.finalDaJornada,
      DateTime(2026, 8, 10, 16),
      {plataformaId: (11000, 6)},
    );
    await inserirBonus(
      jornadaId,
      plataformaId,
      DateTime(2026, 8, 10, 12),
      2000,
    );
    final resultado =
        (await service.resumoUltimaJornada())!.resultadosPlataformas.single;
    expect(resultado.calculavel, isFalse);
    expect(resultado.resultadoOperacionalCentavos, isNull);
  });

  test('passe exige conferência sem reduzir ticket médio', () async {
    final jornadaId = await inserirJornada(
      inicio: DateTime(2026, 8, 10, 8),
      fim: DateTime(2026, 8, 10, 10),
    );
    final plataformaId = await inserirPlataforma('Acumulada');
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.inicial,
      DateTime(2026, 8, 10, 8),
      {plataformaId: (1000, 1)},
    );
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.finalDaJornada,
      DateTime(2026, 8, 10, 10),
      {plataformaId: (5000, 3)},
    );
    await database
        .into(database.passesPlataforma)
        .insert(
          PassesPlataformaCompanion.insert(
            plataformaId: plataformaId,
            jornadaId: Value(jornadaId),
            dataHora: DateTime(2026, 8, 10, 9),
            valorPagoCentavos: 1000,
          ),
        );
    await inserirBonus(
      jornadaId,
      plataformaId,
      DateTime(2026, 8, 10, 9, 30),
      500,
    );

    final resumo = (await service.resumoUltimaJornada())!;
    expect(resumo.resultadosPlataformas.single.calculavel, isFalse);
    expect(resumo.resultadosPlataformas.single.ticketMedio, isNull);
    expect(resumo.receitaTotalCentavos, isNull);
    expect(resumo.ticketMedioGeral, isNull);
    expect(resumo.custoPassesCentavos, 1000);
    expect(resumo.passes, hasLength(1));
    expect(resumo.bonusPromocoesCentavos, 500);
    expect(resumo.resultadoOperacionalCentavos, isNull);
  });

  test('99 recompõe Passe refletido sem descontá-lo duas vezes', () async {
    final jornadaId = await inserirJornada(
      inicio: DateTime(2026, 8, 10, 8),
      fim: DateTime(2026, 8, 10, 10),
    );
    final plataformaId = await inserirPlataforma('99');
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.inicial,
      DateTime(2026, 8, 10, 8),
      {plataformaId: (10000, 5)},
    );
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.finalDaJornada,
      DateTime(2026, 8, 10, 10),
      {plataformaId: (20000, 10)},
    );
    await database
        .into(database.passesPlataforma)
        .insert(
          PassesPlataformaCompanion.insert(
            plataformaId: plataformaId,
            jornadaId: Value(jornadaId),
            dataHora: DateTime(2026, 8, 10, 9),
            valorPagoCentavos: 2000,
          ),
        );

    final resultado =
        (await service.resumoUltimaJornada())!.resultadosPlataformas.single;

    expect(resultado.receitaCentavos, 12000);
    expect(resultado.custoPassesCentavos, 2000);
    expect(resultado.resultadoOperacionalCentavos, 10000);
  });

  test('Uber mantém Passe separado da variação do acumulado', () async {
    final jornadaId = await inserirJornada(
      inicio: DateTime(2026, 8, 10, 8),
      fim: DateTime(2026, 8, 10, 10),
    );
    final plataformaId = await inserirPlataforma('Uber');
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.inicial,
      DateTime(2026, 8, 10, 8),
      {plataformaId: (10000, 5)},
    );
    await inserirLeitura(
      jornadaId,
      TipoLeituraGanhos.finalDaJornada,
      DateTime(2026, 8, 10, 10),
      {plataformaId: (22000, 10)},
    );
    await database
        .into(database.passesPlataforma)
        .insert(
          PassesPlataformaCompanion.insert(
            plataformaId: plataformaId,
            jornadaId: Value(jornadaId),
            dataHora: DateTime(2026, 8, 10, 9),
            valorPagoCentavos: 2000,
          ),
        );

    final resultado =
        (await service.resumoUltimaJornada())!.resultadosPlataformas.single;

    expect(resultado.receitaCentavos, 12000);
    expect(resultado.custoPassesCentavos, 2000);
    expect(resultado.resultadoOperacionalCentavos, 10000);
  });
}
