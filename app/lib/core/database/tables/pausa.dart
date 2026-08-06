import 'package:drift/drift.dart';

import 'jornada.dart';

class Pausas extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get jornadaId => integer().references(Jornadas, #id)();

  DateTimeColumn get inicio => dateTime()();

  DateTimeColumn get fim => dateTime().nullable()();

  TextColumn get motivo => text().nullable()();

  TextColumn get observacao => text().nullable()();

  DateTimeColumn get dataCriacao =>
      dateTime().withDefault(currentDateAndTime)();

  BoolColumn get registrarGanhos =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get concluida => boolean().withDefault(const Constant(false))();
}
