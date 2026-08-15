import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef AbrirJornadaResultado = ({
  int odometro,
  String cidadeOrigem,
  DateTime dataHoraInicio,
});

class AbrirJornadaDialog extends StatefulWidget {
  final int? odometroInicial;
  final int? odometroMinimo;
  final String? cidadeOrigemInicial;

  const AbrirJornadaDialog({
    super.key,
    this.odometroInicial,
    this.odometroMinimo,
    this.cidadeOrigemInicial,
  });

  @override
  State<AbrirJornadaDialog> createState() => _AbrirJornadaDialogState();
}

class _AbrirJornadaDialogState extends State<AbrirJornadaDialog> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController odometroController;

  late final TextEditingController cidadeController;
  late DateTime dataHoraInicio;
  String? erroDataHora;

  @override
  void initState() {
    super.initState();
    odometroController = TextEditingController(
      text: widget.odometroInicial?.toString() ?? '',
    );
    cidadeController = TextEditingController(
      text: widget.cidadeOrigemInicial ?? '',
    );
    dataHoraInicio = DateTime.now();
  }

  Future<void> _alterarDataHora() async {
    final agora = DateTime.now();
    final data = await showDatePicker(
      context: context,
      initialDate: dataHoraInicio,
      firstDate: DateTime(2000),
      lastDate: agora,
    );
    if (!mounted || data == null) return;
    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(dataHoraInicio),
    );
    if (!mounted || hora == null) return;
    setState(() {
      dataHoraInicio = DateTime(
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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formato = DateFormat.yMd(
      Localizations.localeOf(context).toLanguageTag(),
    ).add_Hm();
    return AlertDialog(
      title: const Text('Abrir Jornada'),

      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              key: const ValueKey('alterar_inicio_jornada'),
              contentPadding: EdgeInsets.zero,
              title: const Text('Início'),
              subtitle: Text(formato.format(dataHoraInicio)),
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
              textInputAction: TextInputAction.next,
              selectAllOnFocus: true,
              decoration: const InputDecoration(labelText: 'Odômetro'),
              validator: (valor) {
                final texto = valor?.trim() ?? '';

                if (texto.isEmpty) {
                  return 'Informe o odômetro.';
                }

                final odometro = int.tryParse(texto);

                if (odometro == null) {
                  return 'Informe um número inteiro válido.';
                }

                if (odometro < 0) {
                  return 'O odômetro não pode ser negativo.';
                }

                final odometroMinimo = widget.odometroMinimo;

                if (odometroMinimo != null && odometro < odometroMinimo) {
                  return 'O odômetro não pode ser menor que o último registrado.';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: cidadeController,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
              decoration: const InputDecoration(labelText: 'Cidade'),
              validator: (valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return 'Informe a cidade de origem.';
                }

                return null;
              },
            ),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),

        ElevatedButton(
          onPressed: () {
            if (dataHoraInicio.isAfter(DateTime.now())) {
              setState(() {
                erroDataHora = 'O início da jornada não pode estar no futuro.';
              });
              return;
            }
            if (!formKey.currentState!.validate()) {
              return;
            }

            final resultado = (
              odometro: int.parse(odometroController.text.trim()),
              cidadeOrigem: cidadeController.text.trim(),
              dataHoraInicio: dataHoraInicio,
            );

            Navigator.pop<AbrirJornadaResultado>(context, resultado);
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
