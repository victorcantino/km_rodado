## ADR-001 — Banco local

Decisão: utilizar Drift com SQLite.

Motivo: funcionamento offline, consultas tipadas e migrações.

## ADR-002 — Estado inicial da aplicação

Decisão: utilizar ChangeNotifier e AnimatedBuilder na primeira feature.

Motivo: aprender o funcionamento nativo do Flutter antes de
introduzir bibliotecas de gerenciamento de estado.

## ADR-003 — Injeção de dependências

Decisão: realizar injeção manual durante a implementação da Jornada.

Revisar após a conclusão da primeira feature.

## ADR-004 — Leituras de ganhos normalizadas

Decisão: representar cada observação por uma `LeituraGanhos` e seus itens por
plataforma em `LeituraGanhoPlataforma`.

Motivo: data, Jornada, Pausa e tipo pertencem à ação de leitura, enquanto valor
e viagens acumulados pertencem a cada plataforma. Diferenças são derivadas.

## ADR-005 — Dinheiro em centavos

Decisão: armazenar valores acumulados como inteiros em centavos.

Motivo: evitar imprecisão binária de valores monetários em ponto flutuante.

## ADR-006 — Timeline sem tabela genérica

Decisão: montar inicialmente a timeline como projeção de tabelas especializadas.

Motivo: manter regras e integridade próprias de cada entidade e evitar uma
abstração genérica antes de existir necessidade concreta.

## ADR-007 — Forma de registro por plataforma

Decisão: cada Plataforma declara `TipoRegistroGanhos`, com os valores
`acumulado` ou `individual`.

Motivo: plataformas acumuladas usam leituras do visor, enquanto plataformas
individuais usam a soma de lançamentos. Particular continua sendo plataforma;
nenhuma regra de negócio depende de seu nome. A apresentação pode ser uniforme
sem compartilhar artificialmente a mesma fonte de verdade.

## ADR-008 — Encerramento atômico da Jornada

Decisão: coletar primeiro os dados de fechamento e da leitura final e, somente
após ambas as confirmações, persistir a leitura final e a atualização da
Jornada em uma única transação Drift específica desse fluxo.

Motivo: a leitura final faz parte do encerramento. Uma transação impede tanto
uma Jornada finalizada sem a leitura obrigatória quanto uma leitura final órfã
em uma Jornada ainda aberta, sem introduzir uma camada arquitetural genérica.

## ADR-009 — Resumo derivado e regressões não inferidas

Decisão: calcular o resumo da Jornada a partir de Jornada, Pausas e Leituras de
Ganhos persistidas, sem armazenar os indicadores derivados. Uma regressão de
valor acumulado ou quantidade de viagens em qualquer snapshot entre a Leitura
Inicial e a Final torna o resultado da plataforma não calculável.

Motivo: diferentes plataformas podem alterar seus acumulados visíveis de formas
ainda desconhecidas. Interpretar automaticamente uma regressão como reset
inventaria receita. A futura conferência/reconciliação tratará esses casos com
informação explícita do usuário.

## ADR-010 — Ganhos individuais como fatos

Decisão: persistir cada lançamento individual separadamente, com plataforma,
Jornada opcional, quantidade, valor total em centavos, observação e instante de
criação. Não criar snapshots acumulados artificiais nem odômetro por viagem.

Motivo: um lançamento pode representar várias viagens sem revelar valores
unitários. Seus totais são somas factuais e não sofrem regras de reset.
