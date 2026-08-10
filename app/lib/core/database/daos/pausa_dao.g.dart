// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pausa_dao.dart';

// ignore_for_file: type=lint
mixin _$PausaDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsuariosTable get usuarios => attachedDatabase.usuarios;
  $VeiculosTable get veiculos => attachedDatabase.veiculos;
  $JornadasTable get jornadas => attachedDatabase.jornadas;
  $PausasTable get pausas => attachedDatabase.pausas;
  PausaDaoManager get managers => PausaDaoManager(this);
}

class PausaDaoManager {
  final _$PausaDaoMixin _db;
  PausaDaoManager(this._db);
  $$UsuariosTableTableManager get usuarios =>
      $$UsuariosTableTableManager(_db.attachedDatabase, _db.usuarios);
  $$VeiculosTableTableManager get veiculos =>
      $$VeiculosTableTableManager(_db.attachedDatabase, _db.veiculos);
  $$JornadasTableTableManager get jornadas =>
      $$JornadasTableTableManager(_db.attachedDatabase, _db.jornadas);
  $$PausasTableTableManager get pausas =>
      $$PausasTableTableManager(_db.attachedDatabase, _db.pausas);
}
