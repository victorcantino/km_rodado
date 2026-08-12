// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ganho_individual_dao.dart';

// ignore_for_file: type=lint
mixin _$GanhoIndividualDaoMixin on DatabaseAccessor<AppDatabase> {
  $PlataformasTable get plataformas => attachedDatabase.plataformas;
  $UsuariosTable get usuarios => attachedDatabase.usuarios;
  $VeiculosTable get veiculos => attachedDatabase.veiculos;
  $JornadasTable get jornadas => attachedDatabase.jornadas;
  $LancamentosGanhoIndividualTable get lancamentosGanhoIndividual =>
      attachedDatabase.lancamentosGanhoIndividual;
  GanhoIndividualDaoManager get managers => GanhoIndividualDaoManager(this);
}

class GanhoIndividualDaoManager {
  final _$GanhoIndividualDaoMixin _db;
  GanhoIndividualDaoManager(this._db);
  $$PlataformasTableTableManager get plataformas =>
      $$PlataformasTableTableManager(_db.attachedDatabase, _db.plataformas);
  $$UsuariosTableTableManager get usuarios =>
      $$UsuariosTableTableManager(_db.attachedDatabase, _db.usuarios);
  $$VeiculosTableTableManager get veiculos =>
      $$VeiculosTableTableManager(_db.attachedDatabase, _db.veiculos);
  $$JornadasTableTableManager get jornadas =>
      $$JornadasTableTableManager(_db.attachedDatabase, _db.jornadas);
  $$LancamentosGanhoIndividualTableTableManager
  get lancamentosGanhoIndividual =>
      $$LancamentosGanhoIndividualTableTableManager(
        _db.attachedDatabase,
        _db.lancamentosGanhoIndividual,
      );
}
