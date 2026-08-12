import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/jornada_dao.dart';
import '../../../../core/database/daos/ganho_individual_dao.dart';
import '../../../../core/database/daos/leitura_ganhos_dao.dart';
import '../../../../core/database/daos/pausa_dao.dart';
import '../../../../core/database/seeds/seed.dart';
import '../../../../core/database/seeds/plataformas_seed.dart';
import '../../../leitura_ganhos/data/leitura_ganhos_repository.dart';
import '../../../ganho_individual/data/ganho_individual_repository.dart';
import '../../../ganho_individual/data/ganho_individual_service.dart';
import '../../../ganho_individual/presentation/controllers/ganho_individual_controller.dart';
import '../../../ganho_individual/presentation/widgets/registrar_ganho_individual_dialog.dart';
import '../../../leitura_ganhos/data/leitura_ganhos_service.dart';
import '../../../leitura_ganhos/presentation/controllers/leitura_ganhos_controller.dart';
import '../../../leitura_ganhos/presentation/widgets/leitura_ganhos_dialog.dart';
import '../../../pausa/data/pausa_repository.dart';
import '../../../pausa/data/pausa_service.dart';
import '../../../pausa/presentation/controllers/pausa_controller.dart';
import '../../../pausa/presentation/pausa_formatters.dart';
import '../../../pausa/presentation/widgets/odometro_pausa_dialog.dart';
import '../../../pausa/presentation/widgets/editar_titulo_pausa_dialog.dart';
import '../../data/jornada_repository.dart';
import '../../data/jornada_service.dart';
import '../../data/resumo_jornada.dart';
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
  GanhoIndividualController? ganhoIndividualController;
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
    final ganhoIndividualRepository = GanhoIndividualRepository(
      GanhoIndividualDao(database),
    );
    final service = JornadaService(
      repository,
      pausaRepository,
      leituraGanhosRepository,
      ganhoIndividualRepository,
    );
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
    final novoGanhoIndividualController = GanhoIndividualController(
      GanhoIndividualService(ganhoIndividualRepository, repository),
    );

    setState(() {
      controller = novoController;
      leituraGanhosController = novoLeituraGanhosController;
      pausaController = novoPausaController;
      ganhoIndividualController = novoGanhoIndividualController;
    });

    await novoController.carregarJornadaAberta();
    await novoPausaController.carregar(novoController.jornadaAtual?.id);
    await novoLeituraGanhosController.carregarEstado(
      novoController.jornadaAtual?.id,
    );
    await novoGanhoIndividualController.carregar(
      novoController.jornadaAtual?.id,
    );
  }

  Future<void> _registrarGanhoIndividual([Plataforma? plataforma]) async {
    final jornadaId = controller?.jornadaAtual?.id;
    final ganhoController = ganhoIndividualController;
    if (jornadaId == null || ganhoController == null) return;
    final disponiveis = plataforma == null
        ? ganhoController.plataformas
        : [plataforma];
    if (disponiveis.isEmpty) return;
    final resultado = await showDialog<RegistrarGanhoIndividualResultado>(
      context: context,
      builder: (_) => RegistrarGanhoIndividualDialog(plataformas: disponiveis),
    );
    if (!mounted || resultado == null) return;
    try {
      await ganhoController.registrar(
        jornadaId: jornadaId,
        plataformaId: resultado.plataformaId,
        quantidadeViagens: resultado.quantidadeViagens,
        valorTotalCentavos: resultado.valorTotalCentavos,
        observacao: resultado.observacao,
      );
    } catch (error, stackTrace) {
      if (!mounted) return;
      _apresentarErro(
        operacao: 'registrar o ganho individual',
        error: error,
        stackTrace: stackTrace,
        mensagemPadrao: 'Não foi possível registrar o ganho.',
      );
    }
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

    final odometro = await showDialog<int>(
      context: context,
      builder: (_) => OdometroPausaDialog(
        titulo: 'Iniciar Pausa',
        odometroMinimo: _ultimoOdometroConhecido(),
      ),
    );
    if (!mounted || odometro == null) return;

    try {
      await pausaController.iniciar(jornadaId, odometroInicio: odometro);
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

    final todasPlataformas = await leituraController.listarTodasPlataformas();
    if (!mounted) return null;

    return showDialog<LeituraGanhosResultado>(
      context: context,
      builder: (context) => LeituraGanhosDialog(
        plataformas: leituraController.plataformas,
        sugestoes: leituraController.sugestoes,
        titulo: titulo,
        leituraInicial: !usarSugestoes,
        todasPlataformas: todasPlataformas,
        onConfigurar: (ativacoes) async {
          final atualizadas = await leituraController.configurarPlataformas(
            jornadaId,
            ativacoes,
            leituraInicial: !usarSugestoes,
          );
          await ganhoIndividualController?.carregar(jornadaId);
          return atualizadas;
        },
        totaisIndividuais: ganhoIndividualController?.totais ?? const [],
        onRegistrarIndividual: (plataforma) async {
          await _registrarGanhoIndividual(plataforma);
          return ganhoIndividualController?.totais ?? const [];
        },
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

    final pausa = pausaController.pausaAberta;
    if (pausa == null) return;
    final odometro = await showDialog<int>(
      context: context,
      builder: (_) => OdometroPausaDialog(
        titulo: 'Retomar Jornada',
        odometroMinimo: pausa.odometroInicio ?? _ultimoOdometroConhecido(),
      ),
    );
    if (!mounted || odometro == null) return;

    try {
      await pausaController.finalizar(jornadaId, odometroFim: odometro);
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

  int _ultimoOdometroConhecido() {
    final jornada = controller!.jornadaAtual!;
    for (final pausa in pausaController!.pausas.reversed) {
      final valor = pausa.odometroFim ?? pausa.odometroInicio;
      if (valor != null) return valor;
    }
    return jornada.odometroInicio;
  }

  Future<void> _editarTituloPausa(Pausa pausa) async {
    final titulo = await showDialog<String>(
      context: context,
      builder: (_) => EditarTituloPausaDialog(tituloInicial: pausa.titulo),
    );

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
        odometroInicio: _ultimoOdometroConhecido(),
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
    final ganhoIndividualController = this.ganhoIndividualController;

    if (controller == null ||
        leituraGanhosController == null ||
        pausaController == null ||
        ganhoIndividualController == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Jornada')),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          controller,
          pausaController,
          leituraGanhosController,
          ganhoIndividualController,
        ]),
        builder: (context, _) {
          if (controller.carregando ||
              pausaController.carregando ||
              leituraGanhosController.carregando ||
              ganhoIndividualController.carregando) {
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

                if (ganhoIndividualController.plataformas.isNotEmpty) ...[
                  OutlinedButton.icon(
                    onPressed: _registrarGanhoIndividual,
                    icon: const Icon(Icons.add),
                    label: Text(
                      ganhoIndividualController.plataformas.length == 1
                          ? ganhoIndividualController.plataformas.single.nome
                          : 'Ganho individual',
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

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
          final resumo = controller.resumoUltimaJornada;

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
              if (resumo != null) ...[
                const SizedBox(height: 16),
                _ResumoJornadaConcluida(
                  resumo: resumo,
                  numeros: numeros,
                  formatarDuracao: _formatarDuracao,
                ),
              ],
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
    ganhoIndividualController?.dispose();
    controller?.dispose();
    database.close();
    super.dispose();
  }
}

class _ResumoJornadaConcluida extends StatelessWidget {
  final ResumoJornada resumo;
  final NumberFormat numeros;
  final String Function(Duration, NumberFormat) formatarDuracao;

  const _ResumoJornadaConcluida({
    required this.resumo,
    required this.numeros,
    required this.formatarDuracao,
  });

  @override
  Widget build(BuildContext context) {
    final moeda = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: r'R$',
      decimalDigits: 2,
    );
    final decimal = NumberFormat.decimalPattern('pt_BR')
      ..minimumFractionDigits = 2
      ..maximumFractionDigits = 2;
    final receitaTotal = resumo.receitaTotalCentavos;
    final viagensTotal = resumo.quantidadeTotalViagens;
    final kmPausa = resumo.quilometrosEmPausa;
    final kmAtivo = resumo.quilometrosAtivos;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resultado da Jornada',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        if (receitaTotal != null && viagensTotal != null) ...[
          Text(
            moeda.format(receitaTotal / 100),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text('$viagensTotal ${viagensTotal == 1 ? 'viagem' : 'viagens'}'),
          Text(
            'Ticket médio geral: '
            '${resumo.ticketMedioGeral == null ? '—' : moeda.format(resumo.ticketMedioGeral)}',
          ),
        ] else
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Resultado financeiro incompleto'),
              Text('Ticket médio geral: —'),
            ],
          ),
        const SizedBox(height: 12),
        for (final resultado in resumo.resultadosPlataformas)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: resultado.calculavel
                ? Text(
                    '${resultado.nome}: '
                    '${moeda.format(resultado.receitaCentavos! / 100)} · '
                    '${resultado.quantidadeViagens} '
                    '${resultado.quantidadeViagens == 1 ? 'viagem' : 'viagens'} · '
                    'Ticket médio: '
                    '${resultado.ticketMedio == null ? '—' : moeda.format(resultado.ticketMedio)}',
                  )
                : Text(
                    '${resultado.nome}: Revisão necessária · '
                    'Ticket médio: —',
                  ),
          ),
        const SizedBox(height: 12),
        _SecaoResumo(
          titulo: 'Tempo',
          linhas: [
            '${formatarDuracao(resumo.duracaoTotal, numeros)} total',
            '${formatarDuracao(resumo.tempoPausa, numeros)} em pausa',
            '${formatarDuracao(resumo.tempoAtivo, numeros)} ativo',
          ],
        ),
        const SizedBox(height: 12),
        _SecaoResumo(
          titulo: 'Distância',
          linhas: [
            '${numeros.format(resumo.quilometrosTotal)} km total',
            kmPausa == null
                ? 'km em pausa: indisponível'
                : '${numeros.format(kmPausa)} km em pausa',
            kmAtivo == null
                ? 'km ativo: indisponível'
                : '${numeros.format(kmAtivo)} km ativo',
          ],
        ),
        const SizedBox(height: 12),
        _SecaoResumo(
          titulo: 'Desempenho',
          linhas: [
            resumo.receitaPorHoraAtiva == null
                ? r'R$/h ativo: —'
                : 'R\$ ${decimal.format(resumo.receitaPorHoraAtiva)}/h ativo',
            resumo.receitaPorKmAtivo == null
                ? r'R$/km ativo: —'
                : 'R\$ ${decimal.format(resumo.receitaPorKmAtivo)}/km ativo',
          ],
        ),
      ],
    );
  }
}

class _SecaoResumo extends StatelessWidget {
  final String titulo;
  final List<String> linhas;

  const _SecaoResumo({required this.titulo, required this.linhas});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: Theme.of(context).textTheme.titleSmall),
        for (final linha in linhas) Text(linha),
      ],
    );
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
