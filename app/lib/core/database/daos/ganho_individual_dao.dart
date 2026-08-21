import 'package:drift/drift.dart';

import '../../constants/enums/tipo_registro_ganhos.dart';
import '../app_database.dart';
import '../tables/lancamento_ganho_individual.dart';
import '../tables/plataforma.dart';

part 'ganho_individual_dao.g.dart';

typedef TotalGanhoIndividual = ({
  Plataforma plataforma,
  int valorTotalCentavos,
  int quantidadeViagens,
});

@DriftAccessor(tables: [LancamentosGanhoIndividual, Plataformas])
class GanhoIndividualDao extends DatabaseAccessor<AppDatabase>
    with _$GanhoIndividualDaoMixin {
  GanhoIndividualDao(super.db);

  Future<Plataforma?> buscarPlataforma(int plataformaId) => (select(
    plataformas,
  )..where((p) => p.id.equals(plataformaId))).getSingleOrNull();

  Future<List<Plataforma>> listarPlataformasIndividuaisAtivas() =>
      (select(plataformas)
            ..where(
              (p) =>
                  p.ativa.equals(true) &
                  p.tipoRegistroGanhos.equalsValue(
                    TipoRegistroGanhos.individual,
                  ),
            )
            ..orderBy([
              (p) => OrderingTerm.asc(p.ordem),
              (p) => OrderingTerm.asc(p.nome),
            ]))
          .get();

  Future<int> inserir(LancamentosGanhoIndividualCompanion lancamento) =>
      into(lancamentosGanhoIndividual).insert(lancamento);

  Future<LancamentosGanhoIndividualData?> buscarPorId(int id) => (select(
    lancamentosGanhoIndividual,
  )..where((l) => l.id.equals(id))).getSingleOrNull();

  Future<bool> atualizar(LancamentosGanhoIndividualData lancamento) =>
      update(lancamentosGanhoIndividual).replace(lancamento);

  Future<List<LancamentosGanhoIndividualData>> listarPorJornada(
    int jornadaId,
  ) =>
      (select(lancamentosGanhoIndividual)
            ..where((l) => l.jornadaId.equals(jornadaId))
            ..orderBy([(l) => OrderingTerm.asc(l.dataHora)]))
          .get();

  Future<List<TotalGanhoIndividual>> totalizarPorJornadaNoIntervalo(
    int jornadaId,
    DateTime inicio,
    DateTime fim,
  ) async {
    final valor = lancamentosGanhoIndividual.valorTotalCentavos.sum();
    final viagens = lancamentosGanhoIndividual.quantidadeViagens.sum();
    final consulta =
        select(plataformas).join([
            innerJoin(
              lancamentosGanhoIndividual,
              lancamentosGanhoIndividual.plataformaId.equalsExp(plataformas.id),
            ),
          ])
          ..where(
            lancamentosGanhoIndividual.jornadaId.equals(jornadaId) &
                lancamentosGanhoIndividual.dataHora.isBiggerOrEqualValue(
                  inicio,
                ) &
                lancamentosGanhoIndividual.dataHora.isSmallerOrEqualValue(fim),
          )
          ..addColumns([valor, viagens])
          ..groupBy([plataformas.id])
          ..orderBy([OrderingTerm.asc(plataformas.ordem)]);

    return (await consulta.get())
        .map(
          (linha) => (
            plataforma: linha.readTable(plataformas),
            valorTotalCentavos: linha.read(valor) ?? 0,
            quantidadeViagens: linha.read(viagens) ?? 0,
          ),
        )
        .toList();
  }

  Future<List<TotalGanhoIndividual>> totalizarNoIntervalo(
    DateTime inicio,
    DateTime fim,
  ) async {
    final valor = lancamentosGanhoIndividual.valorTotalCentavos.sum();
    final viagens = lancamentosGanhoIndividual.quantidadeViagens.sum();
    final consulta =
        select(plataformas).join([
            innerJoin(
              lancamentosGanhoIndividual,
              lancamentosGanhoIndividual.plataformaId.equalsExp(plataformas.id),
            ),
          ])
          ..where(
            lancamentosGanhoIndividual.dataHora.isBiggerOrEqualValue(inicio) &
                lancamentosGanhoIndividual.dataHora.isSmallerOrEqualValue(fim),
          )
          ..addColumns([valor, viagens])
          ..groupBy([plataformas.id])
          ..orderBy([OrderingTerm.asc(plataformas.ordem)]);

    return (await consulta.get())
        .map(
          (linha) => (
            plataforma: linha.readTable(plataformas),
            valorTotalCentavos: linha.read(valor) ?? 0,
            quantidadeViagens: linha.read(viagens) ?? 0,
          ),
        )
        .toList();
  }

  Future<List<TotalGanhoIndividual>> totalizarPorJornada(int jornadaId) async {
    final valor = lancamentosGanhoIndividual.valorTotalCentavos.sum();
    final viagens = lancamentosGanhoIndividual.quantidadeViagens.sum();
    final consulta =
        select(plataformas).join([
            innerJoin(
              lancamentosGanhoIndividual,
              lancamentosGanhoIndividual.plataformaId.equalsExp(plataformas.id),
            ),
          ])
          ..where(lancamentosGanhoIndividual.jornadaId.equals(jornadaId))
          ..addColumns([valor, viagens])
          ..groupBy([plataformas.id])
          ..orderBy([OrderingTerm.asc(plataformas.ordem)]);

    return (await consulta.get())
        .map(
          (linha) => (
            plataforma: linha.readTable(plataformas),
            valorTotalCentavos: linha.read(valor) ?? 0,
            quantidadeViagens: linha.read(viagens) ?? 0,
          ),
        )
        .toList();
  }
}
