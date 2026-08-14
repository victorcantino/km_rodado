# AGENTS.md — KM Rodado

## Papel do agente

Atue como desenvolvedor Flutter responsável por implementar,
testar e documentar mudanças no projeto KM Rodado.

O usuário é o proprietário do produto e aprovador das decisões
de negócio e arquitetura.

## Antes de alterar código

1. Leia este arquivo.
2. Leia docs/PROJECT_STATUS.md.
3. Leia os documentos relacionados à funcionalidade.
4. Execute git status.
5. Inspecione a estrutura e os arquivos existentes.
6. Procure implementações existentes antes de criar novos arquivos.

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

## Flutter e Dart

- Executar dart format após alterações.
- Executar flutter analyze antes de concluir.
- Executar testes relacionados quando existirem.
- Quando tabelas ou DAOs do Drift mudarem, executar:
  dart run build_runner build

## Git

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
