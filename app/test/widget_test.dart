import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:km_rodado/features/jornada/presentation/widgets/abrir_jornada_dialog.dart';
import 'package:km_rodado/features/jornada/presentation/widgets/fechar_jornada_dialog.dart';

void main() {
  testWidgets('exibe os campos e ações para abrir jornada', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: AbrirJornadaDialog())),
    );

    expect(find.text('Abrir Jornada'), findsOneWidget);
    expect(find.text('Odômetro'), findsOneWidget);
    expect(find.text('Cidade'), findsOneWidget);
    expect(find.text('Cancelar'), findsOneWidget);
    expect(find.text('Salvar'), findsOneWidget);
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

    expect(campos.elementAt(0).controller!.text, '152184');
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
    expect(resultado, (odometro: 152184, cidadeOrigem: 'Curitiba'));

    await tester.tap(find.text('Exibir progressão'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '152185');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(resultado, (odometro: 152185, cidadeOrigem: 'Curitiba'));
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

    expect(resultado, (odometro: 12345, cidadeOrigem: 'São Paulo'));
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
    expect(campoCidade.controller!.text, 'São Paulo');
  });

  testWidgets('valida odômetro final', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: FecharJornadaDialog(odometroInicio: 100)),
      ),
    );

    final campoOdometro = find.byType(TextFormField).first;

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

    await tester.enterText(campoOdometro, '100');
    await tester.tap(find.text('Confirmar'));
    await tester.pump();
    expect(
      find.text('O odômetro final deve ser maior que o inicial.'),
      findsOneWidget,
    );

    await tester.enterText(campoOdometro, '99');
    await tester.tap(find.text('Confirmar'));
    await tester.pump();
    expect(
      find.text('O odômetro final deve ser maior que o inicial.'),
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

    expect(resultado, (
      odometroFim: 150,
      cidadeDestino: 'Campinas',
      observacoes: 'Dia produtivo',
    ));
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
    expect(resultado, (
      odometroFim: 101,
      cidadeDestino: null,
      observacoes: null,
    ));

    dialogoConcluido = false;
    await tester.tap(find.text('Exibir fechamento'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(dialogoConcluido, isTrue);
    expect(resultado, isNull);
  });
}
