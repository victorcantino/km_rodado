# Arquitetura do KM Rodado

## Estado atual

Aplicativo Flutter offline-first, com persistência local em SQLite por Drift.
A estrutura cresce apenas quando uma necessidade é implementada.

```text
app/lib/
├── core/
│   ├── constants/enums/
│   └── database/
│       ├── daos/
│       ├── seeds/
│       ├── tables/
│       ├── app_database.dart
│       └── app_database.g.dart
├── features/
│   ├── abastecimento/
│   ├── despesa_veiculo/
│   ├── custo_recorrente/
│   ├── depreciacao_veiculo/
│   ├── ganho_individual/
│   ├── jornada/
│   ├── leitura_ganhos/
│   ├── manutencao/
│   ├── passe_plataforma/
│   └── pausa/
└── main.dart
```

Cada feature mantém apenas as pastas necessárias. Hoje elas usam `data/` para
service/repository e `presentation/` para controller e widgets/pages.

## Fluxo de responsabilidades

```text
Page → Controller → Service → Repository → DAO → Drift → SQLite
```

- Page/widget: interação e apresentação.
- Controller: estado observável e coordenação da interface.
- Service: validações e regras de negócio.
- Repository: fronteira entre regra e persistência.
- DAO: consultas e transações Drift.
- Drift/SQLite: schema e armazenamento local.

O projeto usa `ChangeNotifier` com `AnimatedBuilder`, injeção manual e
navegação direta com `Navigator`/`MaterialPageRoute`. Não há Provider, Riverpod,
Bloc ou go_router no código da aplicação. Uma troca só deve ocorrer diante de
necessidade concreta, sem criar abstrações antecipadas.

## Banco e funcionamento offline

O schema atual é 14. O banco é criado localmente e suas migrações preservam
instalações anteriores. Seeds idempotentes garantem os dados temporários de
usuário/veículo e as plataformas padrão sem sobrescrever registros existentes.

Sincronização, API e nuvem são possibilidades futuras, não componentes da
arquitetura atual.

## Features planejadas

Eventos financeiros adicionais, relatórios, notificações, localização e
sincronização permanecem no backlog. Diretórios futuros não são documentados
como estrutura existente.
