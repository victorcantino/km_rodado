import 'package:drift/drift.dart';

import '../../../core/constants/enums/tipo_leitura_ganhos.dart';
import '../../../core/constants/enums/tipo_registro_ganhos.dart';
import '../../../core/database/app_database.dart';
import '../../jornada/data/jornada_repository.dart';
import 'leitura_ganhos_repository.dart';

typedef ItemLeituraGanhosEntrada = ({
  int plataformaId,
  int valorAcumuladoCentavos,
  int quantidadeViagensAcumulada,
});

class LeituraGanhosService {
  final LeituraGanhosRepository _repository;
  final JornadaRepository _jornadaRepository;
  final DateTime Function() _agora;

  LeituraGanhosService(
    this._repository,
    this._jornadaRepository, {
    DateTime Function()? agora,
  }) : _agora = agora ?? DateTime.now;

  Future<List<Plataforma>> listarPlataformasAtivas() {
    return _repository.listarPlataformasAtivas();
  }

  Future<Map<int, LeiturasGanhoPlataformaData>> buscarSugestoes(int jornadaId) {
    return _repository.buscarUltimosItensPorPlataforma(jornadaId);
  }

  Future<int> salvarLeituraParcial({
    required int jornadaId,
    required int pausaId,
    required List<ItemLeituraGanhosEntrada> itens,
  }) async {
    final jornada = await _jornadaRepository.buscarJornadaAberta();

    if (jornada == null || jornada.id != jornadaId) {
      throw Exception('A leitura parcial exige uma Jornada aberta.');
    }

    final pausa = await _repository.buscarPausa(pausaId);

    if (pausa == null || pausa.jornadaId != jornadaId) {
      throw Exception('A Pausa não pertence à Jornada da leitura.');
    }

    if (itens.isEmpty) {
      throw Exception('Informe ao menos uma plataforma acumulada.');
    }

    final ids = itens.map((item) => item.plataformaId).toSet();

    if (ids.length != itens.length) {
      throw Exception('Uma plataforma não pode se repetir na mesma leitura.');
    }

    if (itens.any((item) => item.valorAcumuladoCentavos < 0)) {
      throw Exception('O valor acumulado não pode ser negativo.');
    }

    if (itens.any((item) => item.quantidadeViagensAcumulada < 0)) {
      throw Exception('A quantidade acumulada não pode ser negativa.');
    }

    final plataformas = await _repository.listarPlataformasAtivas();
    final idsAcumulados = plataformas
        .where(
          (plataforma) =>
              plataforma.tipoRegistroGanhos == TipoRegistroGanhos.acumulado,
        )
        .map((plataforma) => plataforma.id)
        .toSet();

    if (ids.length != idsAcumulados.length || !ids.containsAll(idsAcumulados)) {
      throw Exception('Informe uma vez cada plataforma acumulada ativa.');
    }

    final agora = _agora();

    return _repository.salvarLeitura(
      LeiturasGanhosCompanion.insert(
        jornadaId: jornadaId,
        pausaId: Value(pausaId),
        dataHora: agora,
        tipo: TipoLeituraGanhos.parcial,
        dataCriacao: Value(agora),
      ),
      (leituraId) => [
        for (final item in itens)
          LeiturasGanhoPlataformaCompanion.insert(
            leituraGanhosId: leituraId,
            plataformaId: item.plataformaId,
            valorAcumuladoCentavos: item.valorAcumuladoCentavos,
            quantidadeViagensAcumulada: item.quantidadeViagensAcumulada,
          ),
      ],
    );
  }

  Future<LeiturasGanho?> buscarLeitura(int leituraId) {
    return _repository.buscarLeitura(leituraId);
  }

  Future<List<LeiturasGanhoPlataformaData>> listarItens(int leituraId) {
    return _repository.listarItens(leituraId);
  }
}
