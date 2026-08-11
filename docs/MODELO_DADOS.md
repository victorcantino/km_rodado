# Modelo de Dados — KM Rodado

## 1. Usuário

Representa o usuário do aplicativo.

```
USUARIO
---------
id
nome
email
senha
data_criacao
```

---

# 2. Veículo

Representa o veículo utilizado na operação.

```
VEICULO
---------
id
usuario_id

marca
modelo
ano
placa

data_compra
quilometragem_compra
valor_compra

valor_venda_estimado

capacidade_tanque

ativo
observacoes
```

---

# 3. Jornada

Representa o período de trabalho do motorista.

É a entidade principal da operação.

```
JORNADA
---------
id
usuario_id
veiculo_id

data_inicio
hora_inicio

data_fim
hora_fim

odometro_inicio
odometro_fim

cidade_origem
cidade_destino

status

observacoes
```

Status:

```
ABERTA
PAUSADA
FINALIZADA
```

Uma jornada pode conter:

* pausas
* registros de ganhos
* eventos
* informações automáticas
* alertas

---

# 4. Pausa da Jornada

Pausa a atividade do motorista como um todo, não uma plataforma específica.

```
PAUSA
---------
id

jornada_id

inicio
fim

odometro_inicio
odometro_fim

titulo

observacao
data_criacao
```

`fim` e `titulo` são opcionais. Sem título, a interface pode apresentar
`Pausa 1`, `Pausa 2` etc. A duração é derivada e não é persistida.

---

# 5. Leituras de ganhos

Uma leitura representa uma única observação dos acumulados exibidos pelas
plataformas naquele momento. Ela exige Jornada e pode estar associada a uma
Pausa.

```
LEITURA_GANHOS
--------------
id
jornada_id
pausa_id (opcional)
data_hora
tipo
data_criacao
```

Tipos: `INICIAL`, `PARCIAL` e `FINAL_DA_JORNADA`. A leitura inicial estabelece
a base, a parcial registra o estado durante a Jornada e a final antecede seu
fechamento.

Cada plataforma observada é um item da leitura:

```
LEITURA_GANHO_PLATAFORMA
------------------------
id
leitura_ganhos_id
plataforma_id
valor_acumulado_centavos
quantidade_viagens_acumulada
```

Dinheiro é persistido em centavos. Valores e viagens do período são derivados
da diferença entre leituras. Uma plataforma acumulada pode reaparecer sem
mudança em outra leitura, mas somente uma vez dentro da mesma leitura.

## 5.1 Plataforma e forma de registro

```
PLATAFORMA
----------
id
nome
tipo_registro_ganhos
icone
cor
ativa
ordem
data_criacao
```

`tipo_registro_ganhos` pode ser `ACUMULADO` ou `INDIVIDUAL`. Uber, 99 e
inDrive usam o mecanismo acumulado. Particular continua sendo plataforma e
fonte de ganho, mas usa o mecanismo individual. Nenhuma regra depende do nome
da plataforma.

Plataformas individuais continuarão aparecendo com as demais em dashboards,
pausas, fechamento e relatórios. A diferença é somente a fonte dos totais.

## 5.2 Lançamento individual futuro

```
LANCAMENTO_GANHO_INDIVIDUAL
---------------------------
id
plataforma_id
jornada_id (opcional)
quantidade_viagens
valor_total_centavos
observacao (opcional)
data_criacao
```

Não haverá `data_hora` separado no fluxo normal: `data_criacao` será o momento
operacional do lançamento. Um lançamento poderá representar uma ou várias
viagens, sem inferir ou persistir valores individuais. Durante uma Jornada, os
totais serão derivados por `SUM(valor_total_centavos)` e
`SUM(quantidade_viagens)` para a plataforma e a Jornada correspondentes.

Essa tabela ainda não integra o schema 2. Nenhum reset de plataforma é inferido
automaticamente.

---

# 6. Evento Financeiro

Representa movimentações financeiras.

Exemplos:

* compra de passe Uber
* compra de passe 99
* crédito inDrive
* pedágio
* estacionamento
* multa
* outros custos

```
EVENTO_FINANCEIRO
---------
id

usuario_id
veiculo_id

jornada_id (opcional)

data_hora

categoria

plataforma

tipo_movimento

valor

descricao
```

Categorias:

```
PASSE_UBER
PASSE_99
CREDITO_INDRIVE

ABASTECIMENTO
MANUTENCAO
PEDAGIO
ESTACIONAMENTO
MULTA
OUTROS
```

Tipo:

```
ENTRADA
SAIDA
CREDITO
DEBITO
```

---

# 7. Carteira Plataforma

Controla créditos, passes e saldos das plataformas.

```
CARTEIRA_PLATAFORMA
---------
id

usuario_id

plataforma

tipo

saldo_atual

limite_contratado

data_inicio

data_fim
```

Exemplos:

Uber:

```
Passe:
R$30 pago

Limite:
R$125 faturamento
```

99:

```
Passe:
-R$16,99
```

inDrive:

```
Crédito:
R$50
```

---

# 8. Abastecimento

Controle de combustível.

```
ABASTECIMENTO
---------
id

veiculo_id
jornada_id (opcional)

data

odometro

combustivel

litros

valor_litro

valor_total

km_litro

autonomia_estimada
```

Combustível:

```
ETANOL
GASOLINA
OUTRO
```

---

# 9. Manutenção

Registro de manutenções realizadas.

```
MANUTENCAO
---------
id

veiculo_id
jornada_id (opcional)

data

odometro

categoria

item

descricao

valor

vida_util_km

proxima_km
```

Exemplos:

* troca de óleo
* pneus
* freios
* filtros
* bateria

---

# 10. Item de Manutenção

Controle preventivo dos componentes.

```
ITEM_MANUTENCAO
---------
id

veiculo_id

nome

ultima_troca_km

vida_prevista_km

proxima_troca_km

observacoes
```

Exemplos:

```
PNEU
OLEO
FILTRO
PASTILHA
DISCO
BATERIA
PALHETA
LAMPADA
```

---

# 11. Registro de Contexto

Informações coletadas automaticamente.

Exemplos:

* temperatura
* clima
* localização
* Bluetooth conectado
* veículo em movimento

```
CONTEXTO
---------
id

jornada_id

data_hora

tipo

dados
```

Tipos:

```
CLIMA
LOCALIZACAO
MOVIMENTO
BLUETOOTH
SENSOR
```

Campo dados:

Formato JSON.

Exemplo:

```
{
 temperatura:18,
 condicao:"Nublado",
 umidade:80
}
```

---

# 12. Alerta

Sistema de notificações.

Exemplos:

* manutenção próxima
* dados incompletos
* saldo negativo
* erro de registro

```
ALERTA
---------
id

usuario_id

veiculo_id

jornada_id (opcional)

tipo

nivel

titulo

mensagem

data_criacao

resolvido
```

Tipos:

```
MANUTENCAO
FINANCEIRO
OPERACIONAL
DADOS_INCOMPLETOS
```

Níveis:

```
INFO
ATENCAO
CRITICO
```

---

# 13. Configuração

Preferências e parâmetros do usuário.

```
CONFIGURACAO
---------
id

usuario_id

custo_km_base

meta_km_dia

capacidade_tanque

cidade_padrao

```

---

# Relacionamentos

```
USUARIO
 |
 |
 +---- VEICULO
          |
          |
          +---- JORNADA
          |        |
          |        +---- PAUSA
          |        |
          |        +---- LEITURA_GANHOS
          |        |        |
          |        |        +---- LEITURA_GANHO_PLATAFORMA
          |        |
          |        +---- CONTEXTO
          |        |
          |        +---- ALERTA
          |
          +---- ABASTECIMENTO
          |
          +---- MANUTENCAO
          |
          +---- ITEM_MANUTENCAO
          |
          +---- EVENTO_FINANCEIRO
                    |
                    +---- CARTEIRA_PLATAFORMA
```

---

# Conceito principal

O KM Rodado é organizado em três áreas:

## Operação

Responsável pela jornada:

* quilômetros
* pausas
* leituras de ganhos acumulados
* produtividade

## Financeiro

Responsável pelo dinheiro:

* receitas
* custos
* passes
* créditos
* despesas

## Inteligência

Responsável pelas análises:

* custo por km
* lucro por km
* alertas
* previsões
* indicadores

```
JORNADA
   |
   |
OPERAÇÃO
   |
   +---- FINANCEIRO
   |
   +---- INTELIGÊNCIA
```
