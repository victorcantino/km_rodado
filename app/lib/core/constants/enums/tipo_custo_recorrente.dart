enum TipoCustoRecorrente {
  ipva,
  licenciamento,
  seguro,
  parcelaVeiculo,
  depreciacao,
  telefoneProfissional,
  contaPlataforma,
  outro,
}

extension TipoCustoRecorrenteLabel on TipoCustoRecorrente {
  bool get disponivelEmNovoCadastro => this != TipoCustoRecorrente.depreciacao;

  String get label => switch (this) {
    TipoCustoRecorrente.ipva => 'IPVA',
    TipoCustoRecorrente.licenciamento => 'Licenciamento',
    TipoCustoRecorrente.seguro => 'Seguro',
    TipoCustoRecorrente.parcelaVeiculo => 'Parcela do veículo',
    TipoCustoRecorrente.depreciacao => 'Depreciação',
    TipoCustoRecorrente.telefoneProfissional => 'Telefone profissional',
    TipoCustoRecorrente.contaPlataforma => 'Conta de plataforma',
    TipoCustoRecorrente.outro => 'Outro custo recorrente',
  };
}
