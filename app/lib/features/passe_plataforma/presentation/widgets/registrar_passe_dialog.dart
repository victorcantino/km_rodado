import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/app_database.dart';

typedef RegistrarPasseResultado = ({
  int plataformaId,
  DateTime dataHora,
  int valorPagoCentavos,
  String? modalidade,
  DateTime? validadeAte,
  int? limiteFaturamentoCentavos,
  String? observacao,
});

class RegistrarPasseDialog extends StatefulWidget {
  final List<Plataforma> plataformas;
  const RegistrarPasseDialog({super.key, required this.plataformas});

  @override
  State<RegistrarPasseDialog> createState() => _RegistrarPasseDialogState();
}

class _RegistrarPasseDialogState extends State<RegistrarPasseDialog> {
  final formKey = GlobalKey<FormState>();
  final valor = TextEditingController();
  final limite = TextEditingController();
  String modalidade = '';
  String observacao = '';
  late int plataformaId = widget.plataformas.first.id;
  DateTime dataHora = DateTime.now();
  DateTime? validadeAte;

  int? _centavos(TextEditingController controller) {
    final digitos = controller.text.replaceAll(RegExp(r'\D'), '');
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

  Future<void> _alterarValidade() async {
    final data = await showDatePicker(
      context: context,
      initialDate: validadeAte ?? dataHora,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (data != null && mounted) setState(() => validadeAte = data);
  }

  void _salvar() {
    if (!formKey.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.pop<RegistrarPasseResultado>(context, (
      plataformaId: plataformaId,
      dataHora: dataHora,
      valorPagoCentavos: _centavos(valor)!,
      modalidade: _opcional(modalidade),
      validadeAte: validadeAte,
      limiteFaturamentoCentavos: _centavos(limite),
      observacao: _opcional(observacao),
    ));
  }

  String? _opcional(String texto) {
    final normalizado = texto.trim();
    return normalizado.isEmpty ? null : normalizado;
  }

  @override
  void dispose() {
    valor.dispose();
    limite.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return AlertDialog(
      title: const Text('Registrar passe'),
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
                onChanged: (valor) => plataformaId = valor!,
              ),
              TextFormField(
                key: const ValueKey('valor_passe'),
                controller: valor,
                autofocus: true,
                keyboardType: TextInputType.number,
                inputFormatters: const [_CentavosFormatter()],
                decoration: const InputDecoration(
                  labelText: 'Valor pago',
                  prefixText: r'R$ ',
                ),
                validator: (_) => (_centavos(valor) ?? 0) <= 0
                    ? 'Informe um valor maior que zero.'
                    : null,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Modalidade (opcional)',
                ),
                onChanged: (texto) => modalidade = texto,
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
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Validade (opcional)'),
                subtitle: Text(
                  validadeAte == null
                      ? 'Não informada'
                      : DateFormat.yMd(locale).format(validadeAte!),
                ),
                trailing: validadeAte == null
                    ? const Icon(Icons.calendar_today)
                    : IconButton(
                        onPressed: () => setState(() => validadeAte = null),
                        icon: const Icon(Icons.clear),
                      ),
                onTap: _alterarValidade,
              ),
              TextFormField(
                controller: limite,
                keyboardType: TextInputType.number,
                inputFormatters: const [_CentavosFormatter()],
                decoration: const InputDecoration(
                  labelText: 'Limite de faturamento (opcional)',
                  prefixText: r'R$ ',
                ),
              ),
              TextFormField(
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
