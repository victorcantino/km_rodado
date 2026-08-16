import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/enums/tipo_despesa_veiculo.dart';
import '../../../../core/database/app_database.dart';

typedef EditarDespesaVeiculoResultado = ({
  TipoDespesaVeiculo tipo,
  String descricao,
  int valorCentavos,
  DateTime dataHora,
  String? observacao,
});

class EditarDespesaVeiculoDialog extends StatefulWidget {
  final DespesaVeiculo? existente;
  final Future<List<String>> Function(TipoDespesaVeiculo tipo) buscarSugestoes;

  const EditarDespesaVeiculoDialog({
    super.key,
    this.existente,
    required this.buscarSugestoes,
  });

  @override
  State<EditarDespesaVeiculoDialog> createState() =>
      _EditarDespesaVeiculoDialogState();
}

class _EditarDespesaVeiculoDialogState
    extends State<EditarDespesaVeiculoDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController descricao;
  late final TextEditingController valor;
  late final TextEditingController observacao;
  late final FocusNode focoDescricao;
  late final FocusNode focoValor;
  late final FocusNode focoObservacao;
  late TipoDespesaVeiculo tipo;
  late DateTime dataHora;
  List<String> sugestoes = const [];

  @override
  void initState() {
    super.initState();
    final existente = widget.existente;
    tipo = existente?.tipo ?? TipoDespesaVeiculo.ipva;
    dataHora = existente?.dataHora ?? DateTime.now();
    descricao = TextEditingController(text: existente?.descricao ?? '');
    valor = TextEditingController(
      text: _formatarCentavos(existente?.valorCentavos),
    );
    observacao = TextEditingController(text: existente?.observacao ?? '');
    focoDescricao = FocusNode();
    focoValor = FocusNode();
    focoObservacao = FocusNode();
    _carregarSugestoes();
  }

  @override
  void dispose() {
    descricao.dispose();
    valor.dispose();
    observacao.dispose();
    focoDescricao.dispose();
    focoValor.dispose();
    focoObservacao.dispose();
    super.dispose();
  }

  Future<void> _carregarSugestoes() async {
    final resultado = await widget.buscarSugestoes(tipo);
    if (!mounted) return;
    setState(() => sugestoes = resultado);
  }

  Future<void> _alterarDataHora() async {
    final agora = DateTime.now();
    final data = await showDatePicker(
      context: context,
      initialDate: dataHora.isAfter(agora) ? agora : dataHora,
      firstDate: DateTime(2000),
      lastDate: agora,
    );
    if (!mounted || data == null) return;
    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(dataHora),
    );
    if (!mounted || hora == null) return;
    setState(
      () => dataHora = DateTime(
        data.year,
        data.month,
        data.day,
        hora.hour,
        hora.minute,
      ),
    );
  }

  void _salvar() {
    if (!formKey.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.pop<EditarDespesaVeiculoResultado>(context, (
      tipo: tipo,
      descricao: descricao.text,
      valorCentavos: _lerCentavos(valor.text),
      dataHora: dataHora,
      observacao: _opcional(observacao.text),
    ));
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.existente == null ? 'Nova despesa' : 'Editar despesa'),
    content: SizedBox(
      width: 480,
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<TipoDespesaVeiculo>(
                key: const ValueKey('tipo_despesa'),
                initialValue: tipo,
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: [
                  for (final opcao in TipoDespesaVeiculo.values)
                    DropdownMenuItem(value: opcao, child: Text(opcao.label)),
                ],
                onChanged: (valor) {
                  if (valor == null) return;
                  setState(() {
                    tipo = valor;
                    sugestoes = const [];
                  });
                  _carregarSugestoes();
                },
              ),
              RawAutocomplete<String>(
                textEditingController: descricao,
                focusNode: focoDescricao,
                optionsBuilder: (valor) {
                  final busca = valor.text.trim().toLowerCase();
                  if (busca.isEmpty) return const Iterable<String>.empty();
                  return sugestoes
                      .where((opcao) => opcao.toLowerCase().contains(busca))
                      .take(5);
                },
                fieldViewBuilder: (context, controller, foco, _) =>
                    TextFormField(
                      key: const ValueKey('descricao_despesa'),
                      controller: controller,
                      focusNode: foco,
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => focoValor.requestFocus(),
                      decoration: const InputDecoration(labelText: 'Descrição'),
                      validator: (texto) => (texto?.trim().isEmpty ?? true)
                          ? 'Informe a descrição.'
                          : null,
                    ),
                optionsViewBuilder: (context, selecionar, opcoes) => Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 180,
                        maxWidth: 360,
                      ),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        children: [
                          for (final opcao in opcoes)
                            ListTile(
                              title: Text(opcao),
                              onTap: () => selecionar(opcao),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              TextFormField(
                key: const ValueKey('valor_despesa'),
                controller: valor,
                focusNode: focoValor,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => focoObservacao.requestFocus(),
                inputFormatters: const [_CentavosFormatter()],
                decoration: const InputDecoration(
                  labelText: 'Valor',
                  prefixText: r'R$ ',
                ),
                validator: (texto) => _lerCentavos(texto ?? '') <= 0
                    ? 'Informe um valor maior que zero.'
                    : null,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Data e hora'),
                subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(dataHora)),
                trailing: const Icon(Icons.edit_calendar),
                onTap: _alterarDataHora,
              ),
              TextFormField(
                key: const ValueKey('observacao_despesa'),
                controller: observacao,
                focusNode: focoObservacao,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => focoObservacao.unfocus(),
                decoration: const InputDecoration(
                  labelText: 'Observação (opcional)',
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      ElevatedButton(onPressed: _salvar, child: const Text('Salvar')),
    ],
  );
}

class _CentavosFormatter extends TextInputFormatter {
  const _CentavosFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitos = newValue.text.replaceAll(RegExp(r'\D'), '');
    final texto = _formatarCentavos(int.tryParse(digitos) ?? 0);
    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}

String _formatarCentavos(int? centavos) {
  final valor = centavos ?? 0;
  final reais = valor ~/ 100;
  final resto = (valor % 100).toString().padLeft(2, '0');
  return '${NumberFormat.decimalPattern('pt_BR').format(reais)},$resto';
}

int _lerCentavos(String texto) =>
    int.tryParse(texto.replaceAll(RegExp(r'\D'), '')) ?? 0;

String? _opcional(String valor) {
  final texto = valor.trim();
  return texto.isEmpty ? null : texto;
}
