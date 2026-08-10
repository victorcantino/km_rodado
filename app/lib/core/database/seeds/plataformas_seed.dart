import 'package:drift/drift.dart';

import '../../constants/enums/tipo_registro_ganhos.dart';
import '../app_database.dart';

const _plataformasPadrao = [
  (nome: 'Uber', tipoRegistroGanhos: TipoRegistroGanhos.acumulado, ordem: 0),
  (nome: '99', tipoRegistroGanhos: TipoRegistroGanhos.acumulado, ordem: 1),
  (nome: 'inDrive', tipoRegistroGanhos: TipoRegistroGanhos.acumulado, ordem: 2),
  (
    nome: 'Particular',
    tipoRegistroGanhos: TipoRegistroGanhos.individual,
    ordem: 3,
  ),
];

Future<void> garantirPlataformasPadrao(AppDatabase database) {
  return database.transaction(() async {
    final existentes = await database.select(database.plataformas).get();
    final nomesExistentes = existentes
        .map((plataforma) => _normalizarNome(plataforma.nome))
        .toSet();

    for (final plataforma in _plataformasPadrao) {
      if (nomesExistentes.contains(_normalizarNome(plataforma.nome))) {
        continue;
      }

      await database
          .into(database.plataformas)
          .insert(
            PlataformasCompanion.insert(
              nome: plataforma.nome,
              tipoRegistroGanhos: plataforma.tipoRegistroGanhos,
              ordem: Value(plataforma.ordem),
            ),
          );
      nomesExistentes.add(_normalizarNome(plataforma.nome));
    }
  });
}

String _normalizarNome(String nome) => nome.trim().toLowerCase();
