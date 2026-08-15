import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/app_database.dart';

typedef EditarPausaResultado = ({
  String? titulo,
  DateTime inicio,
  int? odometroInicio,
  DateTime? fim,
  int? odometroFim,
  String? observacao,
});

class EditarPausaDialog extends StatefulWidget {
  final Pausa pausa;
  final Future<void> Function(EditarPausaResultado resultado) onSalvar;

  const EditarPausaDialog({
    super.key,
    required this.pausa,
    required this.onSalvar,
  });

  @override
  State<EditarPausaDialog> createState() => _EditarPausaDialogState();
}

class _EditarPausaDialogState extends State<EditarPausaDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController titulo;
  late final TextEditingController odometroInicio;
  late final TextEditingController odometroFim;
  late final TextEditingController observacao;
  final focoTitulo = FocusNode();
  final focoOdometroInicio = FocusNode();
  final focoOdometroFim = FocusNode();
  final focoObservacao = FocusNode();
  late DateTime inicio;
  late DateTime? fim;
  String? erro;
  bool salvando = false;

  bool get concluida => widget.pausa.fim != null;

  @override
  void initState() {
    super.initState();
    titulo = TextEditingController(text: widget.pausa.titulo ?? '');
    odometroInicio = TextEditingController(
      text: widget.pausa.odometroInicio?.toString() ?? '',
    );
    odometroFim = TextEditingController(
      text: widget.pausa.odometroFim?.toString() ?? '',
    );
    observacao = TextEditingController(text: widget.pausa.observacao ?? '');
    inicio = widget.pausa.inicio;
    fim = widget.pausa.fim;
  }

  @override
  void dispose() {
    titulo.dispose();
    odometroInicio.dispose();
    odometroFim.dispose();
    observacao.dispose();
    focoTitulo.dispose();
    focoOdometroInicio.dispose();
    focoOdometroFim.dispose();
    focoObservacao.dispose();
    super.dispose();
  }

  String? _textoOpcional(TextEditingController controller) {
    final texto = controller.text.trim();
    return texto.isEmpty ? null : texto;
  }

  int? _odometroOpcional(TextEditingController controller) {
    final texto = controller.text.trim();
    return texto.isEmpty ? null : int.tryParse(texto);
  }

  String? _validarOdometro(String? texto, {required bool obrigatorio}) {
    final normalizado = texto?.trim() ?? '';
    if (normalizado.isEmpty) {
      return obrigatorio ? 'Informe o odômetro.' : null;
    }
    final valor = int.tryParse(normalizado);
    if (valor == null) return 'Informe um número inteiro válido.';
    if (valor < 0) return 'O odômetro não pode ser negativo.';
    return null;
  }

  Future<void> _alterarDataHora({required bool inicioDaPausa}) async {
    final atual = inicioDaPausa ? inicio : fim!;
    final data = await showDatePicker(
      context: context,
      initialDate: atual,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (!mounted || data == null) return;
    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(atual),
    );
    if (!mounted || hora == null) return;
    setState(() {
      final alterada = DateTime(
        data.year,
        data.month,
        data.day,
        hora.hour,
        hora.minute,
      );
      if (inicioDaPausa) {
        inicio = alterada;
      } else {
        fim = alterada;
      }
    });
  }

  Future<void> _salvar() async {
    if (!formKey.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      salvando = true;
      erro = null;
    });
    try {
      await widget.onSalvar((
        titulo: _textoOpcional(titulo),
        inicio: inicio,
        odometroInicio: _odometroOpcional(odometroInicio),
        fim: concluida ? fim : null,
        odometroFim: concluida ? _odometroOpcional(odometroFim) : null,
        observacao: _textoOpcional(observacao),
      ));
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        salvando = false;
        erro = _mensagemErro(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final formato = DateFormat.yMd(locale).add_Hm();
    return AlertDialog(
      title: const Text('Editar Pausa'),
      content: SizedBox(
        width: 430,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titulo,
                  focusNode: focoTitulo,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => focoOdometroInicio.requestFocus(),
                  decoration: const InputDecoration(
                    labelText: 'Título opcional',
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Início'),
                  subtitle: Text(formato.format(inicio)),
                  trailing: const Icon(Icons.edit_calendar),
                  onTap: salvando
                      ? null
                      : () => _alterarDataHora(inicioDaPausa: true),
                ),
                TextFormField(
                  key: const ValueKey('odometro_inicio_edicao_pausa'),
                  controller: odometroInicio,
                  focusNode: focoOdometroInicio,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => concluida
                      ? focoOdometroFim.requestFocus()
                      : focoObservacao.requestFocus(),
                  selectAllOnFocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Odômetro inicial',
                  ),
                  validator: (texto) => _validarOdometro(
                    texto,
                    obrigatorio: widget.pausa.odometroInicio != null,
                  ),
                ),
                if (concluida) ...[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Fim'),
                    subtitle: Text(formato.format(fim!)),
                    trailing: const Icon(Icons.edit_calendar),
                    onTap: salvando
                        ? null
                        : () => _alterarDataHora(inicioDaPausa: false),
                  ),
                  TextFormField(
                    key: const ValueKey('odometro_fim_edicao_pausa'),
                    controller: odometroFim,
                    focusNode: focoOdometroFim,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => focoObservacao.requestFocus(),
                    selectAllOnFocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Odômetro final',
                    ),
                    validator: (texto) => _validarOdometro(
                      texto,
                      obrigatorio: widget.pausa.odometroFim != null,
                    ),
                  ),
                ],
                TextFormField(
                  controller: observacao,
                  focusNode: focoObservacao,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => focoObservacao.unfocus(),
                  decoration: const InputDecoration(
                    labelText: 'Observação opcional',
                  ),
                  minLines: 1,
                  maxLines: 3,
                ),
                if (erro != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    erro!,
                    key: const ValueKey('erro_edicao_pausa'),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: salvando ? null : () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: salvando ? null : _salvar,
          child: salvando ? const Text('Salvando...') : const Text('Salvar'),
        ),
      ],
    );
  }
}

String _mensagemErro(Object error) {
  final texto = error.toString();
  return texto.startsWith('Exception: ')
      ? texto.substring('Exception: '.length)
      : 'Não foi possível editar a Pausa.';
}
