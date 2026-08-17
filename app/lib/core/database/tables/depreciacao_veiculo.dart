import 'package:drift/drift.dart';

import '../../constants/enums/fonte_referencia_depreciacao.dart';
import '../../constants/enums/metodo_depreciacao.dart';
import 'veiculo.dart';

@DataClassName('DepreciacaoVeiculo')
class DepreciacoesVeiculo extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get veiculoId => integer().unique().references(Veiculos, #id)();
  TextColumn get metodoSelecionado =>
      textEnum<MetodoDepreciacao>().nullable()();
  IntColumn get valorAquisicaoCentavos => integer().nullable()();
  BoolColumn get valorAquisicaoEstimado =>
      boolean().withDefault(const Constant(false))();
  IntColumn get odometroAquisicao => integer().nullable()();
  IntColumn get valorReferenciaCentavos => integer().nullable()();
  BoolColumn get valorReferenciaEstimado =>
      boolean().withDefault(const Constant(false))();
  TextColumn get fonteReferencia =>
      textEnum<FonteReferenciaDepreciacao>().nullable()();
  DateTimeColumn get dataReferencia => dateTime().nullable()();
  IntColumn get odometroReferencia => integer().nullable()();
  IntColumn get valorVendaProjetadoCentavos => integer().nullable()();
  BoolColumn get valorVendaProjetadoEstimado =>
      boolean().withDefault(const Constant(false))();
  IntColumn get odometroVendaProjetado => integer().nullable()();
  DateTimeColumn get dataCriacao =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get dataAtualizacao => dateTime().nullable()();

  @override
  List<String> get customConstraints => [
    'CHECK (valor_aquisicao_centavos IS NULL OR valor_aquisicao_centavos > 0)',
    'CHECK (odometro_aquisicao IS NULL OR odometro_aquisicao >= 0)',
    'CHECK (valor_referencia_centavos IS NULL OR valor_referencia_centavos > 0)',
    'CHECK (odometro_referencia IS NULL OR odometro_referencia >= 0)',
    'CHECK (valor_venda_projetado_centavos IS NULL OR valor_venda_projetado_centavos > 0)',
    'CHECK (odometro_venda_projetado IS NULL OR odometro_venda_projetado >= 0)',
  ];
}
