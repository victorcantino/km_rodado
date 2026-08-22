# Convenções de Git e PR

Este é o padrão oficial de PR do projeto. Não criar formatos alternativos
quando esta estrutura atender; manter a apresentação objetiva.

## Resumo

O que esta PR entrega.

## Regras/decisões

Mudanças de negócio ou arquitetura relevantes. Use “Nenhuma” quando não houver.

## Banco/migração

Schema anterior → novo schema e estratégia, quando aplicável. Caso contrário:
“Sem alteração de schema”.

## Testes

- [ ] `flutter analyze`
- [ ] `flutter test`
- [ ] `git diff --check`
- [ ] Teste manual relevante (descrever ou marcar não aplicável)

## Riscos / pendências

O que deliberadamente ficou fora.

Quando não houver mudança de banco, usar “Sem alteração de schema”. Quando não
houver regra ou decisão relevante, usar “Nenhuma”.

## Processo

- Partir de uma `main` atualizada e usar uma branch por tarefa.
- Quando o ambiente do Codex tiver limitações, o usuário executa as operações
  Git necessárias.
- Conferir o diff staged antes do commit.
- Depois do merge, atualizar a `main`, apagar a branch local e remota e usar
  `fetch --prune` para limpar referências.
