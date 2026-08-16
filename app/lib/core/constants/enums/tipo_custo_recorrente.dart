enum TipoCustoRecorrente {
  ipva,
  licenciamento,
  seguro,
  telefoneProfissional,
  contaPlataforma,
  outro,
}

extension TipoCustoRecorrenteLabel on TipoCustoRecorrente {
  String get label => switch (this) {
    TipoCustoRecorrente.ipva => 'IPVA',
    TipoCustoRecorrente.licenciamento => 'Licenciamento',
    TipoCustoRecorrente.seguro => 'Seguro',
    TipoCustoRecorrente.telefoneProfissional => 'Telefone profissional',
    TipoCustoRecorrente.contaPlataforma => 'Conta de plataforma',
    TipoCustoRecorrente.outro => 'Outro custo recorrente',
  };
}
