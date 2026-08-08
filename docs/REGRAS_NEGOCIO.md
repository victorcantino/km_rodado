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

Uma pausa pertence a uma jornada.

Ao iniciar uma pausa:

O sistema deve registrar:

* horário inicial;
* motivo opcional.

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

# 5. Registro de Ganhos

## 5.1 Conceito

O ganho não representa uma corrida individual.

Ele representa uma leitura da plataforma em determinado momento.

Exemplo:

10:00

Uber mostra:

R$80

18:00

Uber mostra:

R$250

---

# 5.2 Plataformas

O sistema deve permitir:

* Uber;
* 99;
* inDrive;
* Particular;
* outras plataformas futuras.

---

# 5.3 Registro Parcial

Durante a jornada o usuário pode registrar ganhos várias vezes.

Exemplo:

```
Pausa almoço

Uber:
R$120

99:
R$80

Corridas:
15
```

---

# 5.4 Registro Final

Ao finalizar a jornada:

O usuário deve informar os ganhos finais das plataformas utilizadas.

Caso nenhuma plataforma seja informada:

Gerar alerta:

```
Jornada finalizada sem registro de ganhos.
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

A data do ganho deve ser baseada no momento em que o registro foi feito.

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
