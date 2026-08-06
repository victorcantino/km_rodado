import 'package:drift/drift.dart';

import 'jornada.dart';
import 'veiculo.dart';
import 'usuario.dart';
// TODO import '../../constants/enums/categoria_evento.dart';

class EventosFinanceiros extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get usuarioId => integer().references(Usuarios, #id)();

  IntColumn get veiculoId => integer().references(Veiculos, #id)();

  IntColumn get jornadaId => integer().nullable().references(Jornadas, #id)();

  // TODO TextColumn get categoria => textEnum<CategoriaEvento>()();

  RealColumn get valor => real()();

  TextColumn get descricao => text().nullable()();

  DateTimeColumn get dataHora => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get dataCriacao =>
      dateTime().withDefault(currentDateAndTime)();
}
