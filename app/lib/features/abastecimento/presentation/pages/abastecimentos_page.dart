import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../controllers/abastecimento_controller.dart';
import '../widgets/registrar_abastecimento_dialog.dart';

class AbastecimentosPage extends StatefulWidget {
  final int veiculoId;
  final AbastecimentoController controller;
  final bool abrirNovoAoEntrar;
  final String? cidadeInicial;

  const AbastecimentosPage({
    super.key,
    required this.veiculoId,
    required this.controller,
    this.abrirNovoAoEntrar = false,
    this.cidadeInicial,
  });

  @override
  State<AbastecimentosPage> createState() => _AbastecimentosPageState();
}

class _AbastecimentosPageState extends State<AbastecimentosPage> {
  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    await widget.controller.carregar(widget.veiculoId);
    if (mounted && widget.abrirNovoAoEntrar) {
      await _abrirNovo();
    }
  }

  Future<void> _abrirNovo() async {
    final odometroInicial = await widget.controller.ultimoOdometro(
      widget.veiculoId,
    );
    if (!mounted) return;
    final ultimo = widget.controller.ultimo;
    final resultado = await showDialog<RegistrarAbastecimentoResultado>(
      context: context,
      builder: (_) => RegistrarAbastecimentoDialog(
        odometroInicial: odometroInicial,
        cidadeInicial: widget.cidadeInicial,
        tipoCombustivelInicial: ultimo?.tipoCombustivel,
      ),
    );
    if (!mounted || resultado == null) return;
    try {
      await widget.controller.registrar(
        veiculoId: widget.veiculoId,
        odometro: resultado.odometro,
        tipoCombustivel: resultado.tipoCombustivel,
        volumeMililitros: resultado.volumeMililitros,
        valorTotalPagoCentavos: resultado.valorTotalPagoCentavos,
        tanqueCheio: resultado.tanqueCheio,
        dataHora: resultado.dataHora,
        precoBombaMilesimosRealPorLitro:
            resultado.precoBombaMilesimosRealPorLitro,
        cidade: resultado.cidade,
        nomePosto: resultado.nomePosto,
        bandeiraPosto: resultado.bandeiraPosto,
        observacao: resultado.observacao,
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
    appBar: AppBar(title: const Text('Abastecimentos')),
    floatingActionButton: Tooltip(
      message: 'Novo abastecimento',
      child: Semantics(
        label: 'Novo abastecimento',
        button: true,
        child: FloatingActionButton(
          onPressed: _abrirNovo,
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
          return RefreshIndicator(
            onRefresh: () => widget.controller.carregar(widget.veiculoId),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              children: [
                if (widget.controller.historico.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: Text('Nenhum abastecimento registrado.'),
                  ),
                for (final abastecimento in widget.controller.historico)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      '${abastecimento.odometro} km · ${abastecimento.tipoCombustivel.name}',
                    ),
                    subtitle: Text(
                      '${DateFormat('dd/MM/yyyy HH:mm').format(abastecimento.dataHora)}\n'
                      '${(abastecimento.valorTotalPagoCentavos / 100).toStringAsFixed(2)}',
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    ),
  );
}
