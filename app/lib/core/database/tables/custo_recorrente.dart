import 'package:drift/drift.dart';

import '../../constants/enums/escopo_custo_recorrente.dart';
import '../../constants/enums/tipo_custo_recorrente.dart';
import 'plataforma.dart';
import 'veiculo.dart';

@DataClassName('CustoRecorrente')
class CustosRecorrentes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tipo => textEnum<TipoCustoRecorrente>()();
  TextColumn get descricao => text()();
  TextColumn get escopo => textEnum<EscopoCustoRecorrente>()();
  IntColumn get veiculoId => integer().nullable().references(Veiculos, #id)();
  IntColumn get plataformaId =>
      integer().nullable().references(Plataformas, #id)();
  IntColumn get valorReferenciaCentavos => integer().nullable()();
  BoolColumn get valorEstimado =>
      boolean().withDefault(const Constant(false))();
  IntColumn get periodicidadeMeses => integer()();
  IntColumn get parcelasPorCiclo => integer().withDefault(const Constant(1))();
  BoolColumn get ativo => boolean().withDefault(const Constant(true))();
  IntColumn get quantidadeCiclosPrevista => integer().nullable()();
  TextColumn get observacao => text().nullable()();
  DateTimeColumn get dataCriacao =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get dataAtualizacao => dateTime().nullable()();

  @override
  List<String> get customConstraints => [
    'CHECK (valor_referencia_centavos IS NULL OR valor_referencia_centavos > 0)',
    'CHECK (periodicidade_meses > 0)',
    'CHECK (parcelas_por_ciclo >= 1)',
    'CHECK (quantidade_ciclos_prevista IS NULL OR quantidade_ciclos_prevista > 0)',
    "CHECK ((escopo = 'veiculo' AND veiculo_id IS NOT NULL AND plataforma_id IS NULL) OR "
        "(escopo = 'atividade' AND veiculo_id IS NULL AND plataforma_id IS NULL) OR "
        "(escopo = 'plataforma' AND veiculo_id IS NULL AND plataforma_id IS NOT NULL))",
  ];
}
