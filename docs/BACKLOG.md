# Backlog

## Candidatas à próxima prioridade

- Formalização das modalidades de Passe e correção histórica de Passes.

## Operação e dados históricos

- Avaliar inserção histórica arbitrária de Jornadas após uso operacional da
  correção tardia.
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
- Reorganizar futuramente a JornadaPage em seções recolhíveis com resumo curto
  quando fechadas, como Faturamento, Custos, Pausas, Abastecimentos,
  Plataformas e Manutenção. Indicadores serão escolhidos com a maturidade das
  features, sem sanfona nesta etapa.
- DespesasPage com seções recolhíveis independentes para Despesas do veículo e
  Custos recorrentes. Ambas podem ficar abertas ou fechadas sem obrigar o
  fechamento da outra; o objetivo é reduzir altura quando houver muitos dados.
- Tela sempre ligada configurável e modo escuro.
- Onboarding e ajuda contextual por feature, dispensáveis, com Próximo,
  Entendi, “não mostrar novamente” e reabertura sob demanda. Na DespesasPage,
  explicar separadamente que Nova despesa registra pagamento ocorrido e Novo
  custo recorrente registra uma referência econômica periódica; explicar também
  que recarga de carteira/tag pré-paga não é custo e que somente o consumo
  efetivo deve ser registrado, evitando dupla contagem.

## Abastecimento

- Histórico completo por posto, bandeira e cidade; preço médio e promoções.
- Evoluir a capacidade do tanque por veículo para configuração operacional.
- Ao analisar posto/bandeira, tratar ciclos com parciais intermediários como
  potencialmente mistos; não atribuir todo o rendimento a um único posto.
- Com consentimento e infraestrutura apropriada, usar localização/serviço de
  lugares para sugerir cidade e posto, pedir confirmação, recuperar preços e
  ciclos anteriores e apoiar a escolha. GPS sozinho não identifica um
  estabelecimento com garantia; não criar cadastro automático sem confirmação.
- Custo/km e previsão por data de calendário somente com atribuição econômica e
  histórico contínuo confiáveis.

## Manutenção e veículo

- Mapa visual/interativo de Manutenção do veículo: tocar diretamente na peça
  (como pneu dianteiro direito ou farol direito) para abrir o formulário atual
  com componente e posição pré-preenchidos; manter o formulário textual como
  fallback e oferecer opções contextuais somente quando fizerem sentido.
- Alertas/notificações configuráveis por data e/ou odômetro, sem limiares
  arbitrários.
- Importação histórica das 38 linhas do AppSheet, agrupando visitas e revisando
  a semântica mista de `Km Duração` e `Validade`.
- Análises por oficina/fornecedor e custo econômico por km quando houver base
  suficiente, sem atribuir automaticamente o custo a uma Jornada.

## Custos e obrigações

- Reconciliação entre Custo Recorrente e pagamento real, separando competência
  econômica e fluxo de caixa sem dupla contagem.
- Avaliar acompanhamento detalhado de quantidade de parcelas/obrigações somente
  se houver necessidade operacional real; não antecipar contrato, amortização,
  juros, vencimentos, pagamentos ou saldo devedor.
- Integração opcional com FIPE e histórico de avaliações da depreciação, sem
  substituir automaticamente o snapshot informado pelo usuário.
- Avaliar associação opcional de Despesa a Jornada somente quando houver regra
  econômica segura, sem atribuir retroativamente custos gerais ao trabalho.
- Evoluir despesas factuais para obrigações, competência, parcelas,
  vencimentos e status apenas em fluxo próprio; não inferir esses dados do
  registro operacional atual.
- Separar custos diretamente atribuíveis à Jornada, custos gerais do dia e
  custos independentes.
- Resumo futuro: receita bruta, custos da Jornada, resultado operacional e
  custos gerais do dia sem atribuição artificial.
- Pedágio e estacionamento pré-pagos: separar recarga de consumo efetivo.
- Multas com valor original, desconto, pago, vencimento e status.
- Evoluir IPVA, licenciamento e seguro para competência por exercício,
  pagamentos, parcelas e vencimentos somente após definir a reconciliação.

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
- Implementar o Motor Econômico somente após amadurecer as fontes reais. Ele
  deverá decidir explicitamente tipos incluídos, visões, rateios e prevenção de
  dupla contagem; não antecipar flags de inclusão.

## Produto

- Avaliar estratégia gratuito/premium; inteligência econômica é candidata
  natural à camada paga, sem decisão comercial fechada nesta fase.

## Infraestrutura futura

- Clima e localização.
- Backup, sincronização e nuvem.
