import 'package:flutter/material.dart';

typedef AbrirJornadaResultado = ({int odometro, String cidadeOrigem});

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

  @override
  void initState() {
    super.initState();
    odometroController = TextEditingController(
      text: widget.odometroInicial?.toString() ?? '',
    );
    cidadeController = TextEditingController(
      text: widget.cidadeOrigemInicial ?? '',
    );
  }

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
              autofocus: true,
              keyboardType: TextInputType.number,
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
