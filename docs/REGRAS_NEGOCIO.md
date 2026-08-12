# Regras de Negócio — KM Rodado

## 1. Conceito Geral

O KM Rodado é um sistema de gestão operacional para motoristas.

O aplicativo deve controlar:

* jornadas de trabalho;
* quilômetros percorridos;
* ganhos por plataforma;
* custos operacionais;
* manutenção preventiva;
* combustível;
* passes e créditos das plataformas;
* indicadores de eficiência.

O objetivo principal é responder:

* Quanto estou ganhando por quilômetro?
* Quanto estou ganhando por hora?
* Qual meu custo real?
* Qual meu lucro operacional?
* Quais cuidados o veículo precisa?
* Qual período de trabalho apresenta melhor resultado?

---

# 2. Jornada de Trabalho

## 2.1 Início da Jornada

Uma jornada representa o período em que o motorista inicia sua operação.

Ao iniciar uma jornada:

O usuário deve informar:

* odômetro inicial;
* cidade atual.

O sistema deve preencher automaticamente:

* data;
* horário;
* último destino registrado como origem;
* veículo utilizado.

O sistema deve registrar automaticamente:

* temperatura;
* condição climática;
* localização;
* outros dados disponíveis.

---

## 2.2 Odômetro Inicial

O odômetro inicial deve sugerir:

* último odômetro final registrado.

No fluxo operacional normal, o novo odômetro inicial deve ser maior ou igual
ao último odômetro final registrado:

```text
novo odometro_inicio >= último odometro_fim
```

A igualdade é permitida. Se não existir Jornada finalizada anterior ou se ela
não possuir odômetro final, essa comparação não deve ser aplicada.

O usuário pode editar a sugestão, mas não pode informar valor inferior ao
último odômetro final no fluxo operacional de abertura.

Correções retroativas serão realizadas futuramente em fluxo específico, com
justificativa obrigatória e registro da alteração.

---

## 2.3 Fechamento da Jornada

O odômetro final deve ser maior ou igual ao odômetro inicial e ao último
odômetro conhecido da Jornada.

```text
odometro_fim >= odometro_inicio
```

Os quilômetros percorridos devem ser calculados por:

```text
odometro_fim - odometro_inicio
```

Uma Jornada pode ser finalizada sem deslocamento, mas nunca com regressão.

Enquanto o GPS não estiver implementado, a cidade de origem da Jornada aberta
deve ser sugerida como destino no fechamento. O usuário pode editar ou remover
essa sugestão.

Ao abrir a Jornada seguinte, o último destino registrado deve ser sugerido como
cidade de origem. O usuário pode editar a sugestão.

Quando o GPS estiver disponível, a localização atual terá preferência. O
histórico continuará sendo utilizado como fallback quando a localização não
estiver disponível.

## 2.4 Correção de odômetro

A correção futura de um odômetro já registrado deve:

* exigir um motivo em observações;
* definir `odometroAlterado = true`;
* manter o usuário responsável pela correção informada.

O fluxo de correção não faz parte do fechamento normal da Jornada.

---

# 3. Status da Jornada

Uma jornada pode possuir os seguintes estados:

```
ABERTA
PAUSADA
FINALIZADA
```

## Aberta

Motorista está em operação.

## Pausada

Motorista interrompeu temporariamente a operação.

Exemplos:

* almoço;
* academia;
* descanso.

## Finalizada

O motorista encerrou a operação.

---

# 4. Pausas

Uma pausa pertence obrigatoriamente a uma Jornada e interrompe a atividade do
motorista como um todo, não uma plataforma específica.

Somente uma Pausa pode permanecer aberta por Jornada. `fim == null` representa
uma Pausa aberta. Uma nova Pausa só pode começar quando houver Jornada aberta e
nenhuma outra Pausa aberta.

Ao iniciar uma pausa:

O sistema deve registrar:

* horário inicial;
* odômetro inicial;
* título opcional.

Ao retomar, horário e odômetro final são registrados. Os odômetros são
obrigatórios para novas Pausas, nunca podem regredir e podem permanecer iguais.
Pausas históricas permanecem sem odômetro quando o dado não existe.

Sem título, a interface pode apresentar `Pausa 1`, `Pausa 2` etc. A duração é
derivada de início e fim e não deve ser persistida.

O início é registrado imediatamente com o horário atual. Enquanto estiver
aberta, a duração é recalculada na interface, sem atualizações periódicas no
banco. Ao retomar a Jornada, o fim deve ser maior ou igual ao início.

Pausas são listadas pela ordem de início e, em caso de empate, pelo ID. O título
é normalizado com `trim`; vazio volta ao nome automático derivado da posição.

Uma Jornada não pode ser finalizada enquanto existir uma Pausa aberta. O
motorista deve primeiro retomar a Jornada.

Ao iniciar uma Pausa, o início deve ser persistido antes da abertura do registro
de ganhos. Em seguida, o sistema apresenta imediatamente a leitura parcial. O
usuário também pode abrir novamente essa ação enquanto a Pausa estiver aberta.

Salvar ou cancelar a leitura não encerra nem remove a Pausa. Cancelar não cria
uma leitura vazia.

Caso não seja informado:

Gerar alerta:

```
Período sem registro de ganhos.
```

---

# 5. Leituras de ganhos

## 5.1 Conceito

Uma leitura representa uma única ação do motorista ao observar os acumulados
exibidos pelas plataformas naquele momento.

Exemplo:

```
Uber: R$ 50 e 5 viagens
99: R$ 30 e 4 viagens
```

São registrados acumulados brutos, não diferenças. Uma plataforma pode ser
registrada novamente sem mudança. Diferenças de valor e viagens são derivadas
entre leituras e não são persistidas.

Na leitura parcial associada a uma Pausa:

* a Jornada deve estar aberta;
* a Pausa deve pertencer à mesma Jornada;
* o momento observado é registrado ao salvar;
* cabeçalho e itens são persistidos na mesma transação;
* cada plataforma cadastrada, ativa e acumulada gera exatamente um item.

Os últimos acumulados de cada plataforma na Jornada são sugeridos na leitura
seguinte. O usuário pode salvar novamente os mesmos valores quando o visor não
tiver mudado.

A leitura inicial é registrada logo após a abertura e estabelece a base da
Jornada. Ela não possui Pausa e não herda automaticamente dados da Jornada
anterior: o motorista informa exatamente o acumulado visível naquele momento.
Se o registro for interrompido, a Jornada permanece aberta com os ganhos
iniciais pendentes, sem criar leitura vazia ou inventar valores. Leituras
parciais e finais exigem essa base inicial.

---

# 5.2 Plataformas

O sistema deve permitir:

* Uber;
* 99;
* inDrive;
* Particular;
* outras plataformas futuras.

Cada plataforma define sua forma de captura, sem regras baseadas no nome:

* acumulado: Uber, 99 e inDrive;
* individual: Particular.

Particular continua sendo plataforma e fonte de ganho. Ela aparece com as
demais em dashboards, pausas, fechamento e relatórios.

Uma instalação nova deve disponibilizar Uber, 99, inDrive e Particular como
plataformas padrão ativas. O seed identifica plataformas pelo nome normalizado,
não depende de IDs fixos e preserva integralmente registros já existentes.

A configuração rápida permite ativar ou desativar plataformas sem excluí-las.
A Leitura Inicial fixa o conjunto acumulado obrigatório da Jornada. Mudanças
posteriores valem para a próxima Jornada e não alteram dados históricos.

Plataformas individuais exibem na leitura os totais dos lançamentos da Jornada
e uma ação rápida para registrar. Elas não geram `LeituraGanhoPlataforma`
artificial.

---

# 5.3 Tipos de leitura

* inicial: estabelece a base no início da Jornada;
* parcial: registra o estado durante a Jornada, normalmente em uma Pausa;
* final da Jornada: registra o estado antes do fechamento.

Uma leitura exige Jornada e pode ter Pausa. Quando houver Pausa, ela deverá
pertencer à mesma Jornada da leitura.

Cada Jornada pode possuir no máximo uma leitura inicial e uma leitura final.
Leituras parciais continuam permitidas em diferentes Pausas após a inicial.

---

# 5.4 Valores e leitura final

Valores monetários acumulados são armazenados em centavos inteiros. Quantidade
acumulada de viagens também é inteira e não negativa. Cada plataforma aparece
no máximo uma vez na mesma leitura.

Valor acumulado igual a zero e quantidade acumulada igual a zero são válidos.
Uma Jornada sem corridas pode ser encerrada normalmente após registrar sua
leitura final.

Antes de finalizar a Jornada, o usuário deve realizar a leitura final das
plataformas utilizadas. Ela não depende da existência de uma Pausa.

A leitura final sugere a última leitura da própria Jornada e aceita acumulados
iguais. Seus dados e o fechamento da Jornada são persistidos atomicamente: uma
falha em qualquer parte desfaz toda a operação. Cancelar os dados de fechamento
ou a leitura final mantém a Jornada aberta e não cria leitura final.

Na apresentação durante pausas e fechamento, plataformas acumuladas exibem os
valores e quantidades observados pelo usuário. Plataformas individuais exibem
os totais derivados dos lançamentos já registrados e oferecem uma ação rápida
para adicionar novo lançamento. A interface pode ser uniforme, mas não deve
criar `LeituraGanhoPlataforma` artificial para uma plataforma individual.

Caso nenhuma plataforma seja informada:

Gerar alerta:

```
Jornada finalizada sem registro de ganhos.
```

## 5.5 Resumo analítico da Jornada

O resumo da Jornada é integralmente derivado e não persiste duração, tempos,
distâncias ativas, receita, viagens ou indicadores.

O tempo ativo corresponde à duração total menos a soma das Pausas concluídas.
Os quilômetros ativos correspondem aos quilômetros totais menos o deslocamento
registrado durante as Pausas. Resultados negativos decorrentes de histórico
inconsistente são protegidos e apresentados como zero.

Pausas históricas sem odômetro inicial ou final não são interpretadas como
deslocamento zero: os quilômetros totais continuam disponíveis, mas quilômetros
em Pausa, quilômetros ativos e receita por quilômetro ativo ficam incompletos.

A receita e as viagens de cada plataforma acumulada partem da Leitura Inicial e
terminam na Leitura Final. Leituras anteriores à Inicial são ignoradas. Se valor
ou viagens regredirem em qualquer snapshot dessa sequência, a plataforma exige
revisão e nenhuma diferença é apresentada como resultado confiável. Não se
infere automaticamente que a regressão seja um reset.

Receita total, viagens totais, receita por hora ativa e receita por quilômetro
ativo só são completas quando todas as plataformas acumuladas participantes são
calculáveis. Divisões por tempo ativo ou quilômetros ativos iguais a zero ficam
indisponíveis. Receita e quantidade de viagens iguais a zero permanecem válidas.

O resumo calcula o ticket médio de cada plataforma acumulada dividindo seu
faturamento calculável pela quantidade de viagens. O ticket médio geral divide
o faturamento total pelas viagens totais. Com zero viagens, regressão de
snapshot ou resultado financeiro total incompleto, o respectivo ticket médio
fica indisponível. Plataformas individuais, incluindo Particular, participam
por meio da soma de seus lançamentos factuais. Custos ainda não compõem este
resumo.

## 5.6 Conferência futura de snapshots e eventos financeiros

Uma regressão ou um salto entre snapshots acumulados não significa
necessariamente erro ou reset. A variação poderá ser explicada por compra de
passe, bônus, promoção ou outra movimentação financeira conhecida. A futura
conferência deverá relacionar esses fatos sem assumir uma regra universal para
o efeito observado em cada plataforma.

A compra de passe de plataforma deverá registrar plataforma, data e hora,
modalidade e valor. É um custo operacional, mas seu efeito sobre saldo ou
contador visível varia por plataforma e não deve ser tratado automaticamente
como simples subtração do acumulado.

O bônus ou promoção deverá registrar plataforma, data e hora e valor. É um
crédito financeiro que pode ocorrer no mesmo dia ou ser creditado depois, sem
presunção de horário ou regra por plataforma. Quando relacionado ao período de
uma Jornada, deverá participar da futura reconciliação para não ser confundido
com faturamento de corridas.

O ticket médio considera somente faturamento atribuível às viagens. Bônus não
aumenta ticket médio, e passe não reduz artificialmente o faturamento bruto das
corridas. O resultado operacional poderá considerar separadamente:

```text
faturamento de corridas + bônus - passes e custos da plataforma
```

Esses eventos e sua reconciliação não fazem parte do resumo atual.

## 5.7 Lançamentos individuais

Um lançamento individual terá quantidade de viagens maior ou igual a 1 e valor
total em centavos maior ou igual a zero. Poderá representar uma ou várias
viagens. Quando representar várias, o sistema não inferirá nem persistirá
valores individuais.

No fluxo normal, `dataCriacao` preenchida automaticamente será o momento
operacional; não haverá outro campo `dataHora`. Quando registrado durante uma
Jornada, `jornadaId` será preenchido automaticamente, mas continuará opcional
para permitir lançamentos fora de Jornada.

Os acumulados apresentados durante uma Jornada serão calculados, por plataforma
e Jornada, com:

```
SUM(valorTotalCentavos)
SUM(quantidadeViagens)
```

Cada lançamento é um fato e pode representar uma ou várias viagens. Um lote não
permite inferir o valor de cada viagem. A interface operacional associa o
lançamento automaticamente à Jornada aberta, respeita plataformas individuais
ativas e não registra odômetro. Inativar depois preserva o histórico.

O resumo combina resultados acumulados calculáveis e totais individuais. Se
uma acumulada exigir revisão, os individuais continuam visíveis, mas os totais
gerais permanecem incompletos.

---

# 6. Controle de Plataformas e Passes

## 6.1 Uber

Modelo:

Compra de passe para liberar faturamento.

Exemplo:

Pagamento:

R$30

Liberação:

R$125

O sistema deve controlar:

* valor pago;
* valor liberado;
* valor faturado;
* valor restante.

Exemplo:

```
Passe Uber

Meta:
R$125

Faturado:
R$80

Falta:
R$45
```

---

## 6.2 99

Modelo:

Compra de passe que gera saldo negativo.

Exemplo:

Compra:

R$16,99

O sistema deve registrar:

```
Saldo do passe:
-R$16,99
```

Esse valor deve aparecer na tela inicial até ser compensado.

---

## 6.3 inDrive

Modelo:

Carteira de crédito.

Exemplo:

Usuário adiciona:

R$50

Cada corrida desconta a taxa da plataforma.

Exemplo:

Corrida:

R$20

Taxa:

10%

Desconto:

R$2

Novo saldo:

R$48

---

# 7. Eventos Financeiros

Todo movimento financeiro deve ser registrado.

Categorias:

* passe;
* crédito;
* combustível;
* manutenção;
* pedágio;
* estacionamento;
* multa;
* outros.

O evento deve conter:

* data;
* valor;
* categoria;
* plataforma quando aplicável;
* descrição.

Compras de passe e bônus ou promoções são eventos financeiros vinculados à
plataforma. Seus efeitos nos acumulados observados não possuem regra universal
e somente serão interpretados pela futura conferência/reconciliação.

---

# 8. Combustível

## 8.1 Abastecimento

Cada abastecimento deve registrar:

* data;
* odômetro;
* combustível;
* litros;
* valor pago.

---

## 8.2 Cálculo de Consumo

O sistema deve calcular:

```
quilômetros percorridos /
litros abastecidos
```

Resultado:

```
km/litro
```

---

## 8.3 Autonomia

A autonomia deve utilizar:

* média dos últimos abastecimentos;
* capacidade do tanque.

Exemplo:

```
Média:
8 km/l

Tanque:
41 litros

Autonomia:
328 km
```

---

# 9. Manutenção

Toda manutenção deve registrar:

* item;
* data;
* quilometragem;
* valor;
* próxima previsão.

---

# 10. Manutenção Preventiva

O sistema deve acompanhar:

Exemplo:

Troca de óleo:

Última:

152.000 km

Intervalo:

10.000 km

Próxima:

162.000 km

---

Quando aproximar:

Gerar alerta:

```
Troca de óleo próxima.
Faltam 500 km.
```

---

# 11. Alertas

O sistema deve gerar alertas automaticamente.

Tipos:

## Manutenção

Exemplo:

```
Pneus próximos do limite.
```

## Financeiro

Exemplo:

```
Passe Uber ainda não recuperado.
```

## Dados

Exemplo:

```
Jornada sem ganhos registrados.
```

## Operacional

Exemplo:

```
Odômetro inconsistente.
```

---

# 12. Cálculos de Eficiência

## Receita por quilômetro

```
Ganhos totais /
quilômetros rodados
```

---

## Custo por quilômetro

Considera:

* combustível;
* manutenção;
* pneus;
* depreciação;
* custos fixos.

```
Custos totais /
quilômetros rodados
```

---

## Lucro por quilômetro

```
Receita por km -
Custo por km
```

---

## Receita por hora

```
Ganhos totais /
tempo de operação
```

---

# 13. Virada de Dia

A jornada pode atravessar meia-noite.

O sistema não deve obrigatoriamente encerrar uma jornada automaticamente.

Motivo:

* Uber e 99 possuem comportamentos diferentes de fechamento;
* o motorista pode continuar trabalhando após meia-noite.

A data da leitura deve representar o instante observado pelo usuário. Como as
plataformas podem se comportar de formas diferentes, nenhum reset deve ser
inferido automaticamente.

---

# 14. Tela Inicial

A tela inicial deve apresentar:

## Jornada atual

* status;
* horário iniciado;
* quilômetros percorridos.

## Financeiro

* ganhos atuais;
* saldo de passes;
* créditos disponíveis.

## Combustível

* estimativa do tanque;
* autonomia restante.

## Alertas

Mostrar quantidade de alertas pendentes.

Exemplo:

```
🔔 3 alertas
```

---

# 15. Princípio de Dados

O aplicativo deve evitar obrigatoriedade excessiva.

O usuário pode corrigir informações.

Porém:

Quando uma informação importante estiver ausente:

O sistema deve:

* permitir continuar;
* informar a inconsistência;
* gerar alerta.

O objetivo é manter flexibilidade sem perder qualidade dos dados.
