# Regras de negócio — KM Rodado

## Jornada

- Uma Jornada representa o período de trabalho ativo do motorista.
- Só pode existir uma Jornada aberta.
- A abertura exige odômetro não negativo e cidade de origem.
- Havendo Jornada anterior finalizada, `novo odometroInicio >= odometroFim`.
- O destino anterior e seu odômetro final são sugestões editáveis na abertura.
- O fechamento exige `odometroFim >=` o maior odômetro conhecido da Jornada.
- O formulário de fechamento sugere o último odômetro conhecido por cronologia
  entre início da Jornada, Pausas e Abastecimentos do veículo no intervalo. A
  sugestão é editável e não usa ID nem `MAX(odometro)` para definir o último
  fato.
- Igualdade é válida: uma Jornada pode terminar com zero km.
- Quilômetros percorridos são `odometroFim - odometroInicio`.
- A leitura final e o fechamento são persistidos atomicamente.
- Não se fecha Jornada com Pausa aberta ou leitura inicial pendente.
- Abertura e fechamento aceitam registro tardio, usando por padrão o instante
  atual e permitindo alterar data/hora sob demanda, nunca para o futuro.
- Jornadas do mesmo veículo não podem se sobrepor. A validação usa vizinhos por
  data/hora, não por ID; igualdade entre o fim de uma e o início de outra é
  aceita.
- A edição da Jornada aberta ou da última finalizada deve manter Pausas,
  Leituras, Abastecimentos, Passes e Bônus vinculados dentro do intervalo.
  Esses fatos não são movidos ou reescritos automaticamente.
- `LancamentoGanhoIndividual.dataCriacao` é instante técnico e não limita o
  intervalo da Jornada. O lançamento é apenas preservado pelo `jornadaId`.
- Leituras já persistidas preservam horário, tipo, vínculo com Pausa e valores.
  A Leitura Final criada no fechamento usa o fim operacional escolhido em
  `dataHora`; `dataCriacao` registra quando foi lançada no aplicativo.
- A superfície operacional respeita os insets seguros do aparelho; ações não
  podem terminar atrás da navegação inferior do sistema.

Correções tardias da Jornada aberta ou da última finalizada podem ajustar
odômetros quando toda a progressão física permanecer coerente. Auditoria,
justificativa e inserção histórica arbitrária permanecem futuras.

## Pausas

- Pausa pertence obrigatoriamente a uma Jornada e interrompe a operação como um
  todo, não uma plataforma.
- Só pode existir uma Pausa aberta por Jornada; `fim == null` indica abertura.
- Novas Pausas exigem odômetros de início e fim não regressivos; igualdade é
  válida. As colunas permanecem nullable para dados históricos.
- Duração é derivada de início/fim e não persistida.
- Título é opcional, normalizado com `trim`; nulo usa `Pausa 1`, `Pausa 2` etc.
- Iniciar Pausa persiste primeiro o evento e então oferece leitura parcial.
- Salvar ou cancelar uma leitura não encerra nem apaga a Pausa.
- O lápis edita a Pausa existente de forma integral e atômica, sem criar outro
  registro. Pausa aberta continua aberta; somente Retomar Jornada define fim e
  odômetro final.
- A edição aceita duração zero e odômetros iguais, coerente com os fluxos
  operacionais atuais. Início não pode anteceder a Jornada; fim não pode
  anteceder o início nem ultrapassar o fim de uma Jornada finalizada. Em
  Jornada aberta, os instantes editados não podem estar no futuro.
- Uma Pausa editada não pode sobrepor Pausas cronologicamente anterior ou
  posterior. A validação usa horários, não IDs.
- Odômetros presentes devem ser não regressivos entre o início/fim da Jornada,
  as demais Pausas e os Abastecimentos do mesmo veículo ocorridos no intervalo
  da Jornada. Fatos anteriores limitam o mínimo e fatos posteriores limitam o
  máximo. Registros históricos nullable permanecem nullable quando não forem
  explicitamente corrigidos.
- Editar a Pausa preserva seu ID e qualquer Leitura de Ganhos vinculada; horário
  e valores da Leitura não são movidos ou alterados automaticamente.

## Plataformas e ganhos

- Plataforma define `tipoRegistroGanhos`: `acumulado` ou `individual`.
- Uber, 99 e inDrive são seeds acumulados; Particular é seed individual.
- Regras não devem depender desses nomes.
- Desativar uma plataforma afeta novos registros, sem apagar histórico.
- A Leitura Inicial fixa as plataformas acumuladas daquela Jornada. Mudanças de
  ativação posteriores valem para a próxima Jornada.

### Leituras acumuladas

- A leitura registra exatamente valor e viagens acumulados observados.
- Tipos: inicial, parcial e final da Jornada.
- Inicial é o baseline e não herda a Jornada anterior.
- Parcial normalmente ocorre em Pausa; final antecede o encerramento.
- Valor e viagens iguais a zero são dados válidos.
- Leituras seguintes sugerem o último snapshot da mesma Jornada.
- Diferenças são derivadas; não se persiste ganho do período.
- A reconciliação percorre intervalos consecutivos de snapshots. Bônus e
  promoções observados são subtraídos da variação para obter somente receita de
  viagens. Cada intervalo é aberto no snapshot anterior e fechado no posterior.
- Crédito anterior ou exatamente no baseline pode explicar parte do saldo
  inicial, mas não é subtraído da variação seguinte: o próprio baseline já o
  exclui da receita da Jornada. Crédito posterior entra no intervalo
  `(snapshot anterior, snapshot posterior]` correspondente.
- Regressão de valor ou viagens, item ausente, Passe no intervalo ou bônus maior
  que a variação torna a receita dependente de conferência.
- Não se infere reset nem efeito financeiro automaticamente.

### Ganhos individuais

- Um lançamento pertence a Plataforma individual e à Jornada aberta no fluxo
  atual; o schema permite Jornada nula para evolução histórica.
- Quantidade deve ser pelo menos 1 e valor total pode ser zero.
- Um lançamento pode agrupar viagens; não se inferem valores unitários.
- Totais são `SUM(valorTotalCentavos)` e `SUM(quantidadeViagens)`.
- Particular usa este mecanismo e continua aparecendo com as demais fontes.

## Resumo da Jornada

- O resumo é derivado e não persiste indicadores.
- Tempo ativo é duração total menos Pausas concluídas.
- Distância ativa é distância total menos deslocamento em Pausas.
- Pausa histórica sem odômetros deixa indicadores dependentes de distância
  incompletos, sem assumir deslocamento zero.
- Ticket médio usa somente faturamento atribuível às viagens.
- Resultado operacional calculável é receita de viagens + bônus/promoções -
  Passes. Fatos conhecidos continuam visíveis quando a receita exige revisão.
- Zero viagens produz ticket médio indisponível (`—`).
- Se qualquer receita necessária não for calculável, totais gerais, ticket
  médio geral, R$/h e R$/km não são apresentados como exatos.
- Se a Leitura Inicial ocorrer depois do início operacional da Jornada, a
  cobertura financeira inicial é parcial. Não se inventam ganhos do intervalo
  ausente; receita, viagens, ticket médio, R$/h, R$/km e resultado operacional
  gerais ficam indisponíveis como totais exatos, embora fatos conhecidos do
  período observado possam continuar visíveis.

## Abastecimentos

- Abastecimento pertence ao veículo e pode ter Jornada opcional, associada
  automaticamente quando aberta.
- `dataHora` é quando ocorreu; `dataCriacao` é quando foi cadastrado.
- Lançamentos retroativos são permitidos quando o odômetro é cronologicamente
  coerente com fatos anteriores e posteriores do veículo.
- Odômetro é inteiro e não negativo; igualdade é válida.
- Volume é persistido em mililitros, total em centavos e preço da bomba em
  milésimos de real por litro. Não se usa `double` como fonte de verdade nova.
- Tanque cheio é explícito e inicia como `true`; não é inferido pelo volume.
- Preço efetivo é derivado de total/volume. O custo usa o valor realmente pago,
  que pode divergir do preço opcional da bomba.
- Cidade, posto, bandeira e observação são opcionais e normalizados com `trim`.

- Consumo é derivado de ciclos cronologicamente válidos entre abastecimentos
  com tanque cheio: distância entre os cheios dividida por todo o volume
  abastecido depois do cheio inicial, incluindo parciais intermediários.
- A visão usa até os três ciclos válidos mais recentes. A média é aritmética e
  a referência conservadora de consumo é o menor km/L dessa amostra.
- Ciclo com parcial continua fisicamente válido, mas é potencialmente misto e
  não deve ser atribuído integralmente ao posto/bandeira do cheio inicial.
- A capacidade configurada no Veículo permite estimar a autonomia teórica de
  um tanque cheio. Essa autonomia não representa combustível restante nem
  define quando abastecer.
- A referência comportamental para abastecer exige ao menos dois ciclos e usa
  a menor distância recente efetivamente percorrida do tanque cheio até o
  primeiro reabastecimento. Ela é aplicada a partir do último tanque cheio.
- Se houve parcial após o último tanque cheio, a referência é omitida porque o
  nível físico atual é desconhecido. Não se soma uma autonomia artificial.
- Quando o último odômetro conhecido atinge ou ultrapassa a referência, a UI
  informa apenas que a referência comportamental foi atingida. Isso não
  significa tanque vazio ou risco imediato de pane seca.
- A distância restante, quando exibida, é até a referência comportamental, não
  autonomia restante. Uma estimativa em dias de operação exige ao menos três
  dias operacionais válidos recentes.
- Não há previsão por data de calendário enquanto o histórico não permitir
  distinguir com segurança dias sem Jornada de ausência de dados.
- Custo/km e análises por posto/bandeira permanecem futuros.

## Manutenções

- Manutenção representa a visita/evento do veículo e possui um ou mais itens.
  Cabeçalho e itens são criados ou editados em uma única transação.
- Veículo, instante operacional e odômetro são obrigatórios. Oficina e
  observação são textos opcionais. Manutenção não é custo automático de uma
  Jornada e não possui `jornadaId` nesta versão.
- Item exige descrição livre normalizada com `trim`; sugestões históricas não
  limitam textos novos nem formam enum de categorias.
- Valor é opcional por item e usa centavos inteiros. Ausente é desconhecido,
  não zero. Total só é apresentado quando todos os itens têm valor; caso
  contrário, exibe-se custo conhecido e quantidade sem valor.
- `dataHora` é quando ocorreu e não pode estar no futuro; `dataCriacao` é o
  cadastro técnico. Registro retroativo é permitido quando a progressão do
  odômetro é coerente com fatos anteriores e posteriores.
- Manutenção integra a cronologia física usada por Jornada, Pausa e
  Abastecimento. Igualdade de odômetro é válida.
- Recorrência por km guarda somente `intervaloKm > 0`; próximo odômetro é
  derivado. Recorrência por data é opcional, explícita e posterior à
  Manutenção; nunca recebe como default a data do evento.
- A ocorrência mais recente de uma descrição normalizada por `trim` e caixa
  substitui a recorrência ativa anterior. Não há fuzzy matching: “Litro de
  óleo” e “Troca de Óleo e Filtros” continuam diferentes.
- Status mostram fatos — km restantes, referência atingida, dias restantes ou
  vencimento atingido — sem limiares arbitrários e sem notificações nesta fase.
- O XLS do AppSheet não é importado nem usado como seed nesta entrega.

## Passes de plataforma

- Passe é custo operacional factual de uma Plataforma, não faturamento
  negativo.
- Plataforma é obrigatória; Jornada é opcional e associada automaticamente se
  estiver aberta no cadastro.
- `dataHora` representa a compra e pode ser retroativa; `dataCriacao` representa
  o cadastro.
- Valor pago é positivo e persistido em centavos. Modalidade, validade, limite
  de faturamento e observação são opcionais; textos usam `trim`.
- No fluxo operacional atualmente suportado há dois tipos: `faturamento` e
  `tempo`, sem regras por nome de Plataforma. Eles atendem aos Passes usados de
  Uber/99, mas não limitam para sempre todos os mecanismos possíveis. O tipo é
  gravado canonicamente em `modalidade`, preservando textos legados existentes.
- Passe por faturamento exige limite positivo e calcula a validade como
  `dataHora + 180 dias` exatos, preservando hora e minuto.
- Passe por tempo exige duração de 24 ou 72 horas e calcula a validade a partir
  de `dataHora`. A duração é derivada, não persistida separadamente.
- “Repetir último Passe” reutiliza apenas tipo, valor como sugestão e limite ou
  duração da mesma Plataforma. A nova compra recebe nova `dataHora`, validade
  recalculada e associação própria; todos os valores continuam editáveis.
- Passe legado só é repetível se seus dados permitirem reconhecer com segurança
  um dos tipos atuais. Histórico incompleto ou livre permanece preservado.
- Jornada é associada somente quando `dataHora` está entre o início da Jornada
  aberta e o instante atual; cadastro retroativo fora desse intervalo mantém
  `jornadaId` nulo.
- Passe é mostrado separadamente no resumo e não reduz ticket médio.
- Passe de acumulada entre leituras inicial/final exige conferência da receita.
  Não se calcula automaticamente `final - inicial + passe`.
- Foi observado que a 99 pode reduzir o visível e a Uber pode gerar débito
  interno, mas essas observações não viram hardcode por nome.
- Há dois mecanismos conhecidos: por tempo e por limite de faturamento. Ofertas
  concretas, preços, durações e limites são dados observados variáveis, não
  tipos fixos nem valores hardcoded.
- Observações atuais da Uber: limite de R$ 125 por R$ 30; limite de R$ 391 por
  R$ 89; 24 horas por R$ 37; 72 horas por R$ 99. A escolha habitual observada é
  o limite de R$ 125 por R$ 30.
- A 99 também oferece duas opções por tempo e duas por faturamento. Está
  confirmada somente a opção habitual de limite de R$ 200 por R$ 16,98; os
  demais preços não são tratados como fatos.
- Fonte de pagamento e condições do Passe são conceitos distintos. A inDrive
  foi observada com carteira pré-paga e também com o Passe “cidade a cidade”,
  comprado usando esse saldo. A oferta observada custava R$ 12, sem renovação
  automática, e terminava no primeiro evento entre 24 horas e 7 pedidos
  aceitos. Nome, preço, duração e quantidade são observações variáveis, nunca
  regras hardcoded.
- Recarga de carteira não é despesa por si só. Compra de Passe ou outro consumo
  do saldo é o fato econômico; contabilizar recarga e consumo como custos
  duplicaria o mesmo dinheiro.

## Bônus e promoções

- Representam créditos positivos efetivamente observados na Plataforma, não
  promessas, metas futuras ou faturamento de viagens.
- Missão/meta não é modelada nesta fase; registra-se apenas o crédito recebido.
- Plataforma é obrigatória; Jornada é opcional e associada automaticamente se
  estiver aberta no cadastro. `dataHora` é operacional e pode ser retroativa;
  `dataCriacao` é técnica.
- São fatos separados para plataformas acumuladas e individuais. Não se cria
  snapshot artificial para plataforma individual e não aumentam ticket médio.
- Snapshots brutos nunca são alterados.
- `dataHora` indica quando o crédito apareceu e afetou o contador. Uber foi
  observada creditando no mesmo dia após a promoção e 99 normalmente no dia
  seguinte, sem transformar essas observações em regras por Plataforma.
- Não se modelam missão, meta, etapas, viagens necessárias, horário da missão,
  origem/competência econômica, Jornada que teria gerado o bônus nem
  lucratividade da promoção. O registro pede somente Plataforma, valor
  creditado, `dataHora` e observação opcional.
- A distinção técnica histórica entre `bonus` e `promocao` permanece no schema,
  mas não é apresentada nem exigida no fluxo operacional. Novos registros usam
  `bonus` como valor canônico; ambos são tratados como o mesmo crédito adicional.
- Para a reconciliação importa somente quando o crédito apareceu e afetou o
  contador.
- Bônus anterior à Jornada permanece com `jornadaId` nulo. Se já estiver no
  baseline, não é associado artificialmente nem subtraído novamente.

## Escopo operacional do produto

- O KM Rodado não rastreia passageiro, deslocamento para buscar passageiro ou o
  estado individual de cada corrida.
- Jornada aberta representa o período operacional e Pausa representa sua
  interrupção. A utilização profissional futura será derivada desses períodos
  e das diferenças entre Jornadas, sem rastreamento por corrida.

## Decisões futuras já estabelecidas

- Regressões ou saltos de snapshot podem decorrer de reset, passe, bônus ou
  outra movimentação; reconciliação exigirá fatos e regras explícitas.
- Manutenção e outros eventos poderão ter Jornada opcional quando fizer sentido.
- A timeline será projeção de tabelas especializadas, sem tabela Evento genérica
  antecipada.
- A Jornada pode atravessar meia-noite; não há encerramento automático.

Detalhes ainda não implementados permanecem em `BACKLOG.md`, não como
comportamento atual.
