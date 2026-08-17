import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/enums/fonte_referencia_depreciacao.dart';
import '../../../../core/constants/enums/metodo_depreciacao.dart';
import '../../../../core/formatters/quilometragem_input_formatter.dart';
import '../../data/resultado_depreciacao.dart';
import '../controllers/depreciacao_veiculo_controller.dart';

class DepreciacaoVeiculoPage extends StatefulWidget {
  final int veiculoId;
  final DepreciacaoVeiculoController controller;

  const DepreciacaoVeiculoPage({
    super.key,
    required this.veiculoId,
    required this.controller,
  });

  @override
  State<DepreciacaoVeiculoPage> createState() => _DepreciacaoVeiculoPageState();
}

class _DepreciacaoVeiculoPageState extends State<DepreciacaoVeiculoPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _valorAquisicao;
  late final TextEditingController _odometroAquisicao;
  late final TextEditingController _valorReferencia;
  late final TextEditingController _odometroReferencia;
  late final TextEditingController _valorVenda;
  late final TextEditingController _odometroVenda;
  late bool _aquisicaoEstimada;
  late bool _referenciaEstimada;
  late bool _vendaEstimada;
  FonteReferenciaDepreciacao? _fonte;
  late DateTime _dataReferencia;
  MetodoDepreciacao? _metodo;

  @override
  void initState() {
    super.initState();
    final dados = widget.controller.dados;
    _valorAquisicao = TextEditingController(
      text: _formatarCentavos(dados?.valorAquisicaoCentavos),
    );
    _odometroAquisicao = TextEditingController(
      text: formatarQuilometragem(dados?.odometroAquisicao),
    );
    _valorReferencia = TextEditingController(
      text: _formatarCentavos(dados?.valorReferenciaCentavos),
    );
    _odometroReferencia = TextEditingController(
      text: formatarQuilometragem(dados?.odometroReferencia) == ''
          ? formatarQuilometragem(widget.controller.odometroSugerido)
          : formatarQuilometragem(dados?.odometroReferencia),
    );
    _valorVenda = TextEditingController(
      text: _formatarCentavos(dados?.valorVendaProjetadoCentavos),
    );
    _odometroVenda = TextEditingController(
      text: formatarQuilometragem(dados?.odometroVendaProjetado),
    );
    _aquisicaoEstimada = dados?.valorAquisicaoEstimado ?? false;
    _referenciaEstimada = dados?.valorReferenciaEstimado ?? false;
    _vendaEstimada = dados?.valorVendaProjetadoEstimado ?? false;
    _fonte = dados?.fonteReferencia;
    _dataReferencia = dados?.dataReferencia ?? DateTime.now();
    _metodo = dados?.metodoSelecionado;
  }

  @override
  void dispose() {
    for (final controller in [
      _valorAquisicao,
      _odometroAquisicao,
      _valorReferencia,
      _odometroReferencia,
      _valorVenda,
      _odometroVenda,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final agora = DateTime.now();
    final data = await showDatePicker(
      context: context,
      initialDate: _dataReferencia.isAfter(agora) ? agora : _dataReferencia,
      firstDate: DateTime(1900),
      lastDate: agora,
      locale: const Locale('pt', 'BR'),
    );
    if (!mounted || data == null) return;
    setState(() => _dataReferencia = data);
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      await widget.controller.salvar(
        veiculoId: widget.veiculoId,
        metodoSelecionado: _metodo,
        valorAquisicaoCentavos: _centavos(_valorAquisicao.text),
        valorAquisicaoEstimado: _aquisicaoEstimada,
        odometroAquisicao: _inteiro(_odometroAquisicao.text),
        valorReferenciaCentavos: _centavos(_valorReferencia.text),
        valorReferenciaEstimado: _referenciaEstimada,
        fonteReferencia: _fonte,
        dataReferencia: _temObservada ? _dataReferencia : null,
        odometroReferencia: _inteiro(_odometroReferencia.text),
        valorVendaProjetadoCentavos: _centavos(_valorVenda.text),
        valorVendaProjetadoEstimado: _vendaEstimada,
        odometroVendaProjetado: _inteiro(_odometroVenda.text),
      );
      if (!mounted) return;
      setState(() => _metodo = widget.controller.dados?.metodoSelecionado);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Depreciação atualizada.')));
    } catch (erro) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(erro.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
  }

  bool get _temObservada =>
      _valorReferencia.text.isNotEmpty ||
      _odometroReferencia.text.isNotEmpty ||
      _fonte != null;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Depreciação do veículo')),
    body: SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            _titulo('Dados do veículo na aquisição'),
            _dinheiro(
              'Valor na aquisição',
              _valorAquisicao,
              key: const ValueKey('valor_aquisicao_depreciacao'),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _aquisicaoEstimada,
              title: const Text('Valor aproximado'),
              onChanged: (valor) =>
                  setState(() => _aquisicaoEstimada = valor ?? false),
            ),
            _odometro(
              'Km na aquisição',
              _odometroAquisicao,
              key: const ValueKey('odometro_aquisicao_depreciacao'),
            ),
            const SizedBox(height: 24),
            _titulo('Depreciação observada'),
            _dinheiro(
              'Valor atual/de referência',
              _valorReferencia,
              key: const ValueKey('valor_referencia_depreciacao'),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _referenciaEstimada,
              title: const Text('Valor de referência aproximado'),
              onChanged: (valor) =>
                  setState(() => _referenciaEstimada = valor ?? false),
            ),
            DropdownButtonFormField<FonteReferenciaDepreciacao>(
              initialValue: _fonte,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Fonte da referência',
              ),
              items: [
                for (final fonte in FonteReferenciaDepreciacao.values)
                  DropdownMenuItem(value: fonte, child: Text(fonte.label)),
              ],
              onChanged: (fonte) => setState(() => _fonte = fonte),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Data da referência'),
              subtitle: Text(DateFormat('dd/MM/yyyy').format(_dataReferencia)),
              trailing: const Icon(Icons.edit_calendar),
              onTap: _selecionarData,
            ),
            _odometro(
              'Km naquela avaliação',
              _odometroReferencia,
              key: const ValueKey('odometro_referencia_depreciacao'),
            ),
            const SizedBox(height: 24),
            _titulo('Depreciação projetada'),
            _dinheiro(
              'Valor esperado na venda',
              _valorVenda,
              key: const ValueKey('valor_venda_depreciacao'),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _vendaEstimada,
              title: const Text('Valor esperado aproximado'),
              onChanged: (valor) =>
                  setState(() => _vendaEstimada = valor ?? false),
            ),
            _odometro(
              'Km esperado na venda',
              _odometroVenda,
              key: const ValueKey('odometro_venda_depreciacao'),
            ),
            const SizedBox(height: 24),
            _ResultadosDepreciacao(
              controller: widget.controller,
              metodo: _metodo,
              onMetodo: (metodo) => setState(() => _metodo = metodo),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _salvar, child: const Text('Salvar')),
          ],
        ),
      ),
    ),
  );

  Widget _titulo(String texto) =>
      Text(texto, style: Theme.of(context).textTheme.titleLarge);

  Widget _dinheiro(
    String label,
    TextEditingController controller, {
    Key? key,
  }) => TextFormField(
    key: key,
    controller: controller,
    keyboardType: TextInputType.number,
    textInputAction: TextInputAction.next,
    inputFormatters: const [_CentavosFormatter()],
    decoration: InputDecoration(labelText: label, prefixText: r'R$ '),
  );

  Widget _odometro(
    String label,
    TextEditingController controller, {
    Key? key,
  }) => TextFormField(
    key: key,
    controller: controller,
    keyboardType: TextInputType.number,
    textInputAction: TextInputAction.next,
    inputFormatters: const [QuilometragemInputFormatter()],
    decoration: InputDecoration(labelText: label, suffixText: 'km'),
  );
}

class _ResultadosDepreciacao extends StatelessWidget {
  final DepreciacaoVeiculoController controller;
  final MetodoDepreciacao? metodo;
  final ValueChanged<MetodoDepreciacao?> onMetodo;

  const _ResultadosDepreciacao({
    required this.controller,
    required this.metodo,
    required this.onMetodo,
  });

  @override
  Widget build(BuildContext context) {
    final observada = controller.observada;
    final projetada = controller.projetada;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Resultados', style: Theme.of(context).textTheme.titleLarge),
        _resultado(context, observada),
        _resultado(context, projetada),
        if (observada.disponivel || projetada.disponivel)
          SegmentedButton<MetodoDepreciacao>(
            segments: [
              if (observada.disponivel)
                const ButtonSegment(
                  value: MetodoDepreciacao.observada,
                  label: Text('Observada'),
                ),
              if (projetada.disponivel)
                const ButtonSegment(
                  value: MetodoDepreciacao.projetada,
                  label: Text('Projetada'),
                ),
            ],
            selected: metodo == null ? const {} : {metodo!},
            emptySelectionAllowed: true,
            onSelectionChanged: (selecao) =>
                onMetodo(selecao.isEmpty ? null : selecao.first),
          ),
      ],
    );
  }

  Widget _resultado(BuildContext context, ResultadoDepreciacao resultado) {
    if (!resultado.disponivel) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(resultado.metodo.label),
        subtitle: Text(resultado.motivoIndisponibilidade!),
      );
    }
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(resultado.metodo.label),
      subtitle: Text(
        '${resultado.estimado ? 'Referência aproximada: ' : ''}'
        '${_moedaPorKm(resultado.valorPorKm!)}',
      ),
      trailing: TextButton(
        onPressed: () => mostrarCalculoDepreciacao(context, resultado),
        child: const Text('Ver cálculo'),
      ),
    );
  }
}

Future<void> mostrarCalculoDepreciacao(
  BuildContext context,
  ResultadoDepreciacao resultado,
) => showDialog<void>(
  context: context,
  builder: (context) {
    final moeda = NumberFormat.currency(locale: 'pt_BR', symbol: r'R$');
    final finalLabel = resultado.metodo == MetodoDepreciacao.observada
        ? 'Valor de referência'
        : 'Valor esperado na venda';
    final kmLabel = resultado.metodo == MetodoDepreciacao.observada
        ? 'Km na avaliação'
        : 'Km esperado na venda';
    return AlertDialog(
      title: Text('Depreciação ${resultado.metodo.label.toLowerCase()}'),
      content: SingleChildScrollView(
        child: Text(
          'Valor na aquisição: ${moeda.format(resultado.valorInicialCentavos! / 100)}\n'
          '$finalLabel: ${moeda.format(resultado.valorFinalCentavos! / 100)}\n'
          'Perda: ${moeda.format(resultado.perdaCentavos! / 100)}\n\n'
          'Km na aquisição: ${formatarQuilometragem(resultado.odometroInicial)} km\n'
          '$kmLabel: ${formatarQuilometragem(resultado.odometroFinal)} km\n'
          'Distância considerada: ${formatarQuilometragem(resultado.distanciaKm)} km\n\n'
          '${moeda.format(resultado.perdaCentavos! / 100)} / '
          '${resultado.distanciaKm} km\n'
          '${_moedaPorKm(resultado.valorPorKm!)}',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fechar'),
        ),
      ],
    );
  },
);

String _moedaPorKm(double valor) =>
    '${NumberFormat.currency(locale: 'pt_BR', symbol: r'R$').format(valor)}/km';

class _CentavosFormatter extends TextInputFormatter {
  const _CentavosFormatter();
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitos = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digitos.isEmpty) return const TextEditingValue();
    final texto = _formatarCentavos(int.parse(digitos));
    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}

String _formatarCentavos(int? valor) {
  if (valor == null) return '';
  final reais = valor ~/ 100;
  final centavos = (valor % 100).toString().padLeft(2, '0');
  return '${NumberFormat.decimalPattern('pt_BR').format(reais)},$centavos';
}

int? _centavos(String texto) {
  final digitos = texto.replaceAll(RegExp(r'\D'), '');
  return digitos.isEmpty ? null : int.parse(digitos);
}

int? _inteiro(String texto) => parseQuilometragem(texto);
