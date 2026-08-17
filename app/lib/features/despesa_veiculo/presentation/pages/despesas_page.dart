import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/enums/escopo_custo_recorrente.dart';
import '../../../../core/constants/enums/tipo_custo_recorrente.dart';
import '../../../../core/constants/enums/tipo_despesa_veiculo.dart';
import '../../../../core/constants/enums/metodo_depreciacao.dart';
import '../../../../core/database/app_database.dart';
import '../../../custo_recorrente/presentation/controllers/custo_recorrente_controller.dart';
import '../../../custo_recorrente/presentation/widgets/editar_custo_recorrente_dialog.dart';
import '../../../depreciacao_veiculo/presentation/controllers/depreciacao_veiculo_controller.dart';
import '../../../depreciacao_veiculo/presentation/pages/depreciacao_veiculo_page.dart';
import '../controllers/despesa_veiculo_controller.dart';
import '../widgets/editar_despesa_veiculo_dialog.dart';

class DespesasPage extends StatefulWidget {
  final int veiculoId;
  final DespesaVeiculoController controller;
  final CustoRecorrenteController custoRecorrenteController;
  final DepreciacaoVeiculoController depreciacaoController;

  const DespesasPage({
    super.key,
    required this.veiculoId,
    required this.controller,
    required this.custoRecorrenteController,
    required this.depreciacaoController,
  });

  @override
  State<DespesasPage> createState() => _DespesasPageState();
}

class _DespesasPageState extends State<DespesasPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.carregar(widget.veiculoId);
    widget.custoRecorrenteController.carregar();
    widget.depreciacaoController.carregar(widget.veiculoId);
  }

  Future<void> _abrirDespesa([DespesaVeiculo? existente]) async {
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
      _apresentarErro(erro);
    }
  }

  Future<void> _abrirCustoRecorrente([CustoRecorrente? existente]) async {
    final controller = widget.custoRecorrenteController;
    if (controller.veiculos.isEmpty || controller.plataformas.isEmpty) {
      await controller.carregar();
      if (!mounted) return;
    }
    final resultado = await showDialog<EditarCustoRecorrenteResultado>(
      context: context,
      builder: (_) => EditarCustoRecorrenteDialog(
        existente: existente,
        veiculoIdInicial: widget.veiculoId,
        veiculos: controller.veiculos,
        plataformas: controller.plataformas,
        padraoPara: controller.padraoPara,
        buscarSugestoes: controller.sugestoes,
      ),
    );
    if (!mounted || resultado == null) return;
    try {
      await controller.salvar(
        id: existente?.id,
        tipo: resultado.tipo,
        descricao: resultado.descricao,
        escopo: resultado.escopo,
        veiculoId: resultado.veiculoId,
        plataformaId: resultado.plataformaId,
        valorReferenciaCentavos: resultado.valorReferenciaCentavos,
        valorEstimado: resultado.valorEstimado,
        periodicidadeMeses: resultado.periodicidadeMeses,
        parcelasPorCiclo: resultado.parcelasPorCiclo,
        ativo: resultado.ativo,
        quantidadeCiclosPrevista: resultado.quantidadeCiclosPrevista,
        observacao: resultado.observacao,
      );
    } catch (erro) {
      _apresentarErro(erro);
    }
  }

  void _apresentarErro(Object erro) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(erro.toString().replaceFirst('Exception: ', ''))),
    );
  }

  Future<void> _abrirDepreciacao() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => DepreciacaoVeiculoPage(
          veiculoId: widget.veiculoId,
          controller: widget.depreciacaoController,
        ),
      ),
    );
    if (!mounted) return;
    await widget.depreciacaoController.carregar(widget.veiculoId);
  }

  String _escopoLabel(CustoRecorrente custo) {
    if (custo.escopo != EscopoCustoRecorrente.plataforma) {
      return custo.escopo.label;
    }
    for (final plataforma in widget.custoRecorrenteController.plataformas) {
      if (plataforma.id == custo.plataformaId) return plataforma.nome;
    }
    return 'Plataforma';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Despesas')),
    floatingActionButton: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: 'Novo custo recorrente',
          excludeFromSemantics: true,
          child: Semantics(
            label: 'Novo custo recorrente',
            button: true,
            child: FloatingActionButton(
              heroTag: 'novo_custo_recorrente',
              onPressed: _abrirCustoRecorrente,
              child: const Icon(Icons.event_repeat),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Tooltip(
          message: 'Nova despesa',
          excludeFromSemantics: true,
          child: Semantics(
            label: 'Nova despesa',
            button: true,
            child: FloatingActionButton(
              heroTag: 'nova_despesa',
              onPressed: _abrirDespesa,
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ],
    ),
    body: SafeArea(
      key: const ValueKey('despesas_safe_area'),
      child: AnimatedBuilder(
        animation: Listenable.merge([
          widget.controller,
          widget.custoRecorrenteController,
          widget.depreciacaoController,
        ]),
        builder: (context, _) {
          final custos = widget.custoRecorrenteController.historico;
          final ativos = custos.where((custo) => custo.ativo);
          final inativos = custos.where((custo) => !custo.ativo);
          return ListView(
            key: const ValueKey('despesas_scroll_unico'),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 152),
            children: [
              _TituloSecao(titulo: 'Despesas do veículo'),
              if (widget.controller.carregando &&
                  widget.controller.historico.isEmpty)
                const Center(child: CircularProgressIndicator())
              else if (widget.controller.historico.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('Nenhuma despesa registrada.'),
                )
              else
                for (final despesa in widget.controller.historico)
                  _DespesaCard(
                    despesa: despesa,
                    onEditar: () => _abrirDespesa(despesa),
                  ),
              const SizedBox(height: 24),
              _TituloSecao(titulo: 'Custos recorrentes'),
              if (widget.custoRecorrenteController.carregando && custos.isEmpty)
                const Center(child: CircularProgressIndicator())
              else if (custos.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('Nenhum custo recorrente cadastrado.'),
                )
              else ...[
                for (final custo in ativos)
                  _CustoRecorrenteCard(
                    custo: custo,
                    escopoLabel: _escopoLabel(custo),
                    onEditar: () => _abrirCustoRecorrente(custo),
                  ),
                if (inativos.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 4),
                    child: Text(
                      'Inativos',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  for (final custo in inativos)
                    _CustoRecorrenteCard(
                      custo: custo,
                      escopoLabel: _escopoLabel(custo),
                      onEditar: () => _abrirCustoRecorrente(custo),
                    ),
                ],
              ],
              const SizedBox(height: 24),
              _TituloSecao(titulo: 'Depreciação do veículo'),
              _DepreciacaoCard(
                controller: widget.depreciacaoController,
                onConfigurar: _abrirDepreciacao,
              ),
            ],
          );
        },
      ),
    ),
  );
}

class _DepreciacaoCard extends StatelessWidget {
  final DepreciacaoVeiculoController controller;
  final VoidCallback onConfigurar;

  const _DepreciacaoCard({
    required this.controller,
    required this.onConfigurar,
  });

  @override
  Widget build(BuildContext context) {
    if (controller.carregando && controller.dados == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final resultado = controller.selecionada;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resultado == null
                  ? 'Depreciação ainda não calculada'
                  : '${resultado.estimado ? 'Referência aproximada: ' : ''}'
                        '${NumberFormat.currency(locale: 'pt_BR', symbol: r'R$').format(resultado.valorPorKm)}/km',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (resultado != null) Text(resultado.metodo.label),
            Align(
              alignment: Alignment.centerRight,
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                alignment: WrapAlignment.end,
                children: [
                  if (resultado != null)
                    TextButton(
                      key: const ValueKey('ver_calculo_depreciacao'),
                      onPressed: () =>
                          mostrarCalculoDepreciacao(context, resultado),
                      child: const Text('Ver cálculo'),
                    ),
                  TextButton(
                    key: ValueKey(
                      resultado == null
                          ? 'configurar_depreciacao'
                          : 'alterar_depreciacao',
                    ),
                    onPressed: onConfigurar,
                    child: Text(resultado == null ? 'Configurar' : 'Alterar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TituloSecao extends StatelessWidget {
  final String titulo;
  const _TituloSecao({required this.titulo});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(titulo, style: Theme.of(context).textTheme.titleLarge),
      const Divider(),
    ],
  );
}

class _DespesaCard extends StatelessWidget {
  final DespesaVeiculo despesa;
  final VoidCallback onEditar;
  const _DespesaCard({required this.despesa, required this.onEditar});

  @override
  Widget build(BuildContext context) {
    final moeda = NumberFormat.currency(locale: 'pt_BR', symbol: r'R$');
    return Card(
      child: ListTile(
        title: Text(despesa.descricao),
        subtitle: Text(
          '${despesa.tipo.label} · '
          '${DateFormat('dd/MM/yyyy HH:mm').format(despesa.dataHora)}\n'
          '${moeda.format(despesa.valorCentavos / 100)}'
          '${despesa.observacao == null ? '' : '\n${despesa.observacao}'}',
        ),
        trailing: IconButton(
          tooltip: 'Editar despesa',
          onPressed: onEditar,
          icon: const Icon(Icons.edit),
        ),
      ),
    );
  }
}

class _CustoRecorrenteCard extends StatelessWidget {
  final CustoRecorrente custo;
  final String escopoLabel;
  final VoidCallback onEditar;
  const _CustoRecorrenteCard({
    required this.custo,
    required this.escopoLabel,
    required this.onEditar,
  });

  @override
  Widget build(BuildContext context) {
    final moeda = NumberFormat.currency(locale: 'pt_BR', symbol: r'R$');
    final valor = custo.valorReferenciaCentavos == null
        ? 'Valor não informado'
        : '${custo.valorEstimado ? '~' : ''}${moeda.format(custo.valorReferenciaCentavos! / 100)} / '
              '${custo.periodicidadeMeses == 1 ? 'mês' : '${custo.periodicidadeMeses} meses'}';
    final equivalente =
        custo.valorReferenciaCentavos == null || custo.periodicidadeMeses == 1
        ? null
        : '≈ ${moeda.format(custo.valorReferenciaCentavos! / custo.periodicidadeMeses / 100)}/mês';
    return Card(
      child: ListTile(
        title: Text(custo.descricao),
        subtitle: Text(
          [
            custo.tipo.label,
            escopoLabel,
            valor,
            ...?equivalente == null ? null : [equivalente],
            if (custo.quantidadeCiclosPrevista != null)
              '${custo.quantidadeCiclosPrevista} ciclos previstos',
          ].join('\n'),
        ),
        trailing: IconButton(
          tooltip: 'Editar custo recorrente',
          onPressed: onEditar,
          icon: const Icon(Icons.edit),
        ),
      ),
    );
  }
}
