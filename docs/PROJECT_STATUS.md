# Estado atual do projeto

## Fotografia

- desenvolvimento ativo com teste operacional real em Android;
- aplicativo Flutter offline-first com Drift/SQLite;
- schema atual: **12**;
- suíte automatizada: **207 testes aprovados** em 17/08/2026.

## Implementado

- Jornada: abertura, fechamento, persistência, restauração, localização textual
  e progressão de odômetro, inclusive sugestão cronológica no fechamento e
  encerramento com zero km; abertura/fechamento tardios e correção segura da
  Jornada aberta ou da última finalizada;
- Pausas: início/fim, odômetros, duração derivada, título opcional, histórico e
  correção completa pelo lápis com coerência temporal e de odômetro;
- Leituras de ganhos inicial, parcial e final, com fechamento atômico;
- plataformas padrão configuráveis, ativas/inativas e classificadas como
  acumuladas ou individuais;
- ganhos acumulados por snapshots e ganhos individuais/Particular em lote;
- resumo derivado com receita, viagens, ticket médio, tempos, distâncias e
  indicadores; regressões, passes ou baseline posterior ao início impedem
  totais financeiros gerais exatos;
- Abastecimentos atuais/retroativos, preço efetivo derivado, tanque cheio ou
  parcial e associação opcional à Jornada;
- inteligência derivada de Abastecimentos com ciclos cheio a cheio, parciais
  acumulados, consumo recente, autonomia teórica de tanque cheio e referência
  comportamental conservadora para abastecer;
- Manutenções por veículo com cabeçalho e múltiplos itens, valores opcionais,
  edição atômica, histórico, sugestões e recorrências derivadas por km/data;
- Despesas esporádicas por veículo — multa, pedágio, estacionamento, lavagem,
  taxa/documentação eventual e outras — com descrição livre, valor em
  centavos, cadastro retroativo, histórico, edição e compatibilidade de leitura
  dos antigos tipos IPVA/licenciamento/seguro;
- Custos Recorrentes separados do fluxo de caixa, com competência mensal,
  anual ou personalizada, escopo veículo/atividade/Plataforma, valor exato ou
  estimado e equivalente mensal derivado; inclui referência simples de parcela
  do veículo, sem controle financeiro detalhado; Despesas e recorrências aparecem
  em seções distintas da mesma tela, com criação e edição diretas;
- depreciação observada e projetada por veículo, com configuração parcial,
  método principal opcional e R$/km derivado sem percentuais arbitrários;
- Passes por faturamento ou tempo, validade derivada, repetição segura por
  Plataforma, cadastro retroativo, custos separados e Jornada opcional;
- crédito promocional retroativo sem escolha de subtipo pelo motorista; valores
  históricos `bonus`/`promocao` permanecem compatíveis e a reconciliação é
  uniforme por intervalos;
- baseline protege contra dupla subtração de bônus creditado antes da Jornada,
  sem criar associação cronologicamente falsa;
- a ação de ganho Particular na JornadaPage acompanha a disponibilidade de
  Plataformas individuais ativas e não aparece quando nenhuma está disponível;
- JornadaPage protegida pelos insets seguros inferiores do Android;
- formulários operacionais navegam pelo teclado entre campos editáveis,
  ignorando botões, seletores e calendários, e encerram a sequência com Done;
- migrações preservadoras até schema 12 e seeds idempotentes.

## Em teste operacional

Os fluxos são exercitados em Android físico. Abastecimentos e Passes são as
entregas mais recentes; a interface segue funcional e provisória.

## Limitações conhecidas

- usuário e veículo operacionais ainda usam registros temporários com ID 1;
- não há exclusão histórica nem auditoria/versionamento das correções;
- resets e efeitos de Passes sobre snapshots não são inferidos; bônus conhecidos
  são reconciliados somente quando a matemática é segura;
- não há custo/km, análise por posto, consolidação financeira geral,
  motor econômico, obrigações/vencimentos, notificações, GPS,
  nuvem ou importação do AppSheet; previsão por data é omitida sem histórico
  calendário confiável;
- tratamento visual e navegação ainda estão concentrados na `JornadaPage`;
- campos legados de Veículo/Configuração ainda usam `REAL` e aguardam evolução
  orientada pelas respectivas features.
- Passes suportam operacionalmente tempo e faturamento; carteira pré-paga e
  condições compostas por tempo/uso permanecem documentadas, sem schema ou
  fluxo de cadastro.

## Próxima frente

A próxima frente será priorizada após validação operacional desta entrega. O
`BACKLOG.md` permanece como referência.
