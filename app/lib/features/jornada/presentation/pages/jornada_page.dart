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
      pausaRepository,
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
    await novoLeituraGanhosController.carregarEstado(
      novoController.jornadaAtual?.id,
    );
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
      final jornadaId = controller.jornadaAtual?.id;
      if (jornadaId != null && mounted) {
        await _registrarLeituraInicial(jornadaId);
      }
    } catch (error, stackTrace) {
      if (!mounted) {
        return;
      }

      _apresentarErro(
        operacao: 'abrir a Jornada',
        error: error,
        stackTrace: stackTrace,
        mensagemPadrao: 'Não foi possível abrir a jornada. Tente novamente.',
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
        await _registrarLeituraParcial(pausa);
      }
    } catch (error, stackTrace) {
      if (!mounted) {
        return;
      }

      _apresentarErro(
        operacao: 'iniciar a Pausa',
        error: error,
        stackTrace: stackTrace,
        mensagemPadrao: 'Não foi possível iniciar a Pausa.',
      );
    }
  }

  Future<LeituraGanhosResultado?> _coletarLeitura({
    required int jornadaId,
    required String titulo,
    required bool usarSugestoes,
  }) async {
    final leituraController = leituraGanhosController;
    if (leituraController == null) {
      return null;
    }

    try {
      await leituraController.preparar(jornadaId, usarSugestoes: usarSugestoes);
    } catch (error, stackTrace) {
      if (mounted) {
        _apresentarErro(
          operacao: 'carregar as plataformas',
          error: error,
          stackTrace: stackTrace,
          mensagemPadrao: 'Não foi possível carregar as plataformas.',
        );
      }
      return null;
    }

    if (!mounted) {
      return null;
    }

    return showDialog<LeituraGanhosResultado>(
      context: context,
      builder: (context) => LeituraGanhosDialog(
        plataformas: leituraController.plataformas,
        sugestoes: leituraController.sugestoes,
        titulo: titulo,
      ),
    );
  }

  Future<void> _registrarLeituraInicial(int jornadaId) async {
    final leituraController = leituraGanhosController;
    if (leituraController == null) {
      return;
    }

    final resultado = await _coletarLeitura(
      jornadaId: jornadaId,
      titulo: 'Registrar ganhos iniciais',
      usarSugestoes: false,
    );
    if (resultado == null || !mounted) {
      return;
    }

    try {
      await leituraController.salvarInicial(
        jornadaId: jornadaId,
        itens: resultado,
      );
    } catch (error, stackTrace) {
      if (mounted) {
        _apresentarErro(
          operacao: 'salvar os ganhos iniciais',
          error: error,
          stackTrace: stackTrace,
          mensagemPadrao: 'Não foi possível salvar os ganhos iniciais.',
        );
      }
    }
  }

  Future<void> _registrarLeituraParcial(Pausa pausa) async {
    final jornadaId = controller?.jornadaAtual?.id;
    final leituraController = leituraGanhosController;

    if (jornadaId == null || leituraController == null) {
      return;
    }

    final resultado = await _coletarLeitura(
      jornadaId: jornadaId,
      titulo: 'Registrar ganhos',
      usarSugestoes: true,
    );

    if (!mounted || resultado == null) {
      return;
    }

    try {
      await leituraController.salvarParcial(
        jornadaId: jornadaId,
        pausaId: pausa.id,
        itens: resultado,
      );
    } catch (error, stackTrace) {
      if (!mounted) {
        return;
      }

      _apresentarErro(
        operacao: 'salvar a leitura parcial',
        error: error,
        stackTrace: stackTrace,
        mensagemPadrao: 'Não foi possível salvar a leitura.',
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
    } catch (error, stackTrace) {
      if (!mounted) {
        return;
      }

      _apresentarErro(
        operacao: 'finalizar a Pausa',
        error: error,
        stackTrace: stackTrace,
        mensagemPadrao: 'Não foi possível finalizar a Pausa.',
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
    } catch (error, stackTrace) {
      if (!mounted) {
        return;
      }

      _apresentarErro(
        operacao: 'editar a Pausa',
        error: error,
        stackTrace: stackTrace,
        mensagemPadrao: 'Não foi possível editar a Pausa.',
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

    final leituraFinal = await _coletarLeitura(
      jornadaId: jornada.id,
      titulo: 'Registrar ganhos finais',
      usarSugestoes: true,
    );

    if (!mounted || leituraFinal == null) {
      return;
    }

    try {
      await leituraGanhosController?.finalizarJornada(
        jornadaId: jornada.id,
        odometroFim: resultado.odometroFim,
        cidadeDestino: resultado.cidadeDestino,
        observacoes: resultado.observacoes,
        itens: leituraFinal,
      );
      await controller.carregarJornadaAberta();
      await pausaController?.carregar(null);
    } catch (error, stackTrace) {
      if (!mounted) {
        return;
      }

      _apresentarErro(
        operacao: 'fechar a Jornada',
        error: error,
        stackTrace: stackTrace,
        mensagemPadrao: 'Não foi possível fechar a jornada. Tente novamente.',
      );
    }
  }

  void _apresentarErro({
    required String operacao,
    required Object error,
    required StackTrace stackTrace,
    required String mensagemPadrao,
  }) {
    debugPrint('Erro ao $operacao: $error\n$stackTrace');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_mensagemDeNegocio(error) ?? mensagemPadrao)),
    );
  }

  String? _mensagemDeNegocio(Object error) {
    final mensagem = error.toString().replaceFirst(
      RegExp(r'^(Exception|Bad state):\s*'),
      '',
    );
    const iniciosConhecidos = [
      'Já existe',
      'Não existe',
      'O odômetro',
      'O fim',
      'A Jornada',
      'A jornada',
      'A Pausa',
      'A leitura',
      'Os ganhos',
      'Registre',
      'Informe',
      'Uma plataforma',
      'O valor',
      'A quantidade',
    ];

    return iniciosConhecidos.any(mensagem.startsWith) ? mensagem : null;
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
            final inicialConcluida =
                leituraGanhosController.leituraInicialConcluida;

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

                if (!inicialConcluida) ...[
                  Text(
                    'Ganhos iniciais pendentes',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _registrarLeituraInicial(jornada.id),
                    child: const Text('Registrar ganhos iniciais'),
                  ),
                ],

                if (inicialConcluida)
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
                    Text(
                      'Iniciada às ${formatoHora.format(pausaAberta.inicio)}',
                    ),
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
                      onPressed: () => _registrarLeituraParcial(pausaAberta),
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

                if (inicialConcluida && pausaAberta == null) ...[
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
