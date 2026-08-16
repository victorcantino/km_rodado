# Modelo de dados — KM Rodado

O schema Drift atual é **11**. Esta seção separa o que existe no SQLite do que é
derivado ou apenas planejado.

## Tabelas persistidas

### Usuarios

`id`, `nome`, `email?`, `senha?`, `dataCriacao`, `ativo`.

### Veiculos

`id`, `usuarioId`, `marca`, `modelo`, `ano`, `placa?`, `dataCompra?`,
`quilometragemCompra?`, `valorCompra?`, `valorVendaEstimado?`,
`capacidadeTanque`, `ativo`, `observacoes?`.

O vínculo com usuário ainda não possui FK Drift. Alguns campos legados usam
`REAL`; features novas monetárias usam inteiros.

### Configuracoes

`id`, `usuarioId`, `custoKmBase`, `metaKmDia`, `capacidadeTanque`,
`cidadePadrao?`. Integra o schema, mas ainda não possui fluxo de interface.

### Jornadas

`id`, `usuarioId` → Usuarios, `veiculoId` → Veiculos, `dataHoraInicio`,
`dataHoraFim?`, `odometroInicio`, `odometroFim?`, `cidadeOrigem`,
`cidadeDestino?`, `status`, `odometroAlterado`, `observacoes?`, `dataCriacao`,
`dataAtualizacao`, `quilometrosPercorridos?`.

### Pausas

`id`, `jornadaId` → Jornadas, `inicio`, `fim?`, `odometroInicio?`,
`odometroFim?`, `titulo?`, `observacao?`, `dataCriacao`.

Odômetros são obrigatórios no fluxo atual, mas nullable no schema para
preservar dados históricos anteriores ao schema 3.

### Plataformas

`id`, `nome`, `tipoRegistroGanhos`, `icone?`, `cor?`, `ativa`, `ordem`,
`dataCriacao`. O tipo é `acumulado` ou `individual`.

### LeiturasGanhos

`id`, `jornadaId` → Jornadas, `pausaId?` → Pausas, `dataHora`, `tipo`,
`dataCriacao`. Tipos: `inicial`, `parcial` e `finalDaJornada`.

### LeiturasGanhoPlataforma

`id`, `leituraGanhosId` → LeiturasGanhos, `plataformaId` → Plataformas,
`valorAcumuladoCentavos`, `quantidadeViagensAcumulada`.

O par leitura/plataforma é único; valor e quantidade não podem ser negativos.

### LancamentosGanhoIndividual

`id`, `plataformaId` → Plataformas, `jornadaId?` → Jornadas,
`quantidadeViagens`, `valorTotalCentavos`, `observacao?`, `dataCriacao`.

Quantidade é pelo menos 1. Um lançamento pode agrupar viagens sem inferir
valores unitários.

### Abastecimentos

`id`, `veiculoId` → Veiculos, `jornadaId?` → Jornadas, `dataHora`, `odometro`,
`tipoCombustivel`, `volumeMililitros`, `valorTotalPagoCentavos`,
`precoBombaMilesimosRealPorLitro?`, `tanqueCheio`, `cidade?`, `nomePosto?`,
`bandeiraPosto?`, `observacao?`, `dataCriacao`.

Combustíveis atuais: gasolina, etanol e outro. `dataHora` é o instante
operacional; `dataCriacao`, o instante técnico do cadastro.

Consumo, médias, autonomia estimada de tanque cheio e referência comportamental
para abastecer são projeções calculadas a partir de Abastecimentos e da
capacidade do Veículo. Não são persistidos. Parciais integram o volume físico do
ciclo, mas tornam o ciclo potencialmente misto para análises por posto.

### PassesPlataforma

`id`, `plataformaId` → Plataformas, `jornadaId?` → Jornadas, `dataHora`,
`valorPagoCentavos`, `modalidade?`, `validadeAte?`,
`limiteFaturamentoCentavos?`, `observacao?`, `dataCriacao`.

O valor pago deve ser positivo. O efeito sobre snapshots não é persistido nem
inferido. Novos registros usam `modalidade` canônica `faturamento` ou `tempo`.
Faturamento exige `limiteFaturamentoCentavos` e validade derivada de 180 dias;
tempo deriva duração de 24h/72h pela diferença entre `dataHora` e
`validadeAte`. Não há coluna nova de duração, e valores legados livres são
preservados.

### BonusPromocoes

`id`, `plataformaId` → Plataformas, `jornadaId?` → Jornadas, `dataHora`,
`valorCentavos`, `tipo`, `observacao?`, `dataCriacao`.

O valor deve ser positivo. A coluna histórica aceita `bonus` e `promocao`; novos
registros operacionais usam `bonus` canônico, sem escolha do usuário. Ambos são
lidos e reconciliados uniformemente como crédito observado. A receita de
viagens reconciliada permanece derivada.

### Manutencoes

`id`, `veiculoId` → Veiculos, `dataHora`, `odometro`, `oficina?`,
`observacao?`, `dataCriacao`, `dataAtualizacao?`.

Representa uma visita ou evento físico do veículo. Não pertence automaticamente
a uma Jornada e integra a cronologia confiável do odômetro.

### ItensManutencao

`id`, `manutencaoId` → Manutencoes, `descricao`, `valorCentavos?`,
`intervaloKm?`, `vencimentoEm?`, `dataCriacao`, `dataAtualizacao?`.

Descrição é livre. Valor ausente significa desconhecido, não zero. Próximo
odômetro é derivado de `Manutencao.odometro + intervaloKm`; não é persistido.

### DespesasVeiculo

`id`, `veiculoId` → Veiculos, `tipo`, `descricao`, `valorCentavos`,
`dataHora`, `observacao?`, `dataCriacao`, `dataAtualizacao?`.

Registra uma despesa factual paga ou ocorrida para o veículo, sem associação
automática a Jornada. O valor é positivo e usa centavos inteiros. O tipo usa
`TipoDespesaVeiculo`: IPVA, licenciamento, documentação/taxa, seguro, multa,
pedágio, estacionamento, lavagem ou outra despesa.

### CustosRecorrentes

`id`, `tipo`, `descricao`, `escopo`, `veiculoId?` → Veiculos,
`plataformaId?` → Plataformas, `valorReferenciaCentavos?`, `valorEstimado`,
`periodicidadeMeses`, `parcelasPorCiclo`, `ativo`,
`quantidadeCiclosPrevista?`, `observacao?`, `dataCriacao`,
`dataAtualizacao?`.

É referência de competência econômica, não pagamento. Escopos possíveis:
veículo exige `veiculoId`; atividade não recebe veículo nem Plataforma;
Plataforma exige `plataformaId`. Valor ausente é desconhecido, nunca zero.

## Relações principais

```text
Usuario ──< Jornada >── Veiculo
Jornada ──< Pausa
Jornada ──< LeituraGanhos ──< LeituraGanhoPlataforma >── Plataforma
Jornada? ──< LancamentoGanhoIndividual >── Plataforma
Jornada? ──< Abastecimento >── Veiculo
Jornada? ──< PassePlataforma >── Plataforma
Jornada? ──< BonusPromocao >── Plataforma
Veiculo ──< Manutencao ──< ItemManutencao
Veiculo ──< DespesaVeiculo
Veiculo? ──< CustoRecorrente >── Plataforma?
```

## Dados derivados, não persistidos

- duração da Jornada, Pausas e tempo ativo;
- quilômetros ativos e em Pausa;
- diferenças de receita/viagens entre snapshots;
- totais de ganhos individuais;
- ticket médio, receita por hora e receita por quilômetro ativo;
- custo total de passes;
- receita de viagens reconciliada e resultado operacional com bônus e Passes;
- preço efetivo do combustível.
- custo conhecido/completo da Manutenção, próximo hodômetro e estados de
  recorrência por km/data.
- equivalente mensal de cada Custo Recorrente.

## Planejado, sem tabela atual

Evento financeiro genérico, carteira de
plataforma, alertas, clima, localização e sincronização não fazem parte do
schema 11. Suas decisões e ideias permanecem no backlog e nas regras futuras.
