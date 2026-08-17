import 'package:flutter/material.dart';

import '../../../../core/formatters/quilometragem_input_formatter.dart';

class OdometroPausaDialog extends StatefulWidget {
  final String titulo;
  final int odometroMinimo;

  const OdometroPausaDialog({
    super.key,
    required this.titulo,
    required this.odometroMinimo,
  });

  @override
  State<OdometroPausaDialog> createState() => _OdometroPausaDialogState();
}

class _OdometroPausaDialogState extends State<OdometroPausaDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(
      text: formatarQuilometragem(widget.odometroMinimo),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.titulo),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: const [QuilometragemInputFormatter()],
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
          selectAllOnFocus: true,
          decoration: const InputDecoration(labelText: 'Odômetro atual'),
          validator: (texto) {
            final valor = parseQuilometragem(texto);
            if (valor == null) return 'Informe um número inteiro válido.';
            if (valor < 0) return 'O odômetro não pode ser negativo.';
            if (valor < widget.odometroMinimo) {
              return 'O odômetro não pode ser menor que o último registrado.';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              Navigator.pop(context, parseQuilometragem(controller.text));
            }
          },
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}
