import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:km_rodado/core/constants/enums/status_jornada.dart';
import 'package:km_rodado/core/constants/enums/tipo_leitura_ganhos.dart';
import 'package:km_rodado/core/constants/enums/tipo_registro_ganhos.dart';
import 'package:km_rodado/core/database/app_database.dart';
import 'package:km_rodado/core/database/daos/jornada_dao.dart';
import 'package:km_rodado/core/database/daos/abastecimento_dao.dart';
import 'package:km_rodado/core/database/daos/leitura_ganhos_dao.dart';
import 'package:km_rodado/core/database/daos/pausa_dao.dart';
import 'package:km_rodado/core/database/seeds/seed.dart';
import 'package:km_rodado/features/jornada/data/jornada_repository.dart';
import 'package:km_rodado/features/abastecimento/data/abastecimento_repository.dart';
import 'package:km_rodado/features/jornada/data/jornada_service.dart';
import 'package:km_rodado/features/leitura_ganhos/data/leitura_ganhos_repository.dart';
import 'package:km_rodado/features/leitura_ganhos/data/leitura_ganhos_service.dart';
import 'package:km_rodado/features/leitura_ganhos/presentation/controllers/leitura_ganhos_controller.dart';
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
    pausaService = PausaService(
      pausaRepository,
      jornadaRepository,
      AbastecimentoRepository(AbastecimentoDao(database)),
    );
    leituraRepository = LeituraGanhosRepository(LeituraGanhosDao(database));
    leituraService = LeituraGanhosService(
      leituraRepository,
      jornadaRepository,
      pausaRepository,
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
      dataHoraInicio: instanteLeitura.subtract(const Duration(hours: 1)),
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

  Future<void> registrarInicial(Jornada jornada, List<int> plataformas) async {
    await leituraService.salvarLeituraInicial(
      jornadaId: jornada.id,
      itens: [for (final plataformaId in plataformas) item(plataformaId)],
    );
  }

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

  test('abertura tardia não falsifica horário da Leitura Inicial', () async {
    final jornada = await abrirJornada();
    final uberId = await inserirPlataforma(
      'Uber',
      TipoRegistroGanhos.acumulado,
    );
    final leituraId = await leituraService.salvarLeituraInicial(
      jornadaId: jornada.id,
      itens: [item(uberId)],
    );
    final leitura = await leituraService.buscarLeitura(leituraId);

    expect(
      jornada.dataHoraInicio,
      instanteLeitura.subtract(const Duration(hours: 1)),
    );
    expect(leitura!.dataHora, instanteLeitura);
    expect(leitura.dataHora.isAfter(jornada.dataHoraInicio), isTrue);
  });

  test('cria leitura inicial sem Pausa e impede duplicidade', () async {
    final jornada = await abrirJornada();
    final uberId = await inserirPlataforma(
      'Uber',
      TipoRegistroGanhos.acumulado,
    );

    final leituraId = await leituraService.salvarLeituraInicial(
      jornadaId: jornada.id,
      itens: [item(uberId, valor: 1234, viagens: 2)],
    );
    final leitura = await leituraService.buscarLeitura(leituraId);

    expect(leitura!.tipo, TipoLeituraGanhos.inicial);
    expect(leitura.pausaId, isNull);
    await expectLater(
      leituraService.salvarLeituraInicial(
        jornadaId: jornada.id,
        itens: [item(uberId)],
      ),
      throwsException,
    );
  });

  test(
    'ativação define a inicial e não altera o conjunto da Jornada',
    () async {
      final jornada = await abrirJornada();
      final uberId = await inserirPlataforma(
        'Uber',
        TipoRegistroGanhos.acumulado,
      );
      final noventaNoveId = await inserirPlataforma(
        '99',
        TipoRegistroGanhos.acumulado,
      );
      final inDriveId = await inserirPlataforma(
        'inDrive',
        TipoRegistroGanhos.acumulado,
      );

      await leituraService.atualizarAtivacao({inDriveId: false});
      final plataformasIniciais = await leituraService
          .listarPlataformasParaLeitura(jornada.id, leituraInicial: true);
      expect(
        plataformasIniciais.map((p) => p.id),
        unorderedEquals([uberId, noventaNoveId]),
      );

      await leituraService.salvarLeituraInicial(
        jornadaId: jornada.id,
        itens: [item(uberId), item(noventaNoveId)],
      );
      await leituraService.atualizarAtivacao({uberId: false, inDriveId: true});

      final plataformasDaJornada = await leituraService
          .listarPlataformasParaLeitura(jornada.id, leituraInicial: false);
      expect(
        plataformasDaJornada.map((p) => p.id),
        unorderedEquals([uberId, noventaNoveId]),
      );
      final pausaId = await pausaService.iniciarPausa(odometroInicio: 100);
      await leituraService.salvarLeituraParcial(
        jornadaId: jornada.id,
        pausaId: pausaId,
        itens: [item(uberId), item(noventaNoveId)],
      );

      final todas = await leituraService.listarPlataformas();
      expect(todas, hasLength(3));
      expect(todas.singleWhere((p) => p.id == uberId).ativa, isFalse);
      expect(todas.singleWhere((p) => p.id == inDriveId).ativa, isTrue);
    },
  );

  test('leitura inicial não herda valores de Jornada anterior', () async {
    final uberId = await inserirPlataforma(
      'Uber',
      TipoRegistroGanhos.acumulado,
    );
    final jornadaAnteriorId = await database
        .into(database.jornadas)
        .insert(
          JornadasCompanion.insert(
            usuarioId: 1,
            veiculoId: 1,
            dataHoraInicio: DateTime(2026, 8, 9, 8),
            odometroInicio: 50,
            cidadeOrigem: 'Curitiba',
            status: StatusJornada.finalizada,
            dataHoraFim: Value(DateTime(2026, 8, 9, 18)),
            odometroFim: const Value(100),
          ),
        );
    final leituraAnteriorId = await database
        .into(database.leiturasGanhos)
        .insert(
          LeiturasGanhosCompanion.insert(
            jornadaId: jornadaAnteriorId,
            dataHora: DateTime(2026, 8, 9, 18),
            tipo: TipoLeituraGanhos.finalDaJornada,
          ),
        );
    await database
        .into(database.leiturasGanhoPlataforma)
        .insert(
          LeiturasGanhoPlataformaCompanion.insert(
            leituraGanhosId: leituraAnteriorId,
            plataformaId: uberId,
            valorAcumuladoCentavos: 9999,
            quantidadeViagensAcumulada: 20,
          ),
        );

    final jornada = await abrirJornada();
    final leituraId = await leituraService.salvarLeituraInicial(
      jornadaId: jornada.id,
      itens: [item(uberId, valor: 100, viagens: 1)],
    );
    final itens = await leituraService.listarItens(leituraId);

    expect(itens.single.valorAcumuladoCentavos, 100);
    expect(itens.single.quantidadeViagensAcumulada, 1);
  });

  test('impede leitura parcial enquanto a inicial estiver pendente', () async {
    final jornada = await abrirJornada();
    final pausaId = await pausaService.iniciarPausa(odometroInicio: 100);
    final uberId = await inserirPlataforma(
      'Uber',
      TipoRegistroGanhos.acumulado,
    );

    await expectLater(
      leituraService.salvarLeituraParcial(
        jornadaId: jornada.id,
        pausaId: pausaId,
        itens: [item(uberId)],
      ),
      throwsException,
    );
  });

  test('restaura o estado de leitura inicial pendente ou concluída', () async {
    final jornada = await abrirJornada();
    final uberId = await inserirPlataforma(
      'Uber',
      TipoRegistroGanhos.acumulado,
    );
    final novoService = LeituraGanhosService(
      LeituraGanhosRepository(LeituraGanhosDao(database)),
      jornadaRepository,
      pausaRepository,
    );

    final controller = LeituraGanhosController(novoService);
    addTearDown(controller.dispose);

    await controller.carregarEstado(jornada.id);
    expect(controller.leituraInicialConcluida, isFalse);
    await registrarInicial(jornada, [uberId]);
    await controller.carregarEstado(jornada.id);
    expect(controller.leituraInicialConcluida, isTrue);
  });

  test('leitura final usa a última leitura da Jornada como sugestão', () async {
    final jornada = await abrirJornada();
    final uberId = await inserirPlataforma(
      'Uber',
      TipoRegistroGanhos.acumulado,
    );
    await leituraService.salvarLeituraInicial(
      jornadaId: jornada.id,
      itens: [item(uberId, valor: 1520, viagens: 3)],
    );

    final sugestoes = await leituraService.buscarSugestoes(jornada.id);
    expect(sugestoes[uberId]!.valorAcumuladoCentavos, 1520);
    expect(sugestoes[uberId]!.quantidadeViagensAcumulada, 3);
  });

  test(
    'final persiste sem Pausa, aceita valores iguais e fecha Jornada',
    () async {
      final jornada = await abrirJornada();
      final uberId = await inserirPlataforma(
        'Uber',
        TipoRegistroGanhos.acumulado,
      );
      final snapshot = item(uberId, valor: 2500, viagens: 4);
      await leituraService.salvarLeituraInicial(
        jornadaId: jornada.id,
        itens: [snapshot],
      );

      final fimOperacional = DateTime(2026, 8, 10, 12, 30);
      final serviceFechamentoTardio = LeituraGanhosService(
        leituraRepository,
        jornadaRepository,
        pausaRepository,
        agora: () => DateTime(2026, 8, 10, 13),
      );
      final leituraId = await serviceFechamentoTardio.finalizarJornada(
        jornadaId: jornada.id,
        odometroFim: 110,
        itens: [snapshot],
        dataHoraFim: fimOperacional,
      );
      final leitura = await leituraService.buscarLeitura(leituraId);
      final jornadaPersistida = await (database.select(
        database.jornadas,
      )..where((registro) => registro.id.equals(jornada.id))).getSingle();

      expect(leitura!.tipo, TipoLeituraGanhos.finalDaJornada);
      expect(leitura.dataHora, fimOperacional);
      expect(leitura.dataCriacao, DateTime(2026, 8, 10, 13));
      expect(leitura.pausaId, isNull);
      expect(jornadaPersistida.status, StatusJornada.finalizada);
      expect(jornadaPersistida.dataHoraFim, fimOperacional);
      expect(jornadaPersistida.dataAtualizacao, DateTime(2026, 8, 10, 13));
      expect(await leituraService.buscarLeituraFinal(jornada.id), isNotNull);

      await expectLater(
        leituraService.finalizarJornada(
          jornadaId: jornada.id,
          odometroFim: 111,
          itens: [snapshot],
        ),
        throwsException,
      );
      final finais =
          await (database.select(database.leiturasGanhos)..where(
                (registro) =>
                    registro.jornadaId.equals(jornada.id) &
                    registro.tipo.equalsValue(TipoLeituraGanhos.finalDaJornada),
              ))
              .get();
      expect(finais, hasLength(1));
    },
  );

  test(
    'cenário legado parcial, inicial e final encerra com valores zero',
    () async {
      final jornada = await abrirJornada();
      final uberId = await inserirPlataforma(
        'Uber',
        TipoRegistroGanhos.acumulado,
      );
      final pausaId = await database
          .into(database.pausas)
          .insert(
            PausasCompanion.insert(
              jornadaId: jornada.id,
              inicio: DateTime(2026, 8, 10, 10),
              fim: Value(DateTime(2026, 8, 10, 10, 15)),
            ),
          );
      final parcialId = await database
          .into(database.leiturasGanhos)
          .insert(
            LeiturasGanhosCompanion.insert(
              jornadaId: jornada.id,
              pausaId: Value(pausaId),
              dataHora: DateTime(2026, 8, 10, 10, 5),
              tipo: TipoLeituraGanhos.parcial,
            ),
          );
      await database
          .into(database.leiturasGanhoPlataforma)
          .insert(
            LeiturasGanhoPlataformaCompanion.insert(
              leituraGanhosId: parcialId,
              plataformaId: uberId,
              valorAcumuladoCentavos: 0,
              quantidadeViagensAcumulada: 0,
            ),
          );

      final zero = item(uberId, valor: 0, viagens: 0);
      await leituraService.salvarLeituraInicial(
        jornadaId: jornada.id,
        itens: [zero],
      );
      await leituraService.finalizarJornada(
        jornadaId: jornada.id,
        odometroFim: jornada.odometroInicio + 1,
        itens: [zero],
      );

      final jornadaFinalizada = await (database.select(
        database.jornadas,
      )..where((registro) => registro.id.equals(jornada.id))).getSingle();
      final leituras =
          await (database.select(database.leiturasGanhos)
                ..where((registro) => registro.jornadaId.equals(jornada.id))
                ..orderBy([(registro) => OrderingTerm.asc(registro.id)]))
              .get();
      final finais = leituras
          .where((leitura) => leitura.tipo == TipoLeituraGanhos.finalDaJornada)
          .toList();
      final itensFinais = await leituraService.listarItens(finais.single.id);

      expect(leituras.map((leitura) => leitura.tipo), [
        TipoLeituraGanhos.parcial,
        TipoLeituraGanhos.inicial,
        TipoLeituraGanhos.finalDaJornada,
      ]);
      expect(finais, hasLength(1));
      expect(itensFinais.single.valorAcumuladoCentavos, 0);
      expect(itensFinais.single.quantidadeViagensAcumulada, 0);
      expect(jornadaFinalizada.status, StatusJornada.finalizada);
      expect(jornadaFinalizada.odometroFim, jornada.odometroInicio + 1);
    },
  );

  test('impede leitura final com Pausa aberta', () async {
    final jornada = await abrirJornada();
    final uberId = await inserirPlataforma(
      'Uber',
      TipoRegistroGanhos.acumulado,
    );
    await registrarInicial(jornada, [uberId]);
    await pausaService.iniciarPausa(odometroInicio: 100);

    await expectLater(
      leituraService.finalizarJornada(
        jornadaId: jornada.id,
        odometroFim: 110,
        itens: [item(uberId)],
      ),
      throwsException,
    );
    expect(await jornadaService.jornadaAberta(), isNotNull);
    expect(await leituraService.buscarLeituraFinal(jornada.id), isNull);
  });

  test('falha ao inserir leitura final não fecha Jornada', () async {
    final jornada = await abrirJornada();
    final uberId = await inserirPlataforma(
      'Uber',
      TipoRegistroGanhos.acumulado,
    );
    await registrarInicial(jornada, [uberId]);
    await database.customStatement('''
      CREATE TRIGGER falhar_leitura_final
      BEFORE INSERT ON leituras_ganhos
      WHEN NEW.tipo = 'finalDaJornada'
      BEGIN
        SELECT RAISE(ABORT, 'falha controlada');
      END
    ''');

    await expectLater(
      leituraService.finalizarJornada(
        jornadaId: jornada.id,
        odometroFim: 110,
        itens: [item(uberId)],
      ),
      throwsException,
    );
    expect(await jornadaService.jornadaAberta(), isNotNull);
    expect(await leituraService.buscarLeituraFinal(jornada.id), isNull);
  });

  test('falha ao fechar Jornada reverte a leitura final', () async {
    final jornada = await abrirJornada();
    final uberId = await inserirPlataforma(
      'Uber',
      TipoRegistroGanhos.acumulado,
    );
    await registrarInicial(jornada, [uberId]);
    await database.customStatement('''
      CREATE TRIGGER falhar_fechamento
      BEFORE UPDATE ON jornadas
      WHEN NEW.status = 'finalizada'
      BEGIN
        SELECT RAISE(ABORT, 'falha controlada');
      END
    ''');

    await expectLater(
      leituraService.finalizarJornada(
        jornadaId: jornada.id,
        odometroFim: 110,
        itens: [item(uberId)],
      ),
      throwsException,
    );
    expect(await jornadaService.jornadaAberta(), isNotNull);
    expect(await leituraService.buscarLeituraFinal(jornada.id), isNull);
  });

  test('salva leitura parcial na Pausa e mantém a Pausa aberta', () async {
    final jornada = await abrirJornada();
    final pausaId = await pausaService.iniciarPausa(odometroInicio: 100);
    final uberId = await inserirPlataforma(
      'Uber',
      TipoRegistroGanhos.acumulado,
    );
    await registrarInicial(jornada, [uberId]);
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
      final pausaId = await pausaService.iniciarPausa(odometroInicio: 100);
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
      await registrarInicial(jornada, [uberId, noventaNoveId]);

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
      expect(
        await database.select(database.leiturasGanhos).get(),
        hasLength(1),
      );
    },
  );

  test('sugere leitura anterior e aceita snapshot sem alteração', () async {
    final jornada = await abrirJornada();
    final primeiraPausaId = await pausaService.iniciarPausa(
      odometroInicio: 100,
    );
    final uberId = await inserirPlataforma(
      'Uber',
      TipoRegistroGanhos.acumulado,
    );
    await registrarInicial(jornada, [uberId]);
    final snapshot = item(uberId, valor: 5025, viagens: 5);

    await leituraService.salvarLeituraParcial(
      jornadaId: jornada.id,
      pausaId: primeiraPausaId,
      itens: [snapshot],
    );
    await pausaService.finalizarPausa(jornada.id, odometroFim: 100);
    final segundaPausaId = await pausaService.iniciarPausa(odometroInicio: 100);

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
    final pausaId = await pausaService.iniciarPausa(odometroInicio: 100);
    final uberId = await inserirPlataforma(
      'Uber',
      TipoRegistroGanhos.acumulado,
    );
    await registrarInicial(jornada, [uberId]);
    final leituraId = await leituraService.salvarLeituraParcial(
      jornadaId: jornada.id,
      pausaId: pausaId,
      itens: [item(uberId)],
    );
    final novoService = LeituraGanhosService(
      LeituraGanhosRepository(LeituraGanhosDao(database)),
      jornadaRepository,
      pausaRepository,
    );

    expect(await novoService.buscarLeitura(leituraId), isNotNull);
    expect(await novoService.listarItens(leituraId), hasLength(1));
  });

  testWidgets('sugere valores e mostra total e ação individual', (
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
    expect(find.textContaining(r'R$'), findsWidgets);
    expect(find.text('+ Registrar'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));

    await tester.tap(find.byKey(ValueKey('valor_$uberId')));
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pump();
    expect(
      tester
          .widget<EditableText>(
            find.descendant(
              of: find.byKey(ValueKey('quantidade_$uberId')),
              matching: find.byType(EditableText),
            ),
          )
          .focusNode
          .hasFocus,
      isTrue,
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(
      tester
          .widget<EditableText>(
            find.descendant(
              of: find.byKey(ValueKey('quantidade_$uberId')),
              matching: find.byType(EditableText),
            ),
          )
          .focusNode
          .hasFocus,
      isFalse,
    );

    for (var i = 0; i < 6; i++) {
      await tester.tap(find.byKey(ValueKey('menos_$uberId')));
    }
    expect(quantidade.controller!.text, '0');
    await tester.tap(find.byKey(ValueKey('mais_$uberId')));
    expect(quantidade.controller!.text, '1');
  });

  testWidgets('digitação monetária persiste centavos inteiros', (tester) async {
    final uberId = await inserirPlataforma(
      'Uber',
      TipoRegistroGanhos.acumulado,
    );
    final plataforma = (await leituraService.listarPlataformasAtivas()).single;
    LeituraGanhosResultado? resultado;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                resultado = await showDialog<LeituraGanhosResultado>(
                  context: context,
                  builder: (_) => LeituraGanhosDialog(
                    plataformas: [plataforma],
                    sugestoes: const {},
                  ),
                );
              },
              child: const Text('Abrir valores'),
            ),
          ),
        ),
      ),
    );

    for (final caso in [
      ('0', '0,00', 0),
      ('1', '0,01', 1),
      ('1350', '13,50', 1350),
      ('10000', '100,00', 10000),
    ]) {
      await tester.tap(find.text('Abrir valores'));
      await tester.pumpAndSettle();
      final campo = find.byKey(ValueKey('valor_$uberId'));
      await tester.enterText(campo, caso.$1);
      expect(tester.widget<TextFormField>(campo).controller!.text, caso.$2);
      await tester.tap(find.text('Salvar leitura'));
      await tester.pumpAndSettle();
      expect(resultado!.single.valorAcumuladoCentavos, caso.$3);
    }
  });

  testWidgets('Zero limpa valor e viagens da plataforma', (tester) async {
    final uberId = await inserirPlataforma(
      'Uber',
      TipoRegistroGanhos.acumulado,
    );
    final plataforma = (await leituraService.listarPlataformasAtivas()).single;
    final sugestao = LeiturasGanhoPlataformaData(
      id: 1,
      leituraGanhosId: 1,
      plataformaId: uberId,
      valorAcumuladoCentavos: 10000,
      quantidadeViagensAcumulada: 9,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: LeituraGanhosDialog(
          plataformas: [plataforma],
          sugestoes: {uberId: sugestao},
        ),
      ),
    );

    await tester.tap(find.byKey(ValueKey('zero_$uberId')));
    expect(
      tester
          .widget<TextFormField>(find.byKey(ValueKey('valor_$uberId')))
          .controller!
          .text,
      '0,00',
    );
    expect(
      tester
          .widget<TextFormField>(find.byKey(ValueKey('quantidade_$uberId')))
          .controller!
          .text,
      '0',
    );
  });

  testWidgets('Tudo zerado limpa todas as acumuladas da inicial', (
    tester,
  ) async {
    final uberId = await inserirPlataforma(
      'Uber',
      TipoRegistroGanhos.acumulado,
    );
    final outroId = await inserirPlataforma('99', TipoRegistroGanhos.acumulado);
    final plataformas = await leituraService.listarPlataformasAtivas();
    await tester.pumpWidget(
      MaterialApp(
        home: LeituraGanhosDialog(
          plataformas: plataformas,
          sugestoes: {
            uberId: LeiturasGanhoPlataformaData(
              id: 1,
              leituraGanhosId: 1,
              plataformaId: uberId,
              valorAcumuladoCentavos: 5000,
              quantidadeViagensAcumulada: 5,
            ),
            outroId: LeiturasGanhoPlataformaData(
              id: 2,
              leituraGanhosId: 1,
              plataformaId: outroId,
              valorAcumuladoCentavos: 3000,
              quantidadeViagensAcumulada: 3,
            ),
          },
          leituraInicial: true,
        ),
      ),
    );

    await tester.tap(find.text('Tudo zerado'));
    for (final id in [uberId, outroId]) {
      expect(
        tester
            .widget<TextFormField>(find.byKey(ValueKey('valor_$id')))
            .controller!
            .text,
        '0,00',
      );
      expect(
        tester
            .widget<TextFormField>(find.byKey(ValueKey('quantidade_$id')))
            .controller!
            .text,
        '0',
      );
    }
  });

  testWidgets(
    'fecha diálogo com campos focados sem usar controller descartado',
    (tester) async {
      final uberId = await inserirPlataforma(
        'Uber',
        TipoRegistroGanhos.acumulado,
      );
      final outroId = await inserirPlataforma(
        '99',
        TipoRegistroGanhos.acumulado,
      );
      final plataformas = await leituraService.listarPlataformasAtivas();
      LeituraGanhosResultado? resultado;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  resultado = await showDialog<LeituraGanhosResultado>(
                    context: context,
                    builder: (_) => LeituraGanhosDialog(
                      plataformas: plataformas,
                      sugestoes: {
                        uberId: LeiturasGanhoPlataformaData(
                          id: 1,
                          leituraGanhosId: 1,
                          plataformaId: uberId,
                          valorAcumuladoCentavos: 5000,
                          quantidadeViagensAcumulada: 5,
                        ),
                        outroId: LeiturasGanhoPlataformaData(
                          id: 2,
                          leituraGanhosId: 1,
                          plataformaId: outroId,
                          valorAcumuladoCentavos: 3000,
                          quantidadeViagensAcumulada: 3,
                        ),
                      },
                      leituraInicial: true,
                    ),
                  );
                },
                child: const Text('Abrir regressão'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Abrir regressão'));
      await tester.pumpAndSettle();
      final valorUber = find.byKey(ValueKey('valor_$uberId'));
      await tester.tap(valorUber);
      await tester.enterText(valorUber, '1350');
      final zeroUber = find.byKey(ValueKey('zero_$uberId'));
      await tester.ensureVisible(zeroUber);
      await tester.tap(zeroUber);
      final quantidadeOutro = find.byKey(ValueKey('quantidade_$outroId'));
      await tester.ensureVisible(quantidadeOutro);
      await tester.tap(quantidadeOutro);
      await tester.enterText(quantidadeOutro, '7');
      await tester.ensureVisible(find.text('Tudo zerado'));
      await tester.tap(find.text('Tudo zerado'));
      await tester.ensureVisible(find.text('Salvar leitura'));
      await tester.tap(find.text('Salvar leitura'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(resultado, hasLength(2));
      expect(
        resultado!.every((item) => item.valorAcumuladoCentavos == 0),
        isTrue,
      );
      expect(
        resultado!.every((item) => item.quantidadeViagensAcumulada == 0),
        isTrue,
      );
    },
  );

  testWidgets('cancelar diálogo mantém a Pausa aberta', (tester) async {
    final jornada = await abrirJornada();
    await pausaService.iniciarPausa(odometroInicio: 100);
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
