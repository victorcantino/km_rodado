# Convenções de testes

- Durante a implementação, executar testes focados da área alterada.
- Antes de fechar a branch, executar a suíte completa.
- `flutter analyze` e `git diff --check` são validações obrigatórias.
- Bugs reais encontrados no Android devem ganhar testes de regressão.
- Não alterar um teste apenas para mascarar um bug real.
- Alterações de UI devem cobrir telas estreitas quando houver risco de
  overflow.
- Preservar casos históricos e retroativos relevantes nos testes.
