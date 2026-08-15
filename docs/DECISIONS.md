## ADR-001 — Banco local

Decisão: utilizar Drift com SQLite.

Motivo: funcionamento offline, consultas tipadas e migrações.

## ADR-002 — Estado da interface

Decisão: manter `ChangeNotifier` e `AnimatedBuilder` enquanto atenderem aos
fluxos atuais.

Motivo: a solução nativa continua suficiente; adicionar outra biblioteca sem
necessidade concreta aumentaria a arquitetura.

## ADR-003 — Injeção de dependências

Decisão: manter injeção manual nas features atuais.

Motivo: a composição está concentrada e explícita na `JornadaPage`; um
container de dependências ainda não resolveria um problema concreto.

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

## ADR-011 — Precisão inteira nos Abastecimentos

Decisão: armazenar total pago em centavos, volume em mililitros e preço por
litro em milésimos de real. O preço efetivo é calculado de total e volume.

Motivo: representar os valores operacionais sem usar ponto flutuante como fonte
de verdade e sem persistir informação derivada. O abastecimento pertence ao
veículo e associa-se automaticamente à Jornada aberta, permanecendo possível
fora dela.

O instante operacional (`dataHora`) é separado do instante técnico de criação
para permitir lançamentos retroativos. A progressão do odômetro é validada pela
posição cronológica do evento, e não pelo maior valor existente no momento da
digitação.

## ADR-012 — Passes como custo factual separado

Decisão: registrar passes por Plataforma com valor em centavos, instante
operacional, criação técnica e Jornada opcional. Não ajustar automaticamente
snapshots nem ticket médio. Um passe entre as leituras inicial e final torna a
receita acumulada daquela plataforma dependente de conferência.

Motivo: o efeito observado varia entre plataformas. O custo é conhecido, mas a
reconciliação da receita exige regras explícitas ainda não formalizadas.

Os mecanismos conhecidos são `tempo` e `faturamento`; duração, validade,
limite e preço caracterizam a oferta observada. A futura formalização deve usar
esses mecanismos sem transformar ofertas concretas em enum ou hardcode.

## ADR-013 — Créditos promocionais factuais e reconciliação por intervalos

Decisão: persistir Bônus/Promoções observados como fatos especializados,
separados dos snapshots, e reconciliar plataformas acumuladas por intervalos
consecutivos `(snapshot anterior, snapshot posterior]`. A receita de viagens é
a variação menos créditos conhecidos; Passes e inconsistências mantêm revisão.

Motivo: preservar fatos brutos, evitar dupla contagem nas fronteiras e separar
com segurança faturamento de viagens, créditos e custos sem motor financeiro
genérico ou regras por nome de Plataforma.

Crédito anterior ou exatamente no baseline não é subtraído da variação
seguinte, pois já compõe o saldo inicial. Ele permanece um fato independente e
não recebe `jornadaId` artificial.

O módulo não evoluirá para cadastrar missão, meta, etapas, exigências, origem
econômica, competência em outra Jornada ou lucratividade da promoção.
`dataHora` é o instante factual em que o crédito apareceu; análises eventuais
mais complexas não justificam aumentar a carga operacional do motorista.
