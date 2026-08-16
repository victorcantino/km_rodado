enum EscopoCustoRecorrente { veiculo, atividade, plataforma }

extension EscopoCustoRecorrenteLabel on EscopoCustoRecorrente {
  String get label => switch (this) {
    EscopoCustoRecorrente.veiculo => 'Veículo',
    EscopoCustoRecorrente.atividade => 'Atividade',
    EscopoCustoRecorrente.plataforma => 'Plataforma',
  };
}
