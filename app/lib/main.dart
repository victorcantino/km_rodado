import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'features/jornada/presentation/pages/jornada_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final locale = WidgetsBinding.instance.platformDispatcher.locale;
  await initializeDateFormatting(locale.toLanguageTag());
  await initializeDateFormatting('pt_BR');

  runApp(const KmRodadoApp());
}

class KmRodadoApp extends StatelessWidget {
  const KmRodadoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KM Rodado',
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('pt', 'BR')],
      home: const JornadaPage(),
    );
  }
}
