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
  String get label => switch (this) {
    TipoDespesaVeiculo.ipva => 'IPVA',
    TipoDespesaVeiculo.licenciamento => 'Licenciamento',
    TipoDespesaVeiculo.documentacao => 'Documentação / taxa',
    TipoDespesaVeiculo.seguro => 'Seguro',
    TipoDespesaVeiculo.multa => 'Multa',
    TipoDespesaVeiculo.pedagio => 'Pedágio',
    TipoDespesaVeiculo.estacionamento => 'Estacionamento',
    TipoDespesaVeiculo.lavagem => 'Lavagem',
    TipoDespesaVeiculo.outro => 'Outra despesa',
  };
}
