# Tarefa atual — Leitura inicial e final da Jornada

## Objetivo

Completar o ciclo de Leituras de Ganhos no schema 2 existente.

## Escopo

- solicitar leitura inicial após persistir a Jornada;
- manter a Jornada quando a leitura inicial for cancelada;
- restaurar e apresentar o estado de ganhos iniciais pendentes;
- impedir leituras parciais e final sem a base inicial;
- preservar as leituras parciais durante Pausas;
- sugerir na leitura final a última leitura da própria Jornada;
- coletar todos os dados antes de persistir o encerramento;
- salvar leitura final e fechamento da Jornada atomicamente;
- impedir mais de uma leitura inicial ou final por Jornada;
- manter plataformas individuais apenas informativas.

## Fora do escopo

- lançamentos individuais;
- alteração do schema 2;
- cálculos financeiros, diferenças e dashboards;
- configuração de plataformas por Jornada;
- redesign geral da Jornada.

## Pronto quando

- a inicial estabelecer a base sem herdar dados da Jornada anterior;
- uma inicial pendente sobreviver ao reinício sem dados inventados;
- parciais exigirem a inicial e continuarem funcionando depois dela;
- cancelar qualquer diálogo de encerramento não alterar a Jornada;
- leitura final e fechamento forem confirmados ou revertidos juntos;
- análise, testes e documentação representarem o comportamento entregue.
