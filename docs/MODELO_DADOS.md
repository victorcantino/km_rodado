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

Representa períodos sem operação dentro da jornada.

Exemplos:

* academia
* almoço
* descanso
* estudo

```
PAUSA
---------
id

jornada_id

inicio
fim

motivo

observacao
```

---

# 5. Ganhos

Representa os valores informados das plataformas.

> Pendência de modelagem: a documentação relaciona o ganho diretamente à
> jornada, enquanto a tabela Drift atual exige uma pausa. A relação definitiva
> entre Ganho, Jornada e Pausa será decidida em uma tarefa futura; este documento
> não deve ser usado para alterar essas entidades antes dessa decisão.

O registro pode ser parcial durante a jornada.

Exemplo:

10h:
Uber mostrando R$80

18h:
Uber mostrando R$250

```
GANHO
---------
id

jornada_id

data_hora

plataforma

valor

quantidade_corridas

tipo_registro
```

Plataformas:

```
UBER
99
INDRIVE
PARTICULAR
OUTRO
```

Tipo:

```
PARCIAL
FINAL
```

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
          |        +---- GANHO
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
* ganhos
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
