import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/enums/tipo_passe.dart';
import '../../../../core/database/app_database.dart';
import '../../data/passe_plataforma_service.dart';

typedef RegistrarPasseResultado = ({
  int plataformaId,
  DateTime dataHora,
  int valorPagoCentavos,
  TipoPasse tipo,
  int? duracaoHoras,
  int? limiteFaturamentoCentavos,
  String? observacao,
});

class RegistrarPasseDialog extends StatefulWidget {
  final List<Plataforma> plataformas;
  final Map<int, ConfiguracaoPasseRepetivel> ultimosRepetiveis;

  const RegistrarPasseDialog({
    super.key,
    required this.plataformas,
    this.ultimosRepetiveis = const {},
  });

  @override
  State<RegistrarPasseDialog> createState() => _RegistrarPasseDialogState();
}

class _RegistrarPasseDialogState extends State<RegistrarPasseDialog> {
  final formKey = GlobalKey<FormState>();
  final valor = TextEditingController();
  final limite = TextEditingController();
  String observacao = '';
  late int plataformaId = widget.plataformas.first.id;
  TipoPasse tipo = TipoPasse.faturamento;
  int duracaoHoras = 24;
  DateTime dataHora = DateTime.now();
  bool mostrarUltimo = true;

  ConfiguracaoPasseRepetivel? get ultimo =>
      widget.ultimosRepetiveis[plataformaId];

  int? _centavos(TextEditingController controller) {
    final digitos = controller.text.replaceAll(RegExp(r'\D'), '');
    return digitos.isEmpty ? null : int.tryParse(digitos);
  }

  DateTime get validadeCalculada => tipo == TipoPasse.faturamento
      ? dataHora.add(const Duration(days: 180))
      : dataHora.add(Duration(hours: duracaoHoras));

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

  void _repetirUltimo() {
    final configuracao = ultimo;
    if (configuracao == null) return;
    setState(() {
      tipo = configuracao.tipo;
      mostrarUltimo = false;
      valor.text = _formatarCentavos(configuracao.valorPagoCentavos);
      if (configuracao.tipo == TipoPasse.faturamento) {
        limite.text = _formatarCentavos(
          configuracao.limiteFaturamentoCentavos!,
        );
      } else {
        limite.clear();
        duracaoHoras = configuracao.duracaoHoras!;
      }
    });
  }

  void _salvar() {
    if (!formKey.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.pop<RegistrarPasseResultado>(context, (
      plataformaId: plataformaId,
      dataHora: dataHora,
      valorPagoCentavos: _centavos(valor)!,
      tipo: tipo,
      duracaoHoras: tipo == TipoPasse.tempo ? duracaoHoras : null,
      limiteFaturamentoCentavos: tipo == TipoPasse.faturamento
          ? _centavos(limite)
          : null,
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
    final moeda = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: r'R$',
      decimalDigits: 2,
    );
    final configuracao = ultimo;
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
                onChanged: (novoId) => setState(() {
                  plataformaId = novoId!;
                  valor.clear();
                  limite.clear();
                  tipo = TipoPasse.faturamento;
                  duracaoHoras = 24;
                  mostrarUltimo = true;
                }),
              ),
              if (configuracao != null && mostrarUltimo)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Último Passe'),
                        Text(
                          configuracao.tipo == TipoPasse.faturamento
                              ? '${moeda.format(configuracao.valorPagoCentavos / 100)} · '
                                    'até ${moeda.format(configuracao.limiteFaturamentoCentavos! / 100)}'
                              : '${moeda.format(configuracao.valorPagoCentavos / 100)} · '
                                    '${configuracao.duracaoHoras} horas',
                        ),
                        Wrap(
                          spacing: 8,
                          children: [
                            TextButton(
                              key: const ValueKey('repetir_ultimo_passe'),
                              onPressed: _repetirUltimo,
                              child: const Text('Repetir último Passe'),
                            ),
                            TextButton(
                              onPressed: () => setState(() {
                                mostrarUltimo = false;
                                valor.clear();
                                limite.clear();
                              }),
                              child: const Text('Informar outro'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              SegmentedButton<TipoPasse>(
                key: const ValueKey('tipo_passe'),
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(
                    value: TipoPasse.faturamento,
                    label: Text('Faturamento'),
                  ),
                  ButtonSegment(value: TipoPasse.tempo, label: Text('Tempo')),
                ],
                selected: {tipo},
                onSelectionChanged: (selecao) => setState(() {
                  tipo = selecao.single;
                  if (tipo == TipoPasse.tempo) limite.clear();
                }),
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
              if (tipo == TipoPasse.faturamento)
                TextFormField(
                  key: const ValueKey('limite_passe'),
                  controller: limite,
                  keyboardType: TextInputType.number,
                  inputFormatters: const [_CentavosFormatter()],
                  decoration: const InputDecoration(
                    labelText: 'Limite de faturamento',
                    prefixText: r'R$ ',
                  ),
                  validator: (_) => (_centavos(limite) ?? 0) <= 0
                      ? 'Informe um limite maior que zero.'
                      : null,
                )
              else
                SegmentedButton<int>(
                  key: const ValueKey('duracao_passe'),
                  segments: const [
                    ButtonSegment(value: 24, label: Text('24 horas')),
                    ButtonSegment(value: 72, label: Text('72 horas')),
                  ],
                  selected: {duracaoHoras},
                  onSelectionChanged: (selecao) =>
                      setState(() => duracaoHoras = selecao.single),
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
                title: const Text('Validade calculada'),
                subtitle: Text(
                  DateFormat.yMd(locale).add_Hm().format(validadeCalculada),
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
