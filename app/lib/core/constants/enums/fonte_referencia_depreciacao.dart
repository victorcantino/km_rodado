enum FonteReferenciaDepreciacao { informadoPeloUsuario, tabelaFipe, outra }

extension FonteReferenciaDepreciacaoLabel on FonteReferenciaDepreciacao {
  String get label => switch (this) {
    FonteReferenciaDepreciacao.informadoPeloUsuario => 'Informado por mim',
    FonteReferenciaDepreciacao.tabelaFipe => 'Tabela FIPE',
    FonteReferenciaDepreciacao.outra => 'Outra referência',
  };
}
