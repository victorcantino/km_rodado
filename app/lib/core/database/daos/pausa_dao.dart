import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/pausa.dart';

part 'pausa_dao.g.dart';

@DriftAccessor(tables: [Pausas])
class PausaDao extends DatabaseAccessor<AppDatabase> with _$PausaDaoMixin {
  PausaDao(super.db);

  Future<Pausa?> buscarAbertaPorJornada(int jornadaId) {
    return (select(pausas)
          ..where(
            (pausa) => pausa.jornadaId.equals(jornadaId) & pausa.fim.isNull(),
          )
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<Pausa>> listarPorJornada(int jornadaId) {
    return (select(pausas)
          ..where((pausa) => pausa.jornadaId.equals(jornadaId))
          ..orderBy([
            (pausa) => OrderingTerm.asc(pausa.inicio),
            (pausa) => OrderingTerm.asc(pausa.id),
          ]))
        .get();
  }

  Future<int?> inserirSeNaoHouverAberta(PausasCompanion pausa) {
    return transaction(() async {
      final aberta = await buscarAbertaPorJornada(pausa.jornadaId.value);

      if (aberta != null) {
        return null;
      }

      return into(pausas).insert(pausa);
    });
  }

  Future<bool> atualizar(Pausa pausa) {
    return update(pausas).replace(pausa);
  }
}
