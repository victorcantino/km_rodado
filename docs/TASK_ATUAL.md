# Tarefa atual — Leitura parcial de ganhos na Pausa

## Objetivo

Registrar snapshots das plataformas acumuladas ao iniciar uma Pausa, usando o
schema 2 existente.

## Escopo

- persistir a Pausa antes de abrir o diálogo;
- carregar somente plataformas cadastradas e ativas;
- respeitar registro acumulado ou individual;
- sugerir o último snapshot da plataforma na Jornada;
- permitir valor e quantidade iguais à leitura anterior;
- oferecer incremento, decremento e digitação de viagens;
- salvar leitura parcial e itens acumulados na mesma transação;
- validar Jornada, Pausa, plataforma, duplicidade e valores não negativos;
- manter a Pausa aberta ao salvar ou cancelar;
- permitir registrar a leitura posteriormente durante a Pausa;
- recarregar o estado persistido após salvar.
- garantir plataformas padrão ativas por seed idempotente;
- preservar plataformas padrão previamente cadastradas sem sobrescrever dados.

## Fora do escopo

- leitura inicial automática;
- leitura final no fechamento;
- lançamentos individuais;
- diferenças, indicadores ou dashboards;
- alteração do schema 2;
- redesign geral da Jornada.

## Pronto quando

- snapshots acumulados forem persistidos corretamente;
- sugestões vierem da última leitura da Jornada;
- plataformas individuais não produzirem itens artificiais;
- cancelamento e salvamento preservarem a Pausa;
- leitura sobreviver a nova instância do aplicativo;
- análise e testes passarem;
- documentação representar o fluxo implementado.
- uma instalação nova possuir Uber, 99, inDrive e Particular sem duplicações.
