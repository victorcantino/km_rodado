import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/enums/escopo_custo_recorrente.dart';
import '../../../../core/constants/enums/tipo_custo_recorrente.dart';
import '../../../../core/database/app_database.dart';
import '../../data/custo_recorrente_service.dart';

typedef EditarCustoRecorrenteResultado = ({
  TipoCustoRecorrente tipo,
  String descricao,
  EscopoCustoRecorrente escopo,
  int? veiculoId,
  int? plataformaId,
  int? valorReferenciaCentavos,
  bool valorEstimado,
  int periodicidadeMeses,
  int parcelasPorCiclo,
  bool ativo,
  int? quantidadeCiclosPrevista,
  String? observacao,
});

enum _PeriodicidadeVisual { mensal, anual, personalizada }

class EditarCustoRecorrenteDialog extends StatefulWidget {
  final CustoRecorrente? existente;
  final int? veiculoIdInicial;
  final List<Veiculo> veiculos;
  final List<Plataforma> plataformas;
  final PadraoCustoRecorrente Function(TipoCustoRecorrente tipo) padraoPara;
  final Future<List<String>> Function(TipoCustoRecorrente tipo) buscarSugestoes;

  const EditarCustoRecorrenteDialog({
    super.key,
    this.existente,
    this.veiculoIdInicial,
    required this.veiculos,
    required this.plataformas,
    required this.padraoPara,
    required this.buscarSugestoes,
  });

  @override
  State<EditarCustoRecorrenteDialog> createState() =>
      _EditarCustoRecorrenteDialogState();
}

class _EditarCustoRecorrenteDialogState
    extends State<EditarCustoRecorrenteDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController descricao;
  late final TextEditingController valor;
  late final TextEditingController meses;
  late final TextEditingController parcelas;
  late final TextEditingController quantidade;
  late final TextEditingController observacao;
  late final FocusNode focoDescricao;
  late final FocusNode focoValor;
  late final FocusNode focoMeses;
  late final FocusNode focoParcelas;
  late final FocusNode focoQuantidade;
  late final FocusNode focoObservacao;
  late TipoCustoRecorrente tipo;
  late EscopoCustoRecorrente escopo;
  late _PeriodicidadeVisual periodicidadeVisual;
  int? veiculoId;
  int? plataformaId;
  bool valorEstimado = false;
  bool ativo = true;
  List<String> sugestoes = const [];

  @override
  void initState() {
    super.initState();
    final existente = widget.existente;
    tipo = existente?.tipo ?? TipoCustoRecorrente.ipva;
    final padrao = widget.padraoPara(tipo);
    escopo =
        existente?.escopo ?? padrao.escopo ?? EscopoCustoRecorrente.atividade;
    veiculoId =
        existente?.veiculoId ??
        (escopo == EscopoCustoRecorrente.veiculo
            ? widget.veiculoIdInicial ?? widget.veiculos.firstOrNull?.id
            : null);
    plataformaId =
        existente?.plataformaId ??
        (escopo == EscopoCustoRecorrente.plataforma
            ? widget.plataformas.firstOrNull?.id
            : null);
    final periodicidade =
        existente?.periodicidadeMeses ?? padrao.periodicidadeMeses ?? 1;
    periodicidadeVisual = _visualPara(periodicidade);
    valorEstimado = existente?.valorEstimado ?? false;
    ativo = existente?.ativo ?? true;
    descricao = TextEditingController(text: existente?.descricao ?? tipo.label);
    valor = TextEditingController(
      text: _formatarCentavos(existente?.valorReferenciaCentavos),
    );
    meses = TextEditingController(text: periodicidade.toString());
    parcelas = TextEditingController(
      text: (existente?.parcelasPorCiclo ?? 1).toString(),
    );
    quantidade = TextEditingController(
      text: existente?.quantidadeCiclosPrevista?.toString() ?? '',
    );
    observacao = TextEditingController(text: existente?.observacao ?? '');
    focoDescricao = FocusNode();
    focoValor = FocusNode();
    focoMeses = FocusNode();
    focoParcelas = FocusNode();
    focoQuantidade = FocusNode();
    focoObservacao = FocusNode();
    _carregarSugestoes();
  }

  @override
  void dispose() {
    for (final controller in [
      descricao,
      valor,
      meses,
      parcelas,
      quantidade,
      observacao,
    ]) {
      controller.dispose();
    }
    for (final foco in [
      focoDescricao,
      focoValor,
      focoMeses,
      focoParcelas,
      focoQuantidade,
      focoObservacao,
    ]) {
      foco.dispose();
    }
    super.dispose();
  }

  Future<void> _carregarSugestoes() async {
    final resultado = await widget.buscarSugestoes(tipo);
    if (mounted) setState(() => sugestoes = resultado);
  }

  void _alterarTipo(TipoCustoRecorrente novoTipo) {
    final descricaoAnterior = tipo.label;
    final padrao = widget.padraoPara(novoTipo);
    setState(() {
      tipo = novoTipo;
      if (descricao.text.trim().isEmpty ||
          descricao.text == descricaoAnterior) {
        descricao.text = novoTipo.label;
      }
      if (padrao.escopo != null) _alterarEscopo(padrao.escopo!);
      if (padrao.periodicidadeMeses != null) {
        meses.text = padrao.periodicidadeMeses.toString();
        periodicidadeVisual = _visualPara(padrao.periodicidadeMeses!);
      }
      sugestoes = const [];
    });
    _carregarSugestoes();
  }

  void _alterarEscopo(EscopoCustoRecorrente novoEscopo) {
    escopo = novoEscopo;
    switch (novoEscopo) {
      case EscopoCustoRecorrente.veiculo:
        veiculoId ??=
            widget.veiculoIdInicial ?? widget.veiculos.firstOrNull?.id;
        plataformaId = null;
      case EscopoCustoRecorrente.atividade:
        veiculoId = null;
        plataformaId = null;
      case EscopoCustoRecorrente.plataforma:
        veiculoId = null;
        plataformaId ??= widget.plataformas.firstOrNull?.id;
    }
  }

  void _alterarPeriodicidade(_PeriodicidadeVisual visual) {
    setState(() {
      periodicidadeVisual = visual;
      if (visual == _PeriodicidadeVisual.mensal) meses.text = '1';
      if (visual == _PeriodicidadeVisual.anual) meses.text = '12';
    });
  }

  int get _periodicidadeMeses => int.tryParse(meses.text) ?? 0;
  int? get _valorCentavos => _lerCentavos(valor.text);

  String get _equivalenteMensal {
    final centavos = _valorCentavos;
    if (centavos == null) return 'Valor não informado';
    if (_periodicidadeMeses <= 0) return 'Informe a periodicidade';
    final moeda = NumberFormat.currency(locale: 'pt_BR', symbol: r'R$');
    return '≈ ${moeda.format(centavos / _periodicidadeMeses / 100)}/mês';
  }

  void _salvar() {
    if (!formKey.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.pop<EditarCustoRecorrenteResultado>(context, (
      tipo: tipo,
      descricao: descricao.text,
      escopo: escopo,
      veiculoId: veiculoId,
      plataformaId: plataformaId,
      valorReferenciaCentavos: _valorCentavos,
      valorEstimado: valorEstimado,
      periodicidadeMeses: _periodicidadeMeses,
      parcelasPorCiclo: int.parse(parcelas.text),
      ativo: ativo,
      quantidadeCiclosPrevista: int.tryParse(quantidade.text),
      observacao: _opcional(observacao.text),
    ));
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      widget.existente == null
          ? 'Novo custo recorrente'
          : 'Editar custo recorrente',
    ),
    content: SizedBox(
      width: 520,
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<TipoCustoRecorrente>(
                key: const ValueKey('tipo_custo_recorrente'),
                initialValue: tipo,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: [
                  for (final opcao in TipoCustoRecorrente.values)
                    DropdownMenuItem(value: opcao, child: Text(opcao.label)),
                ],
                onChanged: (valor) {
                  if (valor != null) _alterarTipo(valor);
                },
              ),
              RawAutocomplete<String>(
                textEditingController: descricao,
                focusNode: focoDescricao,
                optionsBuilder: (valor) {
                  final busca = valor.text.trim().toLowerCase();
                  if (busca.isEmpty) return const Iterable<String>.empty();
                  return sugestoes
                      .where((s) => s.toLowerCase().contains(busca))
                      .take(5);
                },
                fieldViewBuilder: (context, controller, foco, _) =>
                    TextFormField(
                      key: const ValueKey('descricao_custo_recorrente'),
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
              DropdownButtonFormField<EscopoCustoRecorrente>(
                key: const ValueKey('escopo_custo_recorrente'),
                initialValue: escopo,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Escopo'),
                items: [
                  for (final opcao in EscopoCustoRecorrente.values)
                    DropdownMenuItem(value: opcao, child: Text(opcao.label)),
                ],
                onChanged: (valor) {
                  if (valor != null) setState(() => _alterarEscopo(valor));
                },
              ),
              if (escopo == EscopoCustoRecorrente.veiculo)
                DropdownButtonFormField<int>(
                  key: const ValueKey('veiculo_custo_recorrente'),
                  initialValue: veiculoId,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Veículo'),
                  items: [
                    for (final veiculo in widget.veiculos)
                      DropdownMenuItem(
                        value: veiculo.id,
                        child: Text('${veiculo.marca} ${veiculo.modelo}'),
                      ),
                  ],
                  onChanged: (valor) => setState(() => veiculoId = valor),
                  validator: (valor) =>
                      valor == null ? 'Informe o veículo.' : null,
                ),
              if (escopo == EscopoCustoRecorrente.plataforma)
                DropdownButtonFormField<int>(
                  key: const ValueKey('plataforma_custo_recorrente'),
                  initialValue: plataformaId,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Plataforma'),
                  items: [
                    for (final plataforma in widget.plataformas)
                      DropdownMenuItem(
                        value: plataforma.id,
                        child: Text(plataforma.nome),
                      ),
                  ],
                  onChanged: (valor) => setState(() => plataformaId = valor),
                  validator: (valor) =>
                      valor == null ? 'Informe a Plataforma.' : null,
                ),
              TextFormField(
                key: const ValueKey('valor_custo_recorrente'),
                controller: valor,
                focusNode: focoValor,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: const [_CentavosOpcionaisFormatter()],
                onChanged: (_) => setState(() {}),
                onFieldSubmitted: (_) =>
                    periodicidadeVisual == _PeriodicidadeVisual.personalizada
                    ? focoMeses.requestFocus()
                    : focoParcelas.requestFocus(),
                decoration: const InputDecoration(
                  labelText: 'Valor de referência (opcional)',
                  prefixText: r'R$ ',
                ),
                validator: (texto) =>
                    texto != null &&
                        texto.isNotEmpty &&
                        _lerCentavos(texto) == 0
                    ? 'O valor deve ser maior que zero.'
                    : null,
              ),
              CheckboxListTile(
                key: const ValueKey('valor_estimado'),
                contentPadding: EdgeInsets.zero,
                value: valorEstimado,
                title: const Text('Valor aproximado'),
                onChanged: (valor) =>
                    setState(() => valorEstimado = valor ?? false),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  ChoiceChip(
                    label: const Text('Mensal'),
                    selected:
                        periodicidadeVisual == _PeriodicidadeVisual.mensal,
                    onSelected: (_) =>
                        _alterarPeriodicidade(_PeriodicidadeVisual.mensal),
                  ),
                  ChoiceChip(
                    label: const Text('Anual'),
                    selected: periodicidadeVisual == _PeriodicidadeVisual.anual,
                    onSelected: (_) =>
                        _alterarPeriodicidade(_PeriodicidadeVisual.anual),
                  ),
                  ChoiceChip(
                    label: const Text('Personalizado'),
                    selected:
                        periodicidadeVisual ==
                        _PeriodicidadeVisual.personalizada,
                    onSelected: (_) => _alterarPeriodicidade(
                      _PeriodicidadeVisual.personalizada,
                    ),
                  ),
                ],
              ),
              if (periodicidadeVisual == _PeriodicidadeVisual.personalizada)
                TextFormField(
                  key: const ValueKey('meses_custo_recorrente'),
                  controller: meses,
                  focusNode: focoMeses,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => setState(() {}),
                  onFieldSubmitted: (_) => focoParcelas.requestFocus(),
                  decoration: const InputDecoration(
                    labelText: 'Periodicidade (meses)',
                  ),
                  validator: (texto) => (int.tryParse(texto ?? '') ?? 0) <= 0
                      ? 'Informe uma periodicidade maior que zero.'
                      : null,
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  _equivalenteMensal,
                  key: const ValueKey('equivalente_mensal'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextFormField(
                key: const ValueKey('parcelas_custo_recorrente'),
                controller: parcelas,
                focusNode: focoParcelas,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => focoQuantidade.requestFocus(),
                decoration: const InputDecoration(
                  labelText: 'Parcelas habituais por ciclo',
                ),
                validator: (texto) => (int.tryParse(texto ?? '') ?? 0) < 1
                    ? 'Informe pelo menos 1 parcela.'
                    : null,
              ),
              TextFormField(
                key: const ValueKey('quantidade_ciclos_custo_recorrente'),
                controller: quantidade,
                focusNode: focoQuantidade,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => focoObservacao.requestFocus(),
                decoration: const InputDecoration(
                  labelText: 'Quantidade de ciclos (opcional)',
                ),
                validator: (texto) =>
                    texto != null &&
                        texto.trim().isNotEmpty &&
                        (int.tryParse(texto) ?? 0) <= 0
                    ? 'Informe uma quantidade maior que zero.'
                    : null,
              ),
              SwitchListTile(
                key: const ValueKey('ativo_custo_recorrente'),
                contentPadding: EdgeInsets.zero,
                value: ativo,
                title: const Text('Ativo'),
                onChanged: (valor) => setState(() => ativo = valor),
              ),
              TextFormField(
                key: const ValueKey('observacao_custo_recorrente'),
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

_PeriodicidadeVisual _visualPara(int meses) => switch (meses) {
  1 => _PeriodicidadeVisual.mensal,
  12 => _PeriodicidadeVisual.anual,
  _ => _PeriodicidadeVisual.personalizada,
};

class _CentavosOpcionaisFormatter extends TextInputFormatter {
  const _CentavosOpcionaisFormatter();

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

String _formatarCentavos(int? centavos) {
  if (centavos == null) return '';
  final reais = centavos ~/ 100;
  final resto = (centavos % 100).toString().padLeft(2, '0');
  return '${NumberFormat.decimalPattern('pt_BR').format(reais)},$resto';
}

int? _lerCentavos(String texto) {
  final digitos = texto.replaceAll(RegExp(r'\D'), '');
  return digitos.isEmpty ? null : int.tryParse(digitos);
}

String? _opcional(String valor) {
  final texto = valor.trim();
  return texto.isEmpty ? null : texto;
}
