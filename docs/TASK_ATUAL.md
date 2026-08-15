# Tarefa atual — Inteligência de Abastecimento

## Estado

O aplicativo deriva consumo físico de ciclos válidos entre tanques cheios,
incluindo volumes parciais intermediários. A apresentação separa consumo
recente, média, referência conservadora de consumo, autonomia teórica de tanque
cheio e referência comportamental para abastecer.

A referência exige histórico mínimo, nunca é derivada da autonomia nominal e é
omitida após parcial que torne o nível atual desconhecido. Se já foi alcançada,
a interface informa o estado sem sugerir tanque vazio. Data de calendário não
é prevista enquanto não houver histórico contínuo confiável.

Todos os indicadores são derivados; o schema permanece 8.

## Validação

Aguardando validação operacional no Android.
