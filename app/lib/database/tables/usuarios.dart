import 'package:drift/drift.dart';

class Usuarios extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get nome => text()();

  TextColumn get email => text().nullable()();

  DateTimeColumn get dataCriacao =>
      dateTime().withDefault(currentDateAndTime)();
}