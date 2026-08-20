import '../../../../core/constants/enums/tipo_custo_recorrente.dart';
import '../../../../core/database/app_database.dart';
import '../../depreciacao_veiculo/data/resultado_depreciacao.dart';

enum EstadoCoberturaCusto { informado, estimado, naoInformado }

class ItemCoberturaCusto {
  final String nome;
  final EstadoCoberturaCusto estado;
  final bool parcelaCaixa;
  final TipoCustoRecorrente? tipo;

  const ItemCoberturaCusto({
    required this.nome,
    required this.estado,
    this.parcelaCaixa = false,
    this.tipo,
  });
}

class CoberturaCustos {
  final List<ItemCoberturaCusto> itens;

  const CoberturaCustos(this.itens);

  bool get possuiDados =>
      itens.any((item) => item.estado != EstadoCoberturaCusto.naoInformado);
  bool get possuiLacunas =>
      itens.any((item) => item.estado == EstadoCoberturaCusto.naoInformado);
}

class CoberturaCustosService {
  const CoberturaCustosService();

  CoberturaCustos avaliar({
    required bool possuiAbastecimento,
    required bool possuiManutencao,
    required ResultadoDepreciacao? depreciacao,
    required List<CustoRecorrente> custos,
  }) {
    final itens = <ItemCoberturaCusto>[
      ItemCoberturaCusto(
        nome: 'Combustível',
        estado: possuiAbastecimento
            ? EstadoCoberturaCusto.informado
            : EstadoCoberturaCusto.naoInformado,
      ),
      ItemCoberturaCusto(
        nome: 'Manutenção',
        estado: possuiManutencao
            ? EstadoCoberturaCusto.informado
            : EstadoCoberturaCusto.naoInformado,
      ),
      ItemCoberturaCusto(
        nome: 'Depreciação',
        estado: depreciacao == null || !depreciacao.disponivel
            ? EstadoCoberturaCusto.naoInformado
            : depreciacao.estimado
            ? EstadoCoberturaCusto.estimado
            : EstadoCoberturaCusto.informado,
        tipo: TipoCustoRecorrente.depreciacao,
      ),
    ];

    const tipos = [
      TipoCustoRecorrente.seguro,
      TipoCustoRecorrente.ipva,
      TipoCustoRecorrente.licenciamento,
      TipoCustoRecorrente.telefoneProfissional,
      TipoCustoRecorrente.outro,
    ];
    for (final tipo in tipos) {
      itens.add(_avaliarCusto(tipo, custos));
    }

    itens.add(
      _avaliarCusto(
        TipoCustoRecorrente.parcelaVeiculo,
        custos,
        parcelaCaixa: true,
      ),
    );
    return CoberturaCustos(itens);
  }

  ItemCoberturaCusto _avaliarCusto(
    TipoCustoRecorrente tipo,
    List<CustoRecorrente> custos, {
    bool parcelaCaixa = false,
  }) {
    final registros = custos.where(
      (custo) => custo.tipo == tipo && custo.ativo,
    );
    final registro = registros.firstOrNull;
    final estado = registro == null || registro.valorReferenciaCentavos == null
        ? EstadoCoberturaCusto.naoInformado
        : registro.valorEstimado
        ? EstadoCoberturaCusto.estimado
        : EstadoCoberturaCusto.informado;
    return ItemCoberturaCusto(
      nome: tipo.label,
      estado: estado,
      parcelaCaixa: parcelaCaixa,
      tipo: tipo,
    );
  }
}
