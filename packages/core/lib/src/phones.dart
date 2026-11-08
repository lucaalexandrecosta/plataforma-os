/// Telefones em E.164 (docs/08 §2.12), igual ao CHECK de
/// `customer_contacts.phone_e164`: `^\+[1-9][0-9]{7,14}$`.
abstract final class Phones {
  static final _e164 = RegExp(r'^\+[1-9]\d{7,14}$');
  static final _noise = RegExp(r'[\s().\-]');

  static bool isE164(String value) => _e164.hasMatch(value);

  /// Normaliza o que as pessoas digitam. Sem `+`, assume Brasil:
  /// `(51) 99999-0001` → `+5551999990001`; `0 51 3333-4444` → `+555133334444`;
  /// `55 51 99999-0001` → `+5551999990001`. Devolve `null` se não der para
  /// formar um número válido (o chamador decide se é erro de validação).
  static String? toE164(String input) {
    var v = input.trim().replaceAll(_noise, '');
    if (v.isEmpty) return null;
    if (v.startsWith('+')) return isE164(v) ? v : null;
    if (v.startsWith('00')) {
      v = '+${v.substring(2)}';
      return isE164(v) ? v : null;
    }
    if (!RegExp(r'^\d+$').hasMatch(v)) return null;
    if (v.startsWith('0')) v = v.substring(1); // prefixo de longa distância nacional
    // DDD (2 dígitos, sem zero) + 8 dígitos (fixo) ou 9 começando em 9 (celular).
    final national = RegExp(r'^[1-9]{2}(?:[2-8]\d{7}|9\d{8})$');
    if (national.hasMatch(v)) return '+55$v';
    if (v.startsWith('55') && national.hasMatch(v.substring(2))) return '+$v';
    return null;
  }
}
