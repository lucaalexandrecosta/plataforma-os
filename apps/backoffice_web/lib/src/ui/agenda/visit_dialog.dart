import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:serverpod_client/serverpod_client.dart' show UuidValue;

import '../../api/gateway.dart';
import '../../session/session.dart';
import '../common/errors.dart';
import '../common/format.dart';

/// Agenda uma visita para a OS ou reagenda a [visit]: técnico, dia e janela.
/// Devolve a visita salva.
class VisitDialog extends ConsumerStatefulWidget {
  const VisitDialog({super.key, required this.workOrderId, required this.workOrderNumber, this.visit});

  final UuidValue workOrderId;
  final String workOrderNumber;
  final Visit? visit;

  @override
  ConsumerState<VisitDialog> createState() => _VisitDialogState();
}

class _VisitDialogState extends ConsumerState<VisitDialog> {
  late final Future<List<Technician>> _technicians = ref.read(gatewayProvider).technicians();
  UuidValue? _technicianId;
  late DateTime _day;
  late TimeOfDay _start;
  late TimeOfDay _end;
  var _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final visit = widget.visit;
    if (visit != null) {
      final start = visit.scheduledStart.toLocal();
      final end = visit.scheduledEnd.toLocal();
      _technicianId = visit.technicianId;
      _day = startOfDay(start);
      _start = TimeOfDay.fromDateTime(start);
      _end = TimeOfDay.fromDateTime(end);
    } else {
      _day = startOfDay(DateTime.now()).add(const Duration(days: 1));
      _start = const TimeOfDay(hour: 8, minute: 0);
      _end = const TimeOfDay(hour: 10, minute: 0);
    }
  }

  DateTime _at(TimeOfDay t) => DateTime(_day.year, _day.month, _day.day, t.hour, t.minute);

  Future<void> _pickDay() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _day,
      firstDate: startOfDay(DateTime.now()).subtract(const Duration(days: 7)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _day = startOfDay(picked));
  }

  Future<void> _pickTime(bool start) async {
    final picked = await showTimePicker(context: context, initialTime: start ? _start : _end);
    if (picked == null) return;
    setState(() {
      if (start) {
        final length = _at(_end).difference(_at(_start));
        _start = picked;
        final end = _at(picked).add(length.isNegative ? const Duration(hours: 2) : length);
        _end = TimeOfDay.fromDateTime(end);
      } else {
        _end = picked;
      }
    });
  }

  Future<void> _submit() async {
    if (_technicianId == null) {
      setState(() => _error = 'Escolha o técnico.');
      return;
    }
    if (!_at(_end).isAfter(_at(_start))) {
      setState(() => _error = 'O fim precisa ser depois do início.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final input = VisitInput(technicianId: _technicianId!, scheduledStart: _at(_start), scheduledEnd: _at(_end));
    final g = ref.read(gatewayProvider);
    try {
      final saved = widget.visit == null
          ? await g.scheduleVisit(widget.workOrderId, input)
          : await g.rescheduleVisit(widget.visit!, input);
      if (mounted) Navigator.of(context).pop(saved);
    } on GatewayException catch (e) {
      if (!mounted) return;
      if (e is SessionLost) {
        Navigator.of(context).pop();
        reportError(context, ref, e);
        return;
      }
      setState(() => _error = e.fieldErrors.values.firstOrNull ?? e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(
        widget.visit == null
            ? 'Agendar visita · OS ${widget.workOrderNumber}'
            : 'Reagendar visita ${widget.visit!.visitNumber} · OS ${widget.workOrderNumber}',
      ),
      content: SizedBox(
        width: 460,
        child: FutureBuilder<List<Technician>>(
          future: _technicians,
          builder: (context, snap) {
            if (snap.hasError) return Text(errorMessage(snap.error!));
            if (!snap.hasData) return const SizedBox(height: 120, child: Center(child: CircularProgressIndicator()));
            final technicians = snap.data!;
            if (technicians.isEmpty) {
              return const Text('Nenhum técnico ativo. Cadastre um técnico em "Técnicos" antes de agendar.');
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<UuidValue>(
                  key: const Key('visit-technician'),
                  initialValue: technicians.any((t) => t.id == _technicianId) ? _technicianId : null,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Técnico', border: OutlineInputBorder()),
                  items: [
                    for (final t in technicians) DropdownMenuItem(value: t.id, child: Text('${t.code} · ${t.name}')),
                  ],
                  onChanged: (v) => setState(() => _technicianId = v),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  key: const Key('visit-day'),
                  onPressed: _pickDay,
                  icon: const Icon(Icons.calendar_today),
                  label: Text(formatDay(_day)),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        key: const Key('visit-start'),
                        onPressed: () => _pickTime(true),
                        icon: const Icon(Icons.schedule),
                        label: Text('Das ${_start.format(context)}'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        key: const Key('visit-end'),
                        onPressed: () => _pickTime(false),
                        icon: const Icon(Icons.schedule),
                        label: Text('às ${_end.format(context)}'),
                      ),
                    ),
                  ],
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _error!,
                    key: const Key('visit-error'),
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ],
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(onPressed: _busy ? null : () => Navigator.of(context).pop(), child: const Text('Cancelar')),
        FilledButton(
          key: const Key('visit-save'),
          onPressed: _busy ? null : _submit,
          child: Text(widget.visit == null ? 'Agendar' : 'Reagendar'),
        ),
      ],
    );
  }
}
