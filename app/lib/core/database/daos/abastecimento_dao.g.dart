// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'abastecimento_dao.dart';

// ignore_for_file: type=lint
mixin _$AbastecimentoDaoMixin on DatabaseAccessor<AppDatabase> {
  $VeiculosTable get veiculos => attachedDatabase.veiculos;
  $UsuariosTable get usuarios => attachedDatabase.usuarios;
  $JornadasTable get jornadas => attachedDatabase.jornadas;
  $AbastecimentosTable get abastecimentos => attachedDatabase.abastecimentos;
  $PausasTable get pausas => attachedDatabase.pausas;
  AbastecimentoDaoManager get managers => AbastecimentoDaoManager(this);
}

class AbastecimentoDaoManager {
  final _$AbastecimentoDaoMixin _db;
  AbastecimentoDaoManager(this._db);
  $$VeiculosTableTableManager get veiculos =>
      $$VeiculosTableTableManager(_db.attachedDatabase, _db.veiculos);
  $$UsuariosTableTableManager get usuarios =>
      $$UsuariosTableTableManager(_db.attachedDatabase, _db.usuarios);
  $$JornadasTableTableManager get jornadas =>
      $$JornadasTableTableManager(_db.attachedDatabase, _db.jornadas);
  $$AbastecimentosTableTableManager get abastecimentos =>
      $$AbastecimentosTableTableManager(
        _db.attachedDatabase,
        _db.abastecimentos,
      );
  $$PausasTableTableManager get pausas =>
      $$PausasTableTableManager(_db.attachedDatabase, _db.pausas);
}
