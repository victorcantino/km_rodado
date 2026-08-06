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
}
