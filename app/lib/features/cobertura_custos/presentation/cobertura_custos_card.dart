import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/enums/tipo_custo_recorrente.dart';
import '../data/cobertura_custos.dart';

class CoberturaCustosCard extends StatelessWidget {
  final CoberturaCustos cobertura;
  final void Function(ItemCoberturaCusto item)? onConfigurar;
  final VoidCallback? onNovoCustoRecorrente;

  const CoberturaCustosCard({
    super.key,
    required this.cobertura,
    this.onConfigurar,
    this.onNovoCustoRecorrente,
  });

  IconData _icone(EstadoCoberturaCusto estado) => switch (estado) {
    EstadoCoberturaCusto.informado => Icons.check_circle_outline,
    EstadoCoberturaCusto.estimado => Icons.change_history_outlined,
    EstadoCoberturaCusto.naoInformado => Icons.help_outline,
  };

  String _estado(EstadoCoberturaCusto estado) => switch (estado) {
    EstadoCoberturaCusto.informado => 'Informado',
    EstadoCoberturaCusto.estimado => 'Estimado',
    EstadoCoberturaCusto.naoInformado => 'Não informado',
  };

  @override
  Widget build(BuildContext context) => Card(
    key: const ValueKey('cobertura_custos'),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cobertura.possuiDados
                ? cobertura.possuiLacunas
                      ? 'Já existem dados para iniciar a composição dos custos. Preencha as lacunas quando possível.'
                      : 'Já existem dados para iniciar a composição dos custos.'
                : 'Ainda não há dados suficientes; o cálculo futuro poderá melhorar quando essas informações forem preenchidas.',
          ),
          const SizedBox(height: 8),
          for (final item in cobertura.itens)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                _icone(item.estado),
                semanticLabel: _estado(item.estado),
              ),
              title: Text(item.nome),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _linhas(item),
              ),
              trailing:
                  item.tipo == TipoCustoRecorrente.outro &&
                      onNovoCustoRecorrente != null
                  ? Tooltip(
                      message: 'Novo custo recorrente',
                      excludeFromSemantics: true,
                      child: Semantics(
                        label: 'Novo custo recorrente',
                        button: true,
                        child: IconButton(
                          onPressed: onNovoCustoRecorrente,
                          icon: const Icon(Icons.event_repeat),
                        ),
                      ),
                    )
                  : item.estado == EstadoCoberturaCusto.naoInformado &&
                        onConfigurar != null
                  ? Tooltip(
                      message: 'Configurar ${item.nome}',
                      excludeFromSemantics: true,
                      child: Semantics(
                        label: 'Configurar ${item.nome}',
                        button: true,
                        child: IconButton(
                          onPressed: () => onConfigurar!(item),
                          icon: const Icon(Icons.edit_outlined),
                        ),
                      ),
                    )
                  : null,
            ),
        ],
      ),
    ),
  );

  List<Widget> _linhas(ItemCoberturaCusto item) {
    final linhas = <Widget>[_linha('Estado', _estado(item.estado))];
    if (item.parcelaCaixa) {
      linhas.add(_linha('Natureza', 'Obrigação de caixa'));
    }
    if (item.reaisPorKm != null) {
      linhas.add(
        _linha('Custo por km', 'R\$ ${_decimal(item.reaisPorKm!)}/km'),
      );
    }
    if (item.precoEfetivoReaisPorLitro != null) {
      linhas.add(
        _linha(
          'Último preço efetivo',
          'R\$ ${_decimal(item.precoEfetivoReaisPorLitro!)}/L',
        ),
      );
    }
    if (item.valorAtualEstimadoCentavos != null) {
      linhas.add(
        _linha(
          'Valor atual estimado',
          NumberFormat.currency(
            locale: 'pt_BR',
            symbol: r'R$',
          ).format(item.valorAtualEstimadoCentavos! / 100),
        ),
      );
    }
    if (item.quantidadeItens != null) {
      linhas.add(_linha('Itens considerados', '${item.quantidadeItens}'));
    }
    if (item.referencia != null) {
      linhas.add(_linha('Referência', item.referencia!));
    }
    return linhas;
  }

  Widget _linha(String rotulo, String valor) => Padding(
    padding: const EdgeInsets.only(top: 2),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(rotulo)),
        const SizedBox(width: 12),
        Flexible(child: Text(valor, textAlign: TextAlign.right)),
      ],
    ),
  );

  String _decimal(double valor) => NumberFormat.decimalPatternDigits(
    locale: 'pt_BR',
    decimalDigits: 2,
  ).format(valor);
}
