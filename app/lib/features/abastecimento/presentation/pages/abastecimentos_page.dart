import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import 'package:intl/intl.dart';

import '../../../../core/constants/enums/tipo_combustivel.dart';
import '../../data/resumo_inteligencia_abastecimento.dart';
import '../../../../core/database/app_database.dart';
import '../controllers/abastecimento_controller.dart';
import '../widgets/registrar_abastecimento_dialog.dart';

class AbastecimentosPage extends StatefulWidget {
  final int veiculoId;
  final AbastecimentoController controller;
  final String? cidadeInicial;

  const AbastecimentosPage({
    super.key,
    required this.veiculoId,
    required this.controller,
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
  }

  Future<void> _abrirNovo() async {
    final odometroInicial = await widget.controller.ultimoOdometro(
      widget.veiculoId,
    );
    if (!mounted) return;
    final ultimo = widget.controller.ultimo;
    await _abrirDialogo(
      odometroInicial: odometroInicial,
      tipoCombustivelInicial: ultimo?.tipoCombustivel,
    );
  }

  Future<void> _abrirEdicao(Abastecimento existente) async {
    await _abrirDialogo(existente: existente);
  }

  Future<void> _abrirDialogo({
    int? odometroInicial,
    TipoCombustivel? tipoCombustivelInicial,
    Abastecimento? existente,
  }) async {
    final resultado = await showDialog<RegistrarAbastecimentoResultado>(
      context: context,
      builder: (_) => RegistrarAbastecimentoDialog(
        odometroInicial: odometroInicial,
        cidadeInicial: widget.cidadeInicial,
        tipoCombustivelInicial: tipoCombustivelInicial,
        existente: existente,
        sugestoesPostos: _sugestoes((item) => item.nomePosto),
        sugestoesBandeiras: _sugestoes((item) => item.bandeiraPosto),
        onExcluir: existente == null
            ? null
            : () async {
                Navigator.pop(context);
                await widget.controller.excluir(existente);
              },
      ),
    );
    if (!mounted || resultado == null) return;
    try {
      final atualizado =
          (existente ??
                  Abastecimento(
                    id: 0,
                    veiculoId: widget.veiculoId,
                    odometro: 0,
                    tipoCombustivel: resultado.tipoCombustivel,
                    volumeMililitros: 0,
                    valorTotalPagoCentavos: 0,
                    tanqueCheio: true,
                    dataHora: resultado.dataHora,
                    dataCriacao: DateTime.now(),
                  ))
              .copyWith(
                odometro: resultado.odometro,
                tipoCombustivel: resultado.tipoCombustivel,
                volumeMililitros: resultado.volumeMililitros,
                valorTotalPagoCentavos: resultado.valorTotalPagoCentavos,
                tanqueCheio: resultado.tanqueCheio,
                dataHora: resultado.dataHora,
                precoBombaMilesimosRealPorLitro: Value(
                  resultado.precoBombaMilesimosRealPorLitro,
                ),
                cidade: Value(resultado.cidade),
                nomePosto: Value(resultado.nomePosto),
                bandeiraPosto: Value(resultado.bandeiraPosto),
                observacao: Value(resultado.observacao),
              );
      if (existente == null) {
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
      } else {
        await widget.controller.editar(atualizado);
      }
    } catch (erro) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(erro.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
  }

  List<String> _sugestoes(String? Function(Abastecimento item) valor) => widget
      .controller
      .historico
      .map(valor)
      .whereType<String>()
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toSet()
      .toList();

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
          final ciclos = {
            for (final ciclo
                in widget.controller.inteligencia?.ciclosRecentes ??
                    const <ResumoCicloAbastecimento>[])
              ciclo.abastecimentoFim.id: ciclo,
          };
          final moeda = NumberFormat.currency(locale: 'pt_BR', symbol: r'R$');
          final calendario = DateFormat("dd/MM/yyyy (EEEE) • HH:mm", 'pt_BR');
          final decimal = NumberFormat.decimalPattern('pt_BR')
            ..minimumFractionDigits = 1
            ..maximumFractionDigits = 1;
          double custoPorKm(ResumoCicloAbastecimento ciclo) {
            final custoCentavos = widget.controller.historico
                .where(
                  (item) =>
                      !item.dataHora.isBefore(
                        ciclo.abastecimentoInicio.dataHora,
                      ) &&
                      !item.dataHora.isAfter(ciclo.abastecimentoFim.dataHora),
                )
                .fold<int>(
                  0,
                  (total, item) => total + item.valorTotalPagoCentavos,
                );
            return custoCentavos / ciclo.distanciaKm / 100;
          }

          String combustivel(TipoCombustivel tipo) => switch (tipo) {
            TipoCombustivel.gasolina => 'Gasolina',
            TipoCombustivel.etanol => 'Etanol',
            TipoCombustivel.outro => 'Outro',
          };
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
                  Builder(
                    builder: (context) {
                      final ciclo = ciclos[abastecimento.id];
                      final precoBomba =
                          abastecimento.precoBombaMilesimosRealPorLitro;
                      final totalBomba = precoBomba == null
                          ? null
                          : (abastecimento.volumeMililitros * precoBomba) ~/
                                10000;
                      final desconto = totalBomba == null
                          ? null
                          : totalBomba - abastecimento.valorTotalPagoCentavos;
                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.fromLTRB(
                            16,
                            8,
                            8,
                            8,
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${abastecimento.nomePosto?.trim().isNotEmpty == true ? '${abastecimento.nomePosto} · ' : ''}${combustivel(abastecimento.tipoCombustivel)}',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ),
                              IconButton(
                                tooltip: 'Editar abastecimento',
                                onPressed: () => _abrirEdicao(abastecimento),
                                icon: const Icon(Icons.edit_outlined),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(calendario.format(abastecimento.dataHora)),
                              _DadoAbastecimento(
                                rotulo: 'Litros',
                                valor:
                                    '${decimal.format(abastecimento.volumeMililitros / 1000)} L',
                              ),
                              _DadoAbastecimento(
                                rotulo: 'Pago',
                                valor: moeda.format(
                                  abastecimento.valorTotalPagoCentavos / 100,
                                ),
                              ),
                              if (abastecimento.volumeMililitros > 0)
                                _DadoAbastecimento(
                                  rotulo: 'R\$/L efetivo',
                                  valor: moeda.format(
                                    abastecimento.valorTotalPagoCentavos *
                                        10 /
                                        abastecimento.volumeMililitros,
                                  ),
                                ),
                              if (desconto != null && desconto > 0)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Desconto ${NumberFormat('0.0', 'pt_BR').format(desconto * 100 / totalBomba!)}%',
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      moeda.format(desconto / 100),
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              if (ciclo != null) ...[
                                _DadoAbastecimento(
                                  rotulo: 'Km/l',
                                  valor: decimal.format(ciclo.kmPorLitro),
                                ),
                                _DadoAbastecimento(
                                  rotulo: 'R\$/km',
                                  valor: moeda.format(custoPorKm(ciclo)),
                                ),
                              ] else
                                const Row(
                                  children: [
                                    Icon(Icons.info_outline, size: 16),
                                    SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'Aguardando fechamento do ciclo',
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

class _DadoAbastecimento extends StatelessWidget {
  final String rotulo;
  final String valor;

  const _DadoAbastecimento({required this.rotulo, required this.valor});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: Text(rotulo)),
      Text(valor, textAlign: TextAlign.right),
    ],
  );
}
