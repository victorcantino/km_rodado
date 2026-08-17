import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/formatters/quilometragem_input_formatter.dart';

typedef EditarJornadaResultado = ({
  DateTime dataHoraInicio,
  int odometroInicio,
  String cidadeOrigem,
  DateTime? dataHoraFim,
  int? odometroFim,
  String? cidadeDestino,
  String? observacoes,
});

class EditarJornadaDialog extends StatefulWidget {
  final Jornada jornada;

  const EditarJornadaDialog({super.key, required this.jornada});

  @override
  State<EditarJornadaDialog> createState() => _EditarJornadaDialogState();
}

class _EditarJornadaDialogState extends State<EditarJornadaDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController odometroInicio;
  late final TextEditingController cidadeOrigem;
  late final TextEditingController odometroFim;
  late final TextEditingController cidadeDestino;
  late final TextEditingController observacoes;
  final focoOdometroInicio = FocusNode();
  final focoCidadeOrigem = FocusNode();
  final focoOdometroFim = FocusNode();
  final focoCidadeDestino = FocusNode();
  final focoObservacoes = FocusNode();
  late DateTime dataHoraInicio;
  late DateTime? dataHoraFim;

  bool get finalizada => widget.jornada.dataHoraFim != null;

  @override
  void initState() {
    super.initState();
    dataHoraInicio = widget.jornada.dataHoraInicio;
    dataHoraFim = widget.jornada.dataHoraFim;
    odometroInicio = TextEditingController(
      text: formatarQuilometragem(widget.jornada.odometroInicio),
    );
    cidadeOrigem = TextEditingController(text: widget.jornada.cidadeOrigem);
    odometroFim = TextEditingController(
      text: formatarQuilometragem(widget.jornada.odometroFim),
    );
    cidadeDestino = TextEditingController(
      text: widget.jornada.cidadeDestino ?? '',
    );
    observacoes = TextEditingController(text: widget.jornada.observacoes ?? '');
  }

  @override
  void dispose() {
    for (final controller in [
      odometroInicio,
      cidadeOrigem,
      odometroFim,
      cidadeDestino,
      observacoes,
    ]) {
      controller.dispose();
    }
    for (final focusNode in [
      focoOdometroInicio,
      focoCidadeOrigem,
      focoOdometroFim,
      focoCidadeDestino,
      focoObservacoes,
    ]) {
      focusNode.dispose();
    }
    super.dispose();
  }

  Future<void> _alterarDataHora({required bool inicio}) async {
    final atual = inicio ? dataHoraInicio : dataHoraFim!;
    final agora = DateTime.now();
    final data = await showDatePicker(
      context: context,
      initialDate: atual,
      firstDate: DateTime(2000),
      lastDate: agora,
    );
    if (!mounted || data == null) return;
    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(atual),
    );
    if (!mounted || hora == null) return;
    setState(() {
      final valor = DateTime(
        data.year,
        data.month,
        data.day,
        hora.hour,
        hora.minute,
      );
      if (inicio) {
        dataHoraInicio = valor;
      } else {
        dataHoraFim = valor;
      }
    });
  }

  String? _validarOdometro(String? texto) {
    final valor = parseQuilometragem(texto);
    if (valor == null) return 'Informe um número inteiro válido.';
    if (valor < 0) return 'O odômetro não pode ser negativo.';
    return null;
  }

  String? _opcional(String texto) {
    final normalizado = texto.trim();
    return normalizado.isEmpty ? null : normalizado;
  }

  void _salvar() {
    if (!formKey.currentState!.validate()) return;
    Navigator.pop<EditarJornadaResultado>(context, (
      dataHoraInicio: dataHoraInicio,
      odometroInicio: parseQuilometragem(odometroInicio.text)!,
      cidadeOrigem: cidadeOrigem.text.trim(),
      dataHoraFim: finalizada ? dataHoraFim : null,
      odometroFim: finalizada ? parseQuilometragem(odometroFim.text) : null,
      cidadeDestino: finalizada ? _opcional(cidadeDestino.text) : null,
      observacoes: _opcional(observacoes.text),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final formato = DateFormat.yMd(
      Localizations.localeOf(context).toLanguageTag(),
    ).add_Hm();
    return AlertDialog(
      title: const Text('Editar Jornada'),
      content: SizedBox(
        width: 430,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  key: const ValueKey('editar_inicio_jornada'),
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Início'),
                  subtitle: Text(formato.format(dataHoraInicio)),
                  trailing: const Icon(Icons.edit_calendar),
                  onTap: () => _alterarDataHora(inicio: true),
                ),
                TextFormField(
                  key: const ValueKey('editar_odometro_inicio_jornada'),
                  controller: odometroInicio,
                  focusNode: focoOdometroInicio,
                  autofocus: true,
                  selectAllOnFocus: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: const [QuilometragemInputFormatter()],
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => focoCidadeOrigem.requestFocus(),
                  decoration: const InputDecoration(
                    labelText: 'Odômetro inicial',
                  ),
                  validator: _validarOdometro,
                ),
                TextFormField(
                  controller: cidadeOrigem,
                  focusNode: focoCidadeOrigem,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => finalizada
                      ? focoOdometroFim.requestFocus()
                      : focoObservacoes.requestFocus(),
                  decoration: const InputDecoration(
                    labelText: 'Cidade de origem',
                  ),
                  validator: (texto) => texto == null || texto.trim().isEmpty
                      ? 'Informe a cidade de origem.'
                      : null,
                ),
                if (finalizada) ...[
                  ListTile(
                    key: const ValueKey('editar_fim_jornada'),
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Fim'),
                    subtitle: Text(formato.format(dataHoraFim!)),
                    trailing: const Icon(Icons.edit_calendar),
                    onTap: () => _alterarDataHora(inicio: false),
                  ),
                  TextFormField(
                    key: const ValueKey('editar_odometro_fim_jornada'),
                    controller: odometroFim,
                    focusNode: focoOdometroFim,
                    selectAllOnFocus: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: const [QuilometragemInputFormatter()],
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => focoCidadeDestino.requestFocus(),
                    decoration: const InputDecoration(
                      labelText: 'Odômetro final',
                    ),
                    validator: _validarOdometro,
                  ),
                  TextFormField(
                    controller: cidadeDestino,
                    focusNode: focoCidadeDestino,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => focoObservacoes.requestFocus(),
                    decoration: const InputDecoration(
                      labelText: 'Cidade de destino (opcional)',
                    ),
                  ),
                ],
                TextFormField(
                  controller: observacoes,
                  focusNode: focoObservacoes,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => focoObservacoes.unfocus(),
                  decoration: const InputDecoration(
                    labelText: 'Observações (opcional)',
                  ),
                  maxLines: 3,
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
