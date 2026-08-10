# Tarefa atual — Primeira entrega funcional de Pausas

## Objetivo

Implementar o ciclo completo de uma Pausa durante uma Jornada, sem alterar o
schema 2 e sem iniciar o fluxo de ganhos.

## Escopo

- iniciar e persistir Pausa imediatamente;
- restaurar Pausa aberta após reinício;
- impedir Pausas simultâneas na mesma Jornada;
- mostrar início e duração derivada sem segundos;
- editar título opcional com normalização;
- finalizar Pausa e persistir o fim;
- listar e numerar Pausas cronologicamente;
- impedir o fechamento da Jornada com Pausa aberta;
- integrar as ações na `JornadaPage`;
- testar regras, persistência e formatação.

## Fora do escopo

- registro de ganhos ao pausar;
- leituras inicial, parcial ou final;
- lançamentos individuais;
- categorias ou tags de Pausa;
- redesign geral da Jornada;
- alteração do schema 2.

## Pronto quando

- a Pausa sobreviver ao reinício do aplicativo;
- somente uma Pausa puder permanecer aberta por Jornada;
- duração e títulos derivados forem apresentados corretamente;
- a Jornada só puder ser fechada após retomar;
- análise e testes passarem;
- documentação representar o fluxo implementado.
