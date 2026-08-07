import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/jornada_dao.dart';
import '../../../../core/database/seeds/seed.dart';
import '../../data/jornada_repository.dart';
import '../../data/jornada_service.dart';
import '../controllers/jornada_controller.dart';
import '../widgets/abrir_jornada_dialog.dart';

class JornadaPage extends StatefulWidget {
  const JornadaPage({super.key});

  @override
  State<JornadaPage> createState() => _JornadaPageState();
}

class _JornadaPageState extends State<JornadaPage> {
  JornadaController? controller;
  late final AppDatabase database;

  @override
  void initState() {
    super.initState();

    database = AppDatabase();
    _inicializar();
  }

  Future<void> _inicializar() async {
    await garantirDadosTemporarios(database);

    if (!mounted) {
      return;
    }

    final dao = JornadaDao(database);
    final repository = JornadaRepository(dao);
    final service = JornadaService(repository);
    final novoController = JornadaController(service);

    setState(() {
      controller = novoController;
    });

    await novoController.carregarJornadaAberta();
  }

  Future<void> _abrirJornada() async {
    final controller = this.controller;

    if (controller == null) {
      return;
    }

    final resultado = await showDialog<AbrirJornadaResultado>(
      context: context,
      builder: (context) => const AbrirJornadaDialog(),
    );

    if (!mounted || resultado == null) {
      return;
    }

    try {
      await controller.abrirJornada(
        usuarioId: 1,
        veiculoId: 1,
        odometro: resultado.odometro,
        cidadeOrigem: resultado.cidadeOrigem,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível abrir a jornada. Tente novamente.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = this.controller;

    if (controller == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Jornada')),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          if (controller.carregando) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.possuiJornadaAberta) {
            final jornada = controller.jornadaAtual!;
            final locale = View.of(
              context,
            ).platformDispatcher.locale.toLanguageTag();
            final inicioFormatado = DateFormat.yMd(
              locale,
            ).add_jms().format(jornada.dataHoraInicio);
            final odometroFormatado = NumberFormat.decimalPattern(
              locale,
            ).format(jornada.odometroInicio);

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status: ${jornada.status.name.toUpperCase()}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 16),

                  Text('Início: $inicioFormatado'),

                  Text('Odômetro inicial: $odometroFormatado km'),

                  Text('Cidade de origem: ${jornada.cidadeOrigem}'),

                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: () {
                      // vamos implementar depois
                    },
                    child: const Text('Fechar Jornada'),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: ElevatedButton(
              onPressed: _abrirJornada,
              child: const Text('Abrir Jornada'),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    database.close();
    super.dispose();
  }
}
