# Modelo de dados — KM Rodado

O schema Drift atual é **7**. Esta seção separa o que existe no SQLite do que é
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

### PassesPlataforma

`id`, `plataformaId` → Plataformas, `jornadaId?` → Jornadas, `dataHora`,
`valorPagoCentavos`, `modalidade?`, `validadeAte?`,
`limiteFaturamentoCentavos?`, `observacao?`, `dataCriacao`.

O valor pago deve ser positivo. O efeito sobre snapshots não é persistido nem
inferido.

## Relações principais

```text
Usuario ──< Jornada >── Veiculo
Jornada ──< Pausa
Jornada ──< LeituraGanhos ──< LeituraGanhoPlataforma >── Plataforma
Jornada? ──< LancamentoGanhoIndividual >── Plataforma
Jornada? ──< Abastecimento >── Veiculo
Jornada? ──< PassePlataforma >── Plataforma
```

## Dados derivados, não persistidos

- duração da Jornada, Pausas e tempo ativo;
- quilômetros ativos e em Pausa;
- diferenças de receita/viagens entre snapshots;
- totais de ganhos individuais;
- ticket médio, receita por hora e receita por quilômetro ativo;
- custo total de passes;
- preço efetivo do combustível.

## Planejado, sem tabela atual

Manutenção, bônus/promoções, evento financeiro genérico, carteira de
plataforma, alertas, clima, localização e sincronização não fazem parte do
schema 7. Suas decisões e ideias permanecem no backlog e nas regras futuras.
