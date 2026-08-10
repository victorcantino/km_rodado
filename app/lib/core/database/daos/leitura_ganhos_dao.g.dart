// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leitura_ganhos_dao.dart';

// ignore_for_file: type=lint
mixin _$LeituraGanhosDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsuariosTable get usuarios => attachedDatabase.usuarios;
  $VeiculosTable get veiculos => attachedDatabase.veiculos;
  $JornadasTable get jornadas => attachedDatabase.jornadas;
  $PausasTable get pausas => attachedDatabase.pausas;
  $PlataformasTable get plataformas => attachedDatabase.plataformas;
  $LeiturasGanhosTable get leiturasGanhos => attachedDatabase.leiturasGanhos;
  $LeiturasGanhoPlataformaTable get leiturasGanhoPlataforma =>
      attachedDatabase.leiturasGanhoPlataforma;
  LeituraGanhosDaoManager get managers => LeituraGanhosDaoManager(this);
}

class LeituraGanhosDaoManager {
  final _$LeituraGanhosDaoMixin _db;
  LeituraGanhosDaoManager(this._db);
  $$UsuariosTableTableManager get usuarios =>
      $$UsuariosTableTableManager(_db.attachedDatabase, _db.usuarios);
  $$VeiculosTableTableManager get veiculos =>
      $$VeiculosTableTableManager(_db.attachedDatabase, _db.veiculos);
  $$JornadasTableTableManager get jornadas =>
      $$JornadasTableTableManager(_db.attachedDatabase, _db.jornadas);
  $$PausasTableTableManager get pausas =>
      $$PausasTableTableManager(_db.attachedDatabase, _db.pausas);
  $$PlataformasTableTableManager get plataformas =>
      $$PlataformasTableTableManager(_db.attachedDatabase, _db.plataformas);
  $$LeiturasGanhosTableTableManager get leiturasGanhos =>
      $$LeiturasGanhosTableTableManager(
        _db.attachedDatabase,
        _db.leiturasGanhos,
      );
  $$LeiturasGanhoPlataformaTableTableManager get leiturasGanhoPlataforma =>
      $$LeiturasGanhoPlataformaTableTableManager(
        _db.attachedDatabase,
        _db.leiturasGanhoPlataforma,
      );
}
