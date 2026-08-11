import 'package:flutter/material.dart';

import '../../../../core/database/app_database.dart';

class ConfigurarPlataformasDialog extends StatefulWidget {
  final List<Plataforma> plataformas;
  const ConfigurarPlataformasDialog({super.key, required this.plataformas});

  @override
  State<ConfigurarPlataformasDialog> createState() =>
      _ConfigurarPlataformasDialogState();
}

class _ConfigurarPlataformasDialogState
    extends State<ConfigurarPlataformasDialog> {
  late final Map<int, bool> ativacoes = {
    for (final plataforma in widget.plataformas)
      plataforma.id: plataforma.ativa,
  };

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Plataformas nas leituras'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final plataforma in widget.plataformas)
          SwitchListTile(
            title: Text(plataforma.nome),
            value: ativacoes[plataforma.id]!,
            onChanged: (valor) =>
                setState(() => ativacoes[plataforma.id] = valor),
          ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      ElevatedButton(
        onPressed: () => Navigator.pop(context, ativacoes),
        child: const Text('Salvar'),
      ),
    ],
  );
}
