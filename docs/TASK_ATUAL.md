# Tarefa atual — Jornada retroativa

## Estado

O fluxo normal de Jornada continua usando agora, odômetro e cidade sugeridos,
sem etapa obrigatória adicional. Data/hora pode ser alterada discretamente para
abertura ou fechamento tardio.

A Jornada aberta e a última Jornada finalizada podem ser corrigidas no local em
que são apresentadas. A alteração é validada integralmente antes de persistir,
considerando Jornadas vizinhas e fatos com instante operacional confiável.
Ganhos individuais são preservados, mas seu `dataCriacao` técnico não limita a
Jornada.

Quando a Leitura Inicial é observada depois do início retroativo, o resumo
indica cobertura financeira parcial e não apresenta indicadores gerais como se
cobrissem toda a Jornada. No fechamento reconstruído, `dataHora` da Leitura
Final é operacional e `dataCriacao` permanece técnica.

O schema permanece 8.

## Validação

Aguardando validação operacional no Android.
