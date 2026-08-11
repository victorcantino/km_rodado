import 'package:drift/drift.dart';

import 'jornada.dart';

class Pausas extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get jornadaId => integer().references(Jornadas, #id)();

  DateTimeColumn get inicio => dateTime()();

  DateTimeColumn get fim => dateTime().nullable()();

  IntColumn get odometroInicio => integer().nullable()();

  IntColumn get odometroFim => integer().nullable()();

  TextColumn get titulo => text().nullable()();

  TextColumn get observacao => text().nullable()();

  DateTimeColumn get dataCriacao =>
      dateTime().withDefault(currentDateAndTime)();
}
