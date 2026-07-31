import 'package:drift/drift.dart';

class Configuracoes extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get usuarioId => integer()();

  RealColumn get custoKmBase =>
      real().withDefault(const Constant(0))();

  IntColumn get metaKmDia =>
      integer().withDefault(const Constant(0))();

  RealColumn get capacidadeTanque =>
      real().withDefault(const Constant(41))();

  TextColumn get cidadePadrao =>
      text().nullable()();
}