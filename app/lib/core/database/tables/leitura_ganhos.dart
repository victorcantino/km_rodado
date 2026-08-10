import 'package:drift/drift.dart';

import '../../constants/enums/tipo_leitura_ganhos.dart';
import 'jornada.dart';
import 'pausa.dart';

class LeiturasGanhos extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get jornadaId => integer().references(Jornadas, #id)();

  IntColumn get pausaId => integer().nullable().references(Pausas, #id)();

  DateTimeColumn get dataHora => dateTime()();

  TextColumn get tipo => textEnum<TipoLeituraGanhos>()();

  DateTimeColumn get dataCriacao =>
      dateTime().withDefault(currentDateAndTime)();

  List<Index> get indexes => [
    Index(
      'idx_leituras_ganhos_jornada_data_hora',
      'CREATE INDEX idx_leituras_ganhos_jornada_data_hora '
          'ON leituras_ganhos (jornada_id, data_hora)',
    ),
  ];
}
