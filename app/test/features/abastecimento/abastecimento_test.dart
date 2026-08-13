import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:km_rodado/core/constants/enums/status_jornada.dart';
import 'package:km_rodado/core/constants/enums/tipo_combustivel.dart';
import 'package:km_rodado/core/database/app_database.dart';
import 'package:km_rodado/core/database/daos/abastecimento_dao.dart';
import 'package:km_rodado/core/database/daos/jornada_dao.dart';
import 'package:km_rodado/core/database/seeds/seed.dart';
import 'package:km_rodado/features/abastecimento/data/abastecimento_repository.dart';
import 'package:km_rodado/features/abastecimento/data/abastecimento_service.dart';
import 'package:km_rodado/features/abastecimento/presentation/widgets/registrar_abastecimento_dialog.dart';
import 'package:km_rodado/features/jornada/data/jornada_repository.dart';

void main() {
  late AppDatabase database;
  late AbastecimentoService service;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await garantirDadosTemporarios(database);
    service = AbastecimentoService(
      AbastecimentoRepository(AbastecimentoDao(database)),
      JornadaRepository(JornadaDao(database)),
      agora: () => DateTime(2026, 8, 13, 10),
    );
  });

  tearDown(() => database.close());

  Future<void> registrar({
    int odometro = 100,
    bool cheio = true,
    DateTime? dataHora,
  }) => service.registrar(
    veiculoId: 1,
    odometro: odometro,
    tipoCombustivel: TipoCombustivel.gasolina,
    volumeMililitros: 31800,
    valorTotalPagoCentavos: 19000,
    tanqueCheio: cheio,
    dataHora: dataHora ?? DateTime(2026, 8, 13, 10),
    precoBombaMilesimosRealPorLitro: 6299,
    cidade: '  Curitiba  ',
    nomePosto: '  Posto Centro  ',
    observacao: '   ',
  );

  test('persiste inteiros, opcionais normalizados e tanque parcial', () async {
    await registrar(cheio: false);
    final item = (await database.select(database.abastecimentos).get()).single;
    expect(item.volumeMililitros, 31800);
    expect(item.valorTotalPagoCentavos, 19000);
    expect(item.precoBombaMilesimosRealPorLitro, 6299);
    expect(item.tanqueCheio, isFalse);
    expect(item.cidade, 'Curitiba');
    expect(item.nomePosto, 'Posto Centro');
    expect(item.observacao, isNull);
    expect(item.jornadaId, isNull);
  });

  test('aceita tanque cheio, preço de bomba opcional e promoção', () async {
    await service.registrar(
      veiculoId: 1,
      odometro: 100,
      tipoCombustivel: TipoCombustivel.etanol,
      volumeMililitros: 10000,
      valorTotalPagoCentavos: 5000,
      tanqueCheio: true,
      dataHora: DateTime(2026, 8, 13, 10),
      bandeiraPosto: '  Bandeira  ',
    );
    final semPreco =
        (await database.select(database.abastecimentos).get()).single;
    expect(semPreco.tanqueCheio, isTrue);
    expect(semPreco.precoBombaMilesimosRealPorLitro, isNull);
    expect(semPreco.bandeiraPosto, 'Bandeira');

    await service.registrar(
      veiculoId: 1,
      odometro: 100,
      tipoCombustivel: TipoCombustivel.etanol,
      volumeMililitros: 10000,
      valorTotalPagoCentavos: 5000,
      precoBombaMilesimosRealPorLitro: 6000,
      tanqueCheio: true,
      dataHora: DateTime(2026, 8, 13, 10),
    );
    final promocional = await service.ultimoAbastecimento(1);
    expect(promocional?.valorTotalPagoCentavos, 5000);
    expect(promocional?.precoBombaMilesimosRealPorLitro, 6000);
    expect(
      AbastecimentoService.calcularPrecoEfetivoMilesimos(
        valorTotalCentavos: promocional!.valorTotalPagoCentavos,
        volumeMililitros: promocional.volumeMililitros,
      ),
      5000,
    );
  });

  test('associa automaticamente à Jornada aberta', () async {
    final jornadaId = await database
        .into(database.jornadas)
        .insert(
          JornadasCompanion.insert(
            usuarioId: 1,
            veiculoId: 1,
            dataHoraInicio: DateTime(2026, 8, 13, 8),
            odometroInicio: 100,
            cidadeOrigem: 'Curitiba',
            status: StatusJornada.aberta,
          ),
        );
    await registrar(odometro: 120);
    expect(
      (await database.select(database.abastecimentos).get()).single.jornadaId,
      jornadaId,
    );
  });

  test('aceita progressão atual e igualdade do odômetro', () async {
    await registrar(odometro: 200, dataHora: DateTime(2026, 8, 13, 9));
    await registrar(odometro: 201, dataHora: DateTime(2026, 8, 13, 10));
    await registrar(odometro: 201, dataHora: DateTime(2026, 8, 13, 11));
    expect(await database.select(database.abastecimentos).get(), hasLength(3));
  });

  test('aceita lançamento retroativo cronologicamente válido', () async {
    await registrar(odometro: 300, dataHora: DateTime(2026, 8, 13, 12));
    await registrar(odometro: 200, dataHora: DateTime(2026, 8, 13, 9));
    expect(await database.select(database.abastecimentos).get(), hasLength(2));
  });

  test('rejeita lançamento retroativo cronologicamente impossível', () async {
    await registrar(odometro: 200, dataHora: DateTime(2026, 8, 13, 9));
    await registrar(odometro: 300, dataHora: DateTime(2026, 8, 13, 12));
    await expectLater(
      registrar(odometro: 301, dataHora: DateTime(2026, 8, 13, 10)),
      throwsException,
    );
    await expectLater(
      registrar(odometro: 199, dataHora: DateTime(2026, 8, 13, 10)),
      throwsException,
    );
  });

  test('persiste data operacional diferente da criação', () async {
    final operacional = DateTime(2026, 8, 12, 18, 30);
    await registrar(dataHora: operacional);
    final item = (await database.select(database.abastecimentos).get()).single;
    expect(item.dataHora, operacional);
    expect(item.dataCriacao, DateTime(2026, 8, 13, 10));
  });

  test('valida volume e valores negativos', () async {
    await expectLater(
      service.registrar(
        veiculoId: 1,
        odometro: 100,
        tipoCombustivel: TipoCombustivel.etanol,
        volumeMililitros: 0,
        valorTotalPagoCentavos: 1,
        tanqueCheio: true,
        dataHora: DateTime(2026, 8, 13, 10),
      ),
      throwsException,
    );
    await expectLater(
      service.registrar(
        veiculoId: 1,
        odometro: 100,
        tipoCombustivel: TipoCombustivel.etanol,
        volumeMililitros: 1,
        valorTotalPagoCentavos: -1,
        tanqueCheio: true,
        dataHora: DateTime(2026, 8, 13, 10),
      ),
      throwsException,
    );
  });

  test('calcula auxiliares e preço efetivo somente com inteiros', () {
    expect(
      AbastecimentoService.calcularTotalCentavos(
        volumeMililitros: 10000,
        precoMilesimosRealPorLitro: 6299,
      ),
      6299,
    );
    expect(
      AbastecimentoService.calcularVolumeMililitros(
        valorTotalCentavos: 6299,
        precoMilesimosRealPorLitro: 6299,
      ),
      10000,
    );
    expect(
      AbastecimentoService.calcularPrecoEfetivoMilesimos(
        valorTotalCentavos: 19000,
        volumeMililitros: 31800,
      ),
      5975,
    );
  });

  test('último abastecimento permanece recuperável em novo service', () async {
    await registrar(odometro: 321);
    final novo = AbastecimentoService(
      AbastecimentoRepository(AbastecimentoDao(database)),
      JornadaRepository(JornadaDao(database)),
    );
    expect((await novo.ultimoAbastecimento(1))?.odometro, 321);
  });

  testWidgets('diálogo foca odômetro e salva sem exceção', (tester) async {
    RegistrarAbastecimentoResultado? resultado;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              resultado = await showDialog<RegistrarAbastecimentoResultado>(
                context: context,
                builder: (_) =>
                    const RegistrarAbastecimentoDialog(odometroInicial: 100),
              );
            },
            child: const Text('Abrir'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    final odometro = find.byKey(const ValueKey('odometro_abastecimento'));
    expect(
      tester
          .widget<EditableText>(
            find.descendant(of: odometro, matching: find.byType(EditableText)),
          )
          .focusNode
          .hasFocus,
      isTrue,
    );
    await tester.enterText(
      find.byKey(const ValueKey('volume_abastecimento')),
      '10000',
    );
    await tester.enterText(
      find.byKey(const ValueKey('total_abastecimento')),
      '6299',
    );
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(resultado?.volumeMililitros, 10000);
    expect(resultado?.valorTotalPagoCentavos, 6299);
    expect(tester.takeException(), isNull);
  });

  testWidgets('diálogo sugere combustível do último abastecimento', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RegistrarAbastecimentoDialog(
          tipoCombustivelInicial: TipoCombustivel.etanol,
        ),
      ),
    );
    await tester.pumpAndSettle();
    final campo = tester.widget<DropdownButtonFormField<TipoCombustivel>>(
      find.byType(DropdownButtonFormField<TipoCombustivel>),
    );
    expect(campo.initialValue, TipoCombustivel.etanol);
  });
}
