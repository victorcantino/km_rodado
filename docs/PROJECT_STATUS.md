# Estado atual do projeto

## Funcionalidade em desenvolvimento

Base de dados para Pausas e futuras leituras de ganhos.

## Objetivo atual

Migrar de forma preservadora o schema Drift 1 para 2, sem implementar ainda a
interface ou as camadas funcionais de Pausas e leituras.

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
- Scaffolding vazio e estruturas arquiteturais concorrentes removidos
- Estrutura física reduzida a core ativo e feature Jornada
- Schema Drift 2 com Pausa simplificada
- Leituras de ganhos separadas dos itens acumulados por plataforma
- Plataforma classificada por registro acumulado ou individual
- Valores monetários acumulados armazenados em centavos
- Migração preservadora de Pausas e Ganhos legados
- Testes específicos de migração com banco vazio e preenchido

## Em andamento

- Validação final do schema 2 e de sua documentação

## Próximo passo

Implementar a feature Pausas sobre o schema 2 após aprovação desta migração.

## Decisões temporárias

- usuarioId = 1
- veiculoId = 1
- Registros temporários são criados sem sobrescrever dados existentes
- Injeção de dependências manual
- ChangeNotifier e AnimatedBuilder nesta primeira feature

## Problemas conhecidos

- O tratamento visual de erros ainda é genérico e restrito à abertura
- A consistência entre a Jornada da leitura e a Jornada de sua Pausa opcional
  deverá ser protegida na futura camada de negócio
- Regras de reset das plataformas ainda não são conhecidas e não são inferidas
- Lançamentos individuais permanecem futuros; Particular continua sendo
  plataforma e seus totais serão derivados desses lançamentos
