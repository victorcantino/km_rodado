# Tarefa atual — Baseline inicial e conciliação simples

## Estado

Toda Leitura Inicial declara os acumulados do início da Jornada:
`LeituraGanhos.dataHora` recebe `Jornada.dataHoraInicio` e `dataCriacao` mantém
o instante técnico do salvamento. Isso vale tanto no fluxo automático quanto
no registro posterior de ganhos iniciais pendentes.

Sem Leitura Inicial, o estado permanece “Ganhos iniciais pendentes”. Não existe
conceito operacional de cobertura financeira parcial nem bloqueio por diferença
entre timestamps. Passe, Bônus/Promoção e Pausa não criam snapshots. A
interpretação simples de Passes recompõe o custo já
refletido no acumulado da 99 e mantém o Passe da Uber separado da variação. Não
houve mudança de schema nem implementação de módulo de Conciliação.

## Validação

Implementação concluída, análise estática limpa e 211 testes automatizados
aprovados. Schema permanece 12; aguardando validação operacional no Android.
