# Regras de negócio — KM Rodado

## Jornada

- Uma Jornada representa o período de trabalho ativo do motorista.
- Só pode existir uma Jornada aberta.
- A abertura exige odômetro não negativo e cidade de origem.
- Havendo Jornada anterior finalizada, `novo odometroInicio >= odometroFim`.
- O destino anterior e seu odômetro final são sugestões editáveis na abertura.
- O fechamento exige `odometroFim >=` o maior odômetro conhecido da Jornada.
- Igualdade é válida: uma Jornada pode terminar com zero km.
- Quilômetros percorridos são `odometroFim - odometroInicio`.
- A leitura final e o fechamento são persistidos atomicamente.
- Não se fecha Jornada com Pausa aberta ou leitura inicial pendente.

Correções históricas de odômetro não pertencem ao fluxo operacional normal e
deverão exigir justificativa e rastreabilidade.

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

Consumo, autonomia e custo/km permanecem futuros e devem considerar ciclos
válidos de tanque cheio e abastecimentos parciais.

## Passes de plataforma

- Passe é custo operacional factual de uma Plataforma, não faturamento
  negativo.
- Plataforma é obrigatória; Jornada é opcional e associada automaticamente se
  estiver aberta no cadastro.
- `dataHora` representa a compra e pode ser retroativa; `dataCriacao` representa
  o cadastro.
- Valor pago é positivo e persistido em centavos. Modalidade, validade, limite
  de faturamento e observação são opcionais; textos usam `trim`.
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
- A competência ou origem econômica pode anteceder o crédito e permanece
  futura. Para a reconciliação atual importa o instante em que o contador foi
  afetado.
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
