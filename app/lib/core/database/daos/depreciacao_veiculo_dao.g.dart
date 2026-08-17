// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'depreciacao_veiculo_dao.dart';

// ignore_for_file: type=lint
mixin _$DepreciacaoVeiculoDaoMixin on DatabaseAccessor<AppDatabase> {
  $VeiculosTable get veiculos => attachedDatabase.veiculos;
  $DepreciacoesVeiculoTable get depreciacoesVeiculo =>
      attachedDatabase.depreciacoesVeiculo;
  DepreciacaoVeiculoDaoManager get managers =>
      DepreciacaoVeiculoDaoManager(this);
}

class DepreciacaoVeiculoDaoManager {
  final _$DepreciacaoVeiculoDaoMixin _db;
  DepreciacaoVeiculoDaoManager(this._db);
  $$VeiculosTableTableManager get veiculos =>
      $$VeiculosTableTableManager(_db.attachedDatabase, _db.veiculos);
  $$DepreciacoesVeiculoTableTableManager get depreciacoesVeiculo =>
      $$DepreciacoesVeiculoTableTableManager(
        _db.attachedDatabase,
        _db.depreciacoesVeiculo,
      );
}
