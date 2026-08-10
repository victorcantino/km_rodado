import 'package:drift/drift.dart';

import 'leitura_ganhos.dart';
import 'plataforma.dart';

class LeiturasGanhoPlataforma extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get leituraGanhosId => integer().references(LeiturasGanhos, #id)();

  IntColumn get plataformaId => integer().references(Plataformas, #id)();

  IntColumn get valorAcumuladoCentavos => integer()();

  IntColumn get quantidadeViagensAcumulada => integer()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {leituraGanhosId, plataformaId},
  ];

  @override
  List<String> get customConstraints => [
    'CHECK (valor_acumulado_centavos >= 0)',
    'CHECK (quantidade_viagens_acumulada >= 0)',
  ];
}
