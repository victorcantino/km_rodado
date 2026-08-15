import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/app_database.dart';

typedef RegistrarGanhoIndividualResultado = ({
  int plataformaId,
  int quantidadeViagens,
  int valorTotalCentavos,
  String? observacao,
});

class RegistrarGanhoIndividualDialog extends StatefulWidget {
  final List<Plataforma> plataformas;

  const RegistrarGanhoIndividualDialog({super.key, required this.plataformas});

  @override
  State<RegistrarGanhoIndividualDialog> createState() =>
      _RegistrarGanhoIndividualDialogState();
}

class _RegistrarGanhoIndividualDialogState
    extends State<RegistrarGanhoIndividualDialog> {
  final formKey = GlobalKey<FormState>();
  final valor = TextEditingController();
  final quantidade = TextEditingController(text: '1');
  final focoValor = FocusNode();
  final focoQuantidade = FocusNode();
  final focoObservacao = FocusNode();
  String observacao = '';
  late int plataformaId = widget.plataformas.first.id;

  int? get centavos {
    final digitos = valor.text.replaceAll(RegExp(r'\D'), '');
    return digitos.isEmpty ? null : int.tryParse(digitos);
  }

  void alterarQuantidade(int diferenca) {
    final atual = int.tryParse(quantidade.text) ?? 1;
    quantidade.text = (atual + diferenca).clamp(1, 1 << 31).toString();
    setState(() {});
  }

  void salvar() {
    if (!formKey.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.pop<RegistrarGanhoIndividualResultado>(context, (
      plataformaId: plataformaId,
      quantidadeViagens: int.parse(quantidade.text),
      valorTotalCentavos: centavos!,
      observacao: observacao.trim().isEmpty ? null : observacao.trim(),
    ));
  }

  @override
  void dispose() {
    valor.dispose();
    quantidade.dispose();
    focoValor.dispose();
    focoQuantidade.dispose();
    focoObservacao.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Registrar ganho individual'),
    content: Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.plataformas.length > 1)
              DropdownButtonFormField<int>(
                initialValue: plataformaId,
                decoration: const InputDecoration(labelText: 'Plataforma'),
                items: [
                  for (final plataforma in widget.plataformas)
                    DropdownMenuItem(
                      value: plataforma.id,
                      child: Text(plataforma.nome),
                    ),
                ],
                onChanged: (id) => plataformaId = id!,
              )
            else
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.plataformas.single.nome,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            TextFormField(
              key: const ValueKey('valor_individual'),
              controller: valor,
              focusNode: focoValor,
              autofocus: true,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => focoQuantidade.requestFocus(),
              inputFormatters: const [_CentavosFormatter()],
              decoration: const InputDecoration(
                labelText: 'Valor total',
                prefixText: r'R$ ',
              ),
              validator: (_) =>
                  centavos == null ? 'Informe o valor total.' : null,
            ),
            Row(
              children: [
                IconButton(
                  key: const ValueKey('menos_individual'),
                  onPressed: () => alterarQuantidade(-1),
                  icon: const Icon(Icons.remove),
                ),
                Expanded(
                  child: TextFormField(
                    key: const ValueKey('quantidade_individual'),
                    controller: quantidade,
                    focusNode: focoQuantidade,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => focoObservacao.requestFocus(),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(labelText: 'Viagens'),
                    validator: (texto) {
                      final numero = int.tryParse(texto ?? '');
                      return numero == null || numero < 1
                          ? 'Informe ao menos 1 viagem.'
                          : null;
                    },
                  ),
                ),
                IconButton(
                  key: const ValueKey('mais_individual'),
                  onPressed: () => alterarQuantidade(1),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            TextFormField(
              key: const ValueKey('observacao_individual'),
              initialValue: observacao,
              focusNode: focoObservacao,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => focoObservacao.unfocus(),
              decoration: const InputDecoration(
                labelText: 'Observação (opcional)',
              ),
              onChanged: (texto) => observacao = texto,
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      ElevatedButton(onPressed: salvar, child: const Text('Registrar')),
    ],
  );
}

String _formatarCentavos(int centavos) {
  final reais = centavos ~/ 100;
  final resto = (centavos % 100).toString().padLeft(2, '0');
  return '${NumberFormat.decimalPattern('pt_BR').format(reais)},$resto';
}

class _CentavosFormatter extends TextInputFormatter {
  const _CentavosFormatter();

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
