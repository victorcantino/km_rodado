String formatarDuracaoPausa(Duration duracao) {
  final minutosTotais = duracao.isNegative ? 0 : duracao.inMinutes;
  final horas = minutosTotais ~/ Duration.minutesPerHour;
  final minutos = minutosTotais.remainder(Duration.minutesPerHour);

  if (horas == 0) {
    return '${minutos}m';
  }

  if (minutos == 0) {
    return '${horas}h';
  }

  return '${horas}h ${minutos.toString().padLeft(2, '0')}m';
}

String tituloExibicaoPausa(String? titulo, int numero) {
  final tituloNormalizado = titulo?.trim() ?? '';
  return tituloNormalizado.isEmpty ? 'Pausa $numero' : tituloNormalizado;
}
