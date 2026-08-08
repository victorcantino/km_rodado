import 'package:flutter/material.dart';

typedef FecharJornadaResultado = ({
  int odometroFim,
  String? cidadeDestino,
  String? observacoes,
});

class FecharJornadaDialog extends StatefulWidget {
  final int odometroInicio;
  final String? cidadeDestinoInicial;

  const FecharJornadaDialog({
    super.key,
    required this.odometroInicio,
    this.cidadeDestinoInicial,
  });

  @override
  State<FecharJornadaDialog> createState() => _FecharJornadaDialogState();
}

class _FecharJornadaDialogState extends State<FecharJornadaDialog> {
  final formKey = GlobalKey<FormState>();
  final odometroController = TextEditingController();
  late final TextEditingController cidadeController;
  final observacoesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cidadeController = TextEditingController(
      text: widget.cidadeDestinoInicial ?? '',
    );
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
    return AlertDialog(
      title: const Text('Fechar Jornada'),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: odometroController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Odômetro final'),
                validator: (valor) {
                  final texto = valor?.trim() ?? '';

                  if (texto.isEmpty) {
                    return 'Informe o odômetro final.';
                  }

                  final odometro = int.tryParse(texto);

                  if (odometro == null) {
                    return 'Informe um número inteiro válido.';
                  }

                  if (odometro < 0) {
                    return 'O odômetro não pode ser negativo.';
                  }

                  if (odometro <= widget.odometroInicio) {
                    return 'O odômetro final deve ser maior que o inicial.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: cidadeController,
                decoration: const InputDecoration(
                  labelText: 'Cidade de destino (opcional)',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: observacoesController,
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
            if (!formKey.currentState!.validate()) {
              return;
            }

            final resultado = (
              odometroFim: int.parse(odometroController.text.trim()),
              cidadeDestino: _textoOpcional(cidadeController.text),
              observacoes: _textoOpcional(observacoesController.text),
            );

            Navigator.pop<FecharJornadaResultado>(context, resultado);
          },
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}
