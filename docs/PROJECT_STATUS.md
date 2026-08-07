# Estado atual do projeto

## Funcionalidade em desenvolvimento

Jornada.

## Objetivo atual

Estabilizar a base existente antes de concluir a abertura de jornada pela
interface. O fechamento não faz parte da tarefa atual.

## Já implementado

- Tabela Jornadas no Drift
- JornadaDao
- JornadaRepository
- JornadaService
- JornadaController com ChangeNotifier
- JornadaPage com AnimatedBuilder
- Carregamento da jornada aberta
- Ciclo de vida local do AppDatabase e do JornadaController
- Criação idempotente do usuário 1 e do veículo 1 temporários
- Estrutura visual do AbrirJornadaDialog
- Teste de widget da estrutura atual do diálogo

## Em andamento

- Integração do AbrirJornadaDialog com a JornadaPage

## Próximo passo

Fazer o botão Abrir Jornada exibir o diálogo, validar odômetro e cidade,
retornar os dados para a JornadaPage e chamar
JornadaController.abrirJornada().

## Decisões temporárias

- usuarioId = 1
- veiculoId = 1
- Registros temporários são criados sem sobrescrever dados existentes
- Injeção de dependências manual
- ChangeNotifier e AnimatedBuilder nesta primeira feature

## Problemas conhecidos

- Ainda não existe tratamento visual de erros
- Datas ainda não estão formatadas para exibição
- O diálogo de abertura ainda não está ligado à página
- O fechamento da jornada ainda não possui interface
- A relação de Ganho com Jornada e Pausa depende de decisão futura de modelagem
