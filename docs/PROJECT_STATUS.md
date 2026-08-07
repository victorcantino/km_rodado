# Estado atual do projeto

## Funcionalidade em desenvolvimento

Jornada.

## Objetivo atual

Validar o fluxo de abertura de jornada concluído pela interface. O fechamento
não faz parte da tarefa atual.

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
- Validação de odômetro e cidade de origem no diálogo
- Integração do AbrirJornadaDialog com a JornadaPage
- Abertura e recarga da jornada pela interface
- Apresentação de falha operacional com SnackBar
- Testes de widget do diálogo e de seu resultado
- Persistência e recarga validadas manualmente no Linux
- Data e hora de início formatadas conforme o idioma e a região do aparelho
- Odômetro exibido com separador de milhares localizado

## Em andamento

- Evolução do fluxo funcional da Jornada

## Próximo passo

Implementar o fechamento de jornada em uma tarefa própria antes da melhoria
visual completa da página.

## Decisões temporárias

- usuarioId = 1
- veiculoId = 1
- Registros temporários são criados sem sobrescrever dados existentes
- Injeção de dependências manual
- ChangeNotifier e AnimatedBuilder nesta primeira feature

## Problemas conhecidos

- O tratamento visual de erros ainda é genérico e restrito à abertura
- O fechamento da jornada ainda não possui interface
- A relação de Ganho com Jornada e Pausa depende de decisão futura de modelagem
