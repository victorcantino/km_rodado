# Estado atual do projeto

## Funcionalidade em desenvolvimento

Ganhos individuais.

## Objetivo atual

Permitir lançamentos factuais de plataformas individuais e integrá-los à
operação e ao resumo.

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
- PausaDao, PausaRepository, PausaService e PausaController
- Início e finalização de Pausa durante Jornada aberta
- Garantia transacional de uma única Pausa aberta por Jornada
- Restauração de Pausa aberta e duração derivada após reinício
- Título opcional editável e numeração automática por ordem cronológica
- Lista de Pausas da Jornada integrada à JornadaPage
- Fechamento de Jornada bloqueado na regra de negócio quando há Pausa aberta
- Testes de ciclo de vida, persistência, títulos, duração e fechamento
- LeituraGanhosDao, LeituraGanhosRepository, LeituraGanhosService e controller
- Diálogo de leitura parcial integrado ao início da Pausa
- Pausa persistida antes da abertura do diálogo de ganhos
- Plataformas ativas filtradas por tipo de registro
- Snapshot bruto de valor e viagens para plataformas acumuladas
- Sugestão do último snapshot da plataforma na Jornada
- Salvamento transacional do cabeçalho e dos itens da leitura
- Cancelamento e salvamento sem encerrar ou apagar a Pausa
- Plataformas individuais exibidas sem criar itens acumulados artificiais
- Testes de regras, sugestões, persistência e controles do diálogo
- Seed idempotente de Uber, 99, inDrive e Particular
- Plataformas padrão criadas sem IDs fixos e sem sobrescrever registros existentes
- Leitura inicial solicitada após a abertura da Jornada, sem herdar a Jornada anterior
- Estado de ganhos iniciais pendentes restaurado após reinício
- Leituras parciais e final bloqueadas enquanto a inicial estiver pendente
- Leitura final sugerida pela última leitura da própria Jornada
- Persistência atômica da leitura final e do fechamento da Jornada
- Unicidade de leituras inicial e final protegida na camada de negócio
- Schema 3 com odômetros nullable em Pausas para compatibilidade histórica
- Odômetros obrigatórios no início e fim de novas Pausas
- Configuração rápida de plataformas no diálogo de ganhos
- Conjunto acumulado da Jornada fixado pela Leitura Inicial
- Entrada monetária móvel por dígitos, formatada em pt-BR e persistida em centavos
- Atalhos Zero por plataforma e Tudo zerado na Leitura Inicial
- Resumo derivado da última Jornada com receita e viagens por plataforma
  acumulada, totais, tempos, distâncias e indicadores de eficiência ativa
- Ticket médio por plataforma acumulada e geral, indisponível quando não houver
  viagens ou quando o resultado correspondente estiver incompleto
- Tempo ativo calculado sem Pausas e quilômetros ativos calculados sem o
  deslocamento ocorrido durante Pausas
- Pausas históricas sem odômetros sinalizadas como distância ativa incompleta
- Regressões de valor ou viagens entre snapshots sinalizadas para revisão, sem
  inferência automática de reset
- Resumo recalculado dos dados persistidos após fechamento e reinício
- Schema 4 com lançamentos de ganhos individuais e Jornada opcional
- Registro rápido individual durante Jornada, inclusive durante Pausa
- Totais individuais por plataforma derivados por soma e integrados ao resumo

## Em andamento

- Validação operacional dos ganhos individuais no Android

## Próximo passo

Validar lançamentos individuais em uso operacional.

## Decisões temporárias

- usuarioId = 1
- veiculoId = 1
- Registros temporários são criados sem sobrescrever dados existentes
- Injeção de dependências manual
- ChangeNotifier e AnimatedBuilder nesta primeira feature

## Problemas conhecidos

- O tratamento visual de erros ainda é genérico e restrito à abertura
- A consistência entre Jornada e Pausa da leitura é protegida pelo service
- Regras de reset das plataformas ainda não são conhecidas e não são inferidas
- Edição e exclusão de lançamentos individuais permanecem futuras
