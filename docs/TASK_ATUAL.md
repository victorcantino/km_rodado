# Tarefa atual — Bônus/Promoções e reconciliação

## Estado

Implementada a primeira versão de créditos promocionais observados, com
cadastro retroativo, Jornada opcional e apresentação separada no resumo.
Plataformas acumuladas são reconciliadas por intervalos consecutivos; ticket
médio usa somente receita atribuível às viagens.

Créditos anteriores ou exatamente no baseline permanecem fora da associação
com a Jornada e não são subtraídos novamente da variação. A competência
econômica de bônus permanece futura.

O schema evolui de 7 para 8 com migração preservadora. Esta etapa não infere
resets nem o efeito de Passes sobre snapshots.

## Validação

Aguardando validação operacional no Android após a suíte automatizada.
