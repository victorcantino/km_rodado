# Tarefa atual — Evolução da Cobertura dos Custos

Implementado o diagnóstico derivado de Cobertura dos custos, agora enriquecido
com referências seguras de combustível, manutenção, depreciação e custos
recorrentes. O diagnóstico não persiste cobertura, não calcula confiança e não
é o Motor Econômico. Itens não informados direcionam para os cadastros já
existentes quando há formulário apropriado. Manutenção e Parcela reutilizam
seus fluxos existentes; Outros custos recorrentes são agregados somente quando
seus valores e periodicidades permitem o R$/km planejado, com contagem dos
itens incluídos.

O schema permanece em 14. A meta do Planejamento Mensal continua sendo apenas
uma referência planejada para custos recorrentes mensais; não há novo rateio
econômico nesta frente.

## Validação

Implementação em validação automatizada e teste operacional Android. A
validação desta revisão depende da disponibilidade local do SDK Flutter.

## Estado anterior preservado
O resumo intraday, abastecimentos, Passes/Bônus e Histórico da Jornada
permanecem implementados conforme documentado em `PROJECT_STATUS.md`. Motor
Econômico e regras econômicas finais continuam fora deste pacote.
