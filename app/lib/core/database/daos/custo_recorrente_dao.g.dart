// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custo_recorrente_dao.dart';

// ignore_for_file: type=lint
mixin _$CustoRecorrenteDaoMixin on DatabaseAccessor<AppDatabase> {
  $VeiculosTable get veiculos => attachedDatabase.veiculos;
  $PlataformasTable get plataformas => attachedDatabase.plataformas;
  $CustosRecorrentesTable get custosRecorrentes =>
      attachedDatabase.custosRecorrentes;
  CustoRecorrenteDaoManager get managers => CustoRecorrenteDaoManager(this);
}

class CustoRecorrenteDaoManager {
  final _$CustoRecorrenteDaoMixin _db;
  CustoRecorrenteDaoManager(this._db);
  $$VeiculosTableTableManager get veiculos =>
      $$VeiculosTableTableManager(_db.attachedDatabase, _db.veiculos);
  $$PlataformasTableTableManager get plataformas =>
      $$PlataformasTableTableManager(_db.attachedDatabase, _db.plataformas);
  $$CustosRecorrentesTableTableManager get custosRecorrentes =>
      $$CustosRecorrentesTableTableManager(
        _db.attachedDatabase,
        _db.custosRecorrentes,
      );
}
