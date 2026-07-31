import 'package:drift/drift.dart';

class Usuarios extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get nome => text().withLength(min: 3, max: 100)();

  TextColumn get email => text().nullable()();

  TextColumn get senha => text().nullable()();

  DateTimeColumn get dataCriacao =>
      dateTime().withDefault(currentDateAndTime)();

  BoolColumn get ativo =>
      boolean().withDefault(const Constant(true))();
}