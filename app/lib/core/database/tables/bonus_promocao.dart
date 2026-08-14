import 'package:drift/drift.dart';

import '../../constants/enums/tipo_bonus_promocao.dart';
import 'jornada.dart';
import 'plataforma.dart';

@DataClassName('BonusPromocao')
class BonusPromocoes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get plataformaId => integer().references(Plataformas, #id)();
  IntColumn get jornadaId => integer().nullable().references(Jornadas, #id)();
  DateTimeColumn get dataHora => dateTime()();
  IntColumn get valorCentavos => integer()();
  TextColumn get tipo => textEnum<TipoBonusPromocao>()();
  TextColumn get observacao => text().nullable()();
  DateTimeColumn get dataCriacao =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => ['CHECK (valor_centavos > 0)'];
}
