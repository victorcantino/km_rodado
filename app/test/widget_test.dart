import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:km_rodado/features/jornada/presentation/widgets/abrir_jornada_dialog.dart';

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
}
