# AGENTS.md — KM Rodado

## Papel do agente

Atue como desenvolvedor Flutter responsável por implementar,
testar e documentar mudanças no projeto KM Rodado.

O usuário é o proprietário do produto e aprovador das decisões
de negócio e arquitetura.

## Documento principal e antes de alterar código

Este arquivo é o índice e o orquestrador das convenções do projeto. Leia-o
primeiro e, conforme a tarefa, leia os documentos específicos abaixo. Não
duplique aqui regras detalhadas mantidas nesses documentos.

Quando uma orientação se repetir em prompts, causar regressão recorrente ou se
tornar um padrão estável do produto, consolide-a em documentação persistente e
referencie-a aqui. Não crie documentação especulativa sem necessidade real.

1. Leia este arquivo.
2. Leia docs/PROJECT_STATUS.md.
3. Leia os documentos relacionados à funcionalidade.
4. Execute git status.
5. Inspecione a estrutura e os arquivos existentes.
6. Procure implementações existentes antes de criar novos arquivos.
7. Antes de alterações de UI, leia [`docs/CONVENCOES_UX.md`](docs/CONVENCOES_UX.md)
   e o documento específico aplicável:
   - formulários: [`docs/CONVENCOES_FORMULARIOS.md`](docs/CONVENCOES_FORMULARIOS.md);
   - listas: [`docs/CONVENCOES_LISTAS.md`](docs/CONVENCOES_LISTAS.md);
   - regras financeiras: [`docs/CONVENCOES_FINANCEIRAS.md`](docs/CONVENCOES_FINANCEIRAS.md);
   - fatos e correções temporais: [`docs/CONVENCOES_TEMPORAIS.md`](docs/CONVENCOES_TEMPORAIS.md);
   - testes: [`docs/CONVENCOES_TESTES.md`](docs/CONVENCOES_TESTES.md).
8. Para tarefas envolvendo commit, fechamento de branch, criação de PR,
   merge ou sincronização, consulte e siga
   [`docs/CONVENCOES_GIT_PR.md`](docs/CONVENCOES_GIT_PR.md).

## Regras obrigatórias

- Não alterar arquitetura, nomes ou pastas sem justificar.
- Não criar classes ou arquivos duplicados.
- Não criar abstrações para necessidades futuras.
- Implementar apenas o necessário para a tarefa atual.
- Não editar arquivos gerados, como *.g.dart.
- Não adicionar dependências sem explicar a necessidade.
- Não remover ou mover arquivos silenciosamente.
- Preservar regras de negócio já documentadas.
- Usar nomes em português no domínio do negócio.
- Explicar decisões importantes em linguagem acessível.
- Alterações materiais de feature devem atualizar os documentos afetados.
- Revisar o README quando mudar significativamente o conjunto público de
  funcionalidades.
- Nunca declarar documentação atualizada sem confrontá-la com código e schema.

## Convenções permanentes

Os documentos de convenções listados acima fazem parte das instruções
obrigatórias. `docs/CONVENCOES_UX.md` concentra princípios visuais; os demais
detalham formulários, listas, finanças, temporalidade, testes e Git/PR.

O projeto não precisa se limitar a implementações didáticas ou voltadas a
iniciantes. Bibliotecas maduras, mantidas e compatíveis podem ser usadas
quando reduzirem complexidade e melhorarem a manutenção. Toda dependência nova
exige justificativa concreta; não adicionar pacote apenas para evitar poucas
linhas simples. Preferir soluções compreensíveis por uma pessoa desenvolvedora
e fáceis de manter.

## Flutter e Dart

- Executar dart format após alterações.
- Executar flutter analyze antes de concluir.
- Executar testes relacionados quando existirem.
- Quando tabelas ou DAOs do Drift mudarem, executar:
  dart run build_runner build

## Git

- Tarefas de commit, fechamento de branch, PR, merge ou sincronização devem
  consultar e seguir `docs/CONVENCOES_GIT_PR.md`.
- Trabalhar em uma única funcionalidade por vez.
- Não fazer commit sem solicitação do usuário.
- Antes do commit, apresentar resumo dos arquivos alterados.
- Não descartar alterações existentes do usuário.
- Pull requests devem ter título e descrição.
- Quando houver mudança de banco, a PR deve registrar o schema anterior, o novo
  schema e a estratégia de migração.

## Definição de concluído

Uma tarefa só está concluída quando:

- o comportamento solicitado foi implementado;
- o projeto está formatado;
- flutter analyze não apresenta erros relacionados;
- os testes relevantes passaram;
- a documentação de estado foi atualizada;
- o agente apresentou um resumo das mudanças e limitações.
