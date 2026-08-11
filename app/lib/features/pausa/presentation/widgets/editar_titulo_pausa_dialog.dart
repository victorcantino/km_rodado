import 'package:flutter/material.dart';

class EditarTituloPausaDialog extends StatefulWidget {
  final String? tituloInicial;

  const EditarTituloPausaDialog({super.key, this.tituloInicial});

  @override
  State<EditarTituloPausaDialog> createState() =>
      _EditarTituloPausaDialogState();
}

class _EditarTituloPausaDialogState extends State<EditarTituloPausaDialog> {
  late String titulo = widget.tituloInicial ?? '';

  void _fechar([String? resultado]) {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.pop<String>(context, resultado);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Título da Pausa'),
      content: TextFormField(
        initialValue: titulo,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'Título opcional'),
        onChanged: (valor) => titulo = valor,
      ),
      actions: [
        TextButton(onPressed: _fechar, child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: () => _fechar(titulo),
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
