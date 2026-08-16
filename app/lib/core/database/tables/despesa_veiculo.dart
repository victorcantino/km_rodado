import 'package:drift/drift.dart';

import '../../constants/enums/tipo_despesa_veiculo.dart';
import 'veiculo.dart';

@DataClassName('DespesaVeiculo')
class DespesasVeiculo extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get veiculoId => integer().references(Veiculos, #id)();
  TextColumn get tipo => textEnum<TipoDespesaVeiculo>()();
  TextColumn get descricao => text()();
  IntColumn get valorCentavos => integer()();
  DateTimeColumn get dataHora => dateTime()();
  TextColumn get observacao => text().nullable()();
  DateTimeColumn get dataCriacao =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get dataAtualizacao => dateTime().nullable()();

  @override
  List<String> get customConstraints => ['CHECK (valor_centavos > 0)'];
}
