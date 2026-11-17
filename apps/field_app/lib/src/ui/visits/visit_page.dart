import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:serverpod_client/serverpod_client.dart' show UuidValue;

import '../../api/gateway.dart';
import '../../device/device.dart';
import '../../labels.dart';
import '../../session/session.dart';
import '../common/errors.dart';
import '../common/format.dart';
import 'visit_card.dart';
import 'visit_dialogs.dart';

/// Detalhe e execução da visita: deslocamento, check-in, pausa e finalização
/// (docs/06 §5.5 a §5.8 e §5.14). Cada ação vai direto ao servidor nesta
/// versão; o servidor move a OS na mesma transação (visita resolvida, sem
/// outra ativa, conclui a OS; ou encerra, se o tenant dispensa a conferência).
class VisitPage extends ConsumerStatefulWidget {
  const VisitPage({super.key, required this.id});

  final UuidValue id;

  @override
  ConsumerState<VisitPage> createState() => _VisitPageState();
}

class _VisitPageState extends ConsumerState<VisitPage> {
  Visit? _visit;
  WorkOrderDetail? _wo;
  Object? _error;
  var _busy = false;

  Gateway get _gateway => ref.read(gatewayProvider);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final visit = await _gateway.visit(widget.id);
      final wo = await _gateway.workOrder(visit.workOrderId);
      if (mounted) {
        setState(() {
          _visit = visit;
          _wo = wo;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  void _snack(String text) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));

  /// Roda a ação; se a visita mudou no servidor, recarrega e avisa.
  /// [handled] deixa quem chamou tratar um erro (devolve true se tratou).
  Future<bool> _run(
    Future<Visit> Function(Visit visit) action, {
    String? done,
    bool Function(GatewayException e)? handled,
  }) async {
    final visit = _visit;
    if (visit == null || _busy) return false;
    setState(() => _busy = true);
    try {
      final updated = await action(visit);
      final wo = await _gateway.workOrder(updated.workOrderId);
      if (!mounted) return true;
      setState(() {
        _visit = updated;
        _wo = wo;
      });
      if (done != null) _snack(done);
      return true;
    } on GatewayException catch (e) {
      if (!mounted || (handled?.call(e) ?? false)) return false;
      if (e.code == 'VERSION_MISMATCH' || e.code == 'NOT_FOUND') {
        await _load();
        if (mounted) _snack('A visita mudou no escritório. A tela foi atualizada; confira e tente de novo.');
      } else {
        reportError(context, ref, e);
      }
      return false;
    } catch (e) {
      if (mounted) reportError(context, ref, e);
      return false;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _startTravel() => _run(_gateway.startTravel, done: 'Deslocamento iniciado.');

  Future<void> _checkIn() async {
    final hasAsset = _wo?.workOrder.assetId != null;
    final choice = await chooseCheckIn(context, hasAsset: hasAsset);
    if (choice == null || !mounted) return;
    final device = ref.read(deviceProvider);
    switch (choice) {
      case CheckInChoice.qr:
        final code = await device.scanQr(context);
        if (code == null || !mounted) return;
        await _run(
          (v) => _gateway.checkIn(v, VisitCheckIn(method: 'qr', scannedCode: code)),
          done: 'Check-in confirmado.',
        );
      case CheckInChoice.gps:
        await _checkInByGps(device);
      case CheckInChoice.manual:
        final justification = await askText(
          context,
          title: 'Check-in manual',
          message: 'Sem QR e sem GPS, o check-in fica sinalizado para o escritório conferir.',
          fieldLabel: 'Justificativa',
        );
        if (justification == null || !mounted) return;
        await _run(
          (v) => _gateway.checkIn(v, VisitCheckIn(method: 'manual', justification: justification)),
          done: 'Check-in registrado.',
        );
    }
  }

  /// GPS primeiro sem justificativa; se a OS exigir o QR, o servidor pede a
  /// justificativa e o app tenta de novo com ela.
  Future<void> _checkInByGps(Device device) async {
    final DevicePosition position;
    setState(() => _busy = true);
    try {
      position = await device.position();
    } catch (e) {
      if (mounted) reportError(context, ref, e);
      return;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
    VisitCheckIn input(String? justification) => VisitCheckIn(
      method: 'gps',
      latitude: position.latitude,
      longitude: position.longitude,
      accuracyM: position.accuracyM,
      justification: justification,
    );
    String? ask;
    final ok = await _run(
      (v) => _gateway.checkIn(v, input(null)),
      done: 'Check-in confirmado.',
      handled: (e) => (ask = e.fieldErrors['justification']) != null,
    );
    final message = ask;
    if (ok || message == null || !mounted) return;
    final justification = await askText(
      context,
      title: 'Check-in por GPS',
      message: message,
      fieldLabel: 'Justificativa',
    );
    if (justification == null || !mounted) return;
    await _run((v) => _gateway.checkIn(v, input(justification)), done: 'Check-in registrado.');
  }

  Future<void> _pause() => _run(_gateway.pause, done: 'Visita pausada.');

  Future<void> _resume() => _run(_gateway.resume, done: 'Atendimento retomado.');

  Future<void> _finish() async {
    final checkedIn = const {'on_site', 'paused'}.contains(_visit?.status);
    final input = await askFinish(context, checkedIn: checkedIn);
    if (input == null || !mounted) return;
    await _run((v) => _gateway.finish(v, input), done: 'Visita finalizada.');
  }

  @override
  Widget build(BuildContext context) {
    final visit = _visit;
    final wo = _wo?.workOrder;
    return Scaffold(
      appBar: AppBar(title: Text(visit == null ? 'Visita' : 'OS ${visit.workOrderNumber}')),
      body: _error != null
          ? ErrorPanel(error: _error!, onRetry: _load)
          : visit == null || wo == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  _Header(visit: visit, wo: wo),
                  const SizedBox(height: 8),
                  _Details(visit: visit, wo: wo),
                ],
              ),
            ),
      bottomNavigationBar: visit == null || wo == null ? null : _actions(visit, wo),
    );
  }

  Widget? _actions(Visit visit, WorkOrder wo) {
    final primary = <Widget>[];
    final secondary = <Widget>[];
    Widget main(String key, IconData icon, String text, VoidCallback onPressed) => FilledButton.icon(
      key: Key(key),
      style: _bigButton,
      icon: Icon(icon),
      label: Text(text),
      onPressed: _busy ? null : onPressed,
    );
    Widget other(String key, IconData icon, String text, VoidCallback onPressed) => OutlinedButton.icon(
      key: Key(key),
      style: _bigButton,
      icon: Icon(icon),
      label: Text(text),
      onPressed: _busy ? null : onPressed,
    );
    switch (visit.status) {
      case 'scheduled':
        primary.add(main('act-travel', Icons.directions_car, 'Iniciar deslocamento', _startTravel));
        secondary.add(other('act-checkin', Icons.place, 'Cheguei', _checkIn));
        secondary.add(other('act-not-done', Icons.event_busy, 'Não atendida', _finish));
      case 'en_route':
        primary.add(main('act-checkin', Icons.place, 'Cheguei', _checkIn));
        secondary.add(other('act-not-done', Icons.event_busy, 'Não atendida', _finish));
      case 'on_site':
        primary.add(main('act-finish', Icons.task_alt, 'Finalizar visita', _finish));
        secondary.add(other('act-pause', Icons.pause, 'Pausar', _pause));
      case 'paused':
        primary.add(main('act-resume', Icons.play_arrow, 'Retomar', _resume));
        secondary.add(other('act-finish', Icons.task_alt, 'Finalizar visita', _finish));
    }
    if (primary.isEmpty && secondary.isEmpty) return null;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_busy) const LinearProgressIndicator(),
            ...primary,
            if (secondary.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  for (final (i, w) in secondary.indexed) ...[
                    if (i > 0) const SizedBox(width: 8),
                    Expanded(child: w),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

final _bigButton = ButtonStyle(minimumSize: WidgetStateProperty.all(const Size.fromHeight(52)));

class _Header extends StatelessWidget {
  const _Header({required this.visit, required this.wo});

  final Visit visit;
  final WorkOrder wo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                VisitStatusChip(visit.status),
                PriorityBadge(visit.workOrderPriority),
                Text('Visita ${visit.visitNumber}', style: theme.textTheme.labelLarge),
              ],
            ),
            const SizedBox(height: 12),
            Text(wo.workOrderTypeName, style: theme.textTheme.titleMedium),
            Text(
              '${formatDay(visit.scheduledStart, DateTime.now())} · ${formatWindow(visit.scheduledStart, visit.scheduledEnd)}',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Situação da OS: ${label(workOrderStatusLabels, wo.status)}',
              key: const Key('wo-status'),
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.visit, required this.wo});

  final Visit visit;
  final WorkOrder wo;

  @override
  Widget build(BuildContext context) {
    final where = [wo.customerName, wo.branchName].whereType<String>().join(' · ');
    final asset = [wo.assetLabel, wo.productName].whereType<String>().join(' · ');
    final checkIn = visit.checkedInAt == null
        ? null
        : [
            formatDateTime(visit.checkedInAt),
            label(checkInMethodLabels, visit.checkInMethod),
            if (visit.checkInDistanceM case final d?) 'a ${formatDistance(d)}',
            if (visit.checkInOffSite) 'fora do local',
          ].join(' · ');
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            _Line(Icons.business, 'Local', where.isEmpty ? '—' : where),
            _Line(Icons.inventory_2_outlined, 'Equipamento', asset.isEmpty ? 'OS sem bem' : asset),
            _Line(Icons.report_problem_outlined, 'Problema', wo.problemDescription ?? '—'),
            if (wo.requesterName != null || wo.requesterPhone != null)
              _Line(
                Icons.person_outline,
                'Solicitante',
                [wo.requesterName, wo.requesterPhone].whereType<String>().join(' · '),
              ),
            if (visit.travelStartedAt != null)
              _Line(Icons.directions_car, 'Deslocamento', formatDateTime(visit.travelStartedAt)),
            if (checkIn != null) _Line(Icons.place, 'Check-in', checkIn),
            if (visit.checkInJustification case final j?) _Line(Icons.notes, 'Justificativa', j),
            if (visit.finishedAt != null)
              _Line(
                Icons.task_alt,
                'Término',
                '${formatDateTime(visit.finishedAt)} · ${label(outcomeLabels, visit.outcome)}',
              ),
            if (visit.outcomeNotes case final n?) _Line(Icons.description_outlined, 'Relato', n),
            if (visit.cancellationReason case final r?) _Line(Icons.block, 'Cancelada', r),
          ],
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line(this.icon, this.title, this.value);

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(value, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
