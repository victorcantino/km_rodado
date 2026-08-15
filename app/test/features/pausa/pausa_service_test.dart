import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:km_rodado/core/database/app_database.dart';
import 'package:km_rodado/core/database/daos/jornada_dao.dart';
import 'package:km_rodado/core/database/daos/abastecimento_dao.dart';
import 'package:km_rodado/core/database/daos/pausa_dao.dart';
import 'package:km_rodado/core/database/seeds/seed.dart';
import 'package:km_rodado/core/constants/enums/status_jornada.dart';
import 'package:km_rodado/core/constants/enums/tipo_combustivel.dart';
import 'package:km_rodado/core/constants/enums/tipo_leitura_ganhos.dart';
import 'package:km_rodado/features/jornada/data/jornada_repository.dart';
import 'package:km_rodado/features/abastecimento/data/abastecimento_repository.dart';
import 'package:km_rodado/features/jornada/data/jornada_service.dart';
import 'package:km_rodado/features/pausa/data/pausa_repository.dart';
import 'package:km_rodado/features/pausa/data/pausa_service.dart';
import 'package:km_rodado/features/pausa/presentation/pausa_formatters.dart';
import 'package:km_rodado/features/pausa/presentation/widgets/editar_pausa_dialog.dart';

void main() {
  late AppDatabase database;
  late JornadaRepository jornadaRepository;
  late PausaRepository pausaRepository;
  late JornadaService jornadaService;
  late PausaService pausaService;
  late AbastecimentoRepository abastecimentoRepository;
  var agora = DateTime.now();

  setUp(() async {
    final instante = DateTime.now().add(const Duration(minutes: 1));
    agora = DateTime(
      instante.year,
      instante.month,
      instante.day,
      instante.hour,
      instante.minute,
      instante.second,
    );
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await garantirDadosTemporarios(database);

    jornadaRepository = JornadaRepository(JornadaDao(database));
    pausaRepository = PausaRepository(PausaDao(database));
    abastecimentoRepository = AbastecimentoRepository(
      AbastecimentoDao(database),
    );
    jornadaService = JornadaService(
      jornadaRepository,
      pausaRepository,
      null,
      null,
      null,
      null,
      null,
      () => agora,
    );
    pausaService = PausaService(
      pausaRepository,
      jornadaRepository,
      abastecimentoRepository,
      agora: () => agora,
    );
  });

  tearDown(() => database.close());

  Future<Jornada> abrirJornada() async {
    await jornadaService.abrirJornada(
      usuarioId: 1,
      veiculoId: 1,
      odometro: 100,
      cidadeOrigem: 'Curitiba',
    );
    return (await jornadaService.jornadaAberta())!;
  }

  Future<Jornada> criarJornadaHistorica({bool finalizada = false}) async {
    final id = await database
        .into(database.jornadas)
        .insert(
          JornadasCompanion.insert(
            usuarioId: 1,
            veiculoId: 1,
            dataHoraInicio: DateTime(2026, 8, 10, 8),
            dataHoraFim: Value(finalizada ? DateTime(2026, 8, 10, 18) : null),
            odometroInicio: 1000,
            odometroFim: Value(finalizada ? 1100 : null),
            cidadeOrigem: 'Curitiba',
            cidadeDestino: Value(finalizada ? 'Curitiba' : null),
            status: finalizada
                ? StatusJornada.finalizada
                : StatusJornada.aberta,
            quilometrosPercorridos: Value(finalizada ? 100 : null),
          ),
        );
    return (await jornadaRepository.buscarPorId(id))!;
  }

  Future<Pausa> inserirPausa(
    Jornada jornada, {
    required DateTime inicio,
    DateTime? fim,
    int? odometroInicio,
    int? odometroFim,
    String? titulo,
    String? observacao,
  }) async {
    final id = await database
        .into(database.pausas)
        .insert(
          PausasCompanion.insert(
            jornadaId: jornada.id,
            inicio: inicio,
            fim: Value(fim),
            odometroInicio: Value(odometroInicio),
            odometroFim: Value(odometroFim),
            titulo: Value(titulo),
            observacao: Value(observacao),
          ),
        );
    return (await pausaRepository.listarPorJornada(
      jornada.id,
    )).singleWhere((pausa) => pausa.id == id);
  }

  test('não inicia Pausa sem Jornada aberta', () async {
    await expectLater(
      pausaService.iniciarPausa(odometroInicio: 100),
      throwsException,
    );
    expect(await database.select(database.pausas).get(), isEmpty);
  });

  test('inicia, persiste e restaura uma Pausa aberta', () async {
    final jornada = await abrirJornada();

    final pausaId = await pausaService.iniciarPausa(odometroInicio: 100);
    final pausaPersistida = await pausaRepository.buscarAbertaPorJornada(
      jornada.id,
    );
    final novoService = PausaService(
      pausaRepository,
      jornadaRepository,
      abastecimentoRepository,
      agora: () => agora,
    );

    expect(pausaPersistida, isNotNull);
    expect(pausaPersistida!.id, pausaId);
    expect(pausaPersistida.inicio, agora);
    expect(pausaPersistida.odometroInicio, 100);
    expect(pausaPersistida.fim, isNull);
    expect(pausaPersistida.titulo, isNull);
    expect(await novoService.buscarAbertaPorJornada(jornada.id), isNotNull);
  });

  test('impede duas Pausas abertas na mesma Jornada', () async {
    await abrirJornada();
    await pausaService.iniciarPausa(odometroInicio: 100);

    await expectLater(
      pausaService.iniciarPausa(odometroInicio: 100),
      throwsException,
    );
    expect(await database.select(database.pausas).get(), hasLength(1));
  });

  test('finaliza a Pausa e persiste o fim', () async {
    final jornada = await abrirJornada();
    await pausaService.iniciarPausa(odometroInicio: 100);
    agora = agora.add(const Duration(minutes: 46));

    await pausaService.finalizarPausa(jornada.id, odometroFim: 100);

    final pausas = await pausaService.listarPorJornada(jornada.id);
    expect(pausas.single.fim, agora);
    expect(pausas.single.odometroFim, 100);
    expect(await pausaService.buscarAbertaPorJornada(jornada.id), isNull);
  });

  test('impede regressão e permite deslocamento durante a Pausa', () async {
    final jornada = await abrirJornada();
    await expectLater(
      pausaService.iniciarPausa(odometroInicio: 99),
      throwsException,
    );
    await pausaService.iniciarPausa(odometroInicio: 100);
    await expectLater(
      pausaService.finalizarPausa(jornada.id, odometroFim: 99),
      throwsException,
    );
    await pausaService.finalizarPausa(jornada.id, odometroFim: 105);
    final pausa = (await pausaService.listarPorJornada(jornada.id)).single;
    expect(pausa.odometroInicio, 100);
    expect(pausa.odometroFim, 105);
  });

  test('rejeita fim anterior ao início', () async {
    final jornada = await abrirJornada();
    await pausaService.iniciarPausa(odometroInicio: 100);
    agora = DateTime(2026, 8, 10, 12, 7);

    await expectLater(
      pausaService.finalizarPausa(jornada.id, odometroFim: 100),
      throwsException,
    );
    expect(await pausaService.buscarAbertaPorJornada(jornada.id), isNotNull);
  });

  test('normaliza título e título vazio volta ao nome derivado', () async {
    final jornada = await abrirJornada();
    await pausaService.iniciarPausa(odometroInicio: 100);
    var pausa = (await pausaService.listarPorJornada(jornada.id)).single;

    await pausaService.editarPausa(
      pausa: pausa,
      inicio: pausa.inicio,
      odometroInicio: pausa.odometroInicio,
      fim: pausa.fim,
      odometroFim: pausa.odometroFim,
      titulo: '  Almoço  ',
      observacao: pausa.observacao,
    );
    pausa = (await pausaService.listarPorJornada(jornada.id)).single;
    expect(pausa.titulo, 'Almoço');
    expect(tituloExibicaoPausa(pausa.titulo, 1), 'Almoço');

    await pausaService.editarPausa(
      pausa: pausa,
      inicio: pausa.inicio,
      odometroInicio: pausa.odometroInicio,
      fim: pausa.fim,
      odometroFim: pausa.odometroFim,
      titulo: '   ',
      observacao: pausa.observacao,
    );
    pausa = (await pausaService.listarPorJornada(jornada.id)).single;
    expect(pausa.titulo, isNull);
    expect(tituloExibicaoPausa(pausa.titulo, 1), 'Pausa 1');
  });

  test('lista e numera Pausas pela ordem de início e id', () async {
    final jornada = await abrirJornada();

    await pausaService.iniciarPausa(odometroInicio: 100);
    agora = agora.add(const Duration(minutes: 12));
    await pausaService.finalizarPausa(jornada.id, odometroFim: 100);
    agora = agora.add(const Duration(hours: 2));
    await pausaService.iniciarPausa(odometroInicio: 100);

    final pausas = await pausaService.listarPorJornada(jornada.id);
    expect(pausas, hasLength(2));
    expect(pausas[0].inicio.isBefore(pausas[1].inicio), isTrue);
    expect(tituloExibicaoPausa(pausas[0].titulo, 1), 'Pausa 1');
    expect(tituloExibicaoPausa(pausas[1].titulo, 2), 'Pausa 2');
  });

  test('Jornada não fecha com Pausa aberta e fecha após retomada', () async {
    final jornada = await abrirJornada();
    await pausaService.iniciarPausa(odometroInicio: 100);

    await expectLater(
      jornadaService.fecharJornada(odometroFim: 101),
      throwsException,
    );
    expect(await jornadaService.jornadaAberta(), isNotNull);

    agora = agora.add(const Duration(minutes: 30));
    await pausaService.finalizarPausa(jornada.id, odometroFim: 100);
    await jornadaService.fecharJornada(odometroFim: 101);
    expect(await jornadaService.jornadaAberta(), isNull);
  });

  test('edita todos os campos de Pausa concluída em uma operação', () async {
    final jornada = await criarJornadaHistorica(finalizada: true);
    final pausa = await inserirPausa(
      jornada,
      inicio: DateTime(2026, 8, 10, 10),
      fim: DateTime(2026, 8, 10, 10, 30),
      odometroInicio: 1020,
      odometroFim: 1025,
      titulo: 'Original',
    );

    await pausaService.editarPausa(
      pausa: pausa,
      inicio: DateTime(2026, 8, 10, 10, 5),
      odometroInicio: 1021,
      fim: DateTime(2026, 8, 10, 10, 40),
      odometroFim: 1026,
      titulo: '  Almoço  ',
      observacao: '  Posto de gasolina  ',
    );

    final persistida = (await pausaRepository.listarPorJornada(
      jornada.id,
    )).single;
    expect(persistida.inicio, DateTime(2026, 8, 10, 10, 5));
    expect(persistida.fim, DateTime(2026, 8, 10, 10, 40));
    expect(persistida.odometroInicio, 1021);
    expect(persistida.odometroFim, 1026);
    expect(persistida.titulo, 'Almoço');
    expect(persistida.observacao, 'Posto de gasolina');

    final novoService = PausaService(
      pausaRepository,
      jornadaRepository,
      abastecimentoRepository,
      agora: () => agora,
    );
    expect((await novoService.listarPorJornada(jornada.id)).single, persistida);
  });

  test('edita início, fim e odômetros também isoladamente', () async {
    final jornada = await criarJornadaHistorica(finalizada: true);
    var pausa = await inserirPausa(
      jornada,
      inicio: DateTime(2026, 8, 10, 10),
      fim: DateTime(2026, 8, 10, 11),
      odometroInicio: 1020,
      odometroFim: 1030,
    );

    Future<void> editar({
      DateTime? inicio,
      DateTime? fim,
      int? odometroInicio,
      int? odometroFim,
    }) async {
      await pausaService.editarPausa(
        pausa: pausa,
        inicio: inicio ?? pausa.inicio,
        odometroInicio: odometroInicio ?? pausa.odometroInicio,
        fim: fim ?? pausa.fim,
        odometroFim: odometroFim ?? pausa.odometroFim,
        titulo: pausa.titulo,
        observacao: pausa.observacao,
      );
      pausa = (await pausaRepository.listarPorJornada(jornada.id)).single;
    }

    await editar(inicio: DateTime(2026, 8, 10, 10, 5));
    expect(pausa.inicio, DateTime(2026, 8, 10, 10, 5));
    await editar(fim: DateTime(2026, 8, 10, 11, 5));
    expect(pausa.fim, DateTime(2026, 8, 10, 11, 5));
    await editar(odometroInicio: 1021);
    expect(pausa.odometroInicio, 1021);
    await editar(odometroFim: 1031);
    expect(pausa.odometroFim, 1031);
  });

  test('Pausa aberta permanece aberta e não recebe fim na edição', () async {
    final jornada = await criarJornadaHistorica();
    final pausa = await inserirPausa(
      jornada,
      inicio: DateTime(2026, 8, 10, 10),
      odometroInicio: 1020,
    );

    await pausaService.editarPausa(
      pausa: pausa,
      inicio: DateTime(2026, 8, 10, 10, 5),
      odometroInicio: 1021,
      fim: null,
      odometroFim: null,
      titulo: 'Aberta',
      observacao: null,
    );

    final persistida = (await pausaRepository.listarPorJornada(
      jornada.id,
    )).single;
    expect(persistida.fim, isNull);
    expect(persistida.odometroFim, isNull);
    expect(await pausaRepository.buscarAbertaPorJornada(jornada.id), isNotNull);
  });

  test('rejeita limites temporais da Jornada sem alterar a Pausa', () async {
    final jornada = await criarJornadaHistorica(finalizada: true);
    final pausa = await inserirPausa(
      jornada,
      inicio: DateTime(2026, 8, 10, 10),
      fim: DateTime(2026, 8, 10, 11),
      odometroInicio: 1020,
      odometroFim: 1030,
      titulo: 'Original',
    );

    Future<void> rejeitar(DateTime inicio, DateTime fim) async {
      await expectLater(
        pausaService.editarPausa(
          pausa: pausa,
          inicio: inicio,
          odometroInicio: 1020,
          fim: fim,
          odometroFim: 1030,
          titulo: 'Alterado',
          observacao: null,
        ),
        throwsException,
      );
      final persistida = (await pausaRepository.listarPorJornada(
        jornada.id,
      )).single;
      expect(persistida.titulo, 'Original');
      expect(persistida.inicio, pausa.inicio);
      expect(persistida.fim, pausa.fim);
    }

    await rejeitar(DateTime(2026, 8, 10, 7, 59), pausa.fim!);
    await rejeitar(pausa.inicio, DateTime(2026, 8, 10, 9, 59));
    await rejeitar(pausa.inicio, DateTime(2026, 8, 10, 18, 1));
  });

  test('permite duração zero conforme regra operacional atual', () async {
    final jornada = await criarJornadaHistorica(finalizada: true);
    final pausa = await inserirPausa(
      jornada,
      inicio: DateTime(2026, 8, 10, 10),
      fim: DateTime(2026, 8, 10, 10, 10),
      odometroInicio: 1020,
      odometroFim: 1020,
    );
    final instante = DateTime(2026, 8, 10, 10, 5);

    await pausaService.editarPausa(
      pausa: pausa,
      inicio: instante,
      odometroInicio: 1020,
      fim: instante,
      odometroFim: 1020,
      titulo: null,
      observacao: null,
    );

    final persistida = (await pausaRepository.listarPorJornada(
      jornada.id,
    )).single;
    expect(persistida.fim, persistida.inicio);
  });

  test('rejeita sobreposição com Pausas anterior e posterior', () async {
    final jornada = await criarJornadaHistorica(finalizada: true);
    await inserirPausa(
      jornada,
      inicio: DateTime(2026, 8, 10, 9),
      fim: DateTime(2026, 8, 10, 10),
      odometroInicio: 1010,
      odometroFim: 1020,
    );
    final pausa = await inserirPausa(
      jornada,
      inicio: DateTime(2026, 8, 10, 11),
      fim: DateTime(2026, 8, 10, 12),
      odometroInicio: 1030,
      odometroFim: 1040,
    );
    await inserirPausa(
      jornada,
      inicio: DateTime(2026, 8, 10, 13),
      fim: DateTime(2026, 8, 10, 14),
      odometroInicio: 1050,
      odometroFim: 1060,
    );

    Future<void> editar(DateTime inicio, DateTime fim) =>
        pausaService.editarPausa(
          pausa: pausa,
          inicio: inicio,
          odometroInicio: 1030,
          fim: fim,
          odometroFim: 1040,
          titulo: null,
          observacao: null,
        );
    await expectLater(
      editar(DateTime(2026, 8, 10, 9, 59), pausa.fim!),
      throwsException,
    );
    await expectLater(
      editar(pausa.inicio, DateTime(2026, 8, 10, 13, 1)),
      throwsException,
    );

    await pausaService.editarPausa(
      pausa: pausa,
      inicio: DateTime(2026, 8, 10, 10),
      odometroInicio: 1020,
      fim: DateTime(2026, 8, 10, 13),
      odometroFim: 1050,
      titulo: null,
      observacao: null,
    );
    final ordenadas = await pausaRepository.listarPorJornada(jornada.id);
    expect(ordenadas.map((item) => item.id), [1, pausa.id, 3]);
  });

  test('valida limites e progressão cronológica dos odômetros', () async {
    final jornada = await criarJornadaHistorica(finalizada: true);
    await inserirPausa(
      jornada,
      inicio: DateTime(2026, 8, 10, 9),
      fim: DateTime(2026, 8, 10, 10),
      odometroInicio: 1010,
      odometroFim: 1020,
    );
    final pausa = await inserirPausa(
      jornada,
      inicio: DateTime(2026, 8, 10, 11),
      fim: DateTime(2026, 8, 10, 12),
      odometroInicio: 1030,
      odometroFim: 1040,
    );
    await inserirPausa(
      jornada,
      inicio: DateTime(2026, 8, 10, 13),
      fim: DateTime(2026, 8, 10, 14),
      odometroInicio: 1050,
      odometroFim: 1060,
    );

    Future<void> editar(int inicio, int fim) => pausaService.editarPausa(
      pausa: pausa,
      inicio: pausa.inicio,
      odometroInicio: inicio,
      fim: pausa.fim,
      odometroFim: fim,
      titulo: null,
      observacao: null,
    );
    await expectLater(editar(999, 1040), throwsException);
    await expectLater(editar(1030, 1029), throwsException);
    await expectLater(editar(1101, 1101), throwsException);
    await expectLater(editar(1019, 1040), throwsException);
    await expectLater(editar(1030, 1051), throwsException);
    await editar(1020, 1050);

    final persistida = (await pausaRepository.listarPorJornada(
      jornada.id,
    )).singleWhere((item) => item.id == pausa.id);
    expect(persistida.odometroInicio, 1020);
    expect(persistida.odometroFim, 1050);
  });

  test('não inventa odômetros em Pausa histórica nullable', () async {
    final jornada = await criarJornadaHistorica(finalizada: true);
    final pausa = await inserirPausa(
      jornada,
      inicio: DateTime(2026, 8, 10, 10),
      fim: DateTime(2026, 8, 10, 11),
      titulo: 'Legada',
    );

    await pausaService.editarPausa(
      pausa: pausa,
      inicio: pausa.inicio,
      odometroInicio: null,
      fim: pausa.fim,
      odometroFim: null,
      titulo: '  Histórico  ',
      observacao: '   ',
    );
    final persistida = (await pausaRepository.listarPorJornada(
      jornada.id,
    )).single;
    expect(persistida.odometroInicio, isNull);
    expect(persistida.odometroFim, isNull);
    expect(persistida.titulo, 'Histórico');
    expect(persistida.observacao, isNull);
  });

  test('preserva Leitura parcial vinculada ao editar a Pausa', () async {
    final jornada = await criarJornadaHistorica(finalizada: true);
    final pausa = await inserirPausa(
      jornada,
      inicio: DateTime(2026, 8, 10, 10),
      fim: DateTime(2026, 8, 10, 11),
      odometroInicio: 1020,
      odometroFim: 1030,
    );
    final leituraId = await database
        .into(database.leiturasGanhos)
        .insert(
          LeiturasGanhosCompanion.insert(
            jornadaId: jornada.id,
            pausaId: Value(pausa.id),
            dataHora: DateTime(2026, 8, 10, 10, 5),
            tipo: TipoLeituraGanhos.parcial,
          ),
        );

    await pausaService.editarPausa(
      pausa: pausa,
      inicio: pausa.inicio,
      odometroInicio: pausa.odometroInicio,
      fim: pausa.fim,
      odometroFim: pausa.odometroFim,
      titulo: 'Editada',
      observacao: null,
    );

    final leitura = await (database.select(
      database.leiturasGanhos,
    )..where((item) => item.id.equals(leituraId))).getSingle();
    expect(leitura.pausaId, pausa.id);
    expect(leitura.dataHora, DateTime(2026, 8, 10, 10, 5));
    expect(leitura.tipo, TipoLeituraGanhos.parcial);
  });

  test('Abastecimentos anterior e posterior limitam a correção', () async {
    final jornada = await criarJornadaHistorica(finalizada: true);
    final pausa = await inserirPausa(
      jornada,
      inicio: DateTime(2026, 8, 10, 12),
      fim: DateTime(2026, 8, 10, 13),
      odometroInicio: 1030,
      odometroFim: 1040,
    );
    Future<void> abastecer(DateTime dataHora, int odometro) => database
        .into(database.abastecimentos)
        .insert(
          AbastecimentosCompanion.insert(
            veiculoId: jornada.veiculoId,
            jornadaId: Value(jornada.id),
            dataHora: dataHora,
            odometro: odometro,
            tipoCombustivel: TipoCombustivel.gasolina,
            volumeMililitros: 10000,
            valorTotalPagoCentavos: 6000,
          ),
        )
        .then((_) {});
    await abastecer(DateTime(2026, 8, 10, 11), 1025);
    await abastecer(DateTime(2026, 8, 10, 14), 1045);

    Future<void> editar(int inicio, int fim) => pausaService.editarPausa(
      pausa: pausa,
      inicio: pausa.inicio,
      odometroInicio: inicio,
      fim: pausa.fim,
      odometroFim: fim,
      titulo: null,
      observacao: null,
    );
    await expectLater(editar(1024, 1040), throwsException);
    await expectLater(editar(1030, 1046), throwsException);
    await editar(1025, 1045);
  });

  test('formata duração sem segundos', () {
    expect(formatarDuracaoPausa(const Duration(minutes: 5)), '5min');
    expect(
      formatarDuracaoPausa(const Duration(minutes: 46, seconds: 59)),
      '46min',
    );
    expect(formatarDuracaoPausa(const Duration(hours: 1)), '1h');
    expect(
      formatarDuracaoPausa(const Duration(hours: 1, minutes: 5)),
      '1h 05min',
    );
    expect(
      formatarDuracaoPausa(const Duration(hours: 3, minutes: 27)),
      '3h 27min',
    );
  });

  testWidgets('edita e cancela título com campo focado sem exceções', (
    tester,
  ) async {
    final jornada = await abrirJornada();
    await pausaService.iniciarPausa(odometroInicio: 100);
    var pausa = (await pausaService.listarPorJornada(jornada.id)).single;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                await showDialog<bool>(
                  context: context,
                  builder: (_) => EditarPausaDialog(
                    pausa: pausa,
                    onSalvar: (resultado) async {
                      await pausaService.editarPausa(
                        pausa: pausa,
                        inicio: resultado.inicio,
                        odometroInicio: resultado.odometroInicio,
                        fim: resultado.fim,
                        odometroFim: resultado.odometroFim,
                        titulo: resultado.titulo,
                        observacao: resultado.observacao,
                      );
                      pausa = (await pausaService.listarPorJornada(
                        jornada.id,
                      )).single;
                    },
                  ),
                );
              },
              child: const Text('Editar título'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Editar título'));
    await tester.pumpAndSettle();
    final campo = find.byType(TextFormField).first;
    await tester.tap(campo);
    await tester.enterText(campo, 'Almoço');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    expect(pausa.titulo, 'Almoço');
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Editar título'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(TextFormField).first);
    await tester.enterText(find.byType(TextFormField).first, 'Não salvar');
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(pausa.titulo, 'Almoço');
    expect(tester.takeException(), isNull);
  });

  testWidgets('erro de negócio mantém formulário aberto sem salvar parcial', (
    tester,
  ) async {
    final jornada = await abrirJornada();
    await pausaService.iniciarPausa(odometroInicio: 100);
    final pausa = (await pausaService.listarPorJornada(jornada.id)).single;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showDialog<bool>(
                context: context,
                builder: (_) => EditarPausaDialog(
                  pausa: pausa,
                  onSalvar: (_) async => throw Exception(
                    'O odômetro não pode regredir em relação ao registro anterior.',
                  ),
                ),
              ),
              child: const Text('Editar'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Não persistir');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    expect(find.text('Editar Pausa'), findsOneWidget);
    expect(
      find.text(
        'O odômetro não pode regredir em relação ao registro anterior.',
      ),
      findsOneWidget,
    );
    expect(
      (await pausaRepository.listarPorJornada(jornada.id)).single.titulo,
      isNull,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('exibe e seleciona datas da Pausa em pt-BR', (tester) async {
    final jornada = await criarJornadaHistorica(finalizada: true);
    final pausa = await inserirPausa(
      jornada,
      inicio: DateTime(2026, 8, 14, 10),
      fim: DateTime(2026, 8, 14, 11),
      odometroInicio: 1020,
      odometroFim: 1030,
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pt', 'BR'),
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [Locale('pt', 'BR')],
        home: Scaffold(
          body: EditarPausaDialog(pausa: pausa, onSalvar: (_) async {}),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('14/08/2026 10:00'), findsOneWidget);
    expect(find.text('14/08/2026 11:00'), findsOneWidget);

    await tester.tap(find.text('Início'));
    await tester.pumpAndSettle();
    final seletor = find.byType(DatePickerDialog);
    expect(seletor, findsOneWidget);
    final contexto = tester.element(seletor);
    expect(Localizations.localeOf(contexto), const Locale('pt', 'BR'));
    expect(
      MaterialLocalizations.of(
        contexto,
      ).formatCompactDate(DateTime(2026, 8, 14)),
      '14/08/2026',
    );
  });
}
