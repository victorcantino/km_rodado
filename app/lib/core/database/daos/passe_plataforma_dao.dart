import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/passe_plataforma.dart';
import '../tables/plataforma.dart';

part 'passe_plataforma_dao.g.dart';

typedef PasseComPlataforma = ({
  PassesPlataformaData passe,
  Plataforma plataforma,
});

@DriftAccessor(tables: [PassesPlataforma, Plataformas])
class PassePlataformaDao extends DatabaseAccessor<AppDatabase>
    with _$PassePlataformaDaoMixin {
  PassePlataformaDao(super.db);

  Future<int> inserir(PassesPlataformaCompanion passe) =>
      into(passesPlataforma).insert(passe);
  Future<bool> atualizar(PassesPlataformaData passe) =>
      update(passesPlataforma).replace(passe);
  Future<int> excluir(int id) =>
      (delete(passesPlataforma)..where((p) => p.id.equals(id))).go();

  Future<Plataforma?> buscarPlataforma(int id) =>
      (select(plataformas)..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<List<Plataforma>> listarPlataformasAtivas() =>
      (select(plataformas)
            ..where((p) => p.ativa.equals(true))
            ..orderBy([
              (p) => OrderingTerm.asc(p.ordem),
              (p) => OrderingTerm.asc(p.nome),
            ]))
          .get();

  Future<List<PasseComPlataforma>> listarPorJornada(int jornadaId) async {
    final consulta = select(passesPlataforma).join([
      innerJoin(
        plataformas,
        plataformas.id.equalsExp(passesPlataforma.plataformaId),
      ),
    ])..where(passesPlataforma.jornadaId.equals(jornadaId));
    return (await consulta.get())
        .map(
          (linha) => (
            passe: linha.readTable(passesPlataforma),
            plataforma: linha.readTable(plataformas),
          ),
        )
        .toList();
  }

  Future<List<PasseComPlataforma>> listarTodos() async {
    final consulta =
        select(passesPlataforma).join([
          innerJoin(
            plataformas,
            plataformas.id.equalsExp(passesPlataforma.plataformaId),
          ),
        ])..orderBy([
          OrderingTerm.desc(passesPlataforma.dataHora),
          OrderingTerm.desc(passesPlataforma.id),
        ]);
    return (await consulta.get())
        .map(
          (linha) => (
            passe: linha.readTable(passesPlataforma),
            plataforma: linha.readTable(plataformas),
          ),
        )
        .toList();
  }

  Future<PassesPlataformaData?> buscarUltimoPorPlataforma(int plataformaId) =>
      (select(passesPlataforma)
            ..where((passe) => passe.plataformaId.equals(plataformaId))
            ..orderBy([
              (passe) => OrderingTerm.desc(passe.dataHora),
              (passe) => OrderingTerm.desc(passe.id),
            ])
            ..limit(1))
          .getSingleOrNull();
}
