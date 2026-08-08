# Arquitetura do Projeto — KM Rodado

## Visão Geral

O KM Rodado será um aplicativo mobile desenvolvido em Flutter.

O objetivo é auxiliar motoristas profissionais no controle operacional e financeiro da atividade, permitindo:

- controle de jornadas;
- acompanhamento de ganhos;
- controle de combustível;
- controle de manutenção;
- cálculo de custos;
- análise de produtividade.

O aplicativo será desenvolvido inicialmente com funcionamento offline, utilizando banco de dados local.

---

# Arquitetura Geral

O projeto segue uma arquitetura organizada por funcionalidades (Feature Based
Architecture). A estrutura física cresce somente quando uma necessidade é
implementada.

## Estrutura física atual

```text
lib/
├── core/
│   ├── constants/
│   │   └── enums/
│   │       └── status_jornada.dart
│   └── database/
│       ├── daos/
│       ├── seeds/
│       ├── tables/
│       ├── app_database.dart
│       └── app_database.g.dart
├── features/
│   └── jornada/
│       ├── data/
│       └── presentation/
│           ├── controllers/
│           ├── pages/
│           └── widgets/
└── main.dart
```

Arquivos e diretórios sem implementação não são mantidos apenas para reservar
espaço para funcionalidades futuras.

## Features planejadas

As seguintes features fazem parte do planejamento, mas ainda não possuem
diretórios na árvore física:

- dashboard;
- abastecimento;
- manutenção;
- financeiro;
- relatórios;
- configurações.

Seus diretórios serão criados quando a implementação de cada feature começar.


---

# Organização por Feature

Cada módulo possuirá suas próprias responsabilidades.

Exemplo:


jornada/

├── data
│ ├── jornada_repository.dart
│ └── jornada_service.dart
│
└── presentation
  ├── controllers
  ├── pages
  └── widgets


---

# Camadas

O projeto será dividido em camadas:

## Presentation

Responsável pela interface.

Exemplos:

- telas;
- componentes;
- formulários;
- indicadores.


## Business

Responsável pelas regras.

Exemplos:

- cálculo de custo por km;
- cálculo de lucro;
- validação de jornada;
- controle de saldo das plataformas.


## Data

Responsável pelos dados.

Exemplos:

- banco SQLite;
- armazenamento;
- consultas;
- persistência.

---

# Banco de Dados

Primeira versão:

SQLite local.

Motivos:

- funcionamento offline;
- rapidez;
- confiabilidade;
- adequado para uso em veículo.

Possível evolução:

Flutter

↓

API REST

↓

PostgreSQL

↓

Sincronização em nuvem

---

# Gerenciamento de Estado

Na primeira feature será utilizado ChangeNotifier com AnimatedBuilder.

A escolha de uma solução para outras etapas será revisada após a conclusão da
Jornada. Não há Provider, Riverpod ou Bloc integrados ao fluxo atual.

---

# Princípio Offline First

O aplicativo deve funcionar mesmo sem conexão.

O motorista pode:

- iniciar jornada;
- registrar ganhos;
- abastecer;
- registrar manutenção;
- consultar indicadores.

A sincronização será uma evolução futura.

---

# Objetivo Profissional

O projeto será desenvolvido seguindo boas práticas utilizadas no mercado:

- versionamento Git;
- documentação;
- arquitetura escalável;
- separação de responsabilidades;
- código organizado;
- testes automatizados futuramente.

---

# Evolução planejada

## Versão 1

Controle pessoal:

- jornada;
- ganhos;
- combustível;
- manutenção;
- indicadores.


## Versão 2

Inteligência:

- previsões;
- alertas;
- análises avançadas.


## Versão 3

Produto:

- usuários;
- nuvem;
- sincronização;
- publicação.
