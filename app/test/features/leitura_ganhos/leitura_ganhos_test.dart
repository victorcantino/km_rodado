import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:km_rodado/core/constants/enums/status_jornada.dart';
import 'package:km_rodado/core/constants/enums/tipo_leitura_ganhos.dart';
import 'package:km_rodado/core/constants/enums/tipo_registro_ganhos.dart';
import 'package:km_rodado/core/database/app_database.dart';
import 'package:km_rodado/core/database/daos/jornada_dao.dart';
import 'package:km_rodado/core/database/daos/leitura_ganhos_dao.dart';
import 'package:km_rodado/core/database/daos/pausa_dao.dart';
import 'package:km_rodado/core/database/seeds/seed.dart';
import 'package:km_rodado/features/jornada/data/jornada_repository.dart';
import 'package:km_rodado/features/jornada/data/jornada_service.dart';
import 'package:km_rodado/features/leitura_ganhos/data/leitura_ganhos_repository.dart';
import 'package:km_rodado/features/leitura_ganhos/data/leitura_ganhos_service.dart';
import 'package:km_rodado/features/leitura_ganhos/presentation/widgets/leitura_ganhos_dialog.dart';
import 'package:km_rodado/features/pausa/data/pausa_repository.dart';
import 'package:km_rodado/features/pausa/data/pausa_service.dart';

void main() {
  late AppDatabase database;
  late JornadaRepository jornadaRepository;
  late PausaRepository pausaRepository;
  late JornadaService jornadaService;
  late PausaService pausaService;
  late LeituraGanhosRepository leituraRepository;
  late LeituraGanhosService leituraService;
  final instanteLeitura = DateTime(2026, 8, 10, 12, 7, 30);

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await garantirDadosTemporarios(database);
    jornadaRepository = JornadaRepository(JornadaDao(database));
    pausaRepository = PausaRepository(PausaDao(database));
    jornadaService = JornadaService(jornadaRepository, pausaRepository);
    pausaService = PausaService(pausaRepository, jornadaRepository);
    leituraRepository = LeituraGanhosRepository(LeituraGanhosDao(database));
    leituraService = LeituraGanhosService(
      leituraRepository,
      jornadaRepository,
      agora: () => instanteLeitura,
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

  Future<int> inserirPlataforma(
    String nome,
    TipoRegistroGanhos tipo, {
    bool ativa = true,
  }) {
    return database
        .into(database.plataformas)
        .insert(
          PlataformasCompanion.insert(
            nome: nome,
            tipoRegistroGanhos: tipo,
            ativa: Value(ativa),
          ),
        );
  }

  ItemLeituraGanhosEntrada item(
    int plataformaId, {
    int valor = 5000,
    int viagens = 5,
  }) => (
    plataformaId: plataformaId,
    valorAcumuladoCentavos: valor,
    quantidadeViagensAcumulada: viagens,
  );

  test('leitura parcial exige Jornada aberta', () async {
    await expectLater(
      leituraService.salvarLeituraParcial(
        jornadaId: 1,
        pausaId: 1,
        itens: [item(1)],
      ),
      throwsException,
    );
  });

  test('salva leitura parcial na Pausa e mantém a Pausa aberta', () async {
    final jornada = await abrirJornada();
    final pausaId = await pausaService.iniciarPausa();
    final uberId = await inserirPlataforma(
      'Uber',
      TipoRegistroGanhos.acumulado,
    );
    final leituraId = await leituraService.salvarLeituraParcial(
      jornadaId: jornada.id,
      pausaId: pausaId,
      itens: [item(uberId)],
    );
    final leitura = await leituraService.buscarLeitura(leituraId);
    final itens = await leituraService.listarItens(leituraId);

    expect(leitura!.jornadaId, jornada.id);
    expect(leitura.pausaId, pausaId);
    expect(leitura.tipo, TipoLeituraGanhos.parcial);
    expect(leitura.dataHora, instanteLeitura);
    expect(itens.single.plataformaId, uberId);
    expect(itens.single.valorAcumuladoCentavos, 5000);
    expect(itens.single.quantidadeViagensAcumulada, 5);
    expect(await pausaService.buscarAbertaPorJornada(jornada.id), isNotNull);
  });

  test('rejeita Pausa pertencente a outra Jornada', () async {
    final jornada = await abrirJornada();
    final uberId = await inserirPlataforma(
      'Uber',
      TipoRegistroGanhos.acumulado,
    );
    final outraJornadaId = await database
        .into(database.jornadas)
        .insert(
          JornadasCompanion.insert(
            usuarioId: 1,
            veiculoId: 1,
            dataHoraInicio: DateTime(2026, 8, 9),
            odometroInicio: 90,
            cidadeOrigem: 'Curitiba',
            status: StatusJornada.finalizada,
          ),
        );
    final outraPausaId = await database
        .into(database.pausas)
        .insert(
          PausasCompanion.insert(
            jornadaId: outraJornadaId,
            inicio: DateTime(2026, 8, 9, 12),
          ),
        );

    await expectLater(
      leituraService.salvarLeituraParcial(
        jornadaId: jornada.id,
        pausaId: outraPausaId,
        itens: [item(uberId)],
      ),
      throwsException,
    );
  });

  test(
    'rejeita plataforma repetida, individual, inativa e negativos',
    () async {
      final jornada = await abrirJornada();
      final pausaId = await pausaService.iniciarPausa();
      final uberId = await inserirPlataforma(
        'Uber',
        TipoRegistroGanhos.acumulado,
      );
      final noventaNoveId = await inserirPlataforma(
        '99',
        TipoRegistroGanhos.acumulado,
      );
      final particularId = await inserirPlataforma(
        'Particular',
        TipoRegistroGanhos.individual,
      );
      final inativaId = await inserirPlataforma(
        'Inativa',
        TipoRegistroGanhos.acumulado,
        ativa: false,
      );

      Future<int> salvar(List<ItemLeituraGanhosEntrada> itens) {
        return leituraService.salvarLeituraParcial(
          jornadaId: jornada.id,
          pausaId: pausaId,
          itens: itens,
        );
      }

      await expectLater(salvar([item(uberId), item(uberId)]), throwsException);
      await expectLater(salvar([item(uberId)]), throwsException);
      await expectLater(salvar([item(particularId)]), throwsException);
      await expectLater(salvar([item(inativaId)]), throwsException);
      await expectLater(
        salvar([item(uberId, valor: -1), item(noventaNoveId)]),
        throwsException,
      );
      await expectLater(
        salvar([item(uberId, viagens: -1), item(noventaNoveId)]),
        throwsException,
      );
      expect(await database.select(database.leiturasGanhos).get(), isEmpty);
    },
  );

  test('sugere leitura anterior e aceita snapshot sem alteração', () async {
    final jornada = await abrirJornada();
    final primeiraPausaId = await pausaService.iniciarPausa();
    final uberId = await inserirPlataforma(
      'Uber',
      TipoRegistroGanhos.acumulado,
    );
    final snapshot = item(uberId, valor: 5025, viagens: 5);

    await leituraService.salvarLeituraParcial(
      jornadaId: jornada.id,
      pausaId: primeiraPausaId,
      itens: [snapshot],
    );
    await pausaService.finalizarPausa(jornada.id);
    final segundaPausaId = await pausaService.iniciarPausa();

    final sugestoes = await leituraService.buscarSugestoes(jornada.id);
    expect(sugestoes[uberId]!.valorAcumuladoCentavos, 5025);
    expect(sugestoes[uberId]!.quantidadeViagensAcumulada, 5);

    final segundaLeituraId = await leituraService.salvarLeituraParcial(
      jornadaId: jornada.id,
      pausaId: segundaPausaId,
      itens: [snapshot],
    );
    final itens = await leituraService.listarItens(segundaLeituraId);
    expect(itens.single.valorAcumuladoCentavos, 5025);
    expect(itens.single.quantidadeViagensAcumulada, 5);
  });

  test('leitura pode ser restaurada por nova instância do service', () async {
    final jornada = await abrirJornada();
    final pausaId = await pausaService.iniciarPausa();
    final uberId = await inserirPlataforma(
      'Uber',
      TipoRegistroGanhos.acumulado,
    );
    final leituraId = await leituraService.salvarLeituraParcial(
      jornadaId: jornada.id,
      pausaId: pausaId,
      itens: [item(uberId)],
    );
    final novoService = LeituraGanhosService(
      LeituraGanhosRepository(LeituraGanhosDao(database)),
      jornadaRepository,
    );

    expect(await novoService.buscarLeitura(leituraId), isNotNull);
    expect(await novoService.listarItens(leituraId), hasLength(1));
  });

  testWidgets('sugere valores, controla viagens e não edita individual', (
    tester,
  ) async {
    final uberId = await inserirPlataforma(
      'Uber',
      TipoRegistroGanhos.acumulado,
    );
    await inserirPlataforma('Particular', TipoRegistroGanhos.individual);
    final plataformas = await leituraService.listarPlataformasAtivas();
    final sugestao = LeiturasGanhoPlataformaData(
      id: 1,
      leituraGanhosId: 1,
      plataformaId: uberId,
      valorAcumuladoCentavos: 5000,
      quantidadeViagensAcumulada: 5,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: LeituraGanhosDialog(
          plataformas: plataformas,
          sugestoes: {uberId: sugestao},
        ),
      ),
    );

    final valor = tester.widget<TextFormField>(
      find.byKey(ValueKey('valor_$uberId')),
    );
    final quantidade = tester.widget<TextFormField>(
      find.byKey(ValueKey('quantidade_$uberId')),
    );
    expect(valor.controller!.text, contains('50,00'));
    expect(quantidade.controller!.text, '5');
    expect(find.textContaining('lançamentos individuais'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));

    for (var i = 0; i < 6; i++) {
      await tester.tap(find.byKey(ValueKey('menos_$uberId')));
    }
    expect(quantidade.controller!.text, '0');
    await tester.tap(find.byKey(ValueKey('mais_$uberId')));
    expect(quantidade.controller!.text, '1');
  });

  testWidgets('cancelar diálogo mantém a Pausa aberta', (tester) async {
    final jornada = await abrirJornada();
    await pausaService.iniciarPausa();
    final uberId = await inserirPlataforma(
      'Uber',
      TipoRegistroGanhos.acumulado,
    );
    final plataformas = await leituraService.listarPlataformasAtivas();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showDialog<LeituraGanhosResultado>(
                context: context,
                builder: (_) => LeituraGanhosDialog(
                  plataformas: plataformas,
                  sugestoes: const {},
                ),
              ),
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(find.byKey(ValueKey('valor_$uberId')), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(await pausaService.buscarAbertaPorJornada(jornada.id), isNotNull);
    expect(await database.select(database.leiturasGanhos).get(), isEmpty);
  });
}
