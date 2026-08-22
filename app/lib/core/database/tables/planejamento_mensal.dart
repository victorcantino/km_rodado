import 'package:drift/drift.dart';

import 'usuario.dart';

@DataClassName('PlanejamentoMensal')
class PlanejamentosMensais extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get usuarioId => integer().references(Usuarios, #id)();

  DateTimeColumn get mesReferencia => dateTime()();

  IntColumn get diasPlanejados => integer()();

  IntColumn get metaKmMensal => integer()();

  List<Index> get indexes => [
    Index(
      'idx_planejamento_mensal_usuario_mes',
      'CREATE UNIQUE INDEX idx_planejamento_mensal_usuario_mes '
          'ON planejamentos_mensais (usuario_id, mes_referencia)',
    ),
  ];
}
