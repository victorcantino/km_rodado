# Tarefa atual — Validação da abertura de jornada

## Objetivo

Validar o fluxo de abertura de jornada implementado pela interface.

## Contexto

A JornadaPage abre o AbrirJornadaDialog, recebe odômetro e cidade de origem e
chama JornadaController.abrirJornada(). O diálogo valida os campos antes de
retornar e a página apresenta falhas operacionais com SnackBar.

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

## Concluído

- O botão Abrir Jornada abre o diálogo.
- Odômetro e cidade de origem são validados.
- O diálogo retorna AbrirJornadaResultado para a página.
- A página chama JornadaController.abrirJornada().
- A tela passa a mostrar a jornada salva.
- Erros operacionais são apresentados com SnackBar.
- dart format foi executado.
- flutter analyze não apresenta erros relacionados.
- Os testes aplicáveis passaram.

## Validação pendente

- Confirmar a persistência local em execução no dispositivo.
