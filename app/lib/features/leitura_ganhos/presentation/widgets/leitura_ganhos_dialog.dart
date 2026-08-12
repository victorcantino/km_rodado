import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/enums/tipo_registro_ganhos.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/ganho_individual_dao.dart';
import '../../data/leitura_ganhos_service.dart';
import 'configurar_plataformas_dialog.dart';

typedef LeituraGanhosResultado = List<ItemLeituraGanhosEntrada>;

class LeituraGanhosDialog extends StatefulWidget {
  final List<Plataforma> plataformas;
  final Map<int, LeiturasGanhoPlataformaData> sugestoes;
  final String titulo;
  final List<Plataforma>? todasPlataformas;
  final Future<List<Plataforma>> Function(Map<int, bool>)? onConfigurar;
  final bool leituraInicial;
  final List<TotalGanhoIndividual> totaisIndividuais;
  final Future<List<TotalGanhoIndividual>> Function(Plataforma)?
  onRegistrarIndividual;

  const LeituraGanhosDialog({
    super.key,
    required this.plataformas,
    required this.sugestoes,
    this.titulo = 'Registrar ganhos',
    this.todasPlataformas,
    this.onConfigurar,
    this.leituraInicial = false,
    this.totaisIndividuais = const [],
    this.onRegistrarIndividual,
  });

  @override
  State<LeituraGanhosDialog> createState() => _LeituraGanhosDialogState();
}

class _LeituraGanhosDialogState extends State<LeituraGanhosDialog> {
  final formKey = GlobalKey<FormState>();
  final valores = <int, TextEditingController>{};
  final quantidades = <int, TextEditingController>{};
  late List<Plataforma> plataformas = widget.plataformas;
  late List<TotalGanhoIndividual> totaisIndividuais = widget.totaisIndividuais;

  Iterable<Plataforma> get plataformasAcumuladas => plataformas.where(
    (plataforma) =>
        plataforma.tipoRegistroGanhos == TipoRegistroGanhos.acumulado,
  );

  @override
  void initState() {
    super.initState();

    for (final plataforma in plataformasAcumuladas) {
      final sugestao = widget.sugestoes[plataforma.id];
      valores[plataforma.id] = TextEditingController(
        text: sugestao == null
            ? ''
            : _formatarCentavos(sugestao.valorAcumuladoCentavos),
      );
      quantidades[plataforma.id] = TextEditingController(
        text: sugestao?.quantidadeViagensAcumulada.toString() ?? '0',
      );
    }
  }

  Future<void> _configurar() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final resultado = await showDialog<Map<int, bool>>(
      context: context,
      builder: (_) =>
          ConfigurarPlataformasDialog(plataformas: widget.todasPlataformas!),
    );
    if (resultado == null) return;
    final atualizadas = await widget.onConfigurar!(resultado);
    if (!mounted) return;
    setState(() => plataformas = atualizadas);
    for (final plataforma in plataformasAcumuladas) {
      valores.putIfAbsent(plataforma.id, TextEditingController.new);
      quantidades.putIfAbsent(
        plataforma.id,
        () => TextEditingController(text: '0'),
      );
    }
  }

  @override
  void dispose() {
    for (final controller in [...valores.values, ...quantidades.values]) {
      controller.dispose();
    }
    super.dispose();
  }

  int? _centavos(String texto) {
    final digitos = texto.replaceAll(RegExp(r'\D'), '');
    return digitos.isEmpty ? null : int.tryParse(digitos);
  }

  void _zerar(int plataformaId) {
    valores[plataformaId]!.text = _formatarCentavos(0);
    quantidades[plataformaId]!.text = '0';
    setState(() {});
  }

  void _zerarTudo() {
    for (final plataforma in plataformasAcumuladas) {
      _zerar(plataforma.id);
    }
  }

  void _alterarQuantidade(int plataformaId, int diferenca) {
    final controller = quantidades[plataformaId]!;
    final atual = int.tryParse(controller.text.trim()) ?? 0;
    controller.text = (atual + diferenca).clamp(0, 1 << 31).toString();
    controller.selection = TextSelection.collapsed(
      offset: controller.text.length,
    );
    setState(() {});
  }

  void _salvar() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final resultado = <ItemLeituraGanhosEntrada>[
      for (final plataforma in plataformasAcumuladas)
        (
          plataformaId: plataforma.id,
          valorAcumuladoCentavos: _centavos(valores[plataforma.id]!.text)!,
          quantidadeViagensAcumulada: int.parse(
            quantidades[plataforma.id]!.text.trim(),
          ),
        ),
    ];

    _fechar(resultado);
  }

  void _fechar([LeituraGanhosResultado? resultado]) {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.pop<LeituraGanhosResultado>(context, resultado);
  }

  @override
  Widget build(BuildContext context) {
    final possuiAcumulada = plataformasAcumuladas.isNotEmpty;

    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text(widget.titulo)),
          if (widget.onConfigurar != null)
            IconButton(
              tooltip: 'Configurar plataformas',
              onPressed: _configurar,
              icon: const Icon(Icons.settings),
            ),
        ],
      ),
      content: SizedBox(
        width: 420,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (plataformas.isEmpty)
                  const Text('Nenhuma plataforma ativa cadastrada.'),
                if (widget.leituraInicial && possuiAcumulada)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _zerarTudo,
                      child: const Text('Tudo zerado'),
                    ),
                  ),
                for (final plataforma in plataformas) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      plataforma.nome,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (plataforma.tipoRegistroGanhos ==
                      TipoRegistroGanhos.individual)
                    Builder(
                      builder: (context) {
                        final total = totaisIndividuais
                            .where(
                              (item) => item.plataforma.id == plataforma.id,
                            )
                            .firstOrNull;
                        final moeda = NumberFormat.currency(
                          locale: 'pt_BR',
                          symbol: r'R$',
                        );
                        return Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${moeda.format((total?.valorTotalCentavos ?? 0) / 100)} · '
                                '${total?.quantidadeViagens ?? 0} viagens',
                              ),
                            ),
                            TextButton(
                              onPressed: widget.onRegistrarIndividual == null
                                  ? null
                                  : () async {
                                      final totais = await widget
                                          .onRegistrarIndividual!(plataforma);
                                      if (mounted) {
                                        setState(
                                          () => totaisIndividuais = totais,
                                        );
                                      }
                                    },
                              child: const Text('+ Registrar'),
                            ),
                          ],
                        );
                      },
                    )
                  else ...[
                    TextFormField(
                      key: ValueKey('valor_${plataforma.id}'),
                      controller: valores[plataforma.id],
                      keyboardType: TextInputType.number,
                      inputFormatters: const [_CentavosInputFormatter()],
                      selectAllOnFocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Valor mostrado',
                        prefixText: r'R$ ',
                      ),
                      validator: (texto) {
                        final centavos = _centavos(texto ?? '');
                        if (centavos == null) {
                          return 'Informe o valor acumulado.';
                        }
                        if (centavos < 0) {
                          return 'O valor não pode ser negativo.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        key: ValueKey('zero_${plataforma.id}'),
                        onPressed: () => _zerar(plataforma.id),
                        child: const Text('Zero'),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          key: ValueKey('menos_${plataforma.id}'),
                          tooltip: 'Diminuir viagens',
                          onPressed: () =>
                              _alterarQuantidade(plataforma.id, -1),
                          icon: const Icon(Icons.remove),
                        ),
                        Expanded(
                          child: TextFormField(
                            key: ValueKey('quantidade_${plataforma.id}'),
                            controller: quantidades[plataforma.id],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              labelText: 'Viagens',
                            ),
                            validator: (texto) {
                              final quantidade = int.tryParse(
                                texto?.trim() ?? '',
                              );
                              if (quantidade == null) {
                                return 'Informe uma quantidade inteira.';
                              }
                              if (quantidade < 0) {
                                return 'A quantidade não pode ser negativa.';
                              }
                              return null;
                            },
                          ),
                        ),
                        IconButton(
                          key: ValueKey('mais_${plataforma.id}'),
                          tooltip: 'Aumentar viagens',
                          onPressed: () => _alterarQuantidade(plataforma.id, 1),
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: _fechar, child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: possuiAcumulada ? _salvar : null,
          child: const Text('Salvar leitura'),
        ),
      ],
    );
  }
}

String _formatarCentavos(int centavos) {
  final reais = centavos ~/ 100;
  final centavosRestantes = (centavos % 100).toString().padLeft(2, '0');
  return '${NumberFormat.decimalPattern('pt_BR').format(reais)},$centavosRestantes';
}

class _CentavosInputFormatter extends TextInputFormatter {
  const _CentavosInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitos = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digitos.isEmpty) return const TextEditingValue();
    final centavos = int.tryParse(digitos);
    if (centavos == null) return oldValue;
    final texto = _formatarCentavos(centavos);
    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}
