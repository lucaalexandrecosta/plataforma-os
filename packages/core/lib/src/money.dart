/// Dinheiro em centavos e quantidades em milésimos, sempre `int`
/// (docs/12 §4.1, ADR-019, docs/02 §5.9). Nada de `double` para dinheiro.
///
/// R$ 12,34 → `1234`; 1,5 m → `1500`; 1 UN → `1000`.
abstract final class Money {
  /// Valor da linha em centavos: quantidade (milésimos) × preço unitário
  /// (centavos) ÷ 1000, arredondado ao centavo "meio para longe do zero".
  ///
  /// Regra única do sistema, idêntica a `app.line_amount_cents` no banco.
  /// O cálculo intermediário usa [BigInt] porque no Flutter Web o `int` tem
  /// só 53 bits de precisão.
  static int lineAmountCents(int quantityMilli, int unitCents) {
    final product = BigInt.from(quantityMilli) * BigInt.from(unitCents);
    final thousand = BigInt.from(1000);
    final negative = product.isNegative;
    final abs = product.abs();
    var quotient = abs ~/ thousand;
    if ((abs % thousand) * BigInt.two >= thousand) quotient += BigInt.one;
    return (negative ? -quotient : quotient).toInt();
  }

  /// `123456` → `R$ 1.234,56` (pt-BR). Para outras moedas e idiomas, as telas
  /// usam `intl`; este formatador cobre servidor, PDFs e testes.
  static String formatBrl(int cents) {
    final negative = cents < 0;
    final abs = cents.abs();
    final reais = _groupThousands((abs ~/ 100).toString());
    final centavos = (abs % 100).toString().padLeft(2, '0');
    return '${negative ? '-' : ''}R\$ $reais,$centavos';
  }

  /// Converte decimal em texto (`"12,34"`, `"12.34"`, `"1.234,5"`) para
  /// centavos, sem passar por `double`. Usado na importação por planilha e nos
  /// adaptadores do JSON externo. Lança [FormatException] se for inválido ou
  /// tiver mais de 2 casas decimais.
  static int parseToCents(String input) => _parseScaled(input, 2);

  /// Centavos → decimal com ponto, para JSON externo (webhooks, ERP).
  static String toDecimalString(int cents) {
    final negative = cents < 0;
    final abs = cents.abs();
    return '${negative ? '-' : ''}${abs ~/ 100}.${(abs % 100).toString().padLeft(2, '0')}';
  }
}

abstract final class Quantity {
  static const one = 1000;

  /// `"1,5"` → `1500`. Até 3 casas decimais.
  static int parseToMilli(String input) => _parseScaled(input, 3);

  /// `1500` → `1,5`; `1000` → `1`; `1250` → `1,25` (pt-BR, sem zeros à direita).
  static String format(int milli) {
    final negative = milli < 0;
    final abs = milli.abs();
    final whole = _groupThousands((abs ~/ 1000).toString());
    final frac = (abs % 1000).toString().padLeft(3, '0').replaceFirst(RegExp(r'0+$'), '');
    return '${negative ? '-' : ''}$whole${frac.isEmpty ? '' : ',$frac'}';
  }
}

String _groupThousands(String digits) {
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

// Formatos aceitos (planilhas brasileiras e JSON externo):
//   com vírgula  → vírgula é o separador decimal e pontos agrupam milhar:
//                  "1234,56", "1.234,56", "-0,5"
//   sem vírgula  → ponto é o separador decimal: "1234.56", "1.5"
// "1.234" é lido como 1,234 (decimal): em dinheiro isso dá erro de casas
// decimais, nunca R$ 1.234,00 por engano.
final _ptBr = RegExp(r'^([+-])?(\d{1,3}(?:\.\d{3})+|\d+)(?:,(\d+))?$');
final _dot = RegExp(r'^([+-])?(\d+)(?:\.(\d+))?$');

int _parseScaled(String input, int scale) {
  final text = input.trim().replaceFirst(RegExp(r'^R\$\s*'), '');
  final match = text.contains(',') ? _ptBr.firstMatch(text) : _dot.firstMatch(text);
  if (match == null) throw FormatException('Valor numérico inválido', input);
  final sign = match.group(1);
  final whole = match.group(2)!.replaceAll('.', '');
  final frac = match.group(3) ?? '';
  if (frac.length > scale) {
    throw FormatException('Mais de $scale casas decimais', input);
  }
  final value = int.parse(whole) * _pow10(scale) + (frac.isEmpty ? 0 : int.parse(frac.padRight(scale, '0')));
  return sign == '-' ? -value : value;
}

int _pow10(int n) {
  var r = 1;
  for (var i = 0; i < n; i++) {
    r *= 10;
  }
  return r;
}
