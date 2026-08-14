import 'package:drift/drift.dart';

import 'jornada.dart';
import 'plataforma.dart';

class PassesPlataforma extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get plataformaId => integer().references(Plataformas, #id)();
  IntColumn get jornadaId => integer().nullable().references(Jornadas, #id)();
  DateTimeColumn get dataHora => dateTime()();
  IntColumn get valorPagoCentavos => integer()();
  TextColumn get modalidade => text().nullable()();
  DateTimeColumn get validadeAte => dateTime().nullable()();
  IntColumn get limiteFaturamentoCentavos => integer().nullable()();
  TextColumn get observacao => text().nullable()();
  DateTimeColumn get dataCriacao =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => [
    'CHECK (valor_pago_centavos > 0)',
    'CHECK (limite_faturamento_centavos IS NULL OR '
        'limite_faturamento_centavos >= 0)',
  ];
}
