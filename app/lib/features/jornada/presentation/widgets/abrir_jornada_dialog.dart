import 'package:flutter/material.dart';

class AbrirJornadaDialog extends StatefulWidget {
  const AbrirJornadaDialog({super.key});

  @override
  State<AbrirJornadaDialog> createState() => _AbrirJornadaDialogState();
}

class _AbrirJornadaDialogState extends State<AbrirJornadaDialog> {
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

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: odometroController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Odômetro'),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: cidadeController,
            decoration: const InputDecoration(labelText: 'Cidade'),
          ),
        ],
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),

        ElevatedButton(onPressed: () {}, child: const Text('Salvar')),
      ],
    );
  }
}
