// Formatação no padrão brasileiro, sem depender dos dados de locale do intl.

String _two(int n) => n.toString().padLeft(2, '0');

/// 31/12/2026 (data local).
String formatDate(DateTime? value) {
  if (value == null) return '—';
  final d = value.toLocal();
  return '${_two(d.day)}/${_two(d.month)}/${d.year}';
}

/// 31/12/2026 14:05 (data e hora locais).
String formatDateTime(DateTime? value) {
  if (value == null) return '—';
  final d = value.toLocal();
  return '${formatDate(d)} ${_two(d.hour)}:${_two(d.minute)}';
}

/// Centavos → R$ 1.234,56.
String formatMoney(int? cents) {
  if (cents == null) return '—';
  final negative = cents < 0;
  final abs = cents.abs();
  final reais = (abs ~/ 100).toString();
  final grouped = StringBuffer();
  for (var i = 0; i < reais.length; i++) {
    if (i > 0 && (reais.length - i) % 3 == 0) grouped.write('.');
    grouped.write(reais[i]);
  }
  return '${negative ? '-' : ''}R\$ $grouped,${_two(abs % 100)}';
}
