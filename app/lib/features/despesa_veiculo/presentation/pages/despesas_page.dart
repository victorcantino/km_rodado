import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/enums/tipo_despesa_veiculo.dart';
import '../../../../core/database/app_database.dart';
import '../controllers/despesa_veiculo_controller.dart';
import '../widgets/editar_despesa_veiculo_dialog.dart';

class DespesasPage extends StatefulWidget {
  final int veiculoId;
  final DespesaVeiculoController controller;

  const DespesasPage({
    super.key,
    required this.veiculoId,
    required this.controller,
  });

  @override
  State<DespesasPage> createState() => _DespesasPageState();
}

class _DespesasPageState extends State<DespesasPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.carregar(widget.veiculoId);
  }

  Future<void> _abrir([DespesaVeiculo? existente]) async {
    final resultado = await showDialog<EditarDespesaVeiculoResultado>(
      context: context,
      builder: (_) => EditarDespesaVeiculoDialog(
        existente: existente,
        buscarSugestoes: (tipo) =>
            widget.controller.sugestoes(widget.veiculoId, tipo),
      ),
    );
    if (!mounted || resultado == null) return;
    try {
      await widget.controller.salvar(
        id: existente?.id,
        veiculoId: widget.veiculoId,
        tipo: resultado.tipo,
        descricao: resultado.descricao,
        valorCentavos: resultado.valorCentavos,
        dataHora: resultado.dataHora,
        observacao: resultado.observacao,
      );
    } catch (erro) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_mensagem(erro))));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Despesas do veículo')),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: _abrir,
      icon: const Icon(Icons.add),
      label: const Text('Nova'),
    ),
    body: SafeArea(
      child: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          if (widget.controller.carregando &&
              widget.controller.historico.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (widget.controller.historico.isEmpty) {
            return const Center(child: Text('Nenhuma despesa registrada.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            itemCount: widget.controller.historico.length,
            itemBuilder: (context, indice) {
              final despesa = widget.controller.historico[indice];
              return Card(
                child: ListTile(
                  title: Text(despesa.descricao),
                  subtitle: Text(
                    '${despesa.tipo.label} · '
                    '${DateFormat('dd/MM/yyyy HH:mm').format(despesa.dataHora)}'
                    '${despesa.observacao == null ? '' : '\n${despesa.observacao}'}',
                  ),
                  isThreeLine: despesa.observacao != null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        NumberFormat.currency(
                          locale: 'pt_BR',
                          symbol: r'R$',
                        ).format(despesa.valorCentavos / 100),
                      ),
                      IconButton(
                        tooltip: 'Editar despesa',
                        onPressed: () => _abrir(despesa),
                        icon: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    ),
  );
}

String _mensagem(Object erro) =>
    erro.toString().replaceFirst('Exception: ', '');
