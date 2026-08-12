import 'package:drift/drift.dart';

import '../../constants/enums/tipo_leitura_ganhos.dart';
import '../app_database.dart';
import '../tables/jornada.dart';
import '../tables/leitura_ganho_plataforma.dart';
import '../tables/leitura_ganhos.dart';
import '../tables/pausa.dart';
import '../tables/plataforma.dart';

part 'leitura_ganhos_dao.g.dart';

typedef SnapshotPlataforma = ({
  LeiturasGanho leitura,
  LeiturasGanhoPlataformaData item,
  Plataforma plataforma,
});

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

  Future<List<Plataforma>> listarPlataformas() =>
      (select(plataformas)..orderBy([
            (plataforma) => OrderingTerm.asc(plataforma.ordem),
            (plataforma) => OrderingTerm.asc(plataforma.nome),
          ]))
          .get();

  Future<void> atualizarAtivacao(Map<int, bool> ativacoes) async {
    await transaction(() async {
      for (final entry in ativacoes.entries) {
        await (update(plataformas)..where((p) => p.id.equals(entry.key))).write(
          PlataformasCompanion(ativa: Value(entry.value)),
        );
      }
    });
  }

  Future<List<Plataforma>> listarPlataformasDaLeituraInicial(
    int jornadaId,
  ) async {
    final consulta =
        select(plataformas).join([
            innerJoin(
              leiturasGanhoPlataforma,
              leiturasGanhoPlataforma.plataformaId.equalsExp(plataformas.id),
            ),
            innerJoin(
              leiturasGanhos,
              leiturasGanhos.id.equalsExp(
                leiturasGanhoPlataforma.leituraGanhosId,
              ),
            ),
          ])
          ..where(
            leiturasGanhos.jornadaId.equals(jornadaId) &
                leiturasGanhos.tipo.equalsValue(TipoLeituraGanhos.inicial),
          )
          ..orderBy([OrderingTerm.asc(plataformas.ordem)]);
    return (await consulta.get())
        .map((row) => row.readTable(plataformas))
        .toList();
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

  Future<LeiturasGanho?> buscarPorTipo(int jornadaId, TipoLeituraGanhos tipo) {
    return (select(leiturasGanhos)
          ..where(
            (leitura) =>
                leitura.jornadaId.equals(jornadaId) &
                leitura.tipo.equalsValue(tipo),
          )
          ..orderBy([(leitura) => OrderingTerm.desc(leitura.id)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<LeiturasGanho?> buscarUltimaLeitura(int jornadaId) {
    return (select(leiturasGanhos)
          ..where((leitura) => leitura.jornadaId.equals(jornadaId))
          ..orderBy([
            (leitura) => OrderingTerm.desc(leitura.dataHora),
            (leitura) => OrderingTerm.desc(leitura.id),
          ])
          ..limit(1))
        .getSingleOrNull();
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

  Future<int> salvarLeituraUnica(
    LeiturasGanhosCompanion leitura,
    TipoLeituraGanhos tipo,
    List<LeiturasGanhoPlataformaCompanion> Function(int leituraId) criarItens,
  ) {
    return transaction(() async {
      if (await buscarPorTipo(leitura.jornadaId.value, tipo) != null) {
        throw StateError('Esta leitura já foi registrada para a Jornada.');
      }

      final leituraId = await into(leiturasGanhos).insert(leitura);
      await batch((batch) {
        batch.insertAll(leiturasGanhoPlataforma, criarItens(leituraId));
      });
      return leituraId;
    });
  }

  Future<int> salvarLeituraFinalEFecharJornada(
    LeiturasGanhosCompanion leitura,
    List<LeiturasGanhoPlataformaCompanion> Function(int leituraId) criarItens,
    Jornada jornadaFinalizada,
  ) {
    return transaction(() async {
      if (await buscarPorTipo(
            leitura.jornadaId.value,
            TipoLeituraGanhos.finalDaJornada,
          ) !=
          null) {
        throw StateError('A leitura final desta Jornada já foi registrada.');
      }

      final leituraId = await into(leiturasGanhos).insert(leitura);
      await batch((batch) {
        batch.insertAll(leiturasGanhoPlataforma, criarItens(leituraId));
      });

      final atualizada = await update(jornadas).replace(jornadaFinalizada);
      if (!atualizada) {
        throw StateError('Não foi possível finalizar a Jornada.');
      }

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

  Future<List<SnapshotPlataforma>> listarSnapshotsDaJornada(
    int jornadaId,
  ) async {
    final consulta =
        select(leiturasGanhos).join([
            innerJoin(
              leiturasGanhoPlataforma,
              leiturasGanhoPlataforma.leituraGanhosId.equalsExp(
                leiturasGanhos.id,
              ),
            ),
            innerJoin(
              plataformas,
              plataformas.id.equalsExp(leiturasGanhoPlataforma.plataformaId),
            ),
          ])
          ..where(leiturasGanhos.jornadaId.equals(jornadaId))
          ..orderBy([
            OrderingTerm.asc(leiturasGanhos.dataHora),
            OrderingTerm.asc(leiturasGanhos.id),
            OrderingTerm.asc(plataformas.ordem),
            OrderingTerm.asc(plataformas.id),
          ]);

    return (await consulta.get())
        .map(
          (linha) => (
            leitura: linha.readTable(leiturasGanhos),
            item: linha.readTable(leiturasGanhoPlataforma),
            plataforma: linha.readTable(plataformas),
          ),
        )
        .toList();
  }
}
