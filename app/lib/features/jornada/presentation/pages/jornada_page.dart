import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/jornada_dao.dart';
import '../../../../core/database/daos/abastecimento_dao.dart';
import '../../../../core/database/daos/ganho_individual_dao.dart';
import '../../../../core/database/daos/leitura_ganhos_dao.dart';
import '../../../../core/database/daos/pausa_dao.dart';
import '../../../../core/database/daos/passe_plataforma_dao.dart';
import '../../../../core/database/daos/bonus_promocao_dao.dart';
import '../../../../core/database/daos/manutencao_dao.dart';
import '../../../../core/database/daos/despesa_veiculo_dao.dart';
import '../../../../core/database/daos/custo_recorrente_dao.dart';
import '../../../../core/database/daos/depreciacao_veiculo_dao.dart';
import '../../../../core/database/seeds/seed.dart';
import '../../../../core/database/seeds/plataformas_seed.dart';
import '../../../leitura_ganhos/data/leitura_ganhos_repository.dart';
import '../../../abastecimento/data/abastecimento_repository.dart';
import '../../../abastecimento/data/abastecimento_service.dart';
import '../../../abastecimento/data/resumo_inteligencia_abastecimento.dart';
import '../../../abastecimento/presentation/controllers/abastecimento_controller.dart';
import '../../../abastecimento/presentation/widgets/registrar_abastecimento_dialog.dart';
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
import '../../../pausa/presentation/widgets/editar_pausa_dialog.dart';
import '../../../passe_plataforma/data/passe_plataforma_repository.dart';
import '../../../passe_plataforma/data/passe_plataforma_service.dart';
import '../../../passe_plataforma/presentation/controllers/passe_plataforma_controller.dart';
import '../../../passe_plataforma/presentation/pages/passes_bonus_page.dart';
import '../../../bonus_promocao/data/bonus_promocao_repository.dart';
import '../../../bonus_promocao/data/bonus_promocao_service.dart';
import '../../../bonus_promocao/presentation/controllers/bonus_promocao_controller.dart';
import '../../../manutencao/data/manutencao_repository.dart';
import '../../../manutencao/data/manutencao_service.dart';
import '../../../manutencao/presentation/controllers/manutencao_controller.dart';
import '../../../manutencao/presentation/pages/manutencoes_page.dart';
import '../../../despesa_veiculo/data/despesa_veiculo_repository.dart';
import '../../../despesa_veiculo/data/despesa_veiculo_service.dart';
import '../../../despesa_veiculo/presentation/controllers/despesa_veiculo_controller.dart';
import '../../../despesa_veiculo/presentation/pages/despesas_page.dart';
import '../../../custo_recorrente/data/custo_recorrente_repository.dart';
import '../../../custo_recorrente/data/custo_recorrente_service.dart';
import '../../../custo_recorrente/presentation/controllers/custo_recorrente_controller.dart';
import '../../../depreciacao_veiculo/data/depreciacao_veiculo_repository.dart';
import '../../../depreciacao_veiculo/data/depreciacao_veiculo_service.dart';
import '../../../depreciacao_veiculo/presentation/controllers/depreciacao_veiculo_controller.dart';
import '../../data/jornada_repository.dart';
import '../../data/jornada_service.dart';
import '../../data/resumo_jornada.dart';
import '../controllers/jornada_controller.dart';
import '../widgets/abrir_jornada_dialog.dart';
import '../widgets/fechar_jornada_dialog.dart';
import '../widgets/editar_jornada_dialog.dart';

class JornadaPage extends StatefulWidget {
  final AppDatabase Function()? databaseFactory;

  const JornadaPage({super.key, this.databaseFactory});

  @override
  State<JornadaPage> createState() => _JornadaPageState();
}

class _JornadaPageState extends State<JornadaPage> {
  JornadaController? controller;
  LeituraGanhosController? leituraGanhosController;
  PausaController? pausaController;
  GanhoIndividualController? ganhoIndividualController;
  AbastecimentoController? abastecimentoController;
  PassePlataformaController? passePlataformaController;
  BonusPromocaoController? bonusPromocaoController;
  late final AppDatabase database;
  Timer? atualizadorDuracao;

  @override
  void initState() {
    super.initState();

    database = widget.databaseFactory?.call() ?? AppDatabase();
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
    final passeRepository = PassePlataformaRepository(
      PassePlataformaDao(database),
    );
    final bonusPromocaoRepository = BonusPromocaoRepository(
      BonusPromocaoDao(database),
    );
    final abastecimentoRepository = AbastecimentoRepository(
      AbastecimentoDao(database),
    );
    final service = JornadaService(
      repository,
      pausaRepository,
      leituraGanhosRepository,
      ganhoIndividualRepository,
      passeRepository,
      bonusPromocaoRepository,
      abastecimentoRepository,
    );
    final pausaService = PausaService(
      pausaRepository,
      repository,
      abastecimentoRepository,
    );
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
    final novoAbastecimentoController = AbastecimentoController(
      AbastecimentoService(abastecimentoRepository, repository),
    );
    final novoPasseController = PassePlataformaController(
      PassePlataformaService(passeRepository, repository),
    );
    final novoBonusPromocaoController = BonusPromocaoController(
      BonusPromocaoService(bonusPromocaoRepository, repository),
    );

    setState(() {
      controller = novoController;
      leituraGanhosController = novoLeituraGanhosController;
      pausaController = novoPausaController;
      ganhoIndividualController = novoGanhoIndividualController;
      abastecimentoController = novoAbastecimentoController;
      passePlataformaController = novoPasseController;
      bonusPromocaoController = novoBonusPromocaoController;
    });

    await novoController.carregarJornadaAberta();
    await novoPausaController.carregar(novoController.jornadaAtual?.id);
    await novoLeituraGanhosController.carregarEstado(
      novoController.jornadaAtual?.id,
    );
    await novoGanhoIndividualController.carregar(
      novoController.jornadaAtual?.id,
    );
    await novoAbastecimentoController.carregar(
      novoController.jornadaAtual?.veiculoId ?? 1,
    );
    await novoPasseController.carregar();
    await novoBonusPromocaoController.carregar();
  }

  Future<void> _abrirPassesEBonus() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => PassesBonusPage(
          passeController: passePlataformaController!,
          bonusController: bonusPromocaoController!,
        ),
      ),
    );
  }

  Future<void> _registrarAbastecimento() async {
    final abastecimentoController = this.abastecimentoController;
    if (abastecimentoController == null) return;
    final veiculoId = controller?.jornadaAtual?.veiculoId ?? 1;
    final odometroInicial = await abastecimentoController.ultimoOdometro(
      veiculoId,
    );
    final ultimoAbastecimento = abastecimentoController.ultimo;
    if (!mounted) return;
    final resultado = await showDialog<RegistrarAbastecimentoResultado>(
      context: context,
      builder: (_) => RegistrarAbastecimentoDialog(
        odometroInicial: odometroInicial,
        cidadeInicial:
            controller?.jornadaAtual?.cidadeOrigem ??
            controller?.ultimaJornadaFinalizada?.cidadeDestino,
        tipoCombustivelInicial: ultimoAbastecimento?.tipoCombustivel,
      ),
    );
    if (!mounted || resultado == null) return;
    try {
      await abastecimentoController.registrar(
        veiculoId: veiculoId,
        odometro: resultado.odometro,
        tipoCombustivel: resultado.tipoCombustivel,
        volumeMililitros: resultado.volumeMililitros,
        valorTotalPagoCentavos: resultado.valorTotalPagoCentavos,
        tanqueCheio: resultado.tanqueCheio,
        dataHora: resultado.dataHora,
        precoBombaMilesimosRealPorLitro:
            resultado.precoBombaMilesimosRealPorLitro,
        cidade: resultado.cidade,
        nomePosto: resultado.nomePosto,
        bandeiraPosto: resultado.bandeiraPosto,
        observacao: resultado.observacao,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Abastecimento registrado.')),
      );
    } catch (error, stackTrace) {
      if (!mounted) return;
      _apresentarErro(
        operacao: 'registrar o abastecimento',
        error: error,
        stackTrace: stackTrace,
        mensagemPadrao: 'Não foi possível registrar o abastecimento.',
      );
    }
  }

  Future<void> _abrirManutencoes() async {
    final repository = ManutencaoRepository(ManutencaoDao(database));
    final odometros = AbastecimentoRepository(AbastecimentoDao(database));
    final manutencaoController = ManutencaoController(
      ManutencaoService(repository, odometros),
    );
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => ManutencoesPage(
          veiculoId: controller?.jornadaAtual?.veiculoId ?? 1,
          controller: manutencaoController,
        ),
      ),
    );
    manutencaoController.dispose();
    await abastecimentoController?.carregar(
      controller?.jornadaAtual?.veiculoId ?? 1,
    );
  }

  Future<void> _abrirDespesas() async {
    final despesasController = DespesaVeiculoController(
      DespesaVeiculoService(
        DespesaVeiculoRepository(DespesaVeiculoDao(database)),
      ),
    );
    final custosController = CustoRecorrenteController(
      CustoRecorrenteService(
        CustoRecorrenteRepository(CustoRecorrenteDao(database)),
      ),
    );
    final depreciacaoController = DepreciacaoVeiculoController(
      DepreciacaoVeiculoService(
        DepreciacaoVeiculoRepository(
          DepreciacaoVeiculoDao(database),
          AbastecimentoRepository(AbastecimentoDao(database)),
        ),
      ),
    );
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => DespesasPage(
          veiculoId: controller?.jornadaAtual?.veiculoId ?? 1,
          controller: despesasController,
          custoRecorrenteController: custosController,
          depreciacaoController: depreciacaoController,
        ),
      ),
    );
    despesasController.dispose();
    custosController.dispose();
    depreciacaoController.dispose();
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
        dataHora: resultado.dataHora,
      );
      await controller?.carregarResumoIntraday();
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

    final ultimoFato = await abastecimentoController?.ultimoOdometro(1);
    if (!mounted) return;
    final ultimoFim = controller.ultimaJornadaFinalizada?.odometroFim;
    final odometroSugerido =
        [
          ...?ultimoFim == null ? null : [ultimoFim],
          ...?ultimoFato == null ? null : [ultimoFato],
        ].fold<int?>(
          null,
          (maior, valor) => maior == null || valor > maior ? valor : maior,
        );
    final resultado = await showDialog<AbrirJornadaResultado>(
      context: context,
      builder: (context) => AbrirJornadaDialog(
        odometroInicial: odometroSugerido,
        odometroMinimo: odometroSugerido,
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
        dataHoraInicio: resultado.dataHoraInicio,
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

    final ultimoFato = await abastecimentoController?.ultimoOdometro(
      controller?.jornadaAtual?.veiculoId ?? 1,
    );
    if (!mounted) return;
    final minimoLocal = _ultimoOdometroConhecido();
    final minimo = ultimoFato != null && ultimoFato > minimoLocal
        ? ultimoFato
        : minimoLocal;
    final odometro = await showDialog<int>(
      context: context,
      builder: (_) =>
          OdometroPausaDialog(titulo: 'Iniciar Pausa', odometroMinimo: minimo),
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
      await controller?.carregarResumoIntraday();
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
      await controller?.carregarResumoIntraday();
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
    final ultimoFato = await abastecimentoController?.ultimoOdometro(
      controller?.jornadaAtual?.veiculoId ?? 1,
    );
    if (!mounted) return;
    final minimoLocal = pausa.odometroInicio ?? _ultimoOdometroConhecido();
    final minimo = ultimoFato != null && ultimoFato > minimoLocal
        ? ultimoFato
        : minimoLocal;
    final odometro = await showDialog<int>(
      context: context,
      builder: (_) => OdometroPausaDialog(
        titulo: 'Retomar Jornada',
        odometroMinimo: minimo,
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

  Future<void> _editarPausa(Pausa pausa) async {
    await showDialog<bool>(
      context: context,
      builder: (_) => EditarPausaDialog(
        pausa: pausa,
        onSalvar: (resultado) async {
          try {
            await pausaController?.editarPausa(
              pausa: pausa,
              inicio: resultado.inicio,
              odometroInicio: resultado.odometroInicio,
              fim: resultado.fim,
              odometroFim: resultado.odometroFim,
              titulo: resultado.titulo,
              observacao: resultado.observacao,
            );
          } catch (error, stackTrace) {
            debugPrint('Erro ao editar a Pausa: $error');
            debugPrintStack(stackTrace: stackTrace);
            rethrow;
          }
        },
      ),
    );
  }

  Future<void> _fecharJornada() async {
    final controller = this.controller;
    final jornada = controller?.jornadaAtual;

    if (controller == null || jornada == null) {
      return;
    }

    final odometroSugerido =
        await controller.sugerirOdometroFechamento() ?? jornada.odometroInicio;
    if (!mounted) return;

    final resultado = await showDialog<FecharJornadaResultado>(
      context: context,
      builder: (context) => FecharJornadaDialog(
        odometroInicio: odometroSugerido,
        dataHoraInicio: jornada.dataHoraInicio,
        cidadeDestinoInicial: jornada.cidadeOrigem,
      ),
    );

    if (!mounted || resultado == null) {
      return;
    }

    try {
      await controller.validarFechamento(
        dataHoraFim: resultado.dataHoraFim,
        odometroFim: resultado.odometroFim,
        cidadeDestino: resultado.cidadeDestino,
        observacoes: resultado.observacoes,
      );
    } catch (error, stackTrace) {
      if (!mounted) return;
      _apresentarErro(
        operacao: 'validar o fechamento da Jornada',
        error: error,
        stackTrace: stackTrace,
        mensagemPadrao: 'Não foi possível validar o fechamento da jornada.',
      );
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
        dataHoraFim: resultado.dataHoraFim,
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

  Future<void> _editarJornada(Jornada jornada) async {
    final controller = this.controller;
    if (controller == null) return;
    final resultado = await showDialog<EditarJornadaResultado>(
      context: context,
      builder: (_) => EditarJornadaDialog(jornada: jornada),
    );
    if (!mounted || resultado == null) return;
    try {
      await controller.editarJornada(
        jornada: jornada,
        dataHoraInicio: resultado.dataHoraInicio,
        odometroInicio: resultado.odometroInicio,
        cidadeOrigem: resultado.cidadeOrigem,
        dataHoraFim: resultado.dataHoraFim,
        odometroFim: resultado.odometroFim,
        cidadeDestino: resultado.cidadeDestino,
        observacoes: resultado.observacoes,
      );
      await pausaController?.carregar(controller.jornadaAtual?.id);
    } catch (error, stackTrace) {
      if (!mounted) return;
      _apresentarErro(
        operacao: 'editar a Jornada',
        error: error,
        stackTrace: stackTrace,
        mensagemPadrao: 'Não foi possível editar a Jornada.',
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
      'Existe',
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
    final abastecimentoController = this.abastecimentoController;
    final passePlataformaController = this.passePlataformaController;
    final bonusPromocaoController = this.bonusPromocaoController;

    if (controller == null ||
        leituraGanhosController == null ||
        pausaController == null ||
        ganhoIndividualController == null ||
        abastecimentoController == null ||
        passePlataformaController == null ||
        bonusPromocaoController == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Jornada')),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Tooltip(
            message: 'Despesas',
            excludeFromSemantics: true,
            child: Semantics(
              label: 'Despesas',
              button: true,
              child: FloatingActionButton(
                heroTag: 'despesas',
                onPressed: _abrirDespesas,
                child: const Icon(Icons.receipt_long_outlined),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Tooltip(
            message: 'Manutenções',
            excludeFromSemantics: true,
            child: Semantics(
              label: 'Manutenções',
              button: true,
              child: FloatingActionButton(
                heroTag: 'manutencoes',
                onPressed: _abrirManutencoes,
                child: const Icon(Icons.build_outlined),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Tooltip(
            message: 'Passes e bônus',
            excludeFromSemantics: true,
            child: Semantics(
              label: 'Passes e bônus',
              button: true,
              child: FloatingActionButton(
                heroTag: 'passes_bonus',
                onPressed:
                    passePlataformaController.plataformas.isEmpty &&
                        bonusPromocaoController.plataformas.isEmpty
                    ? null
                    : _abrirPassesEBonus,
                child: const Icon(Icons.confirmation_number_outlined),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Tooltip(
            message: 'Abastecimento',
            excludeFromSemantics: true,
            child: Semantics(
              label: 'Abastecimento',
              button: true,
              child: FloatingActionButton(
                heroTag: 'abastecimento',
                onPressed: abastecimentoController.carregando
                    ? null
                    : _registrarAbastecimento,
                child: const Icon(Icons.local_gas_station),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        key: const ValueKey('jornada_safe_area'),
        bottom: false,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            controller,
            pausaController,
            leituraGanhosController,
            ganhoIndividualController,
            abastecimentoController,
            passePlataformaController,
            bonusPromocaoController,
          ]),
          builder: (context, _) {
            if (controller.carregando ||
                pausaController.carregando ||
                leituraGanhosController.carregando ||
                ganhoIndividualController.carregando ||
                abastecimentoController.carregando ||
                passePlataformaController.carregando ||
                bonusPromocaoController.carregando) {
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
                padding: EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  16 + MediaQuery.viewPaddingOf(context).bottom,
                ),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Status: ${jornada.status.name.toUpperCase()}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Editar Jornada',
                        onPressed: () => _editarJornada(jornada),
                        icon: const Icon(Icons.edit),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _LinhaTabulada(
                    rotulo: 'Status',
                    valor: jornada.status.name.toUpperCase(),
                    destaque: true,
                  ),
                  _LinhaTabulada(rotulo: 'Início', valor: inicioFormatado),
                  _LinhaTabulada(
                    rotulo: 'Odômetro inicial',
                    valor: '$odometroFormatado km',
                  ),
                  _LinhaTabulada(
                    rotulo: 'Cidade de origem',
                    valor: jornada.cidadeOrigem,
                  ),

                  if (abastecimentoController.inteligencia?.possuiDados ==
                      true) ...[
                    const SizedBox(height: 24),
                    ResumoInteligenciaAbastecimentoCard(
                      resumo: abastecimentoController.inteligencia!,
                      locale: locale,
                    ),
                  ],

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

                  if (controller.resumoIntraday != null) ...[
                    const SizedBox(height: 24),
                    _ResumoIntradayCard(
                      resumo: controller.resumoIntraday!,
                      locale: locale,
                      formatarDuracao: _formatarDuracao,
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
                            tooltip: 'Editar Pausa',
                            onPressed: () => _editarPausa(pausaAberta),
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
                          onEditar: _editarPausa,
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
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.viewPaddingOf(context).bottom,
                ),
                child: Center(
                  child: ElevatedButton(
                    onPressed: _abrirJornada,
                    child: const Text('Abrir Jornada'),
                  ),
                ),
              );
            }

            final locale = View.of(
              context,
            ).platformDispatcher.locale.toLanguageTag();
            final numeros = NumberFormat.decimalPattern(locale);

            return ListView(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                16 + MediaQuery.viewPaddingOf(context).bottom,
              ),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Jornada concluída',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Editar Jornada',
                      onPressed: () => _editarJornada(ultimaJornada),
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _formatarLocalizacao(
                    ultimaJornada.cidadeOrigem,
                    ultimaJornada.cidadeDestino,
                  ),
                ),
                if (abastecimentoController.inteligencia?.possuiDados ==
                    true) ...[
                  const SizedBox(height: 16),
                  ResumoInteligenciaAbastecimentoCard(
                    resumo: abastecimentoController.inteligencia!,
                    locale: locale,
                  ),
                ],
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
      ),
    );
  }

  @override
  void dispose() {
    atualizadorDuracao?.cancel();
    leituraGanhosController?.dispose();
    pausaController?.dispose();
    ganhoIndividualController?.dispose();
    abastecimentoController?.dispose();
    passePlataformaController?.dispose();
    bonusPromocaoController?.dispose();
    controller?.dispose();
    database.close();
    super.dispose();
  }
}

class ResumoInteligenciaAbastecimentoCard extends StatelessWidget {
  final ResumoInteligenciaAbastecimento resumo;
  final String locale;

  const ResumoInteligenciaAbastecimentoCard({
    super.key,
    required this.resumo,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final decimal = NumberFormat.decimalPattern(locale)
      ..minimumFractionDigits = 1
      ..maximumFractionDigits = 2;
    final inteiros = NumberFormat.decimalPattern(locale);
    final cicloRecente = resumo.ciclosRecentes.isEmpty
        ? null
        : resumo.ciclosRecentes.first;
    final referencia = resumo.odometroReferenciaAbastecimento;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Consumo recente',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              cicloRecente == null
                  ? '—'
                  : '${decimal.format(cicloRecente.kmPorLitro)} km/L',
            ),
            Text(
              'Média recente: ${resumo.mediaKmPorLitro == null ? '—' : '${decimal.format(resumo.mediaKmPorLitro)} km/L'} '
              '(${resumo.ciclosRecentes.length} ${resumo.ciclosRecentes.length == 1 ? 'ciclo' : 'ciclos'})',
            ),
            Text(
              'Referência conservadora de consumo: '
              '${resumo.kmPorLitroConservador == null ? '—' : '${decimal.format(resumo.kmPorLitroConservador)} km/L'}',
            ),
            Text(
              'Autonomia estimada de tanque cheio: '
              '${resumo.autonomiaConservadoraTanqueCheioKm == null ? '—' : '~${inteiros.format(resumo.autonomiaConservadoraTanqueCheioKm!.round())} km'}',
            ),
            if (referencia != null)
              if (resumo.referenciaAtingida) ...[
                const Text('Referência para abastecer atingida'),
                Text('Referência: ~${inteiros.format(referencia)} km'),
              ] else ...[
                Text(
                  'Referência para abastecer: '
                  '~${inteiros.format(referencia)} km',
                ),
                if (resumo.distanciaAteReferenciaKm != null)
                  Text(
                    'Faltam aproximadamente '
                    '${inteiros.format(resumo.distanciaAteReferenciaKm)} km '
                    'até a referência comportamental.',
                  ),
                if (resumo.diasOperacaoAteReferencia != null)
                  Text(
                    'Aproximadamente '
                    '${decimal.format(resumo.diasOperacaoAteReferencia)} '
                    'dias de operação.',
                  ),
              ]
            else
              const Text('Referência para abastecer: —'),
            if (resumo.ciclosRecentes.any((ciclo) => ciclo.potencialmenteMisto))
              const Text(
                'Há ciclo com abastecimento parcial; o consumo físico é '
                'válido, mas não pertence exclusivamente a um único posto.',
              ),
          ],
        ),
      ),
    );
  }
}

class _LinhaTabulada extends StatelessWidget {
  final String rotulo;
  final String valor;
  final bool destaque;
  final bool alternarZebra;

  const _LinhaTabulada({
    required this.rotulo,
    required this.valor,
    this.destaque = false,
    this.alternarZebra = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: alternarZebra
          ? Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(90)
          : null,
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              rotulo,
              style: destaque
                  ? const TextStyle(fontWeight: FontWeight.w700)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              valor,
              textAlign: TextAlign.right,
              style: destaque
                  ? const TextStyle(fontWeight: FontWeight.w700)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResumoIntradayCard extends StatelessWidget {
  final ResumoIntradayJornada resumo;
  final String locale;
  final String Function(Duration, NumberFormat) formatarDuracao;

  const _ResumoIntradayCard({
    required this.resumo,
    required this.locale,
    required this.formatarDuracao,
  });

  @override
  Widget build(BuildContext context) {
    final moeda = NumberFormat.currency(
      locale: locale,
      symbol: r'R$',
      decimalDigits: 2,
    );
    final numeros = NumberFormat.decimalPattern(locale);
    final hora = DateFormat.Hm(locale).format(resumo.dataHoraReferencia);
    String dinheiro(int? centavos) =>
        centavos == null ? '—' : moeda.format(centavos / 100);
    String decimal(double? valor) => valor == null ? '—' : moeda.format(valor);

    final titulo = resumo.possuiCheckpointReal
        ? 'Jornada até $hora'
        : 'Jornada iniciada às $hora';
    return Card(
      key: const ValueKey('resumo_intraday'),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _LinhaTabulada(
              alternarZebra: true,
              rotulo: 'Tempo ativo',
              valor: formatarDuracao(resumo.tempoAtivo, numeros),
              destaque: true,
            ),
            _LinhaTabulada(
              alternarZebra: true,
              rotulo: 'Distância',
              valor: resumo.quilometros == null
                  ? '—'
                  : '${numeros.format(resumo.quilometros)} km',
              destaque: true,
            ),
            _LinhaTabulada(
              alternarZebra: true,
              rotulo: 'Faturamento',
              valor: dinheiro(resumo.receitaTotalCentavos),
              destaque: true,
            ),
            _LinhaTabulada(
              alternarZebra: true,
              rotulo: 'R\$/hora ativa',
              valor: decimal(resumo.receitaPorHoraAtiva),
              destaque: true,
            ),
            _LinhaTabulada(
              alternarZebra: true,
              rotulo: 'R\$/km',
              valor: decimal(resumo.receitaPorKm),
              destaque: true,
            ),
            _LinhaTabulada(
              alternarZebra: true,
              rotulo: 'Tempo da Jornada',
              valor: formatarDuracao(resumo.duracaoTotal, numeros),
            ),
            _LinhaTabulada(
              alternarZebra: true,
              rotulo: 'Em pausa',
              valor: formatarDuracao(resumo.tempoPausa, numeros),
            ),
            _LinhaTabulada(
              alternarZebra: true,
              rotulo: 'Viagens',
              valor: resumo.quantidadeTotalViagens == null
                  ? '—'
                  : numeros.format(resumo.quantidadeTotalViagens),
            ),
            _LinhaTabulada(
              alternarZebra: true,
              rotulo: 'Ticket médio',
              valor: decimal(resumo.ticketMedio),
            ),
            _LinhaTabulada(
              alternarZebra: true,
              rotulo: 'Passes',
              valor: dinheiro(resumo.custoPassesCentavos),
            ),
            _LinhaTabulada(
              alternarZebra: true,
              rotulo: 'Bônus/promoções',
              valor: dinheiro(resumo.bonusPromocoesCentavos),
            ),
            _LinhaTabulada(
              alternarZebra: true,
              rotulo: 'Resultado operacional',
              valor: dinheiro(resumo.resultadoOperacionalCentavos),
            ),
            if (resumo.resultadosPlataformas.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Por plataforma',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              for (final resultado in resumo.resultadosPlataformas) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 2),
                  child: Text(
                    resultado.nome,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                _LinhaTabulada(
                  alternarZebra: true,
                  rotulo: 'Faturamento',
                  valor: dinheiro(resultado.receitaCentavos),
                ),
                _LinhaTabulada(
                  alternarZebra: true,
                  rotulo: 'Viagens',
                  valor: resultado.quantidadeViagens == null
                      ? '—'
                      : numeros.format(resultado.quantidadeViagens),
                ),
                _LinhaTabulada(
                  alternarZebra: true,
                  rotulo: 'Ticket médio',
                  valor: decimal(resultado.ticketMedio),
                ),
                _LinhaTabulada(
                  alternarZebra: true,
                  rotulo: 'Passes',
                  valor: dinheiro(resultado.custoPassesCentavos),
                ),
                _LinhaTabulada(
                  alternarZebra: true,
                  rotulo: 'Bônus',
                  valor: dinheiro(resultado.bonusPromocoesCentavos),
                ),
                _LinhaTabulada(
                  alternarZebra: true,
                  rotulo: 'Resultado operacional',
                  valor: dinheiro(resultado.resultadoOperacionalCentavos),
                ),
              ],
            ],
            if (!resumo.possuiCheckpointReal)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('Aguardando primeira atualização.'),
              ),
          ],
        ),
      ),
    );
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Resultado financeiro incompleto'),
              const Text('Ticket médio geral: —'),
            ],
          ),
        const SizedBox(height: 12),
        for (final resultado in resumo.resultadosPlataformas)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: resultado.calculavel
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${resultado.nome}: '
                        '${moeda.format(resultado.receitaCentavos! / 100)} em viagens · '
                        '${resultado.quantidadeViagens} '
                        '${resultado.quantidadeViagens == 1 ? 'viagem' : 'viagens'} · '
                        'Ticket médio: '
                        '${resultado.ticketMedio == null ? '—' : moeda.format(resultado.ticketMedio)}',
                      ),
                      Text(
                        'Bônus/promoções: '
                        '${moeda.format(resultado.bonusPromocoesCentavos / 100)} · '
                        'Passes: ${moeda.format(resultado.custoPassesCentavos / 100)} · '
                        'Resultado operacional: '
                        '${moeda.format(resultado.resultadoOperacionalCentavos! / 100)}',
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${resultado.nome}: Revisão necessária · '
                        'Ticket médio: —',
                      ),
                      Text(
                        'Bônus/promoções: '
                        '${moeda.format(resultado.bonusPromocoesCentavos / 100)} · '
                        'Passes: ${moeda.format(resultado.custoPassesCentavos / 100)} · '
                        'Resultado operacional: —',
                      ),
                    ],
                  ),
          ),
        const SizedBox(height: 12),
        if (resumo.passes.isNotEmpty) ...[
          Text(
            'Passes registrados',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          for (final item in resumo.passes)
            Text(
              '${item.plataforma.nome}: '
              '${moeda.format(item.passe.valorPagoCentavos / 100)}',
            ),
          Text(
            'Custo total de passes: '
            '${moeda.format(resumo.custoPassesCentavos / 100)}',
          ),
          const SizedBox(height: 12),
        ],
        if (resumo.bonusPromocoes.isNotEmpty) ...[
          Text(
            'Bônus/promoções registrados',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          for (final item in resumo.bonusPromocoes)
            Text(
              '${item.plataforma.nome}: '
              '${moeda.format(item.bonusPromocao.valorCentavos / 100)}',
            ),
          Text(
            'Total de bônus/promoções: '
            '${moeda.format(resumo.bonusPromocoesCentavos / 100)}',
          ),
          const SizedBox(height: 12),
        ],
        Text(
          'Resultado operacional da Jornada: '
          '${resumo.resultadoOperacionalCentavos == null ? '—' : moeda.format(resumo.resultadoOperacionalCentavos! / 100)}',
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
        tooltip: 'Editar Pausa',
        onPressed: () => onEditar(pausa),
        icon: const Icon(Icons.edit),
      ),
    );
  }
}
