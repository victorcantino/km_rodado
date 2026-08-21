# Convenções de Git e PR

- Partir de uma `main` atualizada e usar uma branch por tarefa.
- Quando o ambiente do Codex tiver limitações, o usuário executa as operações
  Git necessárias.
- Conferir o diff staged antes do commit.
- PRs devem conter as seções: Contexto, Alterações, Regras preservadas,
  Validação e Validação manual.
- Depois do merge, atualizar a `main`, apagar a branch local e remota e usar
  `fetch --prune` para limpar referências.

O processo é permanente; comandos específicos podem variar conforme o ambiente.
