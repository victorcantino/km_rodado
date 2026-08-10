import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/jornada.dart';
import '../tables/leitura_ganho_plataforma.dart';
import '../tables/leitura_ganhos.dart';
import '../tables/pausa.dart';
import '../tables/plataforma.dart';

part 'leitura_ganhos_dao.g.dart';

@DriftAccessor(
  tables: [
    Jornadas,
    Pausas,
    Plataformas,
    LeiturasGanhos,
    LeiturasGanhoPlataforma,
  ],
)
class LeituraGanhosDao extends DatabaseAccessor<AppDatabase>
    with _$LeituraGanhosDaoMixin {
  LeituraGanhosDao(super.db);

  Future<List<Plataforma>> listarPlataformasAtivas() {
    return (select(plataformas)
          ..where((plataforma) => plataforma.ativa.equals(true))
          ..orderBy([
            (plataforma) => OrderingTerm.asc(plataforma.ordem),
            (plataforma) => OrderingTerm.asc(plataforma.nome),
            (plataforma) => OrderingTerm.asc(plataforma.id),
          ]))
        .get();
  }

  Future<Pausa?> buscarPausa(int pausaId) {
    return (select(
      pausas,
    )..where((pausa) => pausa.id.equals(pausaId))).getSingleOrNull();
  }

  Future<Map<int, LeiturasGanhoPlataformaData>> buscarUltimosItensPorPlataforma(
    int jornadaId,
  ) async {
    final consulta =
        select(leiturasGanhoPlataforma).join([
            innerJoin(
              leiturasGanhos,
              leiturasGanhos.id.equalsExp(
                leiturasGanhoPlataforma.leituraGanhosId,
              ),
            ),
          ])
          ..where(leiturasGanhos.jornadaId.equals(jornadaId))
          ..orderBy([
            OrderingTerm.desc(leiturasGanhos.dataHora),
            OrderingTerm.desc(leiturasGanhos.id),
            OrderingTerm.desc(leiturasGanhoPlataforma.id),
          ]);

    final linhas = await consulta.get();
    final ultimos = <int, LeiturasGanhoPlataformaData>{};

    for (final linha in linhas) {
      final item = linha.readTable(leiturasGanhoPlataforma);
      ultimos.putIfAbsent(item.plataformaId, () => item);
    }

    return ultimos;
  }

  Future<int> salvarLeitura(
    LeiturasGanhosCompanion leitura,
    List<LeiturasGanhoPlataformaCompanion> Function(int leituraId) criarItens,
  ) {
    return transaction(() async {
      final leituraId = await into(leiturasGanhos).insert(leitura);
      final itens = criarItens(leituraId);

      await batch((batch) {
        batch.insertAll(leiturasGanhoPlataforma, itens);
      });

      return leituraId;
    });
  }

  Future<LeiturasGanho?> buscarLeitura(int leituraId) {
    return (select(
      leiturasGanhos,
    )..where((leitura) => leitura.id.equals(leituraId))).getSingleOrNull();
  }

  Future<List<LeiturasGanhoPlataformaData>> listarItens(int leituraId) {
    return (select(leiturasGanhoPlataforma)
          ..where((item) => item.leituraGanhosId.equals(leituraId))
          ..orderBy([(item) => OrderingTerm.asc(item.plataformaId)]))
        .get();
  }
}
