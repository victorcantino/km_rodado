# Tarefa atual — Custos recorrentes e competência econômica

## Estado

Primeira versão de referências econômicas recorrentes, separadas das Despesas
efetivamente pagas. Permite competência mensal, anual ou personalizada, padrão
habitual de parcelas, valor exato/estimado/ausente, prazo previsto opcional,
ativação e escopos veículo, atividade ou Plataforma.

O equivalente mensal é derivado e nenhuma Despesa, parcela materializada,
obrigação ou vencimento é gerado. Parcela do veículo e depreciação são apenas
conceitos distintos: a primeira permanece como referência periódica conhecida
de caixa; a segunda deixou o cadastro normal e será calculada por feature
própria, sem percentual ou valor inventado. O schema evolui de 10 para 11 por
migração aditiva e preservadora.

Na interface, Despesas pagas e Custos Recorrentes permanecem em seções
conceitualmente separadas, mas compartilham a mesma `DespesasPage` e rolagem.
As duas ações abrem diretamente seus formulários, sem página intermediária.
Novas Despesas oferecem somente fatos esporádicos; IPVA, licenciamento e seguro
entram normalmente como Custos Recorrentes. Registros antigos desses tipos de
Despesa continuam compatíveis e editáveis, sem mudança de schema.

## Validação

Implementação, migração e suíte automatizada concluídas. Aguardando validação
operacional no Android.
