import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/enums/tipo_combustivel.dart';
import '../../../../core/formatters/quilometragem_input_formatter.dart';
import '../../data/abastecimento_service.dart';

typedef RegistrarAbastecimentoResultado = ({
  DateTime dataHora,
  int odometro,
  TipoCombustivel tipoCombustivel,
  int volumeMililitros,
  int valorTotalPagoCentavos,
  int? precoBombaMilesimosRealPorLitro,
  bool tanqueCheio,
  String? cidade,
  String? nomePosto,
  String? bandeiraPosto,
  String? observacao,
});

class RegistrarAbastecimentoDialog extends StatefulWidget {
  final int? odometroInicial;
  final String? cidadeInicial;
  final TipoCombustivel? tipoCombustivelInicial;
  final DateTime? dataHoraInicial;

  const RegistrarAbastecimentoDialog({
    super.key,
    this.odometroInicial,
    this.cidadeInicial,
    this.tipoCombustivelInicial,
    this.dataHoraInicial,
  });

  @override
  State<RegistrarAbastecimentoDialog> createState() =>
      _RegistrarAbastecimentoDialogState();
}

class _RegistrarAbastecimentoDialogState
    extends State<RegistrarAbastecimentoDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController odometro;
  final volume = TextEditingController();
  final total = TextEditingController();
  final precoCalculo = TextEditingController();
  final precoBomba = TextEditingController();
  late final TextEditingController cidade;
  final posto = TextEditingController();
  final bandeira = TextEditingController();
  final observacao = TextEditingController();
  final focoOdometro = FocusNode();
  final focoVolume = FocusNode();
  final focoTotal = FocusNode();
  final focoPrecoCalculo = FocusNode();
  final focoPrecoBomba = FocusNode();
  final focoCidade = FocusNode();
  final focoPosto = FocusNode();
  final focoBandeira = FocusNode();
  final focoObservacao = FocusNode();
  late TipoCombustivel combustivel;
  late DateTime dataHora;
  bool tanqueCheio = true;

  @override
  void initState() {
    super.initState();
    odometro = TextEditingController(
      text: formatarQuilometragem(widget.odometroInicial),
    );
    cidade = TextEditingController(text: widget.cidadeInicial ?? '');
    combustivel = widget.tipoCombustivelInicial ?? TipoCombustivel.gasolina;
    dataHora = widget.dataHoraInicial ?? DateTime.now();
  }

  int? _inteiro(TextEditingController controller) {
    final digitos = controller.text.replaceAll(RegExp(r'\D'), '');
    return digitos.isEmpty ? null : int.tryParse(digitos);
  }

  int? get volumeMl => _inteiro(volume);
  int? get totalCentavos => _inteiro(total);
  int? get precoCalculoMilesimos => _inteiro(precoCalculo);
  int? get precoBombaMilesimos => _inteiro(precoBomba);

  int? get precoEfetivo {
    final volumeAtual = volumeMl;
    final totalAtual = totalCentavos;
    if (volumeAtual == null || volumeAtual <= 0 || totalAtual == null) {
      return null;
    }
    return AbastecimentoService.calcularPrecoEfetivoMilesimos(
      valorTotalCentavos: totalAtual,
      volumeMililitros: volumeAtual,
    );
  }

  void _calcularTotal() {
    final volumeAtual = volumeMl;
    final preco = precoCalculoMilesimos;
    if (volumeAtual == null || volumeAtual <= 0 || preco == null) return;
    total.text = _formatarCentavos(
      AbastecimentoService.calcularTotalCentavos(
        volumeMililitros: volumeAtual,
        precoMilesimosRealPorLitro: preco,
      ),
    );
    setState(() {});
  }

  void _calcularVolume() {
    final totalAtual = totalCentavos;
    final preco = precoCalculoMilesimos;
    if (totalAtual == null || preco == null || preco <= 0) return;
    volume.text = _formatarMilesimos(
      AbastecimentoService.calcularVolumeMililitros(
        valorTotalCentavos: totalAtual,
        precoMilesimosRealPorLitro: preco,
      ),
    );
    setState(() {});
  }

  String? _opcional(TextEditingController controller) {
    final texto = controller.text.trim();
    return texto.isEmpty ? null : texto;
  }

  void _salvar() {
    if (!formKey.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.pop<RegistrarAbastecimentoResultado>(context, (
      dataHora: dataHora,
      odometro: parseQuilometragem(odometro.text)!,
      tipoCombustivel: combustivel,
      volumeMililitros: volumeMl!,
      valorTotalPagoCentavos: totalCentavos!,
      precoBombaMilesimosRealPorLitro: precoBombaMilesimos,
      tanqueCheio: tanqueCheio,
      cidade: _opcional(cidade),
      nomePosto: _opcional(posto),
      bandeiraPosto: _opcional(bandeira),
      observacao: _opcional(observacao),
    ));
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

  @override
  void dispose() {
    for (final controller in [
      odometro,
      volume,
      total,
      precoCalculo,
      precoBomba,
      cidade,
      posto,
      bandeira,
      observacao,
    ]) {
      controller.dispose();
    }
    for (final focusNode in [
      focoOdometro,
      focoVolume,
      focoTotal,
      focoPrecoCalculo,
      focoPrecoBomba,
      focoCidade,
      focoPosto,
      focoBandeira,
      focoObservacao,
    ]) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final preco = precoEfetivo;
    return AlertDialog(
      title: const Text('Registrar abastecimento'),
      content: SizedBox(
        width: 430,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  key: const ValueKey('odometro_abastecimento'),
                  controller: odometro,
                  focusNode: focoOdometro,
                  autofocus: true,
                  selectAllOnFocus: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: const [QuilometragemInputFormatter()],
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => focoVolume.requestFocus(),
                  decoration: const InputDecoration(labelText: 'Odômetro'),
                  validator: (texto) {
                    final valor = parseQuilometragem(texto);
                    if (valor == null) return 'Informe o odômetro.';
                    if (valor < 0) return 'O odômetro não pode ser negativo.';
                    return null;
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Data e hora'),
                  subtitle: Text(
                    DateFormat.yMd(
                      Localizations.localeOf(context).toLanguageTag(),
                    ).add_Hm().format(dataHora),
                  ),
                  trailing: const Icon(Icons.edit_calendar),
                  onTap: _alterarDataHora,
                ),
                DropdownButtonFormField<TipoCombustivel>(
                  initialValue: combustivel,
                  decoration: const InputDecoration(labelText: 'Combustível'),
                  items: [
                    for (final tipo in TipoCombustivel.values)
                      DropdownMenuItem(
                        value: tipo,
                        child: Text(_nomeCombustivel(tipo)),
                      ),
                  ],
                  onChanged: (valor) => combustivel = valor!,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Tanque cheio'),
                  value: tanqueCheio,
                  onChanged: (valor) => setState(() => tanqueCheio = valor),
                ),
                TextFormField(
                  key: const ValueKey('volume_abastecimento'),
                  controller: volume,
                  focusNode: focoVolume,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => focoTotal.requestFocus(),
                  inputFormatters: const [_MilesimosFormatter()],
                  decoration: const InputDecoration(
                    labelText: 'Volume',
                    suffixText: 'L',
                  ),
                  onChanged: (_) => setState(() {}),
                  validator: (_) => volumeMl == null || volumeMl! <= 0
                      ? 'Informe um volume maior que zero.'
                      : null,
                ),
                TextFormField(
                  key: const ValueKey('total_abastecimento'),
                  controller: total,
                  focusNode: focoTotal,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => focoPrecoCalculo.requestFocus(),
                  inputFormatters: const [_CentavosFormatter()],
                  decoration: const InputDecoration(
                    labelText: 'Total pago',
                    prefixText: r'R$ ',
                  ),
                  onChanged: (_) => setState(() {}),
                  validator: (_) => totalCentavos == null
                      ? 'Informe o total realmente pago.'
                      : null,
                ),
                TextFormField(
                  key: const ValueKey('preco_calculo_abastecimento'),
                  controller: precoCalculo,
                  focusNode: focoPrecoCalculo,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => focoPrecoBomba.requestFocus(),
                  inputFormatters: const [_MilesimosFormatter()],
                  decoration: const InputDecoration(
                    labelText: 'Preço por litro para cálculo (opcional)',
                    prefixText: r'R$ ',
                    suffixText: '/L',
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _calcularTotal,
                      child: const Text('Calcular total'),
                    ),
                    TextButton(
                      onPressed: _calcularVolume,
                      child: const Text('Calcular volume'),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Preço efetivo: '
                    '${preco == null ? '—' : 'R\$ ${_formatarMilesimos(preco)}/L'}',
                  ),
                ),
                TextFormField(
                  key: const ValueKey('preco_bomba_abastecimento'),
                  controller: precoBomba,
                  focusNode: focoPrecoBomba,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => focoPrecoBomba.unfocus(),
                  inputFormatters: const [_MilesimosFormatter()],
                  decoration: const InputDecoration(
                    labelText: 'Preço da bomba (opcional)',
                    prefixText: r'R$ ',
                    suffixText: '/L',
                  ),
                ),
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: EdgeInsets.zero,
                  title: const Text('Cidade e posto'),
                  children: [
                    TextFormField(
                      controller: cidade,
                      focusNode: focoCidade,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => focoPosto.requestFocus(),
                      decoration: const InputDecoration(labelText: 'Cidade'),
                    ),
                    TextFormField(
                      controller: posto,
                      focusNode: focoPosto,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => focoBandeira.requestFocus(),
                      decoration: const InputDecoration(
                        labelText: 'Nome do posto',
                      ),
                    ),
                    TextFormField(
                      controller: bandeira,
                      focusNode: focoBandeira,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => focoObservacao.requestFocus(),
                      decoration: const InputDecoration(labelText: 'Bandeira'),
                    ),
                    TextFormField(
                      controller: observacao,
                      focusNode: focoObservacao,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => focoObservacao.unfocus(),
                      decoration: const InputDecoration(
                        labelText: 'Observação',
                      ),
                    ),
                  ],
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
}

String _nomeCombustivel(TipoCombustivel tipo) => switch (tipo) {
  TipoCombustivel.gasolina => 'Gasolina',
  TipoCombustivel.etanol => 'Etanol',
  TipoCombustivel.outro => 'Outro',
};

String _formatarCentavos(int valor) {
  final reais = valor ~/ 100;
  final centavos = (valor % 100).toString().padLeft(2, '0');
  return '${NumberFormat.decimalPattern('pt_BR').format(reais)},$centavos';
}

String _formatarMilesimos(int valor) {
  final inteiros = valor ~/ 1000;
  final decimais = (valor % 1000).toString().padLeft(3, '0');
  return '${NumberFormat.decimalPattern('pt_BR').format(inteiros)},$decimais';
}

class _CentavosFormatter extends TextInputFormatter {
  const _CentavosFormatter();
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) => _formatar(newValue, oldValue, _formatarCentavos);
}

class _MilesimosFormatter extends TextInputFormatter {
  const _MilesimosFormatter();
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) => _formatar(newValue, oldValue, _formatarMilesimos);
}

TextEditingValue _formatar(
  TextEditingValue novo,
  TextEditingValue antigo,
  String Function(int) formatador,
) {
  final digitos = novo.text.replaceAll(RegExp(r'\D'), '');
  if (digitos.isEmpty) return const TextEditingValue();
  final valor = int.tryParse(digitos);
  if (valor == null) return antigo;
  final texto = formatador(valor);
  return TextEditingValue(
    text: texto,
    selection: TextSelection.collapsed(offset: texto.length),
  );
}
