import 'package:drift/drift.dart';

import 'usuario.dart';
import 'veiculo.dart';
import '../../constants/enums/status_jornada.dart';

class Jornadas extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get usuarioId => integer().references(Usuarios, #id)();

  IntColumn get veiculoId => integer().references(Veiculos, #id)();

  DateTimeColumn get dataHoraInicio => dateTime()();

  DateTimeColumn get dataHoraFim => dateTime().nullable()();

  IntColumn get odometroInicio => integer()();

  IntColumn get odometroFim => integer().nullable()();

  TextColumn get cidadeOrigem => text()();

  TextColumn get cidadeDestino => text().nullable()();

  TextColumn get status => textEnum<StatusJornada>()();

  BoolColumn get odometroAlterado =>
      boolean().withDefault(const Constant(false))();

  TextColumn get observacoes => text().nullable()();

  DateTimeColumn get dataCriacao =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get dataAtualizacao =>
      dateTime().withDefault(currentDateAndTime)();

  List<Index> get indexes => [
    Index(
      'idx_jornada_status',
      'CREATE INDEX idx_jornada_status ON jornadas (status)',
    ),
  ];

  IntColumn get quilometrosPercorridos => integer().nullable()();
}
