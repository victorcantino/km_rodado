# KM Rodado

Aplicativo para apoiar a operação de motoristas profissionais: jornadas,
odômetros, ganhos e custos operacionais registrados durante o trabalho.

O projeto está em desenvolvimento ativo e passa por testes operacionais reais
em Android. Funciona localmente e offline, com Flutter/Dart e Drift sobre
SQLite.

O KM Rodado nasceu de uma necessidade operacional real, teve uma versão de uso
em AppSheet e está sendo reescrito e evoluído em Flutter. O objetivo é
transformar registros reais em uma referência econômica pessoal de quanto o
motorista precisa receber por quilômetro e por hora para cobrir custos e atingir
a margem desejada.

Estado atual: schema Drift 13, com validação automatizada e teste operacional
em Android em andamento.

## Funcionalidades atuais

- abertura e fechamento de Jornada, odômetros e localização textual;
- Pausas com duração e deslocamento derivados;
- Leituras de ganhos inicial, parcial e final;
- resumo intraday acumulado da Jornada aberta até a última Leitura salva;
- plataformas configuráveis com captura acumulada ou individual;
- ganhos individuais, incluindo Particular e lançamentos em lote;
- Passes e Bônus/Promoções em página compartilhada, com históricos separados;
- resumo analítico derivado, com conferência de snapshots inconsistentes;
- Abastecimentos atuais ou retroativos;
- Passes de plataforma como custos separados do faturamento;
- Bônus/promoções como créditos separados e reconciliação conservadora da
  receita de viagens;
- Manutenções por veículo com múltiplos itens, histórico e recorrências por
  odômetro ou data.
- Despesas factuais do veículo, atuais ou retroativas, com histórico e edição.
- Custos recorrentes como referências de competência econômica, separados dos
  pagamentos efetivos.
- Depreciação observada e projetada por veículo, calculada em R$/km.

## Próximos passos

Refinar a experiência móvel, ampliar o histórico e a linha do tempo de Jornadas,
melhorar indicadores de manutenção e preparar a cobertura de custos para o
futuro Motor Econômico. Planejamento Mensal e InDrive continuam pendentes de
definição e observação operacional.

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
