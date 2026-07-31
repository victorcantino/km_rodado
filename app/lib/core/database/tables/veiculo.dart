import 'package:drift/drift.dart';

class Veiculos extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get usuarioId => integer()();

  TextColumn get marca => text()();

  TextColumn get modelo => text()();

  IntColumn get ano => integer()();

  TextColumn get placa => text().nullable()();

  DateTimeColumn get dataCompra => dateTime().nullable()();

  IntColumn get quilometragemCompra =>
      integer().nullable()();

  RealColumn get valorCompra =>
      real().nullable()();

  RealColumn get valorVendaEstimado =>
      real().nullable()();

  RealColumn get capacidadeTanque =>
      real().withDefault(const Constant(41))();

  BoolColumn get ativo =>
      boolean().withDefault(const Constant(true))();

  TextColumn get observacoes =>
      text().nullable()();
}