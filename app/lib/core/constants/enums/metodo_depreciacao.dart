enum MetodoDepreciacao { observada, projetada }

extension MetodoDepreciacaoLabel on MetodoDepreciacao {
  String get label => switch (this) {
    MetodoDepreciacao.observada => 'Observada',
    MetodoDepreciacao.projetada => 'Projetada',
  };
}
