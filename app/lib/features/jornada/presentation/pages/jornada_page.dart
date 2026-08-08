import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/jornada_dao.dart';
import '../../../../core/database/seeds/seed.dart';
import '../../data/jornada_repository.dart';
import '../../data/jornada_service.dart';
import '../controllers/jornada_controller.dart';
import '../widgets/abrir_jornada_dialog.dart';
import '../widgets/fechar_jornada_dialog.dart';

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
      builder: (context) => AbrirJornadaDialog(
        odometroInicial: controller.ultimaJornadaFinalizada?.odometroFim,
        odometroMinimo: controller.ultimaJornadaFinalizada?.odometroFim,
        cidadeOrigemInicial: controller.ultimaJornadaFinalizada?.cidadeDestino,
      ),
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

  Future<void> _fecharJornada() async {
    final controller = this.controller;
    final jornada = controller?.jornadaAtual;

    if (controller == null || jornada == null) {
      return;
    }

    final resultado = await showDialog<FecharJornadaResultado>(
      context: context,
      builder: (context) => FecharJornadaDialog(
        odometroInicio: jornada.odometroInicio,
        cidadeDestinoInicial: jornada.cidadeOrigem,
      ),
    );

    if (!mounted || resultado == null) {
      return;
    }

    try {
      await controller.fecharJornada(
        odometroFim: resultado.odometroFim,
        cidadeDestino: resultado.cidadeDestino,
        observacoes: resultado.observacoes,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível fechar a jornada. Tente novamente.'),
        ),
      );
    }
  }

  String _formatarDuracao(Duration duracao, NumberFormat numeros) {
    if (duracao <= Duration.zero) {
      return '${numeros.format(0)}min';
    }

    final partes = <String>[];
    final horas = duracao.inHours;
    final minutos = duracao.inMinutes.remainder(60);

    if (horas > 0) {
      partes.add('${numeros.format(horas)}h');
    }

    if (minutos > 0 || horas == 0) {
      partes.add('${numeros.format(minutos)}min');
    }

    return partes.join(' ');
  }

  String _formatarLocalizacao(String cidadeOrigem, String? cidadeDestino) {
    final origem = cidadeOrigem.trim();
    final destino = cidadeDestino?.trim() ?? '';

    if (destino.isEmpty || origem == destino) {
      return 'Você dirigiu em $origem';
    }

    return '$origem → $destino';
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
                    onPressed: _fecharJornada,
                    child: const Text('Fechar Jornada'),
                  ),
                ],
              ),
            );
          }

          final ultimaJornada = controller.ultimaJornadaFinalizada;

          if (ultimaJornada == null) {
            return Center(
              child: ElevatedButton(
                onPressed: _abrirJornada,
                child: const Text('Abrir Jornada'),
              ),
            );
          }

          final locale = View.of(
            context,
          ).platformDispatcher.locale.toLanguageTag();
          final numeros = NumberFormat.decimalPattern(locale);
          final dataHoraFim = ultimaJornada.dataHoraFim!;
          final duracao = dataHoraFim.difference(ultimaJornada.dataHoraInicio);
          final quilometros = ultimaJornada.quilometrosPercorridos!;
          final duracaoEmHoras =
              duracao.inMilliseconds / Duration.millisecondsPerHour;
          final mediaFormatada = duracaoEmHoras > 0
              ? (NumberFormat.decimalPattern(locale)
                      ..minimumFractionDigits = 1
                      ..maximumFractionDigits = 1)
                    .format(quilometros / duracaoEmHoras)
              : null;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Jornada concluída',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Text(
                _formatarLocalizacao(
                  ultimaJornada.cidadeOrigem,
                  ultimaJornada.cidadeDestino,
                ),
              ),
              Text('${numeros.format(quilometros)} km percorridos'),
              Text('Duração: ${_formatarDuracao(duracao, numeros)}'),
              Text(
                'Média da jornada: '
                '${mediaFormatada == null ? 'indisponível' : '$mediaFormatada km/h'}',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _abrirJornada,
                child: const Text('Abrir Jornada'),
              ),
            ],
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
