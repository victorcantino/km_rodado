# Estado atual do projeto

## Fotografia

- desenvolvimento ativo com teste operacional real em Android;
- aplicativo Flutter offline-first com Drift/SQLite;
- schema atual: **7**;
- suíte automatizada: **87 testes aprovados** em 13/08/2026.

## Implementado

- Jornada: abertura, fechamento, persistência, restauração, localização textual
  e progressão de odômetro, inclusive encerramento com zero km;
- Pausas: início/fim, odômetros, duração derivada, título opcional e histórico;
- Leituras de ganhos inicial, parcial e final, com fechamento atômico;
- plataformas padrão configuráveis, ativas/inativas e classificadas como
  acumuladas ou individuais;
- ganhos acumulados por snapshots e ganhos individuais/Particular em lote;
- resumo derivado com receita, viagens, ticket médio, tempos, distâncias e
  indicadores; regressões ou passes em acumuladas exigem conferência;
- Abastecimentos atuais/retroativos, preço efetivo derivado, tanque cheio ou
  parcial e associação opcional à Jornada;
- Passes de plataforma retroativos, custos separados e Jornada opcional;
- migrações preservadoras até schema 7 e seeds idempotentes.

## Em teste operacional

Os fluxos são exercitados em Android físico. Abastecimentos e Passes são as
entregas mais recentes; a interface segue funcional e provisória.

## Limitações conhecidas

- usuário e veículo operacionais ainda usam registros temporários com ID 1;
- não há edição/exclusão histórica completa;
- efeitos de reset, passe, bônus ou promoção sobre snapshots não são inferidos;
- não há consumo/autonomia, manutenção, custos gerais, alertas, GPS, nuvem ou
  importação do AppSheet;
- tratamento visual e navegação ainda estão concentrados na `JornadaPage`;
- campos legados de Veículo/Configuração ainda usam `REAL` e aguardam evolução
  orientada pelas respectivas features.

## Próxima frente

A próxima frente de produto ainda será priorizada a partir do uso operacional.
Entre as necessidades candidatas estão correção histórica de Pausas,
bônus/promoções e reconciliação de snapshots. O `BACKLOG.md` é a referência
para priorização.
