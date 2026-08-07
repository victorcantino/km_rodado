// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jornada_dao.dart';

// ignore_for_file: type=lint
mixin _$JornadaDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsuariosTable get usuarios => attachedDatabase.usuarios;
  $VeiculosTable get veiculos => attachedDatabase.veiculos;
  $JornadasTable get jornadas => attachedDatabase.jornadas;
  JornadaDaoManager get managers => JornadaDaoManager(this);
}

class JornadaDaoManager {
  final _$JornadaDaoMixin _db;
  JornadaDaoManager(this._db);
  $$UsuariosTableTableManager get usuarios =>
      $$UsuariosTableTableManager(_db.attachedDatabase, _db.usuarios);
  $$VeiculosTableTableManager get veiculos =>
      $$VeiculosTableTableManager(_db.attachedDatabase, _db.veiculos);
  $$JornadasTableTableManager get jornadas =>
      $$JornadasTableTableManager(_db.attachedDatabase, _db.jornadas);
}
