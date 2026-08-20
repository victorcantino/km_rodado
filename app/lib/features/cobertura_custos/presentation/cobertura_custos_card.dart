import 'package:flutter/material.dart';

import '../data/cobertura_custos.dart';

class CoberturaCustosCard extends StatelessWidget {
  final CoberturaCustos cobertura;
  final void Function(ItemCoberturaCusto item)? onConfigurar;

  const CoberturaCustosCard({
    super.key,
    required this.cobertura,
    this.onConfigurar,
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
              subtitle: Text(
                item.parcelaCaixa
                    ? '${_estado(item.estado)} · obrigação de caixa'
                    : _estado(item.estado),
              ),
              trailing:
                  item.estado == EstadoCoberturaCusto.naoInformado &&
                      onConfigurar != null
                  ? TextButton(
                      onPressed: () => onConfigurar!(item),
                      child: const Text('Configurar'),
                    )
                  : null,
            ),
        ],
      ),
    ),
  );
}
