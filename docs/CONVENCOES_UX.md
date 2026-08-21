# Convenções permanentes de UX

Estas regras orientam alterações de UI e formulários do KM Rodado.

## Campos e formulários operacionais

- Ao editar um campo numérico preenchido, favorecer a substituição rápida:
  selecionar todo o conteúdo no primeiro foco/toque quando aplicável.
- Não adotar como padrão o cursor acidental no meio do número.
- A ordem do `Próximo` deve seguir a ordem visual dos campos editáveis.
- A ordem dos campos deve refletir o fluxo real de uso no carro, com defaults
  sensatos e autofocus somente quando ajudar.
- Não criar etapas ou botões auxiliares quando o valor puder ser derivado
  automaticamente.

## Listas e ações

- Históricos devem mostrar o mais recente primeiro quando isso fizer sentido.
- Preferir lápis explícito para editar; exclusão fica dentro da edição, salvo
  necessidade específica.
- FABs e ações compactas podem ser icon-only quando o significado for claro,
  sempre com Tooltip e Semantics.
- Cards e listas priorizam informação útil e não exibem excesso técnico.

## Visual e formatação

- Não implementar zebra, linhas alternadas ou cores alternadas por métrica.
- Usar cards e seções normais do tema, sem cores decorativas sem ganho real.
- Métricas tabuladas usam rótulo à esquerda e valor à direita.
- Cor nunca é a única forma de comunicar significado.
- Datas, horários, moeda e números seguem pt-BR, incluindo vírgula decimal;
  dia da semana entra quando melhora a leitura operacional.

## Dados derivados

- Não persistir métricas que possam ser recalculadas com segurança.
- Inserção, edição ou exclusão retroativa deve recalcular os derivados afetados.
- `dataHora` é o instante operacional; `dataCriacao` é o timestamp técnico e
  não deve deslocar o fato na linha do tempo.
