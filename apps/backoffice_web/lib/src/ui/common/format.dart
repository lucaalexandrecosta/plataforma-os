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

/// 14:05 (hora local).
String formatTime(DateTime? value) {
  if (value == null) return '—';
  final d = value.toLocal();
  return '${_two(d.hour)}:${_two(d.minute)}';
}

const _weekdays = ['segunda', 'terça', 'quarta', 'quinta', 'sexta', 'sábado', 'domingo'];

/// "terça, 17/11/2026".
String formatDay(DateTime value) => '${_weekdays[value.weekday - 1]}, ${formatDate(value)}';

/// Início do dia local.
DateTime startOfDay(DateTime value) => DateTime(value.year, value.month, value.day);

/// "1.234,56" ou "1234.56" ou "1234" → centavos; nulo se não for valor.
int? parseMoney(String text) {
  var t = text.trim().replaceAll('R\$', '').replaceAll(' ', '');
  if (t.isEmpty) return null;
  if (t.contains(',')) {
    t = t.replaceAll('.', '').replaceAll(',', '.');
  }
  final match = RegExp(r'^(\d+)(?:\.(\d{1,2}))?$').firstMatch(t);
  if (match == null) return null;
  final cents = (match.group(2) ?? '0').padRight(2, '0');
  return int.parse(match.group(1)!) * 100 + int.parse(cents);
}

/// Centavos → "1.234,56" (sem R\$), para campos de edição.
String moneyField(int? cents) => cents == null ? '' : formatMoney(cents).replaceFirst('R\$ ', '');
