import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:km_rodado/core/formatters/quilometragem_input_formatter.dart';

void main() {
  const formatter = QuilometragemInputFormatter();

  TextEditingValue editar(String anterior, String novo) =>
      formatter.formatEditUpdate(
        TextEditingValue(
          text: anterior,
          selection: TextSelection.collapsed(offset: anterior.length),
        ),
        TextEditingValue(
          text: novo,
          selection: TextSelection.collapsed(offset: novo.length),
        ),
      );

  test('formata milhares e preserva o valor numérico', () {
    expect(formatarQuilometragem(75000), '75.000');
    expect(formatarQuilometragem(125000), '125.000');
    expect(formatarQuilometragem(200000), '200.000');
    expect(parseQuilometragem('125.000'), 125000);
  });

  test('colar número sem máscara aplica a apresentação pt-BR', () {
    expect(editar('', '125000').text, '125.000');
  });

  test('backspace remove dígito e reaplica a máscara', () {
    final resultado = editar('125.000', '125.00');
    expect(resultado.text, '12.500');
    expect(parseQuilometragem(resultado.text), 12500);
  });

  test('digitação incremental mantém cursor no final', () {
    var valor = const TextEditingValue();
    for (final caractere in '75000'.split('')) {
      final novoTexto = '${valor.text}$caractere';
      valor = formatter.formatEditUpdate(
        valor,
        TextEditingValue(
          text: novoTexto,
          selection: TextSelection.collapsed(offset: novoTexto.length),
        ),
      );
    }
    expect(valor.text, '75.000');
    expect(valor.selection.baseOffset, valor.text.length);
  });
}
