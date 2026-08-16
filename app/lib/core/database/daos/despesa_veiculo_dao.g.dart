// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'despesa_veiculo_dao.dart';

// ignore_for_file: type=lint
mixin _$DespesaVeiculoDaoMixin on DatabaseAccessor<AppDatabase> {
  $VeiculosTable get veiculos => attachedDatabase.veiculos;
  $DespesasVeiculoTable get despesasVeiculo => attachedDatabase.despesasVeiculo;
  DespesaVeiculoDaoManager get managers => DespesaVeiculoDaoManager(this);
}

class DespesaVeiculoDaoManager {
  final _$DespesaVeiculoDaoMixin _db;
  DespesaVeiculoDaoManager(this._db);
  $$VeiculosTableTableManager get veiculos =>
      $$VeiculosTableTableManager(_db.attachedDatabase, _db.veiculos);
  $$DespesasVeiculoTableTableManager get despesasVeiculo =>
      $$DespesasVeiculoTableTableManager(
        _db.attachedDatabase,
        _db.despesasVeiculo,
      );
}
