# Tarefa atual — Planejamento Mensal

Implementada a primeira versão do Planejamento Mensal. O mês de referência,
os dias planejados e a meta mensal de km são persistidos; média planejada,
progresso, dias trabalhados, km restantes e média necessária são derivados no
Service. Jornadas concluídas pertencem ao mês da `dataHoraInicio`, inclusive
quando atravessam meia-noite ou mudam de mês; não há rateio sem checkpoints.

O schema evoluiu de 13 para 14 com a tabela `planejamentos_mensais` e migração
de criação preservadora.

## Validação

Implementação em validação automatizada e teste operacional Android.

## Estado anterior preservado
O resumo intraday, Cobertura dos custos, abastecimentos, Passes/Bônus e
Histórico da Jornada permanecem implementados conforme documentado em
`PROJECT_STATUS.md`. Motor Econômico e regras de rateio de custos continuam
fora deste pacote.
