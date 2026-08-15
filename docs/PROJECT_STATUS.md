# Estado atual do projeto

## Fotografia

- desenvolvimento ativo com teste operacional real em Android;
- aplicativo Flutter offline-first com Drift/SQLite;
- schema atual: **8**;
- suíte automatizada: **139 testes aprovados** em 15/08/2026.

## Implementado

- Jornada: abertura, fechamento, persistência, restauração, localização textual
  e progressão de odômetro, inclusive sugestão cronológica no fechamento e
  encerramento com zero km;
- Pausas: início/fim, odômetros, duração derivada, título opcional, histórico e
  correção completa pelo lápis com coerência temporal e de odômetro;
- Leituras de ganhos inicial, parcial e final, com fechamento atômico;
- plataformas padrão configuráveis, ativas/inativas e classificadas como
  acumuladas ou individuais;
- ganhos acumulados por snapshots e ganhos individuais/Particular em lote;
- resumo derivado com receita, viagens, ticket médio, tempos, distâncias e
  indicadores; regressões ou passes em acumuladas exigem conferência;
- Abastecimentos atuais/retroativos, preço efetivo derivado, tanque cheio ou
  parcial e associação opcional à Jornada;
- Passes por faturamento ou tempo, validade derivada, repetição segura por
  Plataforma, cadastro retroativo, custos separados e Jornada opcional;
- crédito promocional retroativo sem escolha de subtipo pelo motorista; valores
  históricos `bonus`/`promocao` permanecem compatíveis e a reconciliação é
  uniforme por intervalos;
- baseline protege contra dupla subtração de bônus creditado antes da Jornada,
  sem criar associação cronologicamente falsa;
- JornadaPage protegida pelos insets seguros inferiores do Android;
- formulários operacionais navegam pelo teclado entre campos editáveis,
  ignorando botões, seletores e calendários, e encerram a sequência com Done;
- migrações preservadoras até schema 8 e seeds idempotentes.

## Em teste operacional

Os fluxos são exercitados em Android físico. Abastecimentos e Passes são as
entregas mais recentes; a interface segue funcional e provisória.

## Limitações conhecidas

- usuário e veículo operacionais ainda usam registros temporários com ID 1;
- não há exclusão histórica nem auditoria/versionamento das correções;
- resets e efeitos de Passes sobre snapshots não são inferidos; bônus conhecidos
  são reconciliados somente quando a matemática é segura;
- não há consumo/autonomia, manutenção, custos gerais, alertas, GPS, nuvem ou
  importação do AppSheet;
- tratamento visual e navegação ainda estão concentrados na `JornadaPage`;
- campos legados de Veículo/Configuração ainda usam `REAL` e aguardam evolução
  orientada pelas respectivas features.
- Passes suportam operacionalmente tempo e faturamento; carteira pré-paga e
  condições compostas por tempo/uso permanecem documentadas, sem schema ou
  fluxo de cadastro.

## Próxima frente

A próxima frente será priorizada após validação operacional desta entrega. O
`BACKLOG.md` permanece como referência.
