import 'package:drift/drift.dart';

import '../app_database.dart';

Future<void> garantirDadosTemporarios(AppDatabase database) async {
  await database.transaction(() async {
    final usuario = await (database.select(
      database.usuarios,
    )..where((tabela) => tabela.id.equals(1))).getSingleOrNull();

    if (usuario == null) {
      await database
          .into(database.usuarios)
          .insert(
            UsuariosCompanion.insert(
              id: const Value(1),
              nome: 'Usuário temporário',
            ),
          );
    }

    final veiculo = await (database.select(
      database.veiculos,
    )..where((tabela) => tabela.id.equals(1))).getSingleOrNull();

    if (veiculo == null) {
      await database
          .into(database.veiculos)
          .insert(
            VeiculosCompanion.insert(
              id: const Value(1),
              usuarioId: 1,
              marca: 'Não informada',
              modelo: 'Veículo temporário',
              ano: 0,
            ),
          );
    }
  });
}
