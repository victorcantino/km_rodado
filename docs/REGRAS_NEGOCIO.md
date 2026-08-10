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

O odômetro final deve ser obrigatoriamente maior que o odômetro inicial.

```text
odometro_fim > odometro_inicio
```

Os quilômetros percorridos devem ser calculados por:

```text
odometro_fim - odometro_inicio
```

Uma Jornada não pode ser finalizada com zero ou com quilômetros negativos.

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

Ao iniciar uma pausa:

O sistema deve registrar:

* horário inicial;
* título opcional.

Sem título, a interface pode apresentar `Pausa 1`, `Pausa 2` etc. A duração é
derivada de início e fim e não deve ser persistida.

Antes de finalizar a pausa:

O sistema deve sugerir o registro dos ganhos.

Exemplo:

```
Deseja registrar os ganhos deste período?
```

O preenchimento não deve ser obrigatório.

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

---

# 5.3 Tipos de leitura

* inicial: estabelece a base no início da Jornada;
* parcial: registra o estado durante a Jornada, normalmente em uma Pausa;
* final da Jornada: registra o estado antes do fechamento.

Uma leitura exige Jornada e pode ter Pausa. Quando houver Pausa, ela deverá
pertencer à mesma Jornada da leitura.

---

# 5.4 Valores e leitura final

Valores monetários acumulados são armazenados em centavos inteiros. Quantidade
acumulada de viagens também é inteira e não negativa. Cada plataforma aparece
no máximo uma vez na mesma leitura.

Antes de finalizar a Jornada, o usuário deve realizar a leitura final das
plataformas utilizadas. Ela não depende da existência de uma Pausa.

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

# 5.5 Lançamentos individuais futuros

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
