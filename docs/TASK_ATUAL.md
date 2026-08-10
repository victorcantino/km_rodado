# Tarefa atual — Migração Drift do schema 1 para 2

## Objetivo

Estabelecer a base de dados aprovada para Pausas e futuras leituras de ganhos,
preservando instalações existentes.

## Escopo

- simplificar a tabela `Pausas`;
- substituir `Ganhos` por `LeiturasGanhos` e
  `LeituraGanhoPlataforma`;
- preservar `Plataformas`;
- adicionar a forma obrigatória de registro de ganhos em `Plataformas`;
- migrar plataformas legadas como `acumulado`;
- migrar dados legados sem inferir agrupamentos;
- gerar o código Drift;
- testar migração, integridade e constraints;
- atualizar a documentação do modelo.

## Fora do escopo

- interface e camadas funcionais de Pausas;
- interface de leituras de ganhos;
- viagens particulares;
- tabela e fluxo de lançamentos individuais;
- manutenção e abastecimento;
- timeline;
- regras automáticas de reset.

## Pronto quando

- schema 2 e migração preservadora estiverem implementados;
- dinheiro estiver armazenado em centavos;
- plataformas legadas forem preservadas como `acumulado`;
- constraints e FKs estiverem testadas;
- `build_runner`, análise e testes passarem;
- documentação representar o modelo aprovado.
