import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/app_database.dart';

typedef RegistrarBonusPromocaoResultado = ({
  int plataformaId,
  DateTime dataHora,
  int valorCentavos,
  String? observacao,
});

class RegistrarBonusPromocaoDialog extends StatefulWidget {
  final List<Plataforma> plataformas;
  final BonusPromocao? existente;
  final VoidCallback? onExcluir;

  const RegistrarBonusPromocaoDialog({
    super.key,
    required this.plataformas,
    this.existente,
    this.onExcluir,
  });

  @override
  State<RegistrarBonusPromocaoDialog> createState() =>
      _RegistrarBonusPromocaoDialogState();
}

class _RegistrarBonusPromocaoDialogState
    extends State<RegistrarBonusPromocaoDialog> {
  final formKey = GlobalKey<FormState>();
  final valor = TextEditingController();
  final observacao = TextEditingController();
  final focoValor = FocusNode();
  final focoObservacao = FocusNode();
  late int plataformaId = widget.plataformas.first.id;
  DateTime dataHora = DateTime.now();

  @override
  void initState() {
    super.initState();
    final existente = widget.existente;
    if (existente != null) {
      plataformaId = existente.plataformaId;
      dataHora = existente.dataHora;
      valor.text = _formatarCentavos(existente.valorCentavos);
      observacao.text = existente.observacao ?? '';
    }
  }

  int? get valorCentavos {
    final digitos = valor.text.replaceAll(RegExp(r'\D'), '');
    return digitos.isEmpty ? null : int.tryParse(digitos);
  }

  Future<void> _alterarDataHora() async {
    final data = await showDatePicker(
      context: context,
      initialDate: dataHora,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (!mounted || data == null) return;
    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(dataHora),
    );
    if (!mounted || hora == null) return;
    setState(() {
      dataHora = DateTime(
        data.year,
        data.month,
        data.day,
        hora.hour,
        hora.minute,
      );
    });
  }

  void _salvar() {
    if (!formKey.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();
    final texto = observacao.text.trim();
    Navigator.pop<RegistrarBonusPromocaoResultado>(context, (
      plataformaId: plataformaId,
      dataHora: dataHora,
      valorCentavos: valorCentavos!,
      observacao: texto.isEmpty ? null : texto,
    ));
  }

  @override
  void dispose() {
    valor.dispose();
    observacao.dispose();
    focoValor.dispose();
    focoObservacao.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return AlertDialog(
      title: Text(
        widget.existente == null
            ? 'Registrar bônus/promoção'
            : 'Editar bônus/promoção',
      ),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              ),
              TextFormField(
                key: const ValueKey('valor_bonus_promocao'),
                controller: valor,
                focusNode: focoValor,
                autofocus: true,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => focoObservacao.requestFocus(),
                inputFormatters: const [_CentavosFormatter()],
                decoration: const InputDecoration(
                  labelText: 'Valor creditado',
                  prefixText: r'R$ ',
                ),
                validator: (_) => (valorCentavos ?? 0) <= 0
                    ? 'Informe um valor maior que zero.'
                    : null,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Data e hora'),
                subtitle: Text(
                  DateFormat.yMd(locale).add_Hm().format(dataHora),
                ),
                trailing: const Icon(Icons.edit_calendar),
                onTap: _alterarDataHora,
              ),
              TextFormField(
                key: const ValueKey('observacao_bonus_promocao'),
                controller: observacao,
                focusNode: focoObservacao,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => focoObservacao.unfocus(),
                decoration: const InputDecoration(
                  labelText: 'Observação opcional',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (widget.existente != null && widget.onExcluir != null)
          TextButton(onPressed: widget.onExcluir, child: const Text('Excluir')),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(onPressed: _salvar, child: const Text('Registrar')),
      ],
    );
  }
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
    final numero = int.tryParse(digitos);
    if (numero == null) return oldValue;
    final texto = _formatarCentavos(numero);
    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}
