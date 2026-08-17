import 'package:flutter/services.dart';

class QuilometragemInputFormatter extends TextInputFormatter {
  const QuilometragemInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (RegExp(r'[^0-9.]').hasMatch(newValue.text)) return newValue;
    var digitos = _somenteDigitos(newValue.text);
    if (digitos.isEmpty) return const TextEditingValue();

    final apagouSomenteSeparador =
        _somenteDigitos(oldValue.text) == digitos &&
        newValue.text.length < oldValue.text.length;
    if (apagouSomenteSeparador && newValue.selection.end > 0) {
      final antesDoCursor = newValue.text.substring(0, newValue.selection.end);
      final quantidadeAntes = _somenteDigitos(antesDoCursor).length;
      if (quantidadeAntes > 0) {
        digitos = digitos.replaceRange(
          quantidadeAntes - 1,
          quantidadeAntes,
          '',
        );
      }
    }

    final formatado = formatarQuilometragemTexto(digitos);
    final digitosAntesDoCursor = _somenteDigitos(
      newValue.text.substring(
        0,
        newValue.selection.end.clamp(0, newValue.text.length),
      ),
    ).length.clamp(0, digitos.length);
    var cursor = 0;
    var encontrados = 0;
    while (cursor < formatado.length && encontrados < digitosAntesDoCursor) {
      if (_ehDigito(formatado.codeUnitAt(cursor))) encontrados++;
      cursor++;
    }
    return TextEditingValue(
      text: formatado,
      selection: TextSelection.collapsed(offset: cursor),
    );
  }
}

String formatarQuilometragem(int? valor) =>
    valor == null ? '' : formatarQuilometragemTexto(valor.toString());

String formatarQuilometragemTexto(String texto) {
  final digitos = _somenteDigitos(texto);
  if (digitos.isEmpty) return '';
  final buffer = StringBuffer();
  for (var indice = 0; indice < digitos.length; indice++) {
    if (indice > 0 && (digitos.length - indice) % 3 == 0) buffer.write('.');
    buffer.write(digitos[indice]);
  }
  return buffer.toString();
}

int? parseQuilometragem(String? texto) {
  final normalizado = (texto ?? '').trim().replaceAll('.', '');
  return normalizado.isEmpty ? null : int.tryParse(normalizado);
}

String _somenteDigitos(String texto) =>
    String.fromCharCodes(texto.codeUnits.where(_ehDigito));

bool _ehDigito(int codigo) => codigo >= 48 && codigo <= 57;
