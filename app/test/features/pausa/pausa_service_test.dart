import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:km_rodado/core/database/app_database.dart';
import 'package:km_rodado/core/database/daos/jornada_dao.dart';
import 'package:km_rodado/core/database/daos/pausa_dao.dart';
import 'package:km_rodado/core/database/seeds/seed.dart';
import 'package:km_rodado/features/jornada/data/jornada_repository.dart';
import 'package:km_rodado/features/jornada/data/jornada_service.dart';
import 'package:km_rodado/features/pausa/data/pausa_repository.dart';
import 'package:km_rodado/features/pausa/data/pausa_service.dart';
import 'package:km_rodado/features/pausa/presentation/pausa_formatters.dart';

void main() {
  late AppDatabase database;
  late JornadaRepository jornadaRepository;
  late PausaRepository pausaRepository;
  late JornadaService jornadaService;
  late PausaService pausaService;
  var agora = DateTime(2026, 8, 10, 12, 8, 37);

  setUp(() async {
    agora = DateTime(2026, 8, 10, 12, 8, 37);
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await garantirDadosTemporarios(database);

    jornadaRepository = JornadaRepository(JornadaDao(database));
    pausaRepository = PausaRepository(PausaDao(database));
    jornadaService = JornadaService(jornadaRepository, pausaRepository);
    pausaService = PausaService(
      pausaRepository,
      jornadaRepository,
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
    agora = DateTime(2026, 8, 10, 12, 54, 59);

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

    await pausaService.editarTitulo(pausa, '  Almoço  ');
    pausa = (await pausaService.listarPorJornada(jornada.id)).single;
    expect(pausa.titulo, 'Almoço');
    expect(tituloExibicaoPausa(pausa.titulo, 1), 'Almoço');

    await pausaService.editarTitulo(pausa, '   ');
    pausa = (await pausaService.listarPorJornada(jornada.id)).single;
    expect(pausa.titulo, isNull);
    expect(tituloExibicaoPausa(pausa.titulo, 1), 'Pausa 1');
  });

  test('lista e numera Pausas pela ordem de início e id', () async {
    final jornada = await abrirJornada();

    await pausaService.iniciarPausa(odometroInicio: 100);
    agora = DateTime(2026, 8, 10, 12, 20);
    await pausaService.finalizarPausa(jornada.id, odometroFim: 100);
    agora = DateTime(2026, 8, 10, 14, 10);
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

    agora = DateTime(2026, 8, 10, 12, 30);
    await pausaService.finalizarPausa(jornada.id, odometroFim: 100);
    await jornadaService.fecharJornada(odometroFim: 101);
    expect(await jornadaService.jornadaAberta(), isNull);
  });

  test('formata duração sem segundos', () {
    expect(
      formatarDuracaoPausa(const Duration(minutes: 46, seconds: 59)),
      '46m',
    );
    expect(formatarDuracaoPausa(const Duration(hours: 1)), '1h');
    expect(
      formatarDuracaoPausa(const Duration(hours: 1, minutes: 5)),
      '1h 05m',
    );
    expect(
      formatarDuracaoPausa(const Duration(hours: 3, minutes: 27)),
      '3h 27m',
    );
  });
}
