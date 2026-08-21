class HistoricoJornadaEvento {
  final DateTime dataHora;
  final int ordem;
  final int id;
  final String titulo;
  final String? detalhe;

  const HistoricoJornadaEvento({
    required this.dataHora,
    required this.ordem,
    required this.id,
    required this.titulo,
    this.detalhe,
  });
}
