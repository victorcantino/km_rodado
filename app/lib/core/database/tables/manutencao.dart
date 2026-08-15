import 'package:drift/drift.dart';

import 'veiculo.dart';

@DataClassName('Manutencao')
class Manutencoes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get veiculoId => integer().references(Veiculos, #id)();
  DateTimeColumn get dataHora => dateTime()();
  IntColumn get odometro => integer()();
  TextColumn get oficina => text().nullable()();
  TextColumn get observacao => text().nullable()();
  DateTimeColumn get dataCriacao =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get dataAtualizacao => dateTime().nullable()();

  @override
  List<String> get customConstraints => ['CHECK (odometro >= 0)'];
}
