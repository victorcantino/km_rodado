# Tarefa atual — Limpeza estrutural após Jornada

## Objetivo

Revisar a estrutura atual do projeto após a conclusão da primeira feature
completa e remover somente arquivos, pastas e scaffolding que não possuem
utilidade no estado atual.

## Princípio

O projeto deve crescer conforme a necessidade.

Não manter estruturas vazias ou abstrações criadas apenas para possíveis
necessidades futuras.

## Escopo

Revisar:

- `app/lib/core`;
- `app/lib/features`;
- diretórios globais em `app/lib`;
- arquivos vazios;
- pastas vazias;
- estruturas arquiteturais concorrentes;
- imports e referências dos arquivos candidatos.

## Regras

- Não alterar o comportamento da feature Jornada.
- Não alterar regras de negócio.
- Não reorganizar código funcional apenas por estética.
- Não remover tabelas registradas no banco sem analisar impacto no schema.
- Não editar arquivos `.g.dart` manualmente.
- Não adicionar dependências.
- Não criar novas abstrações.
- Não implementar novas features.
- Preservar documentação necessária.
- Preferir remover scaffolding antecipado.
- Toda remoção precisa ter justificativa objetiva.

## Pronto quando

- arquivos e pastas sem uso foram identificados;
- estruturas concorrentes foram avaliadas;
- somente o que for comprovadamente desnecessário foi removido;
- Jornada continua funcionando;
- `flutter analyze` passa;
- `flutter test` passa;
- `git diff --check` passa;
- documentação representa a estrutura final.

## Removido

- constantes e enums vazios ou sem referência;
- enum fixo de Plataforma não utilizado;
- router e tema vazios;
- seed vazio de plataformas;
- tabela incompleta de Evento Financeiro, que não integrava o schema;
- diretórios vazios de core, features futuras, Jornada e estruturas globais;
- artefatos ignorados em `app/lib/.dart_tool`.

## Preservado

- toda a feature Jornada;
- banco, DAO e arquivos gerados;
- tabelas de Configuração, Pausa, Plataforma e Ganho já registradas no schema;
- seed temporário ativo de usuário e veículo.

## Estrutura resultante

A árvore física contém somente a infraestrutura ativa, a feature Jornada e as
tabelas já integrantes do schema. Features futuras permanecem documentadas no
planejamento e só terão diretórios quando sua implementação começar.
