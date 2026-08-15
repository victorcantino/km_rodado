# Tarefa atual — Navegação dos formulários

## Estado

Os formulários operacionais atuais usam `Próximo` para avançar somente entre
campos editáveis, sem parar em botões, ícones, seletores, calendários ou outros
controles auxiliares. O último campo usa `Done` e apenas encerra o foco, sem
salvar automaticamente.

Fluxos lineares usam a navegação nativa do Flutter. Formulários com controles
intermediários ou campos condicionais possuem foco explícito local ao diálogo,
com ciclo de vida ligado ao respectivo `State`.

O schema permanece 8.

## Validação

Aguardando validação operacional do teclado no Android após a suíte
automatizada.
