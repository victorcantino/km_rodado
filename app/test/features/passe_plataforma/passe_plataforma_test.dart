import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:km_rodado/core/constants/enums/status_jornada.dart';
import 'package:km_rodado/core/constants/enums/tipo_passe.dart';
import 'package:km_rodado/core/constants/enums/tipo_registro_ganhos.dart';
import 'package:km_rodado/core/database/app_database.dart';
import 'package:km_rodado/core/database/daos/jornada_dao.dart';
import 'package:km_rodado/core/database/daos/passe_plataforma_dao.dart';
import 'package:km_rodado/core/database/seeds/seed.dart';
import 'package:km_rodado/features/jornada/data/jornada_repository.dart';
import 'package:km_rodado/features/passe_plataforma/data/passe_plataforma_repository.dart';
import 'package:km_rodado/features/passe_plataforma/data/passe_plataforma_service.dart';
import 'package:km_rodado/features/passe_plataforma/presentation/widgets/registrar_passe_dialog.dart';

void main() {
  late AppDatabase database;
  late PassePlataformaRepository repository;
  late PassePlataformaService service;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await garantirDadosTemporarios(database);
    repository = PassePlataformaRepository(PassePlataformaDao(database));
    service = PassePlataformaService(
      repository,
      JornadaRepository(JornadaDao(database)),
      agora: () => DateTime(2026, 8, 14, 12),
    );
  });
  tearDown(() => database.close());

  Future<int> plataforma() => database
      .into(database.plataformas)
      .insert(
        PlataformasCompanion.insert(
          nome: 'Plataforma',
          tipoRegistroGanhos: TipoRegistroGanhos.acumulado,
        ),
      );

  Future<int> jornadaAberta() => database
      .into(database.jornadas)
      .insert(
        JornadasCompanion.insert(
          usuarioId: 1,
          veiculoId: 1,
          dataHoraInicio: DateTime(2026, 8, 14, 8),
          odometroInicio: 100,
          cidadeOrigem: 'Curitiba',
          status: StatusJornada.aberta,
        ),
      );

  test(
    'registra fora de Jornada com instante operacional e opcionais',
    () async {
      final id = await plataforma();
      final operacional = DateTime(2026, 8, 13, 18);
      await service.registrar(
        plataformaId: id,
        dataHora: operacional,
        valorPagoCentavos: 1990,
        tipo: TipoPasse.faturamento,
        limiteFaturamentoCentavos: 20000,
        observacao: '   ',
      );
      final passe =
          (await database.select(database.passesPlataforma).get()).single;
      expect(passe.jornadaId, isNull);
      expect(passe.dataHora, operacional);
      expect(passe.dataCriacao, DateTime(2026, 8, 14, 12));
      expect(passe.valorPagoCentavos, 1990);
      expect(passe.modalidade, 'faturamento');
      expect(passe.validadeAte, DateTime(2027, 2, 9, 18));
      expect(passe.limiteFaturamentoCentavos, 20000);
      expect(passe.observacao, isNull);
    },
  );

  test('associa automaticamente e soma múltiplos passes da Jornada', () async {
    final id = await plataforma();
    final jornadaId = await jornadaAberta();
    for (final valor in [1000, 2500]) {
      await service.registrar(
        plataformaId: id,
        dataHora: DateTime(2026, 8, 14, 9),
        valorPagoCentavos: valor,
        tipo: TipoPasse.faturamento,
        limiteFaturamentoCentavos: 10000,
      );
    }
    final itens = await repository.listarPorJornada(jornadaId);
    expect(itens, hasLength(2));
    expect(
      itens.fold<int>(
        0,
        (total, item) => total + item.passe.valorPagoCentavos.toInt(),
      ),
      3500,
    );
  });

  test('exige plataforma existente e valor positivo', () async {
    final id = await plataforma();
    for (final valor in [0, -1]) {
      await expectLater(
        service.registrar(
          plataformaId: id,
          dataHora: DateTime.now(),
          valorPagoCentavos: valor,
          tipo: TipoPasse.faturamento,
          limiteFaturamentoCentavos: 100,
        ),
        throwsException,
      );
    }
    await expectLater(
      service.registrar(
        plataformaId: 999,
        dataHora: DateTime.now(),
        valorPagoCentavos: 1,
        tipo: TipoPasse.faturamento,
        limiteFaturamentoCentavos: 100,
      ),
      throwsException,
    );
  });

  test('preserva histórico após desativar e recriar service', () async {
    final id = await plataforma();
    final jornadaId = await jornadaAberta();
    await service.registrar(
      plataformaId: id,
      dataHora: DateTime(2026, 8, 14, 9),
      valorPagoCentavos: 1000,
      tipo: TipoPasse.faturamento,
      limiteFaturamentoCentavos: 10000,
    );
    await (database.update(database.plataformas)..where((p) => p.id.equals(id)))
        .write(const PlataformasCompanion(ativa: Value(false)));
    final novo = PassePlataformaService(
      PassePlataformaRepository(PassePlataformaDao(database)),
      JornadaRepository(JornadaDao(database)),
    );
    expect(await novo.listarPlataformasAtivas(), isEmpty);
    expect(await novo.listarPorJornada(jornadaId), hasLength(1));
  });

  test(
    'Passe por faturamento exige limite e preserva hora na validade',
    () async {
      final id = await plataforma();
      await expectLater(
        service.registrar(
          plataformaId: id,
          dataHora: DateTime(2026, 8, 14, 9, 30),
          valorPagoCentavos: 3000,
          tipo: TipoPasse.faturamento,
        ),
        throwsException,
      );
      await service.registrar(
        plataformaId: id,
        dataHora: DateTime(2026, 8, 14, 9, 30),
        valorPagoCentavos: 3000,
        tipo: TipoPasse.faturamento,
        limiteFaturamentoCentavos: 12500,
      );

      final passe =
          (await database.select(database.passesPlataforma).get()).single;
      expect(passe.validadeAte, DateTime(2027, 2, 10, 9, 30));
      expect(passe.limiteFaturamentoCentavos, 12500);
    },
  );

  test('Passe por tempo calcula validade de 24 e 72 horas', () async {
    final id = await plataforma();
    for (final horas in [24, 72]) {
      await service.registrar(
        plataformaId: id,
        dataHora: DateTime(2026, 8, 14, 9, 30),
        valorPagoCentavos: 3700,
        tipo: TipoPasse.tempo,
        duracaoHoras: horas,
      );
    }

    final passes = await database.select(database.passesPlataforma).get();
    expect(passes[0].validadeAte, DateTime(2026, 8, 15, 9, 30));
    expect(passes[1].validadeAte, DateTime(2026, 8, 17, 9, 30));
    expect(
      passes.every((passe) => passe.limiteFaturamentoCentavos == null),
      isTrue,
    );
  });

  test('Passe por tempo rejeita duração desconhecida', () async {
    final id = await plataforma();
    await expectLater(
      service.registrar(
        plataformaId: id,
        dataHora: DateTime(2026, 8, 14, 9),
        valorPagoCentavos: 100,
        tipo: TipoPasse.tempo,
        duracaoHoras: 48,
      ),
      throwsException,
    );
  });

  test(
    'retroativo anterior à Jornada não recebe associação incorreta',
    () async {
      final id = await plataforma();
      await jornadaAberta();
      await service.registrar(
        plataformaId: id,
        dataHora: DateTime(2026, 8, 13, 23),
        valorPagoCentavos: 1000,
        tipo: TipoPasse.tempo,
        duracaoHoras: 24,
      );

      final passe =
          (await database.select(database.passesPlataforma).get()).single;
      expect(passe.jornadaId, isNull);
    },
  );

  test('encontra somente o último Passe da mesma Plataforma', () async {
    final primeira = await plataforma();
    final segunda = await database
        .into(database.plataformas)
        .insert(
          PlataformasCompanion.insert(
            nome: 'Outra',
            tipoRegistroGanhos: TipoRegistroGanhos.acumulado,
          ),
        );
    await service.registrar(
      plataformaId: primeira,
      dataHora: DateTime(2026, 8, 13, 8),
      valorPagoCentavos: 1000,
      tipo: TipoPasse.tempo,
      duracaoHoras: 24,
    );
    await service.registrar(
      plataformaId: segunda,
      dataHora: DateTime(2026, 8, 14, 8),
      valorPagoCentavos: 2000,
      tipo: TipoPasse.faturamento,
      limiteFaturamentoCentavos: 30000,
    );

    final configuracao = await service.buscarUltimoRepetivel(primeira);
    expect(configuracao?.tipo, TipoPasse.tempo);
    expect(configuracao?.valorPagoCentavos, 1000);
    expect(configuracao?.duracaoHoras, 24);
  });

  test('legado incompleto é preservado mas não é repetível', () async {
    final id = await plataforma();
    final passeId = await database
        .into(database.passesPlataforma)
        .insert(
          PassesPlataformaCompanion.insert(
            plataformaId: id,
            dataHora: DateTime(2026, 8, 14, 8),
            valorPagoCentavos: 1000,
            modalidade: const Value('Diário antigo'),
          ),
        );

    expect(await service.buscarUltimoRepetivel(id), isNull);
    expect(
      await (database.select(
        database.passesPlataforma,
      )..where((passe) => passe.id.equals(passeId))).getSingle(),
      isNotNull,
    );
  });

  test(
    'repetição usa nova data e recalcula validade sem copiar Jornada',
    () async {
      final id = await plataforma();
      await service.registrar(
        plataformaId: id,
        dataHora: DateTime(2026, 8, 13, 8),
        valorPagoCentavos: 3700,
        tipo: TipoPasse.tempo,
        duracaoHoras: 24,
      );
      final configuracao = (await service.buscarUltimoRepetivel(id))!;
      await jornadaAberta();
      final novaData = DateTime(2026, 8, 14, 10);
      await service.registrar(
        plataformaId: id,
        dataHora: novaData,
        valorPagoCentavos: configuracao.valorPagoCentavos,
        tipo: configuracao.tipo,
        duracaoHoras: configuracao.duracaoHoras,
      );

      final passes = await database.select(database.passesPlataforma).get();
      expect(passes[0].jornadaId, isNull);
      expect(passes[1].dataHora, novaData);
      expect(passes[1].validadeAte, DateTime(2026, 8, 15, 10));
      expect(passes[1].jornadaId, isNotNull);
    },
  );

  testWidgets('seleciona os dois tipos e valida limite de faturamento', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final plataformaTeste = Plataforma(
      id: 1,
      nome: 'Plataforma',
      tipoRegistroGanhos: TipoRegistroGanhos.acumulado,
      icone: null,
      cor: null,
      ativa: true,
      ordem: 0,
      dataCriacao: DateTime(2026),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RegistrarPasseDialog(plataformas: [plataformaTeste]),
        ),
      ),
    );

    expect(find.text('Faturamento'), findsOneWidget);
    expect(find.text('Tempo'), findsOneWidget);
    final alturaFaturamento = tester
        .getSize(find.byKey(const ValueKey('tipo_passe')))
        .height;
    await tester.tap(find.text('Tempo'));
    await tester.pump();
    final alturaTempo = tester
        .getSize(find.byKey(const ValueKey('tipo_passe')))
        .height;
    expect(alturaTempo, alturaFaturamento);
    expect(find.text('24 horas'), findsOneWidget);
    expect(find.text('72 horas'), findsOneWidget);
    await tester.tap(find.text('Faturamento'));
    await tester.pump();
    await tester.enterText(find.byKey(const ValueKey('valor_passe')), '3000');
    await tester.tap(find.text('Registrar'));
    await tester.pump();
    expect(find.text('Informe um limite maior que zero.'), findsOneWidget);
  });

  testWidgets('repetir Passe copia configuração e mantém campos editáveis', (
    tester,
  ) async {
    final plataformaTeste = Plataforma(
      id: 1,
      nome: '99',
      tipoRegistroGanhos: TipoRegistroGanhos.acumulado,
      icone: null,
      cor: null,
      ativa: true,
      ordem: 0,
      dataCriacao: DateTime(2026),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RegistrarPasseDialog(
            plataformas: [plataformaTeste],
            ultimosRepetiveis: const {
              1: (
                tipo: TipoPasse.faturamento,
                valorPagoCentavos: 1698,
                limiteFaturamentoCentavos: 20000,
                duracaoHoras: null,
              ),
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('repetir_ultimo_passe')));
    await tester.pump();
    final valor = tester.widget<TextFormField>(
      find.byKey(const ValueKey('valor_passe')),
    );
    final limite = tester.widget<TextFormField>(
      find.byKey(const ValueKey('limite_passe')),
    );
    expect(valor.controller?.text, '16,98');
    expect(limite.controller?.text, '200,00');
    await tester.enterText(find.byKey(const ValueKey('valor_passe')), '1800');
    await tester.enterText(find.byKey(const ValueKey('limite_passe')), '21000');
    expect(valor.controller?.text, '18,00');
    expect(limite.controller?.text, '210,00');
  });
}
