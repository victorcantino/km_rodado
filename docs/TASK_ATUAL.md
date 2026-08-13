# Tarefa atual — Abastecimentos

## Objetivo

Registrar abastecimentos de forma rápida no uso operacional, dentro ou fora de
uma Jornada.

## Escopo

- dados monetários, volume e preço armazenados como inteiros;
- associação automática à Jornada aberta, quando existir;
- progressão do odômetro protegida pela regra de negócio;
- cálculo auxiliar explícito entre volume, preço e total;
- schema 6, instante operacional distinto da criação e consulta do último
  abastecimento.

## Fora do escopo

- edição e exclusão histórica;
- consumo, autonomia, custo por quilômetro e previsões;
- cadastro próprio de postos e integração com localização;
- módulo financeiro geral e redesign.
