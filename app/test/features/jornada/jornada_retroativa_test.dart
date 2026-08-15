import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:km_rodado/core/constants/enums/status_jornada.dart';
import 'package:km_rodado/core/constants/enums/tipo_combustivel.dart';
import 'package:km_rodado/core/constants/enums/tipo_bonus_promocao.dart';
import 'package:km_rodado/core/constants/enums/tipo_leitura_ganhos.dart';
import 'package:km_rodado/core/constants/enums/tipo_registro_ganhos.dart';
import 'package:km_rodado/core/database/app_database.dart';
import 'package:km_rodado/core/database/daos/abastecimento_dao.dart';
import 'package:km_rodado/core/database/daos/bonus_promocao_dao.dart';
import 'package:km_rodado/core/database/daos/ganho_individual_dao.dart';
import 'package:km_rodado/core/database/daos/jornada_dao.dart';
import 'package:km_rodado/core/database/daos/leitura_ganhos_dao.dart';
import 'package:km_rodado/core/database/daos/passe_plataforma_dao.dart';
import 'package:km_rodado/core/database/daos/pausa_dao.dart';
import 'package:km_rodado/core/database/seeds/seed.dart';
import 'package:km_rodado/features/abastecimento/data/abastecimento_repository.dart';
import 'package:km_rodado/features/bonus_promocao/data/bonus_promocao_repository.dart';
import 'package:km_rodado/features/ganho_individual/data/ganho_individual_repository.dart';
import 'package:km_rodado/features/jornada/data/jornada_repository.dart';
import 'package:km_rodado/features/jornada/data/jornada_service.dart';
import 'package:km_rodado/features/leitura_ganhos/data/leitura_ganhos_repository.dart';
import 'package:km_rodado/features/passe_plataforma/data/passe_plataforma_repository.dart';
import 'package:km_rodado/features/pausa/data/pausa_repository.dart';

void main() {
  late AppDatabase database;
  late JornadaService service;
  late JornadaRepository jornadaRepository;
  final agora = DateTime(2026, 8, 15, 22);

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await garantirDadosTemporarios(database);
    jornadaRepository = JornadaRepository(JornadaDao(database));
    service = JornadaService(
      jornadaRepository,
      PausaRepository(PausaDao(database)),
      LeituraGanhosRepository(LeituraGanhosDao(database)),
      GanhoIndividualRepository(GanhoIndividualDao(database)),
      PassePlataformaRepository(PassePlataformaDao(database)),
      BonusPromocaoRepository(BonusPromocaoDao(database)),
      AbastecimentoRepository(AbastecimentoDao(database)),
      () => agora,
    );
  });

  tearDown(() => database.close());

  Future<int> inserirJornada({
    required DateTime inicio,
    DateTime? fim,
    int odometroInicio = 1000,
    int? odometroFim,
  }) => database
      .into(database.jornadas)
      .insert(
        JornadasCompanion.insert(
          usuarioId: 1,
          veiculoId: 1,
          dataHoraInicio: inicio,
          dataHoraFim: Value(fim),
          odometroInicio: odometroInicio,
          odometroFim: Value(odometroFim),
          cidadeOrigem: 'Curitiba',
          cidadeDestino: const Value('Curitiba'),
          status: fim == null ? StatusJornada.aberta : StatusJornada.finalizada,
          quilometrosPercorridos: Value(
            odometroFim == null ? null : odometroFim - odometroInicio,
          ),
        ),
      );

  test(
    'abertura normal usa agora e tardia preserva instante escolhido',
    () async {
      final normal = await service.abrirJornada(
        usuarioId: 1,
        veiculoId: 1,
        odometro: 1000,
        cidadeOrigem: 'Curitiba',
      );
      expect(
        (await jornadaRepository.buscarPorId(normal))!.dataHoraInicio,
        agora,
      );
      await database.delete(database.jornadas).go();

      final inicio = DateTime(2026, 8, 15, 12, 30);
      final tardia = await service.abrirJornada(
        usuarioId: 1,
        veiculoId: 1,
        odometro: 1000,
        cidadeOrigem: 'Curitiba',
        dataHoraInicio: inicio,
      );
      expect(
        (await jornadaRepository.buscarPorId(tardia))!.dataHoraInicio,
        inicio,
      );
    },
  );

  test('abertura futura e sobreposição são rejeitadas', () async {
    await expectLater(
      service.abrirJornada(
        usuarioId: 1,
        veiculoId: 1,
        odometro: 1000,
        cidadeOrigem: 'Curitiba',
        dataHoraInicio: agora.add(const Duration(minutes: 1)),
      ),
      throwsA(isA<Exception>()),
    );
    await inserirJornada(
      inicio: DateTime(2026, 8, 15, 8),
      fim: DateTime(2026, 8, 15, 12),
      odometroFim: 1100,
    );
    await expectLater(
      service.abrirJornada(
        usuarioId: 1,
        veiculoId: 1,
        odometro: 1100,
        cidadeOrigem: 'Curitiba',
        dataHoraInicio: DateTime(2026, 8, 15, 11),
      ),
      throwsA(predicate((error) => '$error'.contains('sobrepor'))),
    );
  });

  test(
    'edição usa vizinhos por horário e aceita igualdade nos limites',
    () async {
      await inserirJornada(
        inicio: DateTime(2026, 8, 15, 16),
        fim: DateTime(2026, 8, 15, 18),
        odometroInicio: 1200,
        odometroFim: 1300,
      );
      final atual = await inserirJornada(
        inicio: DateTime(2026, 8, 15, 12),
        fim: DateTime(2026, 8, 15, 14),
        odometroInicio: 1100,
        odometroFim: 1200,
      );
      await inserirJornada(
        inicio: DateTime(2026, 8, 15, 8),
        fim: DateTime(2026, 8, 15, 10),
        odometroInicio: 1000,
        odometroFim: 1100,
      );
      await service.editarJornada(
        jornadaId: atual,
        dataHoraInicio: DateTime(2026, 8, 15, 10),
        odometroInicio: 1100,
        cidadeOrigem: 'Curitiba',
        dataHoraFim: DateTime(2026, 8, 15, 16),
        odometroFim: 1200,
        cidadeDestino: 'Curitiba',
      );
      final salva = await jornadaRepository.buscarPorId(atual);
      expect(salva!.dataHoraInicio, DateTime(2026, 8, 15, 10));
      expect(salva.dataHoraFim, DateTime(2026, 8, 15, 16));
    },
  );

  test(
    'sobreposição com Jornada posterior não persiste parcialmente',
    () async {
      final atual = await inserirJornada(
        inicio: DateTime(2026, 8, 15, 8),
        fim: DateTime(2026, 8, 15, 12),
        odometroFim: 1100,
      );
      await inserirJornada(
        inicio: DateTime(2026, 8, 15, 13),
        fim: DateTime(2026, 8, 15, 18),
        odometroInicio: 1100,
        odometroFim: 1200,
      );
      await expectLater(
        service.editarJornada(
          jornadaId: atual,
          dataHoraInicio: DateTime(2026, 8, 15, 8),
          odometroInicio: 1000,
          cidadeOrigem: 'Alterada',
          dataHoraFim: DateTime(2026, 8, 15, 14),
          odometroFim: 1100,
        ),
        throwsA(predicate((error) => '$error'.contains('sobrepor'))),
      );
      expect(
        (await jornadaRepository.buscarPorId(atual))!.cidadeOrigem,
        'Curitiba',
      );
    },
  );

  test('Pausa e Abastecimento limitam horário e odômetro', () async {
    final id = await inserirJornada(
      inicio: DateTime(2026, 8, 15, 8),
      fim: DateTime(2026, 8, 15, 18),
      odometroFim: 1200,
    );
    await database
        .into(database.pausas)
        .insert(
          PausasCompanion.insert(
            jornadaId: id,
            inicio: DateTime(2026, 8, 15, 15),
            fim: Value(DateTime(2026, 8, 15, 16)),
            odometroInicio: const Value(1150),
            odometroFim: const Value(1150),
          ),
        );
    await database
        .into(database.abastecimentos)
        .insert(
          AbastecimentosCompanion.insert(
            veiculoId: 1,
            jornadaId: Value(id),
            dataHora: DateTime(2026, 8, 15, 17),
            odometro: 1180,
            tipoCombustivel: TipoCombustivel.gasolina,
            volumeMililitros: 1000,
            valorTotalPagoCentavos: 500,
          ),
        );
    await expectLater(
      service.editarJornada(
        jornadaId: id,
        dataHoraInicio: DateTime(2026, 8, 15, 8),
        odometroInicio: 1000,
        cidadeOrigem: 'Curitiba',
        dataHoraFim: DateTime(2026, 8, 15, 14),
        odometroFim: 1200,
      ),
      throwsA(isA<Exception>()),
    );
    await expectLater(
      service.editarJornada(
        jornadaId: id,
        dataHoraInicio: DateTime(2026, 8, 15, 8),
        odometroInicio: 1000,
        cidadeOrigem: 'Curitiba',
        dataHoraFim: DateTime(2026, 8, 15, 18),
        odometroFim: 1140,
      ),
      throwsA(predicate((error) => '$error'.contains('odômetro final'))),
    );
  });

  test('ganho individual técnico posterior não limita a Jornada', () async {
    final id = await inserirJornada(
      inicio: DateTime(2026, 8, 15, 8),
      fim: DateTime(2026, 8, 15, 18),
      odometroFim: 1100,
    );
    final plataformaId = await database
        .into(database.plataformas)
        .insert(
          PlataformasCompanion.insert(
            nome: 'Particular',
            tipoRegistroGanhos: TipoRegistroGanhos.individual,
          ),
        );
    await database
        .into(database.lancamentosGanhoIndividual)
        .insert(
          LancamentosGanhoIndividualCompanion.insert(
            plataformaId: plataformaId,
            jornadaId: Value(id),
            quantidadeViagens: 1,
            valorTotalCentavos: 4000,
            dataCriacao: Value(DateTime(2026, 8, 15, 21)),
          ),
        );
    await service.editarJornada(
      jornadaId: id,
      dataHoraInicio: DateTime(2026, 8, 15, 8),
      odometroInicio: 1000,
      cidadeOrigem: 'Curitiba',
      dataHoraFim: DateTime(2026, 8, 15, 18),
      odometroFim: 1100,
      cidadeDestino: 'Curitiba',
    );
    final lancamentos = await database
        .select(database.lancamentosGanhoIndividual)
        .get();
    expect(lancamentos.single.jornadaId, id);
    expect(lancamentos.single.dataCriacao, DateTime(2026, 8, 15, 21));
  });

  test('Leituras são limites e seus snapshots permanecem intactos', () async {
    final id = await inserirJornada(
      inicio: DateTime(2026, 8, 15, 8),
      fim: DateTime(2026, 8, 15, 18),
      odometroFim: 1100,
    );
    final plataformaId = await database
        .into(database.plataformas)
        .insert(
          PlataformasCompanion.insert(
            nome: 'Uber',
            tipoRegistroGanhos: TipoRegistroGanhos.acumulado,
          ),
        );
    final leituraId = await database
        .into(database.leiturasGanhos)
        .insert(
          LeiturasGanhosCompanion.insert(
            jornadaId: id,
            dataHora: DateTime(2026, 8, 15, 8),
            tipo: TipoLeituraGanhos.inicial,
          ),
        );
    await database
        .into(database.leiturasGanhoPlataforma)
        .insert(
          LeiturasGanhoPlataformaCompanion.insert(
            leituraGanhosId: leituraId,
            plataformaId: plataformaId,
            valorAcumuladoCentavos: 800,
            quantidadeViagensAcumulada: 2,
          ),
        );
    await service.editarJornada(
      jornadaId: id,
      dataHoraInicio: DateTime(2026, 8, 15, 8),
      odometroInicio: 1000,
      cidadeOrigem: 'Ponta Grossa',
      dataHoraFim: DateTime(2026, 8, 15, 18),
      odometroFim: 1100,
    );
    final item = await database
        .select(database.leiturasGanhoPlataforma)
        .getSingle();
    expect(item.valorAcumuladoCentavos, 800);
    expect(item.quantidadeViagensAcumulada, 2);
    expect(await database.select(database.leiturasGanhos).get(), hasLength(1));
    await expectLater(
      service.editarJornada(
        jornadaId: id,
        dataHoraInicio: DateTime(2026, 8, 15, 8, 1),
        odometroInicio: 1000,
        cidadeOrigem: 'Ponta Grossa',
        dataHoraFim: DateTime(2026, 8, 15, 18),
        odometroFim: 1100,
      ),
      throwsA(predicate((error) => '$error'.contains('Leitura'))),
    );
  });

  test(
    'Passes e Bônus operacionais são preservados e limitam intervalo',
    () async {
      final id = await inserirJornada(
        inicio: DateTime(2026, 8, 15, 8),
        fim: DateTime(2026, 8, 15, 18),
        odometroFim: 1100,
      );
      final plataformaId = await database
          .into(database.plataformas)
          .insert(
            PlataformasCompanion.insert(
              nome: '99',
              tipoRegistroGanhos: TipoRegistroGanhos.acumulado,
            ),
          );
      await database
          .into(database.passesPlataforma)
          .insert(
            PassesPlataformaCompanion.insert(
              plataformaId: plataformaId,
              jornadaId: Value(id),
              dataHora: DateTime(2026, 8, 15, 9),
              valorPagoCentavos: 1698,
            ),
          );
      await database
          .into(database.bonusPromocoes)
          .insert(
            BonusPromocoesCompanion.insert(
              plataformaId: plataformaId,
              jornadaId: Value(id),
              dataHora: DateTime(2026, 8, 15, 17),
              valorCentavos: 800,
              tipo: TipoBonusPromocao.bonus,
            ),
          );
      await service.editarJornada(
        jornadaId: id,
        dataHoraInicio: DateTime(2026, 8, 15, 9),
        odometroInicio: 1000,
        cidadeOrigem: 'Curitiba',
        dataHoraFim: DateTime(2026, 8, 15, 17),
        odometroFim: 1100,
      );
      expect(
        await database.select(database.passesPlataforma).get(),
        hasLength(1),
      );
      expect(
        await database.select(database.bonusPromocoes).get(),
        hasLength(1),
      );
      await expectLater(
        service.editarJornada(
          jornadaId: id,
          dataHoraInicio: DateTime(2026, 8, 15, 9, 1),
          odometroInicio: 1000,
          cidadeOrigem: 'Curitiba',
          dataHoraFim: DateTime(2026, 8, 15, 17),
          odometroFim: 1100,
        ),
        throwsA(predicate((error) => '$error'.contains('Passe'))),
      );
    },
  );

  test(
    'Jornada aberta editada permanece aberta e persiste ao recriar service',
    () async {
      final id = await inserirJornada(inicio: DateTime(2026, 8, 15, 8));
      await service.editarJornada(
        jornadaId: id,
        dataHoraInicio: DateTime(2026, 8, 15, 7, 30),
        odometroInicio: 990,
        cidadeOrigem: ' Ponta Grossa ',
        observacoes: ' corrigida ',
      );
      final novoService = JornadaService(
        jornadaRepository,
        PausaRepository(PausaDao(database)),
        null,
        null,
        null,
        null,
        AbastecimentoRepository(AbastecimentoDao(database)),
        () => agora,
      );
      final salva = await novoService.jornadaAberta();
      expect(salva!.status, StatusJornada.aberta);
      expect(salva.dataHoraFim, null);
      expect(salva.cidadeOrigem, 'Ponta Grossa');
      expect(salva.observacoes, 'corrigida');
    },
  );
}
