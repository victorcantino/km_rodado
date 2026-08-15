import 'package:drift/drift.dart';

import 'manutencao.dart';

@DataClassName('ItemManutencao')
class ItensManutencao extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get manutencaoId =>
      integer().references(Manutencoes, #id, onDelete: KeyAction.cascade)();
  TextColumn get descricao => text()();
  IntColumn get valorCentavos => integer().nullable()();
  IntColumn get intervaloKm => integer().nullable()();
  DateTimeColumn get vencimentoEm => dateTime().nullable()();
  DateTimeColumn get dataCriacao =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get dataAtualizacao => dateTime().nullable()();

  @override
  List<String> get customConstraints => [
    'CHECK (valor_centavos IS NULL OR valor_centavos >= 0)',
    'CHECK (intervalo_km IS NULL OR intervalo_km > 0)',
  ];
}
