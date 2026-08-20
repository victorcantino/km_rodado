import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:km_rodado/core/constants/enums/tipo_registro_ganhos.dart';
import 'package:km_rodado/core/constants/enums/status_jornada.dart';
import 'package:km_rodado/core/database/app_database.dart';
import 'package:km_rodado/core/database/daos/ganho_individual_dao.dart';
import 'package:km_rodado/core/database/daos/jornada_dao.dart';
import 'package:km_rodado/core/database/seeds/seed.dart';
import 'package:km_rodado/features/ganho_individual/data/ganho_individual_repository.dart';
import 'package:km_rodado/features/ganho_individual/data/ganho_individual_service.dart';
import 'package:km_rodado/features/jornada/data/jornada_repository.dart';
import 'package:km_rodado/features/ganho_individual/presentation/widgets/registrar_ganho_individual_dialog.dart';

void main() {
  late AppDatabase database;
  late JornadaRepository jornadaRepository;
  late GanhoIndividualRepository repository;
  late GanhoIndividualService service;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await garantirDadosTemporarios(database);
    jornadaRepository = JornadaRepository(JornadaDao(database));
    repository = GanhoIndividualRepository(GanhoIndividualDao(database));
    service = GanhoIndividualService(repository, jornadaRepository);
  });

  tearDown(() => database.close());

  Future<int> plataforma(
    String nome,
    TipoRegistroGanhos tipo, {
    bool ativa = true,
  }) => database
      .into(database.plataformas)
      .insert(
        PlataformasCompanion.insert(
          nome: nome,
          tipoRegistroGanhos: tipo,
          ativa: Value(ativa),
        ),
      );

  Future<int> abrirJornada() => database
      .into(database.jornadas)
      .insert(
        JornadasCompanion.insert(
          usuarioId: 1,
          veiculoId: 1,
          dataHoraInicio: DateTime(2026, 8, 12, 8),
          odometroInicio: 100,
          cidadeOrigem: 'Curitiba',
          status: StatusJornada.aberta,
        ),
      );

  test('registra uma viagem e lote em centavos na Jornada aberta', () async {
    final jornadaId = await abrirJornada();
    final particular = await plataforma(
      'Fonte individual',
      TipoRegistroGanhos.individual,
    );

    await service.registrar(
      plataformaId: particular,
      quantidadeViagens: 1,
      valorTotalCentavos: 4000,
    );
    await service.registrar(
      plataformaId: particular,
      quantidadeViagens: 3,
      valorTotalCentavos: 12500,
      observacao: '  lote  ',
    );

    final registros = await repository.listarPorJornada(jornadaId);
    final total = (await repository.totalizarPorJornada(jornadaId)).single;
    expect(registros, hasLength(2));
    expect(registros.last.quantidadeViagens, 3);
    expect(registros.last.valorTotalCentavos, 12500);
    expect(registros.last.observacao, 'lote');
    expect(total.quantidadeViagens, 4);
    expect(total.valorTotalCentavos, 16500);
  });

  test(
    'preserva horário operacional, permite edição e rejeita futuro',
    () async {
      final jornadaId = await abrirJornada();
      final particular = await plataforma(
        'Fonte individual',
        TipoRegistroGanhos.individual,
      );
      final agora = DateTime(2026, 8, 12, 14);
      final serviceComRelogio = GanhoIndividualService(
        repository,
        jornadaRepository,
        agora: () => agora,
      );
      final retroativo = DateTime(2026, 8, 12, 10, 25);
      final leiturasAntes = await database
          .select(database.leiturasGanhos)
          .get();

      final id = await serviceComRelogio.registrar(
        plataformaId: particular,
        quantidadeViagens: 1,
        valorTotalCentavos: 3000,
        dataHora: retroativo,
      );
      var registro = (await repository.listarPorJornada(jornadaId)).single;
      expect(registro.dataHora, retroativo);
      expect(registro.dataCriacao, agora);
      expect(
        await database.select(database.leiturasGanhos).get(),
        leiturasAntes,
      );

      final editado = DateTime(2026, 8, 12, 11);
      expect(
        await serviceComRelogio.editarDataHora(
          lancamentoId: id,
          dataHora: editado,
        ),
        isTrue,
      );
      registro = (await repository.listarPorJornada(jornadaId)).single;
      expect(registro.dataHora, editado);
      expect(registro.dataCriacao, agora);

      await expectLater(
        serviceComRelogio.editarDataHora(
          lancamentoId: id,
          dataHora: agora.add(const Duration(minutes: 1)),
        ),
        throwsException,
      );
    },
  );

  test('valida quantidade, valor, tipo e Jornada aberta', () async {
    final individual = await plataforma(
      'Individual',
      TipoRegistroGanhos.individual,
    );
    await expectLater(
      service.registrar(
        plataformaId: individual,
        quantidadeViagens: 1,
        valorTotalCentavos: 1,
      ),
      throwsException,
    );
    await abrirJornada();
    final acumulada = await plataforma(
      'Acumulada',
      TipoRegistroGanhos.acumulado,
    );
    for (final quantidade in [0, -1]) {
      await expectLater(
        service.registrar(
          plataformaId: individual,
          quantidadeViagens: quantidade,
          valorTotalCentavos: 1,
        ),
        throwsException,
      );
    }
    await expectLater(
      service.registrar(
        plataformaId: individual,
        quantidadeViagens: 1,
        valorTotalCentavos: -1,
      ),
      throwsException,
    );
    await expectLater(
      service.registrar(
        plataformaId: acumulada,
        quantidadeViagens: 1,
        valorTotalCentavos: 1,
      ),
      throwsException,
    );
  });

  test(
    'inativa não aceita novo registro, mas preserva e totaliza histórico',
    () async {
      final jornadaId = await abrirJornada();
      final id = await plataforma('Individual', TipoRegistroGanhos.individual);
      await service.registrar(
        plataformaId: id,
        quantidadeViagens: 2,
        valorTotalCentavos: 5000,
      );
      await (database.update(database.plataformas)
            ..where((p) => p.id.equals(id)))
          .write(const PlataformasCompanion(ativa: Value(false)));

      expect(await service.listarPlataformasAtivas(), isEmpty);
      expect(
        (await service.totalizarPorJornada(
          jornadaId,
        )).single.valorTotalCentavos,
        5000,
      );
      await expectLater(
        service.registrar(
          plataformaId: id,
          quantidadeViagens: 1,
          valorTotalCentavos: 1,
        ),
        throwsException,
      );
    },
  );

  test(
    'mantém plataformas separadas e restaura dados em novo service',
    () async {
      final jornadaId = await abrirJornada();
      final a = await plataforma('A', TipoRegistroGanhos.individual);
      final b = await plataforma('B', TipoRegistroGanhos.individual);
      await service.registrar(
        plataformaId: a,
        quantidadeViagens: 1,
        valorTotalCentavos: 1000,
      );
      await service.registrar(
        plataformaId: b,
        quantidadeViagens: 2,
        valorTotalCentavos: 3000,
      );

      final novo = GanhoIndividualService(
        GanhoIndividualRepository(GanhoIndividualDao(database)),
        JornadaRepository(JornadaDao(database)),
      );
      final totais = await novo.totalizarPorJornada(jornadaId);
      expect(totais, hasLength(2));
      expect(
        totais.map((t) => t.valorTotalCentavos),
        containsAll([1000, 3000]),
      );
    },
  );

  test('registrar durante Pausa não encerra a Pausa', () async {
    final jornadaId = await abrirJornada();
    final id = await plataforma('Individual', TipoRegistroGanhos.individual);
    final pausaId = await database
        .into(database.pausas)
        .insert(
          PausasCompanion.insert(
            jornadaId: jornadaId,
            inicio: DateTime(2026, 8, 12, 10),
            odometroInicio: const Value(120),
          ),
        );

    await service.registrar(
      plataformaId: id,
      quantidadeViagens: 1,
      valorTotalCentavos: 2000,
    );

    final pausa = await (database.select(
      database.pausas,
    )..where((p) => p.id.equals(pausaId))).getSingle();
    expect(pausa.fim, isNull);
  });

  testWidgets('valor recebe foco e diálogo salva e cancela sem exceções', (
    tester,
  ) async {
    final id = await plataforma('Particular', TipoRegistroGanhos.individual);
    final item = (await database.select(database.plataformas).get())
        .singleWhere((p) => p.id == id);
    RegistrarGanhoIndividualResultado? resultado;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                resultado = await showDialog<RegistrarGanhoIndividualResultado>(
                  context: context,
                  builder: (_) =>
                      RegistrarGanhoIndividualDialog(plataformas: [item]),
                );
              },
              child: const Text('Abrir ganho'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Abrir ganho'));
    await tester.pumpAndSettle();
    final valor = find.byKey(const ValueKey('valor_individual'));
    expect(
      tester
          .widget<EditableText>(
            find.descendant(of: valor, matching: find.byType(EditableText)),
          )
          .focusNode
          .hasFocus,
      isTrue,
    );
    await tester.enterText(valor, '4000');
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pump();
    expect(
      tester
          .widget<EditableText>(
            find.descendant(
              of: find.byKey(const ValueKey('quantidade_individual')),
              matching: find.byType(EditableText),
            ),
          )
          .focusNode
          .hasFocus,
      isTrue,
    );
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pump();
    expect(
      tester
          .widget<EditableText>(
            find.descendant(
              of: find.byKey(const ValueKey('observacao_individual')),
              matching: find.byType(EditableText),
            ),
          )
          .focusNode
          .hasFocus,
      isTrue,
    );
    await tester.tap(find.text('Registrar'));
    await tester.pumpAndSettle();
    expect(resultado?.valorTotalCentavos, 4000);
    expect(resultado?.quantidadeViagens, 1);
    expect(tester.takeException(), isNull);

    resultado = null;
    await tester.tap(find.text('Abrir ganho'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(resultado, isNull);
    expect(tester.takeException(), isNull);
  });
}
