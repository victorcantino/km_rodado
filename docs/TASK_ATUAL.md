# Tarefa atual — Formalização de Passes e SafeArea

## Estado

Passes foram formalizados no domínio como `faturamento` ou `tempo`, usando os
campos existentes do schema 8. Validades são derivadas, o último Passe seguro
da mesma Plataforma pode ser repetido como sugestão e associações retroativas
não recebem Jornada incompatível.

Esses são os mecanismos operacionais atualmente suportados, não um limite
universal. Carteira pré-paga pode coexistir com Passes; condições compostas por
tempo ou quantidade de usos permanecem futuras.

A JornadaPage preserva explicitamente `viewPadding.bottom` no fim do conteúdo
rolável em cenários Android edge-to-edge, sem confundir o inset do sistema com
o teclado.

O registro operacional de Bônus/Promoções foi simplificado para um único
crédito adicional. A coluna histórica continua no schema, novos registros usam
`bonus` canônico e históricos `promocao` permanecem legíveis e reconciliados da
mesma forma.

O schema permanece 8.

## Validação

Aguardando validação operacional no Android após a suíte automatizada.
