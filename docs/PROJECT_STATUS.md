# Estado atual do projeto

## Funcionalidade em desenvolvimento

Jornada.

## Objetivo atual

Validar o fluxo completo de fechamento da Jornada e o resumo operacional da
última Jornada encerrada.

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
- Diálogo de fechamento com destino sugerido e campos opcionais
- Validação de odômetro final maior que o inicial na interface e no service
- Persistência dos dados de fechamento e recarga do estado
- Consulta da última Jornada finalizada
- Resumo da última Jornada com localização, quilômetros, duração e média por
  hora de Jornada
- Sugestão do último destino como origem da próxima Jornada
- Sugestão do último odômetro final como odômetro inicial da próxima Jornada
- Progressão do odômetro protegida na abertura pela interface e pelo service

## Em andamento

- Validação automatizada final do fluxo de Jornada

## Próximo passo

Concluir as validações automatizadas antes da melhoria visual completa da
página.

## Decisões temporárias

- usuarioId = 1
- veiculoId = 1
- Registros temporários são criados sem sobrescrever dados existentes
- Injeção de dependências manual
- ChangeNotifier e AnimatedBuilder nesta primeira feature

## Problemas conhecidos

- O tratamento visual de erros ainda é genérico e restrito à abertura
- A relação de Ganho com Jornada e Pausa depende de decisão futura de modelagem
