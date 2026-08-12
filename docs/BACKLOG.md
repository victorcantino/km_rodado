# Agora

# Depois

- Leitura inicial de ganhos ao abrir a Jornada
- Leitura final de ganhos antes de fechar a Jornada
- Plataformas
- Lançamentos individuais por plataforma: quantidade de viagens, valor total
  em centavos, observação opcional, Jornada opcional e `dataCriacao` como
  momento operacional
- Totais individuais por Jornada derivados com `SUM` de valor e quantidade,
  sem inferir valores unitários
- Visão conjunta em pausas e fechamento com ação rápida para novo lançamento
  individual, sem criar leitura acumulada artificial
- Abastecimentos
- Manutenções e abastecimentos com Jornada opcional
- Eficiência diária
- Obter cidade de origem pela localização do aparelho, mantendo edição manual
- Fazer a melhoria visual completa da JornadaPage após concluir o fluxo funcional
- Criar fluxo de correção de odômetro com motivo obrigatório

# Futuro

- Planejar migração histórica de mais de um ano de dados do AppSheet quando o
  modelo de destino estiver estável, preservando Jornadas, ganhos, odômetros,
  manutenções, custos e os dados originais para análises históricas
- Evoluir a interface funcional atual para uma experiência móvel e operacional
  mais rica, sem antecipar o redesign durante a estabilização dos fluxos

- Modelar custos futuros distinguindo custos diretamente associados a uma
  Jornada, custos ocorridos no dia sem necessariamente pertencer à Jornada e
  custos independentes de Jornada. Estacionamento e pedágio durante o trabalho
  podem pertencer à Jornada; manutenção pode ter `jornadaId` quando ocorrer
  durante o trabalho ou deixá-lo ausente fora dele; IPVA, seguro, licenciamento
  e financiamento permanecem custos ou obrigações independentes da Jornada

- Permitir que o futuro resumo apresente separadamente, quando houver dados,
  receita bruta, custos diretamente atribuíveis à Jornada, resultado
  operacional da Jornada e custos gerais do dia, sem atribuir artificialmente
  estes últimos à Jornada

- Modelar compra de passe de plataforma com plataforma, data/hora, modalidade e
  valor como custo operacional, sem assumir regra universal de subtração sobre
  saldo ou contador acumulado observado

- Modelar bônus e promoções com plataforma, data/hora e valor como créditos que
  podem ocorrer ou ser creditados em momentos diferentes, integrando-os à
  futura reconciliação quando relacionados ao período de uma Jornada

- Conferir regressões e saltos de snapshots considerando resets, passes, bônus
  e outras movimentações conhecidas, sem concluir automaticamente que a
  variação seja erro ou reset

- Manter o resultado operacional futuro com faturamento, bônus, passes e custos
  da plataforma apresentados de forma separável, sem alterar o ticket médio já
  calculado somente sobre o faturamento atribuível às viagens

- Manutenção com mapa visual do veículo para selecionar regiões e lados, como
  faróis e pneus dianteiros/traseiros, reduzindo digitação manual

- Timeline como projeção de tabelas especializadas, sem tabela genérica Evento
- Definir regras específicas de reset e movimentações de plataforma somente
  quando conhecidas
- Clima
- Localização
- Sincronização
- Backup
