# Estado atual do projeto

## Fotografia

- desenvolvimento ativo com teste operacional real em Android;
- aplicativo Flutter offline-first com Drift/SQLite;
- schema atual: **13**;
- suíte automatizada: **219 testes aprovados** na última validação disponível;
  a validação final desta revisão depende do ambiente Flutter local.

## Implementado

- Jornada: abertura, fechamento, persistência, restauração, localização textual
  e progressão de odômetro, inclusive sugestão cronológica no fechamento e
  encerramento com zero km; abertura/fechamento tardios e correção segura da
  Jornada aberta ou da última finalizada;
- Pausas: início/fim, odômetros, duração derivada, título opcional, histórico e
  correção completa pelo lápis com coerência temporal e de odômetro;
- Leituras de ganhos inicial, parcial e final, com fechamento atômico;
- Leitura Inicial como declaração do baseline no início da Jornada, inclusive
  quando registrada posteriormente, com instante técnico de criação preservado;
- plataformas padrão configuráveis, ativas/inativas e classificadas como
  acumuladas ou individuais;
- ganhos acumulados por snapshots e ganhos individuais/Particular em lote;
- resumo derivado com receita, viagens, ticket médio, tempos, distâncias e
  indicadores; regressões e fatos financeiros sem interpretação segura impedem
  totais gerais exatos;
- resumo intraday da Jornada aberta, acumulado até a última Leitura salva, com
  tempo total, Pausas, tempo ativo, distância segura, composição financeira e
  resultados por Plataforma na mesma referência temporal;
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
- Passes da 99 são recompostos quando já refletidos no acumulado; Passes da
  Uber permanecem como custo separado da variação, sem dupla contagem;
- Passes e Bônus/Promoções têm página compartilhada, seções independentes,
  histórico por data/hora decrescente, cadastro e edição com exclusão;
- a ação de ganho Particular na JornadaPage acompanha a disponibilidade de
  Plataformas individuais ativas e não aparece quando nenhuma está disponível;
- ganhos individuais possuem horário operacional próprio e participam do
  Intraday acumulado até o checkpoint, sem snapshots artificiais;
- JornadaPage protegida pelos insets seguros inferiores do Android;
- formulários operacionais navegam pelo teclado entre campos editáveis,
  ignorando botões, seletores e calendários, e encerram a sequência com Done;
- migrações preservadoras até schema 13 e seeds idempotentes.
- Cobertura dos custos como diagnóstico derivado na página de Despesas, com
  estados Informado, Estimado e Não informado; parcela do veículo separada
  como obrigação de caixa e multa fora da cobertura estrutural.

## Em teste operacional

Os fluxos são exercitados em Android físico. Abastecimentos e Passes são as
entregas mais recentes; a interface segue funcional e provisória.

## Limitações conhecidas

- usuário e veículo operacionais ainda usam registros temporários com ID 1;
- não há exclusão histórica nem auditoria/versionamento das correções;
- resets e efeitos de Passes sobre snapshots não são inferidos; bônus conhecidos
  são reconciliados somente quando a matemática é segura;
- não existe módulo de Conciliação; o termo descreve somente a interpretação
  derivada de Passes e Bônus/Promoções nos acumulados;
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
- FABs e “Ver todos” da página de Passes/Bônus ainda são uma primeira versão
  operacional; refinamentos visuais permanecem no backlog.
- Cobertura dos custos ainda não calcula custo econômico por km nem percentual
  de confiança; essas decisões pertencem ao futuro Motor Econômico.

## Próxima frente

A próxima frente será priorizada após validação operacional desta entrega. O
`BACKLOG.md` permanece como referência.

O pacote atual aguarda teste manual Android, especialmente o baseline sem
checkpoint, os lançamentos Particular retroativos e a página Passes e bônus.
