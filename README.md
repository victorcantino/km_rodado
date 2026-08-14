# KM Rodado

Aplicativo para apoiar a operação de motoristas profissionais: jornadas,
odômetros, ganhos e custos operacionais registrados durante o trabalho.

O projeto está em desenvolvimento ativo e passa por testes operacionais reais
em Android. Funciona localmente e offline, com Flutter/Dart e Drift sobre
SQLite.

## Funcionalidades atuais

- abertura e fechamento de Jornada, odômetros e localização textual;
- Pausas com duração e deslocamento derivados;
- Leituras de ganhos inicial, parcial e final;
- plataformas configuráveis com captura acumulada ou individual;
- ganhos individuais, incluindo Particular e lançamentos em lote;
- resumo analítico derivado, com conferência de snapshots inconsistentes;
- Abastecimentos atuais ou retroativos;
- Passes de plataforma como custos separados do faturamento.

## Arquitetura

O aplicativo é offline-first e usa a cadeia atual:

```text
Page → Controller → Service → Repository → DAO → Drift → SQLite
```

O estado da interface usa `ChangeNotifier` e `AnimatedBuilder`, com injeção
manual de dependências. Consulte [`docs/`](docs/) para arquitetura, modelo,
regras, decisões, estado e backlog.

## Desenvolvimento local

```bash
cd app
flutter pub get
dart run build_runner build   # quando tabelas ou DAOs Drift mudarem
flutter analyze
flutter test
flutter run
```
