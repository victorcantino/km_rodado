# Backlog

## Candidatas à próxima prioridade

- Formalização das modalidades de Passe e correção histórica de Passes.

## Operação e dados históricos

- Evoluir edição/exclusão histórica para um fluxo auditável, com usuário,
  justificativa e rastreabilidade de versões quando o uso definitivo/frota
  exigir; a correção simples de Pausas já existe sem essa trilha.
- Categorias e sugestões editáveis de Pausa, sem substituir o título livre.
- Importar mais de um ano de dados do AppSheet, preservando originais e
  rastreabilidade.
- GPS para sugerir cidade, mantendo edição manual.

## Experiência de uso

- Evolução visual móvel/operacional após estabilizar os fluxos.
- Revisar autofocus e redução de toques nos demais inputs após uso em campo.
- Controlar explicitamente a navegação “Próximo” entre campos editáveis: pular
  botões, ícones, checkboxes e controles auxiliares; trocar teclado conforme o
  tipo do próximo input e usar Done/Concluir no último campo.
- Reorganizar futuramente a JornadaPage em seções recolhíveis com resumo curto
  quando fechadas, como Faturamento, Custos, Pausas, Abastecimentos,
  Plataformas e Manutenção. Indicadores serão escolhidos com a maturidade das
  features, sem sanfona nesta etapa.
- Tela sempre ligada configurável e modo escuro.
- Onboarding e guias contextuais por módulo, dispensáveis e reabertos sob
  demanda.

## Abastecimento

- Histórico completo por posto, bandeira e cidade; preço médio e promoções.
- Capacidade real/configurável do tanque por veículo.
- Consumo por pelo menos três ciclos válidos de tanque cheio, tratando parciais.
- No ciclo entre tanques cheios A e B, calcular `km desde A / litros colocados
  em B` e atribuir o rendimento ao ciclo iniciado em A, inclusive ao analisar o
  posto/bandeira de A. Acumular parciais até o próximo ciclo válido.
- Com consentimento e infraestrutura apropriada, usar localização/serviço de
  lugares para sugerir cidade e posto, pedir confirmação, recuperar preços e
  ciclos anteriores e apoiar a escolha. GPS sozinho não identifica um
  estabelecimento com garantia; não criar cadastro automático sem confirmação.
- Autonomia, custo/km e previsão do próximo abastecimento como derivados.

## Manutenção e veículo

- Manutenção associável ou não a Jornada.
- Componentes por posição/lado e mapa visual do veículo (pneus, faróis etc.).
- Alertas por data e/ou odômetro.

## Custos e obrigações

- Separar custos diretamente atribuíveis à Jornada, custos gerais do dia e
  custos independentes.
- Resumo futuro: receita bruta, custos da Jornada, resultado operacional e
  custos gerais do dia sem atribuição artificial.
- Pedágio e estacionamento pré-pagos: separar recarga de consumo efetivo.
- Multas com valor original, desconto, pago, vencimento e status.
- IPVA por exercício, à vista/parcelado e regras configuráveis.
- Licenciamento, seguro e financiamento com parcelas e vencimentos.

## Plataforma e análises

- Evoluir reconciliação de resets, Passes e outras movimentações conhecidas.
- Quando houver necessidade operacional real, generalizar condições de Passe
  para duração, limite de faturamento, quantidade máxima de usos/pedidos e
  combinações “o que ocorrer primeiro”. Não antecipar enum de uso nem engine
  genérica.
- Modelar futuramente carteira pré-paga separando recarga, saldo e consumo. Uma
  recarga de R$ 15 seguida por Passe de R$ 12 deixa saldo de R$ 3 e reconhece
  custo de R$ 12; não somar recarga e compra como duas despesas. Consumo direto
  posterior do saldo é outro fato econômico.
- Resultado operacional separando faturamento, bônus, passes e custos, sem
  alterar ticket médio das viagens.
- Eficiência diária, relatórios e timeline por projeção de tabelas especializadas.
- Quilômetros operacionais versus não operacionais e proporção de utilização
  profissional do veículo.
- Meta mensal de quilômetros e rateio planejado de custos fixos por essa meta.
- Referência econômica pessoal por quilômetro e hora, margem desejada e valor
  mínimo econômico por Plataforma.

## Produto

- Avaliar estratégia gratuito/premium; inteligência econômica é candidata
  natural à camada paga, sem decisão comercial fechada nesta fase.

## Infraestrutura futura

- Clima e localização.
- Backup, sincronização e nuvem.
