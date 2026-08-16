enum TipoDespesaVeiculo {
  ipva,
  licenciamento,
  documentacao,
  seguro,
  multa,
  pedagio,
  estacionamento,
  lavagem,
  outro,
}

extension TipoDespesaVeiculoLabel on TipoDespesaVeiculo {
  bool get disponivelEmNovoCadastro => switch (this) {
    TipoDespesaVeiculo.ipva ||
    TipoDespesaVeiculo.licenciamento ||
    TipoDespesaVeiculo.seguro => false,
    _ => true,
  };

  String get label => switch (this) {
    TipoDespesaVeiculo.ipva => 'IPVA',
    TipoDespesaVeiculo.licenciamento => 'Licenciamento',
    TipoDespesaVeiculo.documentacao => 'Taxa/documentação eventual',
    TipoDespesaVeiculo.seguro => 'Seguro',
    TipoDespesaVeiculo.multa => 'Multa',
    TipoDespesaVeiculo.pedagio => 'Pedágio',
    TipoDespesaVeiculo.estacionamento => 'Estacionamento',
    TipoDespesaVeiculo.lavagem => 'Lavagem',
    TipoDespesaVeiculo.outro => 'Outra despesa',
  };
}
