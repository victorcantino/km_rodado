import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../constants/enums/status_jornada.dart';
import 'tables/usuario.dart';
import 'tables/veiculo.dart';
import 'tables/configuracao.dart';
import 'tables/jornada.dart';
import 'tables/pausa.dart';
import 'tables/plataforma.dart';
import 'tables/ganho.dart';

import 'daos/jornada_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Usuarios,
    Veiculos,
    Configuracoes,
    Jornadas,
    Pausas,
    Plataformas,
    Ganhos,
  ],
  daos: [JornadaDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();

    final file = File(p.join(dir.path, 'km_rodado.db'));

    return NativeDatabase(file);
  });
}
