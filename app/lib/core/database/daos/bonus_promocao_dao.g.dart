// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bonus_promocao_dao.dart';

// ignore_for_file: type=lint
mixin _$BonusPromocaoDaoMixin on DatabaseAccessor<AppDatabase> {
  $PlataformasTable get plataformas => attachedDatabase.plataformas;
  $UsuariosTable get usuarios => attachedDatabase.usuarios;
  $VeiculosTable get veiculos => attachedDatabase.veiculos;
  $JornadasTable get jornadas => attachedDatabase.jornadas;
  $BonusPromocoesTable get bonusPromocoes => attachedDatabase.bonusPromocoes;
  BonusPromocaoDaoManager get managers => BonusPromocaoDaoManager(this);
}

class BonusPromocaoDaoManager {
  final _$BonusPromocaoDaoMixin _db;
  BonusPromocaoDaoManager(this._db);
  $$PlataformasTableTableManager get plataformas =>
      $$PlataformasTableTableManager(_db.attachedDatabase, _db.plataformas);
  $$UsuariosTableTableManager get usuarios =>
      $$UsuariosTableTableManager(_db.attachedDatabase, _db.usuarios);
  $$VeiculosTableTableManager get veiculos =>
      $$VeiculosTableTableManager(_db.attachedDatabase, _db.veiculos);
  $$JornadasTableTableManager get jornadas =>
      $$JornadasTableTableManager(_db.attachedDatabase, _db.jornadas);
  $$BonusPromocoesTableTableManager get bonusPromocoes =>
      $$BonusPromocoesTableTableManager(
        _db.attachedDatabase,
        _db.bonusPromocoes,
      );
}
