import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:serverpod_client/serverpod_client.dart' show UuidValue;

import '../../session/session.dart';
import '../common/errors.dart';
import '../common/format.dart';
import '../common/paged_table.dart';
import 'visit_tile.dart';

/// Agenda do despacho: visitas do dia ou da semana, por técnico. Agendar é
/// pelo detalhe da OS; aqui se reagenda e desmarca.
class AgendaPage extends ConsumerStatefulWidget {
  const AgendaPage({super.key});

  @override
  ConsumerState<AgendaPage> createState() => _AgendaPageState();
}

enum _Span { day, week }

class _AgendaPageState extends ConsumerState<AgendaPage> {
  var _span = _Span.day;
  var _day = startOfDay(DateTime.now());
  UuidValue? _technicianId;
  var _includeCancelled = false;
  late final Future<List<Technician>> _technicians = ref.read(gatewayProvider).technicians(includeInactive: true);
  late Future<List<Visit>> _visits;

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Semana de segunda a domingo.
  DateTime get _from => _span == _Span.day ? _day : _day.subtract(Duration(days: _day.weekday - 1));
  DateTime get _to {
    final from = _from;
    final days = _span == _Span.day ? 1 : 7;
    return DateTime(from.year, from.month, from.day + days);
  }

  void _load() {
    _visits = ref
        .read(gatewayProvider)
        .agenda(_from, _to, technicianId: _technicianId, includeCancelled: _includeCancelled);
  }

  void _reload() => setState(_load);

  void _move(int direction) => setState(() {
    final step = _span == _Span.day ? 1 : 7;
    _day = DateTime(_day.year, _day.month, _day.day + direction * step);
    _load();
  });

  String get _periodLabel {
    if (_span == _Span.day) return formatDay(_day);
    final last = _to.subtract(const Duration(days: 1));
    return '${formatDate(_from)} a ${formatDate(last)}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: 'Agenda',
          filters: [
            SegmentedButton<_Span>(
              segments: const [
                ButtonSegment(value: _Span.day, label: Text('Dia')),
                ButtonSegment(value: _Span.week, label: Text('Semana')),
              ],
              selected: {_span},
              onSelectionChanged: (s) => setState(() {
                _span = s.single;
                _load();
              }),
            ),
            IconButton(tooltip: 'Anterior', onPressed: () => _move(-1), icon: const Icon(Icons.chevron_left)),
            Text(_periodLabel, key: const Key('agenda-period')),
            IconButton(tooltip: 'Próximo', onPressed: () => _move(1), icon: const Icon(Icons.chevron_right)),
            TextButton(
              onPressed: () => setState(() {
                _day = startOfDay(DateTime.now());
                _load();
              }),
              child: const Text('Hoje'),
            ),
            FutureBuilder<List<Technician>>(
              future: _technicians,
              builder: (context, snap) => DropdownButton<UuidValue?>(
                key: const Key('agenda-technician'),
                value: _technicianId,
                hint: const Text('Todos os técnicos'),
                onChanged: (v) => setState(() {
                  _technicianId = v;
                  _load();
                }),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Todos os técnicos')),
                  for (final t in snap.data ?? const <Technician>[])
                    DropdownMenuItem(value: t.id, child: Text('${t.code} · ${t.name}')),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: _includeCancelled,
                  onChanged: (v) => setState(() {
                    _includeCancelled = v ?? false;
                    _load();
                  }),
                ),
                const Text('Mostrar desmarcadas'),
              ],
            ),
          ],
        ),
        Expanded(
          child: FutureBuilder<List<Visit>>(
            future: _visits,
            builder: (context, snap) {
              if (snap.hasError) return ErrorPanel(error: snap.error!, onRetry: _reload);
              if (!snap.hasData) return const Center(child: CircularProgressIndicator());
              final visits = snap.data!;
              if (visits.isEmpty) {
                return const Center(
                  child: Text('Nenhuma visita no período. Para agendar, abra a OS e use "Agendar visita".'),
                );
              }
              return ListView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), children: _grouped(context, visits));
            },
          ),
        ),
      ],
    );
  }

  /// Por dia e, dentro do dia, por técnico (a lista já vem por horário).
  List<Widget> _grouped(BuildContext context, List<Visit> visits) {
    final theme = Theme.of(context);
    final byDay = <DateTime, Map<String, List<Visit>>>{};
    for (final v in visits) {
      final day = startOfDay(v.scheduledStart.toLocal());
      byDay.putIfAbsent(day, () => {}).putIfAbsent(v.technicianName ?? 'Sem técnico', () => []).add(v);
    }
    final days = byDay.keys.toList()..sort();
    return [
      for (final day in days) ...[
        if (_span == _Span.week)
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 4),
            child: Text(formatDay(day), style: theme.textTheme.titleMedium),
          ),
        for (final entry in (byDay[day]!.entries.toList()..sort((a, b) => a.key.compareTo(b.key))))
          Card(
            margin: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Text('${entry.key} · ${entry.value.length} visita(s)', style: theme.textTheme.titleSmall),
                ),
                for (final v in entry.value) VisitTile(visit: v, onChanged: _reload),
              ],
            ),
          ),
      ],
    ];
  }
}
