import 'package:drift/drift.dart';

class Plataformas extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get nome => text()();

  TextColumn get icone => text().nullable()();

  TextColumn get cor => text().nullable()();

  BoolColumn get ativa => boolean().withDefault(const Constant(true))();

  IntColumn get ordem => integer().withDefault(const Constant(0))();

  DateTimeColumn get dataCriacao =>
      dateTime().withDefault(currentDateAndTime)();
}
