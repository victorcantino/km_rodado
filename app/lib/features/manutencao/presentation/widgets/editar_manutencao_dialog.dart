import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/daos/manutencao_dao.dart';
import '../../../../core/database/app_database.dart';
import '../../data/manutencao_service.dart';

typedef EditarManutencaoResultado = ({
  DateTime dataHora,
  int odometro,
  String? oficina,
  String? observacao,
  List<ItemManutencaoEntrada> itens,
});

class EditarManutencaoDialog extends StatefulWidget {
  final ManutencaoComItens? existente;
  final int? odometroInicial;
  final List<String> sugestoes;
  final Future<int?> Function(String descricao) sugerirIntervalo;

  const EditarManutencaoDialog({
    super.key,
    this.existente,
    this.odometroInicial,
    required this.sugestoes,
    required this.sugerirIntervalo,
  });

  @override
  State<EditarManutencaoDialog> createState() => _EditarManutencaoDialogState();
}

class _EditarManutencaoDialogState extends State<EditarManutencaoDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController odometro;
  late final TextEditingController oficina;
  late final TextEditingController observacao;
  late DateTime dataHora;
  final itens = <_ItemDraft>[];

  @override
  void initState() {
    super.initState();
    final existente = widget.existente;
    dataHora = existente?.manutencao.dataHora ?? DateTime.now();
    odometro = TextEditingController(
      text:
          (existente?.manutencao.odometro ?? widget.odometroInicial)
              ?.toString() ??
          '',
    );
    oficina = TextEditingController(text: existente?.manutencao.oficina ?? '');
    observacao = TextEditingController(
      text: existente?.manutencao.observacao ?? '',
    );
    if (existente == null) {
      itens.add(_ItemDraft());
    } else {
      itens.addAll(existente.itens.map(_ItemDraft.fromItem));
    }
  }

  @override
  void dispose() {
    odometro.dispose();
    oficina.dispose();
    observacao.dispose();
    for (final item in itens) {
      item.dispose();
    }
    super.dispose();
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

  void _adicionarItem() => setState(() => itens.add(_ItemDraft()));

  void _removerItem(int indice) {
    if (itens.length == 1) return;
    final removido = itens.removeAt(indice);
    removido.dispose();
    setState(() {});
  }

  Future<void> _aplicarSugestao(_ItemDraft item) async {
    if (item.intervalo.text.trim().isNotEmpty) return;
    final intervalo = await widget.sugerirIntervalo(item.descricao.text);
    if (!mounted || intervalo == null) return;
    setState(() {
      item.recorrenciaAberta = true;
      item.intervalo.text = intervalo.toString();
    });
  }

  void _salvar() {
    if (!formKey.currentState!.validate()) return;
    final resultadoItens = itens.map((item) => item.resultado).toList();
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.pop<EditarManutencaoResultado>(context, (
      dataHora: dataHora,
      odometro: int.parse(odometro.text),
      oficina: _opcional(oficina.text),
      observacao: _opcional(observacao.text),
      itens: resultadoItens,
    ));
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      widget.existente == null ? 'Nova Manutenção' : 'Editar Manutenção',
    ),
    content: SizedBox(
      width: 520,
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Data e hora'),
                subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(dataHora)),
                trailing: const Icon(Icons.edit_calendar),
                onTap: _alterarDataHora,
              ),
              TextFormField(
                key: const ValueKey('odometro_manutencao'),
                controller: odometro,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Odômetro'),
                validator: (texto) {
                  final valor = int.tryParse(texto?.trim() ?? '');
                  if (valor == null) return 'Informe o odômetro.';
                  if (valor < 0) return 'O odômetro não pode ser negativo.';
                  return null;
                },
              ),
              TextFormField(
                controller: oficina,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Oficina (opcional)',
                ),
              ),
              TextFormField(
                controller: observacao,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Observação (opcional)',
                ),
              ),
              const SizedBox(height: 16),
              Text('Itens', style: Theme.of(context).textTheme.titleMedium),
              for (var indice = 0; indice < itens.length; indice++)
                _ItemEditor(
                  key: ObjectKey(itens[indice]),
                  item: itens[indice],
                  manutencaoOdometro: int.tryParse(odometro.text),
                  sugestoes: widget.sugestoes,
                  autofocus: widget.existente == null && indice == 0,
                  podeRemover: itens.length > 1,
                  onRemover: () => _removerItem(indice),
                  onDescricaoConcluida: () => _aplicarSugestao(itens[indice]),
                  onAlterado: () => setState(() {}),
                ),
              TextButton.icon(
                onPressed: _adicionarItem,
                icon: const Icon(Icons.add),
                label: const Text('Adicionar item'),
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

class _ItemEditor extends StatelessWidget {
  final _ItemDraft item;
  final int? manutencaoOdometro;
  final List<String> sugestoes;
  final bool autofocus;
  final bool podeRemover;
  final VoidCallback onRemover;
  final VoidCallback onDescricaoConcluida;
  final VoidCallback onAlterado;

  const _ItemEditor({
    super.key,
    required this.item,
    required this.manutencaoOdometro,
    required this.sugestoes,
    required this.autofocus,
    required this.podeRemover,
    required this.onRemover,
    required this.onDescricaoConcluida,
    required this.onAlterado,
  });

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: RawAutocomplete<String>(
                  textEditingController: item.descricao,
                  focusNode: item.focoDescricao,
                  optionsBuilder: (valor) {
                    final busca = valor.text.trim().toLowerCase();
                    if (busca.isEmpty) return const Iterable<String>.empty();
                    return sugestoes
                        .where((opcao) => opcao.toLowerCase().contains(busca))
                        .take(5);
                  },
                  onSelected: (_) => onDescricaoConcluida(),
                  fieldViewBuilder: (context, controller, foco, _) =>
                      TextFormField(
                        key: const ValueKey('descricao_item_manutencao'),
                        controller: controller,
                        focusNode: foco,
                        autofocus: autofocus,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          onDescricaoConcluida();
                          item.focoValor.requestFocus();
                        },
                        decoration: const InputDecoration(
                          labelText: 'Descrição',
                        ),
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
              ),
              if (podeRemover)
                IconButton(
                  tooltip: 'Remover item',
                  onPressed: onRemover,
                  icon: const Icon(Icons.delete_outline),
                ),
            ],
          ),
          TextFormField(
            controller: item.valor,
            focusNode: item.focoValor,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            inputFormatters: const [_CentavosFormatter()],
            decoration: const InputDecoration(
              labelText: 'Valor (opcional)',
              prefixText: r'R$ ',
            ),
          ),
          ExpansionTile(
            initiallyExpanded: item.recorrenciaAberta,
            onExpansionChanged: (aberta) => item.recorrenciaAberta = aberta,
            tilePadding: EdgeInsets.zero,
            title: const Text('Adicionar lembrete / recorrência'),
            children: [
              TextFormField(
                controller: item.intervalo,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onChanged: (_) => onAlterado(),
                decoration: const InputDecoration(
                  labelText: 'Intervalo',
                  suffixText: 'km',
                ),
                validator: (texto) {
                  if (texto == null || texto.trim().isEmpty) return null;
                  final valor = int.tryParse(texto.trim());
                  return valor == null || valor <= 0
                      ? 'O intervalo deve ser maior que zero.'
                      : null;
                },
              ),
              if (manutencaoOdometro != null &&
                  int.tryParse(item.intervalo.text) != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Próximo: ${NumberFormat.decimalPattern('pt_BR').format(manutencaoOdometro! + int.parse(item.intervalo.text))} km',
                  ),
                ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Vencimento por data (opcional)'),
                subtitle: Text(
                  item.vencimento == null
                      ? 'Não informado'
                      : DateFormat('dd/MM/yyyy').format(item.vencimento!),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.vencimento != null)
                      IconButton(
                        onPressed: () {
                          item.vencimento = null;
                          onAlterado();
                        },
                        icon: const Icon(Icons.clear),
                      ),
                    IconButton(
                      icon: const Icon(Icons.edit_calendar),
                      onPressed: () async {
                        final data = await showDatePicker(
                          context: context,
                          initialDate:
                              item.vencimento ??
                              DateTime.now().add(const Duration(days: 1)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (data != null) {
                          item.vencimento = data;
                          onAlterado();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _ItemDraft {
  final descricao = TextEditingController();
  final valor = TextEditingController();
  final intervalo = TextEditingController();
  final focoDescricao = FocusNode();
  final focoValor = FocusNode();
  DateTime? vencimento;
  bool recorrenciaAberta = false;

  _ItemDraft();
  _ItemDraft.fromItem(ItemManutencao item) {
    descricao.text = item.descricao;
    if (item.valorCentavos != null) {
      valor.text = _formatarCentavos(item.valorCentavos!);
    }
    if (item.intervaloKm != null) intervalo.text = item.intervaloKm.toString();
    vencimento = item.vencimentoEm;
    recorrenciaAberta = item.intervaloKm != null || item.vencimentoEm != null;
  }

  ItemManutencaoEntrada get resultado => (
    descricao: descricao.text,
    valorCentavos: _centavos(valor.text),
    intervaloKm: int.tryParse(intervalo.text.trim()),
    vencimentoEm: vencimento,
  );

  void dispose() {
    descricao.dispose();
    valor.dispose();
    intervalo.dispose();
    focoDescricao.dispose();
    focoValor.dispose();
  }
}

String? _opcional(String texto) => texto.trim().isEmpty ? null : texto.trim();
int? _centavos(String texto) {
  final digitos = texto.replaceAll(RegExp(r'\D'), '');
  return digitos.isEmpty ? null : int.parse(digitos);
}

String _formatarCentavos(int centavos) =>
    '${NumberFormat.decimalPattern('pt_BR').format(centavos ~/ 100)},${(centavos % 100).toString().padLeft(2, '0')}';

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
