# Tarefa atual — Cobertura dos custos

## Estado

Implementada a primeira visualização derivada de Cobertura dos custos na página
de Despesas. O diagnóstico cobre combustível, manutenção, depreciação, seguro,
IPVA, licenciamento, telefone profissional, outros custos recorrentes e parcela
do veículo separada como obrigação de caixa. Estados: Informado, Estimado e
Não informado. Não há percentual de confiança, persistência redundante,
Motor Econômico ou Planejamento Mensal.

O resumo intraday da Jornada permanece implementado conforme o histórico desta
branch.

## Resumo intraday — estado preservado

Durante a Jornada aberta, a `JornadaPage` apresenta um resumo acumulado desde a
Leitura Inicial até o último checkpoint salvo. Tempo total, Pausas, tempo
ativo, distância segura e métricas financeiras compartilham a mesma referência
temporal. Passes e Bônus/Promoções são recortados no checkpoint e reconciliados
pelas regras atuais de 99 e Uber.

O resumo é derivado e preserva todas as Leituras intermediárias. Ganhos
individuais possuem `dataHora` operacional e entram quando pertencem ao período
entre o início da Jornada e o checkpoint, sem virar `LeituraGanhos`. Sem Leitura
Inicial permanece o estado “Ganhos iniciais pendentes”.

O schema evoluiu de 12 para 13. Registros individuais legados preservam os
dados e recebem `dataHora = dataCriacao` como aproximação técnica. Passes e
Bônus/Promoções possuem consulta compartilhada, cadastro separado, edição e
exclusão dentro da edição, sem módulo de Conciliação.

## Validação

Implementação em validação automatizada. Schema 13; aguardando validação
operacional no Android e validação final no ambiente local do usuário.
