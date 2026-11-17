// Formatação no padrão brasileiro, sem depender dos dados de locale do intl.

String _two(int n) => n.toString().padLeft(2, '0');

const _weekdays = ['seg', 'ter', 'qua', 'qui', 'sex', 'sáb', 'dom'];

/// 31/12/2026 (data local).
String formatDate(DateTime? value) {
  if (value == null) return '—';
  final d = value.toLocal();
  return '${_two(d.day)}/${_two(d.month)}/${d.year}';
}

/// 14:05 (hora local).
String formatTime(DateTime? value) {
  if (value == null) return '—';
  final d = value.toLocal();
  return '${_two(d.hour)}:${_two(d.minute)}';
}

/// 31/12/2026 14:05 (data e hora locais).
String formatDateTime(DateTime? value) => value == null ? '—' : '${formatDate(value)} ${formatTime(value)}';

/// Meia-noite local do dia de [value].
DateTime startOfDay(DateTime value) {
  final d = value.toLocal();
  return DateTime(d.year, d.month, d.day);
}

/// "Hoje", "Amanhã", "Ontem" ou "qua, 19/11", relativo a [today].
String formatDay(DateTime day, DateTime today) {
  final d = startOfDay(day);
  final diff = d.difference(startOfDay(today)).inDays;
  if (diff == 0) return 'Hoje';
  if (diff == 1) return 'Amanhã';
  if (diff == -1) return 'Ontem';
  return '${_weekdays[d.weekday - 1]}, ${_two(d.day)}/${_two(d.month)}';
}

/// Janela planejada: "08:00–10:00", ou com a data do fim se cruzar o dia.
String formatWindow(DateTime start, DateTime end) {
  final sameDay = startOfDay(start) == startOfDay(end);
  return '${formatTime(start)}–${sameDay ? formatTime(end) : formatDateTime(end)}';
}

/// Distância em metros: "85 m" ou "1,2 km".
String formatDistance(double meters) {
  if (meters < 1000) return '${meters.round()} m';
  return '${(meters / 1000).toStringAsFixed(1).replaceAll('.', ',')} km';
}
