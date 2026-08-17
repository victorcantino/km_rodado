# Tarefa atual — Depreciação do veículo

## Estado

Primeira versão derivada por veículo, com cenários observado e projetado,
configuração parcial, identificação de valores aproximados e escolha opcional
do método principal. O valor em R$/km não é persistido. A referência observada
fica estável até edição explícita e o odômetro operacional é somente sugestão.

O schema evolui de 11 para 12 por migração aditiva e preservadora. A feature
segue o fluxo Page → Controller → Service → Repository → DAO → Drift e aparece
como seção própria no contexto econômico do veículo, sem se confundir com
Despesa ou Custo Recorrente.

## Validação

Implementação, migração e suíte automatizada concluídas. Aguardando validação
operacional no Android.
