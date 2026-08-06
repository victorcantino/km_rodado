# Tarefa atual — Abertura de jornada

## Objetivo

Concluir o fluxo de abertura de jornada pela interface após a estabilização da
base técnica.

## Contexto

A JornadaPage utiliza JornadaController e AnimatedBuilder. O
AbrirJornadaDialog possui somente a estrutura visual: a página ainda não abre o
diálogo e o botão Salvar ainda não valida nem retorna os dados.

O usuário 1 e o veículo 1 são registros temporários garantidos de forma
idempotente antes do carregamento da jornada aberta.

## Restrições

- Não alterar a arquitetura.
- Não adicionar Provider, Riverpod ou outro gerenciador de estado.
- Manter usuarioId e veiculoId iguais a 1 temporariamente.
- Não criar arquivos sem necessidade.
- Não editar arquivos gerados pelo Drift.
- Não implementar o fechamento nesta tarefa.
- Não decidir nesta tarefa a relação definitiva entre Ganho, Jornada e Pausa.

## Pronto quando

- O botão Abrir Jornada abre o diálogo.
- Odômetro e cidade são validados.
- O diálogo retorna os dados para a página.
- A página chama JornadaController.abrirJornada().
- A tela passa a mostrar a jornada salva.
- dart format foi executado.
- flutter analyze não apresenta erros relacionados.
- Os testes aplicáveis passaram.
