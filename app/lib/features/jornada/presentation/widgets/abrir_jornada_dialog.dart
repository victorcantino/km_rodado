import 'package:flutter/material.dart';

typedef AbrirJornadaResultado = ({int odometro, String cidadeOrigem});

class AbrirJornadaDialog extends StatefulWidget {
  const AbrirJornadaDialog({super.key});

  @override
  State<AbrirJornadaDialog> createState() => _AbrirJornadaDialogState();
}

class _AbrirJornadaDialogState extends State<AbrirJornadaDialog> {
  final formKey = GlobalKey<FormState>();

  final odometroController = TextEditingController();

  final cidadeController = TextEditingController();

  @override
  void dispose() {
    odometroController.dispose();
    cidadeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Abrir Jornada'),

      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: odometroController,
              keyboardType: TextInputType.number,
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

                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: cidadeController,
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
            if (!formKey.currentState!.validate()) {
              return;
            }

            final resultado = (
              odometro: int.parse(odometroController.text.trim()),
              cidadeOrigem: cidadeController.text.trim(),
            );

            Navigator.pop<AbrirJornadaResultado>(context, resultado);
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
