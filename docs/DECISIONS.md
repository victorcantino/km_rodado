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
operacional, criação técnica e Jornada opcional. Na 99, o Passe refletido no
acumulado é recomposto para derivar faturamento bruto e descontado uma vez no
resultado operacional. Na Uber, a variação do acumulado permanece como
faturamento e o Passe é custo separado. Outras Plataformas permanecem em
revisão quando houver Passe no intervalo.

Motivo: o efeito observado varia entre plataformas. As duas regras factuais
conhecidas evitam dupla contagem sem criar configuração genérica, tabela,
página ou workflow de Conciliação.

Os mecanismos suportados nesta etapa são `tempo` e `faturamento`; duração,
validade, limite e preço caracterizam a oferta observada. Essa formalização
atende ao uso operacional atual, sem declarar que são as únicas condições
possíveis nem transformar ofertas concretas em enum ou hardcode.

A formalização operacional usa enum somente no domínio Dart e persiste os nomes
canônicos no campo legado `modalidade`. Faturamento deriva validade de 180 dias;
tempo deriva validade de 24h ou 72h. A duração pode ser recuperada de
`validadeAte - dataHora`, evitando migração. Repetição só ocorre quando os dados
anteriores são inequívocos e nunca copia identidade, datas ou Jornada.

Fonte de pagamento não define o tipo do Passe. Carteira pré-paga pode financiar
um Passe com condições próprias, como a oferta “cidade a cidade” observada na
inDrive, encerrada por tempo ou quantidade de pedidos — o que ocorrer primeiro.
Recarga transfere dinheiro para saldo; somente compra/consumo reconhece custo,
evitando dupla contagem. A condição composta permanece futura até haver uso
operacional que justifique ampliar o modelo.

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

## ADR-014 — Redução de toques com correção manual preservada

Decisão: quanto menos o motorista precisar digitar e tocar, melhor. Formulários
devem priorizar histórico, valores derivados, defaults seguros, autofocus,
repetição e campos condicionais, mantendo sempre a possibilidade de correção
manual. GPS e serviços externos só entram quando agregarem valor, com
consentimento e confirmação do usuário.

Ao acionar `Próximo`, o foco percorre somente campos editáveis e respeita o
tipo de teclado do destino. Botões, seletores e calendários ficam fora dessa
sequência; valores padrão confiáveis permanecem preenchidos e detalhes menos
frequentes continuam disponíveis sob demanda.

## ADR-015 — Correção tardia sem falsificar instantes técnicos

Decisão: o fluxo normal usa valores padrão confiáveis e exige poucos toques;
edição de data/hora e demais detalhes permanece disponível sob demanda. O uso
operacional tolera lançamentos tardios somente quando os fatos podem ser
reconstruídos de forma cronologicamente coerente.

Somente instantes operacionais semanticamente confiáveis limitam a Jornada.
`LancamentoGanhoIndividual.dataCriacao` registra o cadastro técnico, não o
momento da viagem, e por isso nunca é usado como fronteira temporal.

## ADR-016 — Inteligência de abastecimento conservadora e derivada

Decisão: calcular consumo por ciclos válidos entre tanques cheios, somando os
volumes parciais intermediários, e usar no máximo os três ciclos mais recentes.
A média é aritmética; a referência conservadora de consumo é o menor km/L.

A autonomia estimada usa a capacidade do tanque, mas é apenas uma estimativa de
tanque cheio. A referência para abastecer é comportamental: exige ao menos dois
ciclos e usa a menor distância recente entre um tanque cheio e o primeiro
reabastecimento. Após um parcial, a recomendação é omitida por não conhecermos o
nível físico atual. Referência atingida não significa tanque vazio.

Todos esses valores são derivados. Não há previsão por data de calendário sem
histórico contínuo confiável, nem atribuição exclusiva de ciclo com parcial a
um posto/bandeira.

## ADR-017 — Manutenção como visita com itens livres

Decisão: representar Manutenção como cabeçalho do evento físico do veículo e
seus itens em relação 1:N. Descrição é livre, valor é opcional por item e o
custo total/completo é derivado. Manutenção não recebe `jornadaId` nesta versão.

Recorrência por km persiste somente o intervalo; o próximo odômetro é derivado.
Vencimento por data é explícito e opcional. Apenas o item mais recente de uma
descrição normalizada por espaços externos e caixa mantém a recorrência ativa.

Motivo: o histórico real agrupa várias peças e serviços na mesma visita e usa
descrições concretas, incompatíveis com enum rígido ou uma linha por visita.
Separar fatos comuns dos itens evita repetição e preserva valor desconhecido sem
tratá-lo como zero. O XLS permanece fonte para futura importação revisada, não
seed desta entrega.

## ADR-018 — Ações compactas quando o ícone é inequívoco

Decisão: o KM Rodado prefere ações compactas somente com ícone quando o
significado visual for suficientemente reconhecível. O nome permanece
disponível por tooltip/toque longo e pela semântica de acessibilidade.

Ícones claros e universais reduzem poluição visual. Ações ambíguas, destrutivas
ou dependentes de contexto podem manter texto; ações como Salvar e Confirmar
também preservam texto quando isso evita dúvida. A preferência orienta novos
botões e revisões oportunas, sem conversão indiscriminada da interface atual.

## ADR-019 — Despesa factual do veículo sem evento financeiro genérico

Decisão: registrar despesas gerais pagas ou ocorridas em `DespesasVeiculo`,
ligadas obrigatoriamente ao veículo e sem `jornadaId` nesta primeira versão.
Abastecimento, Manutenção e Passe permanecem fatos especializados e não são
replicados nessa tabela.

Motivo: a necessidade atual é registrar fatos esporádicos como multa, pedágio,
estacionamento, lavagem e taxas/documentações eventuais. IPVA, licenciamento e
seguro seguem o fluxo normal de Custos Recorrentes. Os valores técnicos antigos
permanecem compatíveis, mas deixam de ser oferecidos em novas Despesas para
evitar mistura e futura dupla contagem.

## ADR-020 — Competência recorrente separada do pagamento

Decisão: representar referências econômicas em `CustosRecorrentes`, sem gerar
ou vincular automaticamente `DespesasVeiculo`. Periodicidade em meses define a
competência; parcelas por ciclo descrevem somente o hábito de pagamento. O
equivalente mensal é derivado e valor ausente permanece desconhecido.

O escopo é explícito — veículo, atividade ou Plataforma — com FKs condicionais.
Não há data inicial inventada, vencimentos, contas a pagar ou motor econômico.

Motivo: um IPVA anual pode ser pago à vista ou parcelado sem deixar de ser custo
do ciclo anual. Da mesma forma, telefone profissional pertence à atividade e
conta de Plataforma não pertence ao veículo. Separar competência de caixa
evita dupla contagem e preserva fatos suficientes para análises futuras.

Parcela do veículo pode ser registrada neste modelo como referência periódica
simples de caixa e é deliberadamente genérica: financiamento, consórcio,
parcelamento direto, acordo de pagamento ou modalidade equivalente são
diferenciados pela descrição livre, não por novos tipos. Só serão separados se
o uso real exigir tratamento econômico ou operacional distinto.

Depreciação, por outro lado, não é uma referência manual conhecida pelo
usuário e não é oferecida em novos Custos Recorrentes. Será calculada por uma
feature própria, anterior ao Motor Econômico, sem percentuais arbitrários. O
valor técnico existente no enum é preservado apenas para compatibilidade. O
Motor Econômico decidirá depois como usar a estimativa sem dupla contagem.

## ADR-021 — Contexto visual único para despesas e recorrências

Decisão: Despesas do Veículo e Custos Recorrentes mantêm modelos, regras e
listas semanticamente separados, mas aparecem na mesma `DespesasPage` e na
mesma rolagem. Cada formulário abre diretamente por sua própria ação compacta,
sem página intermediária.

Motivo: os dois conceitos pertencem ao mesmo contexto econômico para o usuário,
embora pagamento e competência não possam ser misturados. Uma tela única reduz
etapas sem esconder a distinção nem alterar as fontes de verdade.

## ADR-022 — Depreciação derivada por veículo

Decisão: manter um único snapshot configurável por veículo, com cenários
observado e projetado. Valores e odômetros factuais são persistidos, enquanto
R$/km é calculado em apresentação. Os dois métodos podem coexistir e a escolha
principal só é mantida quando o respectivo cálculo está disponível.

Motivo: depreciação é perda econômica estimada, não saída recorrente de caixa.
Separá-la de Despesas e Custos Recorrentes evita percentuais arbitrários e
dupla contagem futura. A referência observada é deliberadamente estável até
edição; integração automática com FIPE permanece evolução opcional.

## ADR-023 — Instante operacional do baseline financeiro

Decisão: a Leitura Inicial declara os acumulados no início da Jornada. Sua
`dataHora` é sempre `Jornada.dataHoraInicio`, tanto no diálogo automático quanto
no registro posterior de ganhos iniciais pendentes; `dataCriacao` preserva o
instante técnico do salvamento.

Motivo: o usuário está declarando o baseline, não registrando uma observação
temporal intermediária. Portanto, não existe cobertura financeira parcial
inferida pela demora no preenchimento. Conciliação permanece apenas a
interpretação derivada de Passes e Bônus/Promoções em relação aos snapshots,
sem módulo, tabela ou workflow próprios.
