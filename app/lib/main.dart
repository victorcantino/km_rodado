import 'package:flutter/material.dart';

import 'features/jornada/presentation/pages/jornada_page.dart';

void main() {
  runApp(const KmRodadoApp());
}

class KmRodadoApp extends StatelessWidget {
  const KmRodadoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KM Rodado',
      home: const JornadaPage(),
    );
  }
}
