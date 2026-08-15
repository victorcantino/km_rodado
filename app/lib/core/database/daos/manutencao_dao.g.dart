// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manutencao_dao.dart';

// ignore_for_file: type=lint
mixin _$ManutencaoDaoMixin on DatabaseAccessor<AppDatabase> {
  $VeiculosTable get veiculos => attachedDatabase.veiculos;
  $ManutencoesTable get manutencoes => attachedDatabase.manutencoes;
  $ItensManutencaoTable get itensManutencao => attachedDatabase.itensManutencao;
  ManutencaoDaoManager get managers => ManutencaoDaoManager(this);
}

class ManutencaoDaoManager {
  final _$ManutencaoDaoMixin _db;
  ManutencaoDaoManager(this._db);
  $$VeiculosTableTableManager get veiculos =>
      $$VeiculosTableTableManager(_db.attachedDatabase, _db.veiculos);
  $$ManutencoesTableTableManager get manutencoes =>
      $$ManutencoesTableTableManager(_db.attachedDatabase, _db.manutencoes);
  $$ItensManutencaoTableTableManager get itensManutencao =>
      $$ItensManutencaoTableTableManager(
        _db.attachedDatabase,
        _db.itensManutencao,
      );
}
