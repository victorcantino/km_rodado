import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import 'package:intl/intl.dart';

import '../../../../core/constants/enums/tipo_passe.dart';
import '../../../../core/database/daos/bonus_promocao_dao.dart';
import '../../../../core/database/daos/passe_plataforma_dao.dart';
import '../controllers/passe_plataforma_controller.dart';
import '../widgets/registrar_passe_dialog.dart';
import '../../../bonus_promocao/presentation/controllers/bonus_promocao_controller.dart';
import '../../../bonus_promocao/presentation/widgets/registrar_bonus_promocao_dialog.dart';

class PassesBonusPage extends StatefulWidget {
  final PassePlataformaController passeController;
  final BonusPromocaoController bonusController;

  const PassesBonusPage({
    super.key,
    required this.passeController,
    required this.bonusController,
  });

  @override
  State<PassesBonusPage> createState() => _PassesBonusPageState();
}

class _PassesBonusPageState extends State<PassesBonusPage> {
  bool carregando = true;
  bool mostrarTodosPasses = false;
  bool mostrarTodosBonus = false;

  @override
  void initState() {
    super.initState();
    _carregarHistorico();
  }

  Future<void> _carregarHistorico() async {
    setState(() => carregando = true);
    await Future.wait([
      widget.passeController.carregarHistorico(),
      widget.bonusController.carregarHistorico(),
    ]);
    if (mounted) setState(() => carregando = false);
  }

  Future<void> _registrarPasse() async {
    final resultado = await showDialog<RegistrarPasseResultado>(
      context: context,
      builder: (_) => RegistrarPasseDialog(
        plataformas: widget.passeController.plataformas,
        ultimosRepetiveis: widget.passeController.ultimosRepetiveis,
      ),
    );
    if (!mounted || resultado == null) return;
    try {
      await widget.passeController.registrar(
        plataformaId: resultado.plataformaId,
        dataHora: resultado.dataHora,
        valorPagoCentavos: resultado.valorPagoCentavos,
        tipo: resultado.tipo,
        duracaoHoras: resultado.duracaoHoras,
        limiteFaturamentoCentavos: resultado.limiteFaturamentoCentavos,
        observacao: resultado.observacao,
      );
      await _carregarHistorico();
    } catch (erro) {
      _mostrarErro(erro);
    }
  }

  Future<void> _registrarBonus() async {
    final resultado = await showDialog<RegistrarBonusPromocaoResultado>(
      context: context,
      builder: (_) => RegistrarBonusPromocaoDialog(
        plataformas: widget.bonusController.plataformas,
      ),
    );
    if (!mounted || resultado == null) return;
    try {
      await widget.bonusController.registrar(
        plataformaId: resultado.plataformaId,
        dataHora: resultado.dataHora,
        valorCentavos: resultado.valorCentavos,
        observacao: resultado.observacao,
      );
      await _carregarHistorico();
    } catch (erro) {
      _mostrarErro(erro);
    }
  }

  Future<void> _editarPasse(PasseComPlataforma item) async {
    final resultado = await showDialog<RegistrarPasseResultado>(
      context: context,
      builder: (_) => RegistrarPasseDialog(
        plataformas: widget.passeController.plataformas,
        ultimosRepetiveis: const {},
        existente: item.passe,
        onExcluir: () async {
          Navigator.pop(context);
          await widget.passeController.excluir(item.passe.id);
          await _carregarHistorico();
        },
      ),
    );
    if (!mounted || resultado == null) return;
    await widget.passeController.editar(
      item.passe.copyWith(
        plataformaId: resultado.plataformaId,
        dataHora: resultado.dataHora,
        valorPagoCentavos: resultado.valorPagoCentavos,
        modalidade: Value(resultado.tipo.name),
        validadeAte: Value(
          resultado.tipo == TipoPasse.faturamento
              ? resultado.dataHora.add(const Duration(days: 180))
              : resultado.dataHora.add(
                  Duration(hours: resultado.duracaoHoras!),
                ),
        ),
        limiteFaturamentoCentavos: Value(resultado.limiteFaturamentoCentavos),
        observacao: Value(resultado.observacao),
      ),
    );
    await _carregarHistorico();
  }

  Future<void> _editarBonus(BonusPromocaoComPlataforma item) async {
    final resultado = await showDialog<RegistrarBonusPromocaoResultado>(
      context: context,
      builder: (_) => RegistrarBonusPromocaoDialog(
        plataformas: widget.bonusController.plataformas,
        existente: item.bonusPromocao,
        onExcluir: () async {
          Navigator.pop(context);
          await widget.bonusController.excluir(item.bonusPromocao.id);
          await _carregarHistorico();
        },
      ),
    );
    if (!mounted || resultado == null) return;
    await widget.bonusController.editar(
      item.bonusPromocao.copyWith(
        plataformaId: resultado.plataformaId,
        dataHora: resultado.dataHora,
        valorCentavos: resultado.valorCentavos,
        observacao: Value(resultado.observacao),
      ),
    );
    await _carregarHistorico();
  }

  void _mostrarErro(Object erro) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(erro.toString().replaceFirst('Exception: ', ''))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final moeda = NumberFormat.currency(locale: 'pt_BR', symbol: r'R$');
    final data = DateFormat.yMd('pt_BR').add_Hm();
    final passes = mostrarTodosPasses
        ? widget.passeController.passes
        : widget.passeController.passes.take(3).toList();
    final bonus = mostrarTodosBonus
        ? widget.bonusController.bonusPromocoes
        : widget.bonusController.bonusPromocoes.take(3).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Passes e bônus')),
      floatingActionButton: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Tooltip(
              message: 'Novo passe',
              child: Semantics(
                label: 'Novo passe',
                button: true,
                child: FloatingActionButton(
                  heroTag: 'novo_passe',
                  onPressed: widget.passeController.plataformas.isEmpty
                      ? null
                      : _registrarPasse,
                  child: const Icon(Icons.confirmation_number_outlined),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Tooltip(
              message: 'Novo bônus',
              child: Semantics(
                label: 'Novo bônus',
                button: true,
                child: FloatingActionButton(
                  heroTag: 'novo_bonus',
                  onPressed: widget.bonusController.plataformas.isEmpty
                      ? null
                      : _registrarBonus,
                  child: const Icon(Icons.redeem_outlined),
                ),
              ),
            ),
          ],
        ),
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _carregarHistorico,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _Secao(
                    titulo: 'Passes',
                    mostrarTodos: mostrarTodosPasses,
                    onVerTodos: () => setState(() => mostrarTodosPasses = true),
                    children: [
                      for (final item in passes)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(item.plataforma.nome),
                          subtitle: Text(data.format(item.passe.dataHora)),
                          onTap: () => _editarPasse(item),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                moeda.format(
                                  item.passe.valorPagoCentavos / 100,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.edit_outlined, size: 20),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _Secao(
                    titulo: 'Bônus/Promoções',
                    mostrarTodos: mostrarTodosBonus,
                    onVerTodos: () => setState(() => mostrarTodosBonus = true),
                    children: [
                      for (final item in bonus)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(item.plataforma.nome),
                          subtitle: Text(
                            data.format(item.bonusPromocao.dataHora),
                          ),
                          onTap: () => _editarBonus(item),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                moeda.format(
                                  item.bonusPromocao.valorCentavos / 100,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.edit_outlined, size: 20),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class _Secao extends StatelessWidget {
  final String titulo;
  final bool mostrarTodos;
  final VoidCallback onVerTodos;
  final List<Widget> children;

  const _Secao({
    required this.titulo,
    required this.mostrarTodos,
    required this.onVerTodos,
    required this.children,
  });

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  titulo,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              if (!mostrarTodos)
                TextButton(
                  onPressed: onVerTodos,
                  child: const Text('Ver todos'),
                ),
            ],
          ),
          if (children.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Nenhum registro.'),
            )
          else
            ...children,
        ],
      ),
    ),
  );
}
