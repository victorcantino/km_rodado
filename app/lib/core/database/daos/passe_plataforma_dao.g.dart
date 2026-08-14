// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passe_plataforma_dao.dart';

// ignore_for_file: type=lint
mixin _$PassePlataformaDaoMixin on DatabaseAccessor<AppDatabase> {
  $PlataformasTable get plataformas => attachedDatabase.plataformas;
  $UsuariosTable get usuarios => attachedDatabase.usuarios;
  $VeiculosTable get veiculos => attachedDatabase.veiculos;
  $JornadasTable get jornadas => attachedDatabase.jornadas;
  $PassesPlataformaTable get passesPlataforma =>
      attachedDatabase.passesPlataforma;
  PassePlataformaDaoManager get managers => PassePlataformaDaoManager(this);
}

class PassePlataformaDaoManager {
  final _$PassePlataformaDaoMixin _db;
  PassePlataformaDaoManager(this._db);
  $$PlataformasTableTableManager get plataformas =>
      $$PlataformasTableTableManager(_db.attachedDatabase, _db.plataformas);
  $$UsuariosTableTableManager get usuarios =>
      $$UsuariosTableTableManager(_db.attachedDatabase, _db.usuarios);
  $$VeiculosTableTableManager get veiculos =>
      $$VeiculosTableTableManager(_db.attachedDatabase, _db.veiculos);
  $$JornadasTableTableManager get jornadas =>
      $$JornadasTableTableManager(_db.attachedDatabase, _db.jornadas);
  $$PassesPlataformaTableTableManager get passesPlataforma =>
      $$PassesPlataformaTableTableManager(
        _db.attachedDatabase,
        _db.passesPlataforma,
      );
}
