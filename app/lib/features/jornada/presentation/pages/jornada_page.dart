import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/jornada_dao.dart';
import '../../../../core/database/daos/leitura_ganhos_dao.dart';
import '../../../../core/database/daos/pausa_dao.dart';
import '../../../../core/database/seeds/seed.dart';
import '../../../../core/database/seeds/plataformas_seed.dart';
import '../../../leitura_ganhos/data/leitura_ganhos_repository.dart';
import '../../../leitura_ganhos/data/leitura_ganhos_service.dart';
import '../../../leitura_ganhos/presentation/controllers/leitura_ganhos_controller.dart';
import '../../../leitura_ganhos/presentation/widgets/leitura_ganhos_dialog.dart';
import '../../../pausa/data/pausa_repository.dart';
import '../../../pausa/data/pausa_service.dart';
import '../../../pausa/presentation/controllers/pausa_controller.dart';
import '../../../pausa/presentation/pausa_formatters.dart';
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
  LeituraGanhosController? leituraGanhosController;
  PausaController? pausaController;
  late final AppDatabase database;
  Timer? atualizadorDuracao;

  @override
  void initState() {
    super.initState();

    database = AppDatabase();
    atualizadorDuracao = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && pausaController?.possuiPausaAberta == true) {
        setState(() {});
      }
    });
    _inicializar();
  }

  Future<void> _inicializar() async {
    await garantirDadosTemporarios(database);
    await garantirPlataformasPadrao(database);

    if (!mounted) {
      return;
    }

    final dao = JornadaDao(database);
    final repository = JornadaRepository(dao);
    final pausaDao = PausaDao(database);
    final pausaRepository = PausaRepository(pausaDao);
    final leituraGanhosRepository = LeituraGanhosRepository(
      LeituraGanhosDao(database),
    );
    final service = JornadaService(repository, pausaRepository);
    final pausaService = PausaService(pausaRepository, repository);
    final leituraGanhosService = LeituraGanhosService(
      leituraGanhosRepository,
      repository,
    );
    final novoController = JornadaController(service);
    final novoLeituraGanhosController = LeituraGanhosController(
      leituraGanhosService,
    );
    final novoPausaController = PausaController(pausaService);

    setState(() {
      controller = novoController;
      leituraGanhosController = novoLeituraGanhosController;
      pausaController = novoPausaController;
    });

    await novoController.carregarJornadaAberta();
    await novoPausaController.carregar(novoController.jornadaAtual?.id);
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
      await pausaController?.carregar(controller.jornadaAtual?.id);
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

  Future<void> _iniciarPausa() async {
    final jornadaId = controller?.jornadaAtual?.id;
    final pausaController = this.pausaController;

    if (jornadaId == null || pausaController == null) {
      return;
    }

    try {
      await pausaController.iniciar(jornadaId);
      final pausa = pausaController.pausaAberta;

      if (pausa != null && mounted) {
        await _registrarGanhos(pausa);
      }
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível iniciar a Pausa.')),
      );
    }
  }

  Future<void> _registrarGanhos(Pausa pausa) async {
    final jornadaId = controller?.jornadaAtual?.id;
    final leituraController = leituraGanhosController;

    if (jornadaId == null || leituraController == null) {
      return;
    }

    try {
      await leituraController.preparar(jornadaId);
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível carregar as plataformas.'),
        ),
      );
      return;
    }

    if (!mounted) {
      return;
    }

    final resultado = await showDialog<LeituraGanhosResultado>(
      context: context,
      builder: (context) => LeituraGanhosDialog(
        plataformas: leituraController.plataformas,
        sugestoes: leituraController.sugestoes,
      ),
    );

    if (!mounted || resultado == null) {
      return;
    }

    try {
      await leituraController.salvar(
        jornadaId: jornadaId,
        pausaId: pausa.id,
        itens: resultado,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível salvar a leitura.')),
      );
    }
  }

  Future<void> _finalizarPausa() async {
    final jornadaId = controller?.jornadaAtual?.id;
    final pausaController = this.pausaController;

    if (jornadaId == null || pausaController == null) {
      return;
    }

    try {
      await pausaController.finalizar(jornadaId);
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível finalizar a Pausa.')),
      );
    }
  }

  Future<void> _editarTituloPausa(Pausa pausa) async {
    final textoController = TextEditingController(text: pausa.titulo ?? '');
    final titulo = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Título da Pausa'),
        content: TextField(
          controller: textoController,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Título opcional'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, textoController.text),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
    textoController.dispose();

    if (!mounted || titulo == null) {
      return;
    }

    try {
      await pausaController?.editarTitulo(pausa, titulo);
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível editar a Pausa.')),
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
    final leituraGanhosController = this.leituraGanhosController;
    final pausaController = this.pausaController;

    if (controller == null ||
        leituraGanhosController == null ||
        pausaController == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Jornada')),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          controller,
          pausaController,
          leituraGanhosController,
        ]),
        builder: (context, _) {
          if (controller.carregando ||
              pausaController.carregando ||
              leituraGanhosController.carregando) {
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

            final pausaAberta = pausaController.pausaAberta;
            final formatoHora = DateFormat.Hm(locale);

            return ListView(
              padding: const EdgeInsets.all(16),
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

                if (pausaAberta == null)
                  ElevatedButton(
                    onPressed: _iniciarPausa,
                    child: const Text('Pausar'),
                  )
                else ...[
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Pausa em andamento',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Editar título',
                        onPressed: () => _editarTituloPausa(pausaAberta),
                        icon: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                  Text('Iniciada às ${formatoHora.format(pausaAberta.inicio)}'),
                  Text(
                    formatarDuracaoPausa(
                      DateTime.now().difference(pausaAberta.inicio),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _finalizarPausa,
                    child: const Text('Retomar Jornada'),
                  ),
                  TextButton(
                    onPressed: () => _registrarGanhos(pausaAberta),
                    child: const Text('Registrar ganhos'),
                  ),
                ],

                if (pausaController.pausas.any(
                  (pausa) => pausa.fim != null,
                )) ...[
                  const SizedBox(height: 24),
                  Text(
                    'Pausas da Jornada',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  for (
                    var indice = 0;
                    indice < pausaController.pausas.length;
                    indice++
                  )
                    if (pausaController.pausas[indice].fim != null)
                      _PausaItem(
                        pausa: pausaController.pausas[indice],
                        numero: indice + 1,
                        formatoHora: formatoHora,
                        onEditar: _editarTituloPausa,
                      ),
                ],

                if (pausaAberta == null) ...[
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _fecharJornada,
                    child: const Text('Fechar Jornada'),
                  ),
                ],
              ],
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
    atualizadorDuracao?.cancel();
    leituraGanhosController?.dispose();
    pausaController?.dispose();
    controller?.dispose();
    database.close();
    super.dispose();
  }
}

class _PausaItem extends StatelessWidget {
  final Pausa pausa;
  final int numero;
  final DateFormat formatoHora;
  final ValueChanged<Pausa> onEditar;

  const _PausaItem({
    required this.pausa,
    required this.numero,
    required this.formatoHora,
    required this.onEditar,
  });

  @override
  Widget build(BuildContext context) {
    final fim = pausa.fim;
    final tituloExibido = tituloExibicaoPausa(pausa.titulo, numero);
    final intervalo = fim == null
        ? '${formatoHora.format(pausa.inicio)} → em andamento'
        : '${formatoHora.format(pausa.inicio)} → ${formatoHora.format(fim)} '
              '· ${formatarDuracaoPausa(fim.difference(pausa.inicio))}';

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(tituloExibido),
      subtitle: Text(intervalo),
      trailing: IconButton(
        tooltip: 'Editar título',
        onPressed: () => onEditar(pausa),
        icon: const Icon(Icons.edit),
      ),
    );
  }
}
