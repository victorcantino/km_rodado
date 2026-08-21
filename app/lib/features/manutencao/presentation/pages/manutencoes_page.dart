import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/daos/manutencao_dao.dart';
import '../controllers/manutencao_controller.dart';
import '../widgets/editar_manutencao_dialog.dart';

class ManutencoesPage extends StatefulWidget {
  final int veiculoId;
  final ManutencaoController controller;
  const ManutencoesPage({
    super.key,
    required this.veiculoId,
    required this.controller,
  });

  @override
  State<ManutencoesPage> createState() => _ManutencoesPageState();
}

class _ManutencoesPageState extends State<ManutencoesPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.carregar(widget.veiculoId);
  }

  Future<void> _abrir([ManutencaoComItens? existente]) async {
    final odometro =
        existente?.manutencao.odometro ??
        await widget.controller.sugerirOdometro(widget.veiculoId);
    if (!mounted) return;
    final resultado = await showDialog<EditarManutencaoResultado>(
      context: context,
      builder: (_) => EditarManutencaoDialog(
        existente: existente,
        odometroInicial: odometro,
        sugestoes: widget.controller.sugestoes,
        sugerirIntervalo: (descricao) =>
            widget.controller.sugerirIntervalo(widget.veiculoId, descricao),
      ),
    );
    if (!mounted || resultado == null) return;
    try {
      await widget.controller.salvar(
        id: existente?.manutencao.id,
        veiculoId: widget.veiculoId,
        dataHora: resultado.dataHora,
        odometro: resultado.odometro,
        oficina: resultado.oficina,
        observacao: resultado.observacao,
        itens: resultado.itens,
      );
    } catch (erro) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(erro.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Manutenções')),
    floatingActionButton: Tooltip(
      message: 'Nova manutenção',
      child: Semantics(
        label: 'Nova manutenção',
        button: true,
        child: FloatingActionButton(
          onPressed: _abrir,
          child: const Icon(Icons.add),
        ),
      ),
    ),
    body: SafeArea(
      child: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          if (widget.controller.carregando &&
              widget.controller.historico.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            children: [
              if (widget.controller.proximas.isNotEmpty) ...[
                Text(
                  'Próximas manutenções',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                for (final proxima in widget.controller.proximas)
                  ListTile(
                    title: Text(proxima.item.descricao),
                    subtitle: Text(
                      [
                        if (proxima.kmRestantes != null)
                          proxima.kmRestantes! <= 0
                              ? 'Referência por km atingida'
                              : 'Faltam ${NumberFormat.decimalPattern('pt_BR').format(proxima.kmRestantes)} km',
                        if (proxima.diasRestantes != null)
                          proxima.diasRestantes! <= 0
                              ? 'Vencimento por data atingido'
                              : 'Vence em ${proxima.diasRestantes} dias',
                      ].join(' · '),
                    ),
                  ),
                const Divider(),
              ],
              Text('Histórico', style: Theme.of(context).textTheme.titleLarge),
              if (widget.controller.historico.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Text('Nenhuma manutenção registrada.'),
                ),
              for (final registro in widget.controller.historico)
                _ManutencaoCard(
                  registro: registro,
                  onEditar: () => _abrir(registro),
                ),
            ],
          );
        },
      ),
    ),
  );
}

class _ManutencaoCard extends StatelessWidget {
  final ManutencaoComItens registro;
  final VoidCallback onEditar;
  const _ManutencaoCard({required this.registro, required this.onEditar});

  @override
  Widget build(BuildContext context) {
    final conhecidos = registro.itens.fold<int>(
      0,
      (total, item) => total + (item.valorCentavos ?? 0),
    );
    final ausentes = registro.itens
        .where((item) => item.valorCentavos == null)
        .length;
    final moeda = NumberFormat.currency(locale: 'pt_BR', symbol: r'R$');
    return Card(
      child: ExpansionTile(
        title: Text(
          '${DateFormat('dd/MM/yyyy').format(registro.manutencao.dataHora)} · '
          '${NumberFormat.decimalPattern('pt_BR').format(registro.manutencao.odometro)} km',
        ),
        subtitle: Text(
          '${registro.itens.length} ${registro.itens.length == 1 ? 'item' : 'itens'} · '
          '${ausentes == 0 ? 'Total' : 'Custo conhecido'}: ${moeda.format(conhecidos / 100)}'
          '${ausentes == 0 ? '' : ' · $ausentes sem valor'}',
        ),
        trailing: IconButton(
          tooltip: 'Editar Manutenção',
          onPressed: onEditar,
          icon: const Icon(Icons.edit),
        ),
        children: [
          for (final item in registro.itens)
            ListTile(
              title: Text(item.descricao),
              subtitle: Text(
                [
                  item.valorCentavos == null
                      ? 'Valor desconhecido'
                      : moeda.format(item.valorCentavos! / 100),
                  if (item.intervaloKm != null)
                    'Próximo: ${NumberFormat.decimalPattern('pt_BR').format(registro.manutencao.odometro + item.intervaloKm!)} km',
                  if (item.vencimentoEm != null)
                    'Revisar até ${DateFormat('dd/MM/yyyy').format(item.vencimentoEm!)}',
                ].join(' · '),
              ),
            ),
          if (registro.manutencao.oficina != null)
            ListTile(
              title: const Text('Oficina'),
              subtitle: Text(registro.manutencao.oficina!),
            ),
          if (registro.manutencao.observacao != null)
            ListTile(
              title: const Text('Observação'),
              subtitle: Text(registro.manutencao.observacao!),
            ),
        ],
      ),
    );
  }
}
