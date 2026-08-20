import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:drift/drift.dart' hide Column, isNull;
import 'package:drift/native.dart';

import 'package:km_rodado/core/constants/enums/status_jornada.dart';
import 'package:km_rodado/core/constants/enums/tipo_leitura_ganhos.dart';
import 'package:km_rodado/core/constants/enums/tipo_registro_ganhos.dart';
import 'package:km_rodado/core/database/app_database.dart';
import 'package:km_rodado/core/database/seeds/seed.dart';
import 'package:km_rodado/features/jornada/presentation/pages/jornada_page.dart';
import 'package:km_rodado/features/jornada/presentation/widgets/abrir_jornada_dialog.dart';
import 'package:km_rodado/features/jornada/presentation/widgets/fechar_jornada_dialog.dart';
import 'package:km_rodado/features/jornada/presentation/widgets/editar_jornada_dialog.dart';
import 'package:km_rodado/features/pausa/presentation/widgets/odometro_pausa_dialog.dart';

void main() {
  testWidgets('Jornada aberta mostra resumo intraday do último checkpoint', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    await garantirDadosTemporarios(database);
    final jornadaId = await database
        .into(database.jornadas)
        .insert(
          JornadasCompanion.insert(
            usuarioId: 1,
            veiculoId: 1,
            dataHoraInicio: DateTime(2026, 8, 18, 7),
            odometroInicio: 1000,
            cidadeOrigem: 'Curitiba',
            status: StatusJornada.aberta,
          ),
        );
    final uberId = await database
        .into(database.plataformas)
        .insert(
          PlataformasCompanion.insert(
            nome: 'Uber',
            tipoRegistroGanhos: TipoRegistroGanhos.acumulado,
          ),
        );
    final inicialId = await database
        .into(database.leiturasGanhos)
        .insert(
          LeiturasGanhosCompanion.insert(
            jornadaId: jornadaId,
            dataHora: DateTime(2026, 8, 18, 7),
            tipo: TipoLeituraGanhos.inicial,
          ),
        );
    await database
        .into(database.leiturasGanhoPlataforma)
        .insert(
          LeiturasGanhoPlataformaCompanion.insert(
            leituraGanhosId: inicialId,
            plataformaId: uberId,
            valorAcumuladoCentavos: 0,
            quantidadeViagensAcumulada: 0,
          ),
        );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [Locale('pt', 'BR')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: JornadaPage(databaseFactory: () => database),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('resumo_intraday')),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();

    expect(find.byKey(const ValueKey('resumo_intraday')), findsOneWidget);
    expect(find.text('Jornada iniciada às 07:00'), findsOneWidget);
    expect(find.text('Aguardando primeira atualização.'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await database.close();
  });

  testWidgets('JornadaPage respeita área segura inferior em viewport pequena', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    await garantirDadosTemporarios(database);
    await database
        .into(database.jornadas)
        .insert(
          JornadasCompanion.insert(
            usuarioId: 1,
            veiculoId: 1,
            dataHoraInicio: DateTime(2026, 8, 15, 8),
            dataHoraFim: Value(DateTime(2026, 8, 15, 9)),
            odometroInicio: 100,
            odometroFim: const Value(100),
            cidadeOrigem: 'Curitiba',
            cidadeDestino: const Value('Curitiba'),
            status: StatusJornada.finalizada,
            quilometrosPercorridos: const Value(0),
          ),
        );
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(320, 400),
            padding: EdgeInsets.zero,
            viewPadding: EdgeInsets.only(bottom: 48),
            viewInsets: EdgeInsets.zero,
          ),
          child: JornadaPage(databaseFactory: () => database),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('jornada_safe_area')), findsOneWidget);
    final safeArea = tester.widget<SafeArea>(
      find.byKey(const ValueKey('jornada_safe_area')),
    );
    expect(safeArea.bottom, isFalse);
    final lista = tester.widget<ListView>(find.byType(ListView).first);
    expect(lista.padding, const EdgeInsets.fromLTRB(16, 16, 16, 64));
    await tester.scrollUntilVisible(
      find.text('Abrir Jornada'),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    expect(tester.getBottomRight(find.text('Abrir Jornada')).dy, lessThan(352));
  });

  testWidgets('ações do veículo usam ícones empilhados, tooltip e semântica', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    await garantirDadosTemporarios(database);

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(320, 480),
            viewPadding: EdgeInsets.only(bottom: 48),
          ),
          child: JornadaPage(databaseFactory: () => database),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final despesas = find.byIcon(Icons.receipt_long_outlined);
    final manutencao = find.byIcon(Icons.build_outlined);
    final abastecimento = find.byIcon(Icons.local_gas_station);
    expect(despesas, findsOneWidget);
    expect(manutencao, findsOneWidget);
    expect(abastecimento, findsOneWidget);
    expect(
      find.descendant(of: find.byType(AppBar), matching: manutencao),
      findsNothing,
    );
    expect(find.byTooltip('Despesas'), findsOneWidget);
    expect(find.byTooltip('Manutenções'), findsOneWidget);
    expect(find.byTooltip('Abastecimento'), findsOneWidget);
    expect(find.text('Despesas'), findsNothing);
    expect(find.text('Manutenções'), findsNothing);
    expect(find.text('Abastecimento'), findsNothing);
    expect(
      tester.getCenter(despesas).dy,
      lessThan(tester.getCenter(manutencao).dy),
    );
    expect(
      tester.getCenter(manutencao).dy,
      lessThan(tester.getCenter(abastecimento).dy),
    );
    expect(
      tester.getSize(find.byType(FloatingActionButton).first).width,
      greaterThanOrEqualTo(48),
    );
    expect(tester.getBottomRight(abastecimento).dy, lessThanOrEqualTo(432));

    final semantics = tester.ensureSemantics();
    expect(find.bySemanticsLabel('Despesas'), findsOneWidget);
    expect(find.bySemanticsLabel('Manutenções'), findsOneWidget);
    expect(find.bySemanticsLabel('Abastecimento'), findsOneWidget);

    await tester.tap(despesas);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Despesas do veículo'),
      400,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Despesas do veículo'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Custos recorrentes'),
      400,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Custos recorrentes'), findsOneWidget);
    expect(find.byKey(const ValueKey('despesas_scroll_unico')), findsOneWidget);
    expect(find.byTooltip('Novo custo recorrente'), findsOneWidget);
    expect(find.byTooltip('Nova despesa'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNWidgets(2));
    expect(
      tester.getCenter(find.byTooltip('Novo custo recorrente')).dy,
      lessThan(tester.getCenter(find.byTooltip('Nova despesa')).dy),
    );
    expect(find.bySemanticsLabel('Novo custo recorrente'), findsOneWidget);
    expect(find.bySemanticsLabel('Nova despesa'), findsOneWidget);

    await tester.tap(find.byTooltip('Novo custo recorrente'));
    await tester.pumpAndSettle();
    expect(find.text('Novo custo recorrente'), findsOneWidget);
    expect(find.text('IPVA'), findsWidgets);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Nova despesa'));
    await tester.pumpAndSettle();
    expect(find.text('Nova despesa'), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.longPress(manutencao);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Manutenções'), findsOneWidget);
    await tester.tapAt(const Offset(10, 100));
    await tester.pumpAndSettle();

    await tester.tap(manutencao);
    await tester.pumpAndSettle();
    expect(find.text('Manutenções'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(abastecimento);
    await tester.pumpAndSettle();
    expect(find.text('Registrar abastecimento'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('exibe os campos e ações para abrir jornada', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: AbrirJornadaDialog())),
    );

    expect(find.text('Abrir Jornada'), findsOneWidget);
    expect(find.text('Odômetro'), findsOneWidget);
    expect(find.text('Cidade'), findsOneWidget);
    expect(find.text('Cancelar'), findsOneWidget);
    expect(find.text('Salvar'), findsOneWidget);
    expect(
      tester
          .widget<EditableText>(find.byType(EditableText).first)
          .focusNode
          .hasFocus,
      isTrue,
    );
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pump();
    expect(
      tester
          .widget<EditableText>(find.byType(EditableText).at(1))
          .focusNode
          .hasFocus,
      isTrue,
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    for (final campo in tester.widgetList<EditableText>(
      find.byType(EditableText),
    )) {
      expect(campo.focusNode.hasFocus, isFalse);
    }
  });

  testWidgets('odômetro da Pausa recebe foco e fecha sem exceções', (
    tester,
  ) async {
    int? resultado;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                resultado = await showDialog<int>(
                  context: context,
                  builder: (_) => const OdometroPausaDialog(
                    titulo: 'Iniciar Pausa',
                    odometroMinimo: 152184,
                  ),
                );
              },
              child: const Text('Abrir odômetro'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Abrir odômetro'));
    await tester.pumpAndSettle();
    final campo = tester.widget<EditableText>(find.byType(EditableText));
    expect(campo.focusNode.hasFocus, isTrue);
    expect(campo.selectAllOnFocus, isTrue);
    await tester.enterText(find.byType(TextFormField), '152185');
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();
    expect(resultado, 152185);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Abrir odômetro'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('preenche odômetro e cidade de origem sugeridos', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AbrirJornadaDialog(
            odometroInicial: 152184,
            odometroMinimo: 152184,
            cidadeOrigemInicial: 'Curitiba',
          ),
        ),
      ),
    );

    final campos = tester.widgetList<TextFormField>(find.byType(TextFormField));

    expect(campos.elementAt(0).controller!.text, '152.184');
    expect(campos.elementAt(1).controller!.text, 'Curitiba');
  });

  testWidgets('valida progressão do odômetro inicial', (tester) async {
    AbrirJornadaResultado? resultado;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                resultado = await showDialog<AbrirJornadaResultado>(
                  context: context,
                  builder: (context) => const AbrirJornadaDialog(
                    odometroInicial: 152184,
                    odometroMinimo: 152184,
                    cidadeOrigemInicial: 'Curitiba',
                  ),
                );
              },
              child: const Text('Exibir progressão'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Exibir progressão'));
    await tester.pumpAndSettle();
    final campoOdometro = find.byType(TextFormField).first;

    await tester.enterText(campoOdometro, '152183');
    await tester.tap(find.text('Salvar'));
    await tester.pump();
    expect(
      find.text('O odômetro não pode ser menor que o último registrado.'),
      findsOneWidget,
    );

    await tester.enterText(campoOdometro, '152184');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(resultado?.odometro, 152184);
    expect(resultado?.cidadeOrigem, 'Curitiba');

    await tester.tap(find.text('Exibir progressão'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '152185');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(resultado?.odometro, 152185);
    expect(resultado?.cidadeOrigem, 'Curitiba');
  });

  testWidgets('valida os campos obrigatórios', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: AbrirJornadaDialog())),
    );

    await tester.tap(find.text('Salvar'));
    await tester.pump();

    expect(find.text('Informe o odômetro.'), findsOneWidget);
    expect(find.text('Informe a cidade de origem.'), findsOneWidget);
  });

  testWidgets('valida odômetro inválido e negativo', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: AbrirJornadaDialog())),
    );

    final campoOdometro = find.byType(TextFormField).first;

    await tester.enterText(campoOdometro, 'inválido');
    await tester.enterText(find.byType(TextFormField).last, 'São Paulo');
    await tester.tap(find.text('Salvar'));
    await tester.pump();

    expect(find.text('Informe um número inteiro válido.'), findsOneWidget);

    await tester.enterText(campoOdometro, '-1');
    await tester.tap(find.text('Salvar'));
    await tester.pump();

    expect(find.text('O odômetro não pode ser negativo.'), findsOneWidget);
  });

  testWidgets('retorna odômetro e cidade de origem válidos', (tester) async {
    AbrirJornadaResultado? resultado;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                resultado = await showDialog<AbrirJornadaResultado>(
                  context: context,
                  builder: (context) => const AbrirJornadaDialog(),
                );
              },
              child: const Text('Exibir diálogo'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Exibir diálogo'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '12345');
    await tester.enterText(find.byType(TextFormField).last, '  São Paulo  ');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    expect(resultado?.odometro, 12345);
    expect(resultado?.cidadeOrigem, 'São Paulo');
  });

  testWidgets('retorna nulo ao cancelar', (tester) async {
    AbrirJornadaResultado? resultado;
    var dialogoConcluido = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                resultado = await showDialog<AbrirJornadaResultado>(
                  context: context,
                  builder: (context) => const AbrirJornadaDialog(),
                );
                dialogoConcluido = true;
              },
              child: const Text('Exibir diálogo'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Exibir diálogo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(dialogoConcluido, isTrue);
    expect(resultado, isNull);
  });

  testWidgets('exibe diálogo de fechamento com destino sugerido', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: FecharJornadaDialog(
            odometroInicio: 100,
            cidadeDestinoInicial: 'São Paulo',
          ),
        ),
      ),
    );

    expect(find.text('Fechar Jornada'), findsOneWidget);
    expect(find.text('Odômetro final'), findsOneWidget);
    expect(find.text('Cidade de destino (opcional)'), findsOneWidget);
    expect(find.text('Observações (opcional)'), findsOneWidget);

    final campoCidade = tester.widget<TextFormField>(
      find.byType(TextFormField).at(1),
    );
    final campoOdometro = tester.widget<TextFormField>(
      find.byType(TextFormField).first,
    );
    expect(campoOdometro.controller!.text, '100');
    final campoEditavel = tester.widget<EditableText>(
      find.byType(EditableText).first,
    );
    expect(campoEditavel.focusNode.hasFocus, isTrue);
    expect(campoCidade.controller!.text, 'São Paulo');
  });

  testWidgets('valida odômetro final', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: FecharJornadaDialog(odometroInicio: 100)),
      ),
    );

    final campoOdometro = find.byType(TextFormField).first;

    await tester.enterText(campoOdometro, '');
    await tester.tap(find.text('Confirmar'));
    await tester.pump();
    expect(find.text('Informe o odômetro final.'), findsOneWidget);

    await tester.enterText(campoOdometro, 'inválido');
    await tester.tap(find.text('Confirmar'));
    await tester.pump();
    expect(find.text('Informe um número inteiro válido.'), findsOneWidget);

    await tester.enterText(campoOdometro, '-1');
    await tester.tap(find.text('Confirmar'));
    await tester.pump();
    expect(find.text('O odômetro não pode ser negativo.'), findsOneWidget);

    await tester.enterText(campoOdometro, '99');
    await tester.tap(find.text('Confirmar'));
    await tester.pump();
    expect(
      find.text('O odômetro final não pode ser menor que o inicial.'),
      findsOneWidget,
    );
  });

  testWidgets('retorna fechamento válido com campos opcionais', (tester) async {
    FecharJornadaResultado? resultado;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                resultado = await showDialog<FecharJornadaResultado>(
                  context: context,
                  builder: (context) => const FecharJornadaDialog(
                    odometroInicio: 100,
                    cidadeDestinoInicial: 'São Paulo',
                  ),
                );
              },
              child: const Text('Exibir fechamento'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Exibir fechamento'));
    await tester.pumpAndSettle();
    final campos = find.byType(TextFormField);
    await tester.enterText(campos.at(0), '150');
    await tester.enterText(campos.at(1), '  Campinas  ');
    await tester.enterText(campos.at(2), '  Dia produtivo  ');
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();

    expect(resultado?.odometroFim, 150);
    expect(resultado?.cidadeDestino, 'Campinas');
    expect(resultado?.observacoes, 'Dia produtivo');
  });

  testWidgets('retorna opcionais nulos e permite cancelar', (tester) async {
    FecharJornadaResultado? resultado;
    var dialogoConcluido = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    resultado = await showDialog<FecharJornadaResultado>(
                      context: context,
                      builder: (context) =>
                          const FecharJornadaDialog(odometroInicio: 100),
                    );
                    dialogoConcluido = true;
                  },
                  child: const Text('Exibir fechamento'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Exibir fechamento'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '101');
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();
    expect(resultado?.odometroFim, 101);
    expect(resultado?.cidadeDestino, null);
    expect(resultado?.observacoes, null);

    dialogoConcluido = false;
    await tester.tap(find.text('Exibir fechamento'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(dialogoConcluido, isTrue);
    expect(resultado, isNull);
  });

  testWidgets('edição abre preenchida, localizada e preserva Próximo', (
    tester,
  ) async {
    final jornada = Jornada(
      id: 1,
      usuarioId: 1,
      veiculoId: 1,
      dataHoraInicio: DateTime(2026, 8, 14, 8),
      dataHoraFim: DateTime(2026, 8, 14, 18),
      odometroInicio: 1000,
      odometroFim: 1100,
      cidadeOrigem: 'Ponta Grossa',
      cidadeDestino: 'Curitiba',
      status: StatusJornada.finalizada,
      odometroAlterado: false,
      observacoes: 'Teste',
      dataCriacao: DateTime(2026, 8, 14),
      dataAtualizacao: DateTime(2026, 8, 14),
      quilometrosPercorridos: 100,
    );
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [Locale('pt', 'BR')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: EditarJornadaDialog(jornada: jornada),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('14/08/2026'), findsNWidgets(2));
    expect(find.text('Ponta Grossa'), findsOneWidget);
    expect(find.text('Curitiba'), findsOneWidget);
    final inicio = find.byKey(const ValueKey('editar_odometro_inicio_jornada'));
    expect(
      tester
          .widget<EditableText>(
            find.descendant(of: inicio, matching: find.byType(EditableText)),
          )
          .focusNode
          .hasFocus,
      isTrue,
    );
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pump();
    expect(
      tester
          .widgetList<EditableText>(find.byType(EditableText))
          .elementAt(1)
          .focusNode
          .hasFocus,
      isTrue,
    );
  });
}
