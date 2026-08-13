import 'package:drift/drift.dart';

import '../../constants/enums/tipo_combustivel.dart';
import 'jornada.dart';
import 'veiculo.dart';

class Abastecimentos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get veiculoId => integer().references(Veiculos, #id)();
  IntColumn get jornadaId => integer().nullable().references(Jornadas, #id)();
  DateTimeColumn get dataHora => dateTime()();
  IntColumn get odometro => integer()();
  TextColumn get tipoCombustivel => textEnum<TipoCombustivel>()();
  IntColumn get volumeMililitros => integer()();
  IntColumn get valorTotalPagoCentavos => integer()();
  IntColumn get precoBombaMilesimosRealPorLitro => integer().nullable()();
  BoolColumn get tanqueCheio => boolean().withDefault(const Constant(true))();
  TextColumn get cidade => text().nullable()();
  TextColumn get nomePosto => text().nullable()();
  TextColumn get bandeiraPosto => text().nullable()();
  TextColumn get observacao => text().nullable()();
  DateTimeColumn get dataCriacao =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => [
    'CHECK (odometro >= 0)',
    'CHECK (volume_mililitros > 0)',
    'CHECK (valor_total_pago_centavos >= 0)',
    'CHECK (preco_bomba_milesimos_real_por_litro IS NULL OR '
        'preco_bomba_milesimos_real_por_litro >= 0)',
  ];
}
