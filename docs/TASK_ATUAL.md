# Tarefa atual — Validação do fechamento de Jornada

## Objetivo

Validar o fechamento completo da Jornada pela interface e a apresentação do
resumo operacional da última Jornada encerrada.

## Regras de negócio

### Odômetro final

O odômetro final deve ser obrigatoriamente maior que o odômetro inicial.

```text
odometroFim > odometroInicio
```

Não permitir:

* valor igual ao odômetro inicial;
* valor menor que o odômetro inicial;
* valor negativo;
* valor não numérico.

A Jornada somente pode ser encerrada quando:

```text
quilometrosPercorridos > 0
```

O cálculo é:

```text
quilometrosPercorridos =
odometroFim - odometroInicio
```

Nunca persistir quilômetros zero ou negativos.

### Correções de odômetro

Correções de um odômetro já registrado serão permitidas futuramente, porém:

* deverão exigir obrigatoriamente um motivo em `observacoes`;
* deverão definir `odometroAlterado = true`;
* o usuário continua responsável pela correção informada.

Não criar nesta tarefa uma nova tela de edição/correção caso esse fluxo ainda não exista.

Registrar essa regra em `docs/REGRAS_NEGOCIO.md`.

### Cidade de destino

Enquanto GPS não estiver implementado:

* ao fechar uma Jornada, sugerir como cidade de destino a última cidade de origem registrada;
* no fluxo atual isso normalmente corresponde à cidade de origem da Jornada aberta;
* o campo continua editável pelo usuário.

Futuramente:

```text
GPS disponível → localização atual
GPS indisponível → sugestão pelo histórico
```

### Cidade de origem da próxima Jornada

Enquanto GPS não estiver implementado:

* ao abrir uma nova Jornada, sugerir como cidade de origem a cidade de destino da última Jornada encerrada;
* o campo continua editável.

Futuramente:

```text
GPS disponível → localização atual
GPS indisponível → último destino registrado
```

### Odômetro inicial da próxima Jornada

Ao abrir uma nova Jornada, sugerir o odômetro final da última Jornada
finalizada como odômetro inicial. A sugestão permanece editável e deve ser
apresentada como número inteiro sem separador de milhares.

Se não existir Jornada finalizada ou o odômetro final estiver ausente, manter o
campo vazio.

No fluxo operacional normal, o valor informado deve respeitar:

```text
novo odometroInicio >= último odometroFim
```

A igualdade é válida. Valores inferiores devem ser rejeitados tanto pelo
diálogo quanto pelo `JornadaService`.

## Fluxo de fechamento

Jornada aberta

→ tocar em “Fechar Jornada”

→ abrir diálogo

→ odômetro final obrigatório

→ cidade de destino sugerida e editável

→ observações opcionais

→ validar

→ confirmar

→ chamar `JornadaController.fecharJornada()`

→ persistir encerramento

→ recarregar estado

→ não existir mais Jornada aberta

→ apresentar resumo da última Jornada encerrada

## Dados persistidos no fechamento

Garantir:

* `dataHoraFim`;
* `odometroFim`;
* `cidadeDestino`;
* `observacoes`;
* `status = finalizada`;
* `quilometrosPercorridos`;
* `dataAtualizacao`.

Não alterar `odometroAlterado` em um fechamento normal.

## Resumo / Dashboard da Jornada

Após o fechamento, apresentar somente informações derivadas da Jornada já existente:

* indicação de Jornada concluída;
* localização, combinando origem e destino;
* quilômetros percorridos;
* duração total da Jornada, sem segundos;
* média de quilômetros percorridos por hora de Jornada.

Usar formatação localizada já existente para:

* quilômetros.

Não apresentar no resumo:

* horários inicial e final;
* odômetros inicial e final.

A média da Jornada é uma informação derivada e não deve ser persistida:

```text
quilometrosPercorridos / duraçãoEmHoras
```

Apresentar a média com uma casa decimal e proteger o cálculo quando a duração
for igual ou inferior a zero. Não chamar essa métrica de velocidade média.

Não incluir ainda:

* Ganhos;
* Pausas;
* R$/km;
* R$/hora;
* custos;
* lucro.

Esses indicadores serão adicionados quando as features correspondentes estiverem implementadas.

Antes de criar uma nova estrutura de Dashboard, inspecionar o projeto atual. Reutilizar a tela/estrutura existente se possível. Não criar uma nova arquitetura apenas para apresentar esse resumo.

## Mudanças permitidas

Pode alterar no menor escopo necessário:

* diálogo de fechamento;
* `JornadaPage`;
* `JornadaService`, para garantir `odometroFim > odometroInicio`;
* DAO/repository/service somente se for realmente necessário consultar a última Jornada encerrada para a sugestão da próxima cidade de origem;
* testes;
* documentação relacionada.

Não editar manualmente arquivos `.g.dart`.

Não alterar tabelas caso os campos necessários já existam.

## Testes

Cobrir, quando possível:

* diálogo de fechamento;
* odômetro obrigatório;
* odômetro inválido;
* odômetro negativo;
* odômetro igual ao inicial rejeitado;
* odômetro menor que o inicial rejeitado;
* odômetro maior aceito;
* cidade de destino sugerida;
* cidade de destino editável;
* observações opcionais;
* retorno tipado do diálogo;
* cancelamento.

Adicionar teste da regra do service para garantir que quilômetros zero ou negativos não possam ser persistidos, caso isso possa ser feito sem infraestrutura artificial excessiva.

## Documentação

Atualizar:

* `docs/REGRAS_NEGOCIO.md`;
* `docs/PROJECT_STATUS.md`;
* `docs/TASK_ATUAL.md`;
* `docs/BACKLOG.md`, se necessário.

Registrar também:

* GPS terá preferência sobre sugestões históricas;
* último destino será fallback da próxima origem;
* última origem será fallback do destino;
* correção manual de odômetro exige motivo.

## Restrições

* Não alterar arquitetura.
* Não adicionar biblioteca de estado.
* Não implementar GPS.
* Não implementar Ganhos ou Pausas.
* Não implementar métricas financeiras.
* Não redesenhar completamente a interface.
* Não adicionar dependências sem necessidade.
* Não editar `.g.dart`.
* Não fazer commit nem push.

## Pronto quando

* Jornada pode ser fechada pela interface;
* `odometroFim > odometroInicio` é garantido também pela regra de negócio, não apenas pela interface;
* quilômetros percorridos são sempre maiores que zero;
* destino é sugerido;
* observações funcionam;
* fechamento persiste após reiniciar o aplicativo;
* após o fechamento não existe Jornada aberta;
* resumo da Jornada encerrada é apresentado;
* próxima abertura consegue sugerir a última cidade de destino quando não houver GPS;
* formatações são localizadas;
* `dart format` passa;
* `flutter analyze` passa;
* testes passam;
* `git diff --check` passa.

## Implementado

* diálogo de fechamento com retorno tipado;
* validação de odômetro final maior que o inicial;
* validação defensiva no service;
* sugestão editável da cidade de destino;
* cidade de destino e observações opcionais;
* consulta da última Jornada finalizada;
* resumo operacional localizado na JornadaPage;
* sugestão do último destino na próxima abertura;
* sugestão do último odômetro final na próxima abertura;
* progressão do odômetro inicial validada na interface e no service;
* testes de widget do diálogo.

## Validação manual concluída

* fechamento e persistência confirmados no Linux;
* Jornada permaneceu encerrada após reiniciar o aplicativo;
* resumo e sugestão da origem da Jornada seguinte confirmados.
A nova regra de negócio está definida em `docs/TASK_ATUAL.md`.

Pode prosseguir, mas antes de alterar código faça uma inspeção curta e informe se já existe uma forma de recuperar a última Jornada finalizada.

Se não existir, está autorizado criar no menor escopo necessário uma consulta para a última Jornada finalizada e propagá-la pelas camadas existentes, mantendo a convenção atual de nomes.

Essa consulta deverá servir tanto para:

* apresentar o resumo da última Jornada encerrada;
* sugerir a cidade de destino da última Jornada como origem da próxima Jornada.

Não crie uma camada nova de Dashboard.

Reutilize a arquitetura existente.

Depois implemente a tarefa completa, execute as validações previstas e não faça commit nem push.
