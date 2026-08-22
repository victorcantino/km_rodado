import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/planejamento_mensal.dart';

part 'planejamento_mensal_dao.g.dart';

@DriftAccessor(tables: [PlanejamentosMensais])
class PlanejamentoMensalDao extends DatabaseAccessor<AppDatabase>
    with _$PlanejamentoMensalDaoMixin {
  PlanejamentoMensalDao(super.db);

  Future<PlanejamentoMensal?> buscar(int usuarioId, DateTime mes) {
    return (select(planejamentosMensais)..where(
          (p) => p.usuarioId.equals(usuarioId) & p.mesReferencia.equals(mes),
        ))
        .getSingleOrNull();
  }

  Future<int> inserir(PlanejamentosMensaisCompanion planejamento) {
    return into(planejamentosMensais).insert(planejamento);
  }

  Future<bool> atualizar(PlanejamentoMensal planejamento) {
    return update(planejamentosMensais).replace(planejamento);
  }
}
