import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/jornada.dart';
import '../../constants/enums/status_jornada.dart';

part 'jornada_dao.g.dart';

@DriftAccessor(tables: [Jornadas])
class JornadaDao extends DatabaseAccessor<AppDatabase> with _$JornadaDaoMixin {
  JornadaDao(super.db);

  /// Retorna a jornada aberta, se existir.
  Future<Jornada?> buscarJornadaAberta() {
    return (select(jornadas)
          ..where((j) => j.status.equalsValue(StatusJornada.aberta)))
        .getSingleOrNull();
  }

  /// Retorna a Jornada finalizada mais recentemente, se existir.
  Future<Jornada?> buscarUltimaJornadaFinalizada() {
    return (select(jornadas)
          ..where((j) => j.status.equalsValue(StatusJornada.finalizada))
          ..orderBy([(j) => OrderingTerm.desc(j.dataHoraFim)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Insere uma nova jornada.
  Future<int> inserir(JornadasCompanion jornada) {
    return into(jornadas).insert(jornada);
  }

  /// Atualiza uma jornada.
  Future<bool> atualizar(Jornada jornada) {
    return update(jornadas).replace(jornada);
  }

  /// Remove uma jornada.
  Future<int> remover(int id) {
    return (delete(jornadas)..where((j) => j.id.equals(id))).go();
  }

  /// Lista todas as jornadas.
  Future<List<Jornada>> listar() {
    return select(jornadas).get();
  }

  /// Observa todas as jornadas em tempo real.
  Stream<List<Jornada>> observar() {
    return select(jornadas).watch();
  }
}
