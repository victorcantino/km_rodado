import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/daos/manutencao_dao.dart';
import '../../abastecimento/data/abastecimento_repository.dart';
import 'manutencao_repository.dart';

typedef ItemManutencaoEntrada = ({
  String descricao,
  int? valorCentavos,
  int? intervaloKm,
  DateTime? vencimentoEm,
});

class ResumoCustoManutencao {
  final int custoConhecidoCentavos;
  final int itensSemValor;
  const ResumoCustoManutencao(this.custoConhecidoCentavos, this.itensSemValor);
  bool get custoCompleto => itensSemValor == 0;
}

class ProximaManutencao {
  final Manutencao manutencao;
  final ItemManutencao item;
  final int? proximoOdometro;
  final int? kmRestantes;
  final int? diasRestantes;
  const ProximaManutencao({
    required this.manutencao,
    required this.item,
    this.proximoOdometro,
    this.kmRestantes,
    this.diasRestantes,
  });
}

class ManutencaoService {
  final ManutencaoRepository _repository;
  final AbastecimentoRepository _odometros;
  final DateTime Function() _agora;

  ManutencaoService(
    this._repository,
    this._odometros, {
    DateTime Function()? agora,
  }) : _agora = agora ?? DateTime.now;

  Future<List<ManutencaoComItens>> listar(int veiculoId) =>
      _repository.listarPorVeiculo(veiculoId);
  Future<List<String>> sugestoes(int veiculoId) =>
      _repository.listarDescricoes(veiculoId);
  Future<int?> sugerirOdometro(int veiculoId) =>
      _odometros.buscarUltimoOdometroCronologico(veiculoId);

  Future<int?> sugerirIntervalo(int veiculoId, String descricao) async {
    final chave = _normalizarDescricao(descricao);
    if (chave.isEmpty) return null;
    for (final registro in await listar(veiculoId)) {
      for (final item in registro.itens.reversed) {
        if (_normalizarDescricao(item.descricao) == chave &&
            item.intervaloKm != null) {
          return item.intervaloKm;
        }
      }
    }
    return null;
  }

  ResumoCustoManutencao resumirCusto(List<ItemManutencao> itens) =>
      ResumoCustoManutencao(
        itens.fold(0, (total, item) => total + (item.valorCentavos ?? 0)),
        itens.where((item) => item.valorCentavos == null).length,
      );

  Future<List<ProximaManutencao>> proximas(int veiculoId) async {
    final registros = await listar(veiculoId);
    final atuais = <String, ({Manutencao manutencao, ItemManutencao item})>{};
    for (final registro in registros) {
      for (final item in registro.itens) {
        final chave = _normalizarDescricao(item.descricao);
        atuais.putIfAbsent(
          chave,
          () => (manutencao: registro.manutencao, item: item),
        );
      }
    }
    final odometro = await sugerirOdometro(veiculoId);
    final hoje = DateTime(_agora().year, _agora().month, _agora().day);
    return atuais.values
        .where(
          (registro) =>
              registro.item.intervaloKm != null ||
              registro.item.vencimentoEm != null,
        )
        .map((registro) {
          final proximo = registro.item.intervaloKm == null
              ? null
              : registro.manutencao.odometro + registro.item.intervaloKm!;
          final vencimento = registro.item.vencimentoEm;
          return ProximaManutencao(
            manutencao: registro.manutencao,
            item: registro.item,
            proximoOdometro: proximo,
            kmRestantes: proximo == null || odometro == null
                ? null
                : proximo - odometro,
            diasRestantes: vencimento == null
                ? null
                : DateTime(
                    vencimento.year,
                    vencimento.month,
                    vencimento.day,
                  ).difference(hoje).inDays,
          );
        })
        .toList();
  }

  Future<int> criar({
    required int veiculoId,
    required DateTime dataHora,
    required int odometro,
    required List<ItemManutencaoEntrada> itens,
    String? oficina,
    String? observacao,
  }) async {
    final normalizados = await _validar(
      veiculoId: veiculoId,
      dataHora: dataHora,
      odometro: odometro,
      itens: itens,
    );
    return _repository.inserirAtomico(
      ManutencoesCompanion.insert(
        veiculoId: veiculoId,
        dataHora: dataHora,
        odometro: odometro,
        oficina: Value(_opcional(oficina)),
        observacao: Value(_opcional(observacao)),
        dataCriacao: Value(_agora()),
      ),
      _companions(normalizados),
    );
  }

  Future<void> editar({
    required int id,
    required int veiculoId,
    required DateTime dataHora,
    required int odometro,
    required List<ItemManutencaoEntrada> itens,
    String? oficina,
    String? observacao,
  }) async {
    final existente = await _repository.buscarPorId(id);
    if (existente == null) throw Exception('A Manutenção não foi encontrada.');
    final normalizados = await _validar(
      veiculoId: veiculoId,
      dataHora: dataHora,
      odometro: odometro,
      itens: itens,
      ignorarManutencaoId: id,
    );
    await _repository.atualizarAtomico(
      existente.manutencao.copyWith(
        dataHora: dataHora,
        odometro: odometro,
        oficina: Value(_opcional(oficina)),
        observacao: Value(_opcional(observacao)),
        dataAtualizacao: Value(_agora()),
      ),
      _companions(normalizados),
    );
  }

  Future<List<ItemManutencaoEntrada>> _validar({
    required int veiculoId,
    required DateTime dataHora,
    required int odometro,
    required List<ItemManutencaoEntrada> itens,
    int? ignorarManutencaoId,
  }) async {
    if (dataHora.isAfter(_agora())) {
      throw Exception('A data da Manutenção não pode estar no futuro.');
    }
    if (odometro < 0) throw Exception('O odômetro não pode ser negativo.');
    if (itens.isEmpty) throw Exception('Informe pelo menos um item.');
    final limites = await _odometros.buscarLimitesOdometro(
      veiculoId,
      dataHora,
      ignorarManutencaoId: ignorarManutencaoId,
    );
    if (limites.anterior != null && odometro < limites.anterior!) {
      throw Exception(
        'O hodômetro não pode ser menor que um registro anterior.',
      );
    }
    if (limites.posterior != null && odometro > limites.posterior!) {
      throw Exception(
        'O hodômetro não pode ultrapassar um registro posterior.',
      );
    }
    return itens.map((item) {
      final descricao = item.descricao.trim();
      if (descricao.isEmpty) throw Exception('Informe a descrição do item.');
      if (item.valorCentavos != null && item.valorCentavos! < 0) {
        throw Exception('O valor do item não pode ser negativo.');
      }
      if (item.intervaloKm != null && item.intervaloKm! <= 0) {
        throw Exception('O intervalo deve ser maior que zero.');
      }
      if (item.vencimentoEm != null && !item.vencimentoEm!.isAfter(dataHora)) {
        throw Exception('O vencimento deve ser posterior à manutenção.');
      }
      return (
        descricao: descricao,
        valorCentavos: item.valorCentavos,
        intervaloKm: item.intervaloKm,
        vencimentoEm: item.vencimentoEm,
      );
    }).toList();
  }

  List<ItensManutencaoCompanion Function(int)> _companions(
    List<ItemManutencaoEntrada> itens,
  ) => itens
      .map(
        (item) =>
            (int manutencaoId) => ItensManutencaoCompanion.insert(
              manutencaoId: manutencaoId,
              descricao: item.descricao,
              valorCentavos: Value(item.valorCentavos),
              intervaloKm: Value(item.intervaloKm),
              vencimentoEm: Value(item.vencimentoEm),
              dataCriacao: Value(_agora()),
            ),
      )
      .toList();

  String _normalizarDescricao(String valor) => valor.trim().toLowerCase();
  String? _opcional(String? valor) {
    final texto = valor?.trim() ?? '';
    return texto.isEmpty ? null : texto;
  }
}
