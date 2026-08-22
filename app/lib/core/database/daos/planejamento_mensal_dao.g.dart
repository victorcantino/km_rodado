// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planejamento_mensal_dao.dart';

// ignore_for_file: type=lint
mixin _$PlanejamentoMensalDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsuariosTable get usuarios => attachedDatabase.usuarios;
  $PlanejamentosMensaisTable get planejamentosMensais =>
      attachedDatabase.planejamentosMensais;
  PlanejamentoMensalDaoManager get managers =>
      PlanejamentoMensalDaoManager(this);
}

class PlanejamentoMensalDaoManager {
  final _$PlanejamentoMensalDaoMixin _db;
  PlanejamentoMensalDaoManager(this._db);
  $$UsuariosTableTableManager get usuarios =>
      $$UsuariosTableTableManager(_db.attachedDatabase, _db.usuarios);
  $$PlanejamentosMensaisTableTableManager get planejamentosMensais =>
      $$PlanejamentosMensaisTableTableManager(
        _db.attachedDatabase,
        _db.planejamentosMensais,
      );
}
