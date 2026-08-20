import 'package:drift/drift.dart';

import 'jornada.dart';
import 'plataforma.dart';

class LancamentosGanhoIndividual extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get plataformaId => integer().references(Plataformas, #id)();

  IntColumn get jornadaId => integer().nullable().references(Jornadas, #id)();

  IntColumn get quantidadeViagens => integer()();

  IntColumn get valorTotalCentavos => integer()();

  TextColumn get observacao => text().nullable()();

  DateTimeColumn get dataHora => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get dataCriacao =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => [
    'CHECK (quantidade_viagens >= 1)',
    'CHECK (valor_total_centavos >= 0)',
  ];
}
