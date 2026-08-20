import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/formatters/quilometragem_input_formatter.dart';

typedef FecharJornadaResultado = ({
  int odometroFim,
  String? cidadeDestino,
  String? observacoes,
  DateTime dataHoraFim,
});

class FecharJornadaDialog extends StatefulWidget {
  final int odometroInicio;
  final String? cidadeDestinoInicial;
  final DateTime? dataHoraInicio;

  const FecharJornadaDialog({
    super.key,
    required this.odometroInicio,
    this.dataHoraInicio,
    this.cidadeDestinoInicial,
  });

  @override
  State<FecharJornadaDialog> createState() => _FecharJornadaDialogState();
}

class _FecharJornadaDialogState extends State<FecharJornadaDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController odometroController;
  late final TextEditingController cidadeController;
  final observacoesController = TextEditingController();
  late DateTime dataHoraFim;
  String? erroDataHora;

  @override
  void initState() {
    super.initState();
    odometroController = TextEditingController(
      text: formatarQuilometragem(widget.odometroInicio),
    );
    cidadeController = TextEditingController(
      text: widget.cidadeDestinoInicial ?? '',
    );
    dataHoraFim = DateTime.now();
  }

  Future<void> _alterarDataHora() async {
    final agora = DateTime.now();
    final data = await showDatePicker(
      context: context,
      initialDate: dataHoraFim,
      firstDate: widget.dataHoraInicio ?? DateTime(2000),
      lastDate: agora,
    );
    if (!mounted || data == null) return;
    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(dataHoraFim),
    );
    if (!mounted || hora == null) return;
    setState(() {
      dataHoraFim = DateTime(
        data.year,
        data.month,
        data.day,
        hora.hour,
        hora.minute,
      );
      erroDataHora = null;
    });
  }

  @override
  void dispose() {
    odometroController.dispose();
    cidadeController.dispose();
    observacoesController.dispose();
    super.dispose();
  }

  String? _textoOpcional(String texto) {
    final valor = texto.trim();
    return valor.isEmpty ? null : valor;
  }

  @override
  Widget build(BuildContext context) {
    final formato = DateFormat.yMd(
      Localizations.localeOf(context).toLanguageTag(),
    ).add_Hm();
    return AlertDialog(
      title: const Text('Fechar Jornada'),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                key: const ValueKey('alterar_fim_jornada'),
                contentPadding: EdgeInsets.zero,
                title: const Text('Fim'),
                subtitle: Text(formato.format(dataHoraFim)),
                trailing: const Icon(Icons.edit_calendar),
                onTap: _alterarDataHora,
              ),
              if (erroDataHora != null)
                Text(
                  erroDataHora!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              TextFormField(
                controller: odometroController,
                autofocus: true,
                keyboardType: TextInputType.number,
                inputFormatters: const [QuilometragemInputFormatter()],
                textInputAction: TextInputAction.next,
                selectAllOnFocus: true,
                onTap: () => odometroController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: odometroController.text.length,
                ),
                decoration: const InputDecoration(labelText: 'Odômetro final'),
                validator: (valor) {
                  final texto = valor?.trim() ?? '';

                  if (texto.isEmpty) {
                    return 'Informe o odômetro final.';
                  }

                  final odometro = parseQuilometragem(texto);

                  if (odometro == null) {
                    return 'Informe um número inteiro válido.';
                  }

                  if (odometro < 0) {
                    return 'O odômetro não pode ser negativo.';
                  }

                  if (odometro < widget.odometroInicio) {
                    return 'O odômetro final não pode ser menor que o inicial.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: cidadeController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Cidade de destino (opcional)',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: observacoesController,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                decoration: const InputDecoration(
                  labelText: 'Observações (opcional)',
                ),
                maxLines: 3,
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
        ElevatedButton(
          onPressed: () {
            if (dataHoraFim.isAfter(DateTime.now())) {
              setState(() {
                erroDataHora = 'O fim da jornada não pode estar no futuro.';
              });
              return;
            }
            if (widget.dataHoraInicio != null &&
                dataHoraFim.isBefore(widget.dataHoraInicio!)) {
              setState(() {
                erroDataHora =
                    'O fim da jornada não pode ser anterior ao início.';
              });
              return;
            }
            if (!formKey.currentState!.validate()) {
              return;
            }

            final resultado = (
              odometroFim: parseQuilometragem(odometroController.text)!,
              cidadeDestino: _textoOpcional(cidadeController.text),
              observacoes: _textoOpcional(observacoesController.text),
              dataHoraFim: dataHoraFim,
            );

            Navigator.pop<FecharJornadaResultado>(context, resultado);
          },
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}
