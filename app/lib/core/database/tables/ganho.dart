import 'package:drift/drift.dart';

import 'pausa.dart';
import 'plataforma.dart';

class Ganhos extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get pausaId => integer().references(Pausas, #id)();

  IntColumn get plataformaId => integer().references(Plataformas, #id)();

  RealColumn get valor => real()();

  IntColumn get quantidadeCorridas =>
      integer().withDefault(const Constant(0))();

  BoolColumn get registroFinal =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get dataCriacao =>
      dateTime().withDefault(currentDateAndTime)();
}
