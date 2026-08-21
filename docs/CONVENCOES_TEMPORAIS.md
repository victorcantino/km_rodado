# Convenções temporais

- Quando um fato tem momento real relevante, usar um campo operacional como
  `dataHora`.
- Campos de criação e alteração são auditoria técnica; não representam
  automaticamente o momento do fato.
- `dataCriacao` não é automaticamente dado de negócio nem é obrigatório em
  toda entidade sem necessidade explícita.
- Se uma auditoria consistente for necessária no futuro, avaliar
  `dataCriacao`/`dataAtualizacao` de forma explícita para aquela entidade.
- Fatos retroativos usam o momento operacional para pertencimento histórico
  quando a regra permitir.
- Correções retroativas devem recalcular as métricas derivadas afetadas.
