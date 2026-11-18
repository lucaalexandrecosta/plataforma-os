import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:serverpod_client/serverpod_client.dart' show UuidValue;

import '../../api/gateway.dart';
import '../../device/device.dart';
import '../../labels.dart';
import '../../local/attachment_rules.dart';
import '../../local/checklist_rules.dart';
import '../../local/database.dart';
import '../../local/field_store.dart';
import '../../local/providers.dart';
import '../../local/visit_rules.dart';
import '../common/errors.dart';
import '../common/format.dart';
import 'sync_widgets.dart';
import 'visit_card.dart';
import 'visit_dialogs.dart';

/// Detalhe e execução da visita: deslocamento, check-in, pausa e finalização
/// (docs/06 §5.5 a §5.8 e §5.14). Cada ação muda a visita no banco local na
/// hora e entra na fila do sync; o servidor confirma (e move a OS) quando a
/// ação chega. Se recusar, a visita volta ao estado dele com um aviso.
class VisitPage extends ConsumerStatefulWidget {
  const VisitPage({super.key, required this.id});

  final UuidValue id;

  @override
  ConsumerState<VisitPage> createState() => _VisitPageState();
}

class _VisitPageState extends ConsumerState<VisitPage> {
  var _busy = false;

  void _snack(String text) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));

  /// Grava a ação no aparelho. [handled] deixa quem chamou tratar um erro
  /// (devolve true se tratou).
  Future<bool> _run(
    Visit visit,
    String type, {
    VisitMutationPayload? payload,
    String? done,
    bool Function(GatewayException e)? handled,
  }) async {
    final store = ref.read(storeProvider);
    if (store == null || _busy) return false;
    setState(() => _busy = true);
    try {
      await store.act(visit, type, payload ?? VisitMutationPayload());
      if (mounted && done != null) _snack(done);
      return true;
    } on GatewayException catch (e) {
      if (mounted && !(handled?.call(e) ?? false)) reportError(context, ref, e);
      return false;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _checkIn(Visit visit) async {
    final choice = await chooseCheckIn(context, hasAsset: visit.assetLabel != null);
    if (choice == null || !mounted) return;
    final device = ref.read(deviceProvider);
    switch (choice) {
      case CheckInChoice.qr:
        final code = await device.scanQr(context);
        if (code == null || !mounted) return;
        await _run(
          visit,
          VisitMutation.checkIn,
          payload: VisitMutationPayload(
            checkIn: VisitCheckIn(method: 'qr', scannedCode: code),
          ),
          done: 'Check-in registrado.',
        );
      case CheckInChoice.gps:
        await _checkInByGps(visit, device);
      case CheckInChoice.manual:
        final justification = await askText(
          context,
          title: 'Check-in manual',
          message: 'Sem QR e sem GPS, o check-in fica sinalizado para o escritório conferir.',
          fieldLabel: 'Justificativa',
        );
        if (justification == null || !mounted) return;
        await _run(
          visit,
          VisitMutation.checkIn,
          payload: VisitMutationPayload(
            checkIn: VisitCheckIn(method: 'manual', justification: justification),
          ),
          done: 'Check-in registrado.',
        );
    }
  }

  /// GPS primeiro sem justificativa; se a OS exigir o QR, pede a justificativa
  /// e tenta de novo com ela.
  Future<void> _checkInByGps(Visit visit, Device device) async {
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
    VisitMutationPayload input(String? justification) => VisitMutationPayload(
      checkIn: VisitCheckIn(
        method: 'gps',
        latitude: position.latitude,
        longitude: position.longitude,
        accuracyM: position.accuracyM,
        justification: justification,
      ),
    );
    String? ask;
    final ok = await _run(
      visit,
      VisitMutation.checkIn,
      payload: input(null),
      done: 'Check-in registrado.',
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
    await _run(visit, VisitMutation.checkIn, payload: input(justification), done: 'Check-in registrado.');
  }

  Future<void> _photo(Visit visit, String stage) async {
    final store = ref.read(storeProvider);
    if (store == null || _busy) return;
    try {
      final bytes = await ref.read(deviceProvider).takePhoto();
      if (bytes == null || !mounted) return;
      await store.addPhoto(visit, stage, bytes);
      if (mounted) _snack('Foto de ${label(photoStageLabels, stage).toLowerCase()} salva.');
    } on GatewayException catch (e) {
      if (mounted) reportError(context, ref, e);
    }
  }

  Future<void> _finish(Visit visit) async {
    final checkedIn = const {'on_site', 'paused'}.contains(visit.status);
    final input = await askFinish(context, checkedIn: checkedIn);
    if (input == null || !mounted) return;
    await _run(
      visit,
      VisitMutation.finish,
      payload: VisitMutationPayload(finish: input),
      done: 'Visita finalizada.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = ref.watch(storeProvider);
    if (store == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return StreamBuilder<Visit?>(
      stream: store.watchVisit(widget.id),
      builder: (context, snap) {
        final visit = snap.data;
        return Scaffold(
          appBar: AppBar(
            title: Text(visit == null ? 'Visita' : 'OS ${visit.workOrderNumber}'),
            actions: [SyncButton(store: store)],
          ),
          body: snap.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : visit == null
              ? const Center(child: Text('Esta visita não está mais na sua agenda.'))
              : StreamBuilder<WorkOrder?>(
                  stream: store.watchWorkOrder(visit.workOrderId),
                  builder: (context, woSnap) => StreamBuilder<SyncSummary>(
                    stream: store.watchSummary(),
                    initialData: store.summary,
                    builder: (context, sumSnap) => RefreshIndicator(
                      onRefresh: () => runSync(context, ref, store),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        children: [
                          _Header(
                            visit: visit,
                            wo: woSnap.data,
                            pending: sumSnap.data?.pendingVisitIds.contains(visit.id.uuid) ?? false,
                          ),
                          StreamBuilder<VisitChecklistState?>(
                            stream: store.watchChecklist(visit.id),
                            builder: (context, c) => switch (c.data) {
                              final checklist? => Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: _ChecklistCard(
                                  checklist: checklist,
                                  onOpen: () => context.push('/agenda/visita/${visit.id}/checklist'),
                                ),
                              ),
                              null => const SizedBox.shrink(),
                            },
                          ),
                          const SizedBox(height: 8),
                          _EvidenceCard(
                            visit: visit,
                            attachments: store.watchAttachments(visit.id),
                            busy: _busy,
                            onPhoto: (stage) => _photo(visit, stage),
                            onSign: () => context.push('/agenda/visita/${visit.id}/assinatura'),
                          ),
                          const SizedBox(height: 8),
                          _Details(visit: visit, wo: woSnap.data),
                        ],
                      ),
                    ),
                  ),
                ),
          bottomNavigationBar: visit == null ? null : _actions(visit),
        );
      },
    );
  }

  Widget? _actions(Visit visit) {
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
        primary.add(
          main(
            'act-travel',
            Icons.directions_car,
            'Iniciar deslocamento',
            () => _run(visit, VisitMutation.startTravel, done: 'Deslocamento iniciado.'),
          ),
        );
        secondary.add(other('act-checkin', Icons.place, 'Cheguei', () => _checkIn(visit)));
        secondary.add(other('act-not-done', Icons.event_busy, 'Não atendida', () => _finish(visit)));
      case 'en_route':
        primary.add(main('act-checkin', Icons.place, 'Cheguei', () => _checkIn(visit)));
        secondary.add(other('act-not-done', Icons.event_busy, 'Não atendida', () => _finish(visit)));
      case 'on_site':
        primary.add(main('act-finish', Icons.task_alt, 'Finalizar visita', () => _finish(visit)));
        secondary.add(
          other('act-pause', Icons.pause, 'Pausar', () => _run(visit, VisitMutation.pause, done: 'Visita pausada.')),
        );
      case 'paused':
        primary.add(
          main(
            'act-resume',
            Icons.play_arrow,
            'Retomar',
            () => _run(visit, VisitMutation.resume, done: 'Atendimento retomado.'),
          ),
        );
        secondary.add(other('act-finish', Icons.task_alt, 'Finalizar visita', () => _finish(visit)));
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
  const _Header({required this.visit, required this.wo, required this.pending});

  final Visit visit;
  final WorkOrder? wo;
  final bool pending;

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
                if (pending) const PendingBadge(),
              ],
            ),
            const SizedBox(height: 12),
            Text(wo?.workOrderTypeName ?? 'OS', style: theme.textTheme.titleMedium),
            Text(
              '${formatDay(visit.scheduledStart, DateTime.now())} · ${formatWindow(visit.scheduledStart, visit.scheduledEnd)}',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Situação da OS: ${label(workOrderStatusLabels, visit.workOrderStatus)}',
              key: const Key('wo-status'),
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChecklistCard extends StatelessWidget {
  const _ChecklistCard({required this.checklist, required this.onOpen});

  final VisitChecklistState checklist;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = checklist.submitted
        ? (checklist.pending ? 'Enviado, aguardando sinal' : 'Enviado')
        : checklist.answered == 0
        ? 'Não iniciado'
        : 'Em preenchimento';
    return Card(
      child: ListTile(
        key: const Key('visit-checklist'),
        leading: Icon(checklist.submitted ? Icons.fact_check : Icons.checklist, color: theme.colorScheme.primary),
        title: Text(checklist.template.name),
        subtitle: Text('${checklist.answered} de ${checklist.total} respondidos · $status'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onOpen,
      ),
    );
  }
}

/// Fotos (antes, depois, evidência) e assinatura da visita, com o que o
/// tipo de OS exige e a situação do envio de cada arquivo.
class _EvidenceCard extends StatelessWidget {
  const _EvidenceCard({
    required this.visit,
    required this.attachments,
    required this.busy,
    required this.onPhoto,
    required this.onSign,
  });

  final Visit visit;
  final Stream<List<LocalAttachment>> attachments;
  final bool busy;
  final ValueChanged<String> onPhoto;
  final VoidCallback onSign;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final open = const {'on_site', 'paused'}.contains(visit.status);
    final required = [
      if (visit.requirePhotos) '1 foto de antes e 1 de depois',
      if (visit.requireSignature) 'assinatura',
    ];
    return StreamBuilder<List<LocalAttachment>>(
      stream: attachments,
      builder: (context, snap) {
        final all = snap.data ?? const <LocalAttachment>[];
        final photos = [
          for (final a in all)
            if (a.kind == 'photo' && a.status != attachmentFailed) a,
        ];
        if (!open && photos.isEmpty && visit.signerName == null) return const SizedBox.shrink();
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              key: const Key('evidence-card'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fotos e assinatura', style: theme.textTheme.titleMedium),
                if (required.isNotEmpty)
                  Text(
                    'Obrigatório para concluir: ${required.join(' e ')}.',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                if (photos.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [for (final p in photos) _Thumb(attachment: p)],
                  ),
                ],
                if (open) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final MapEntry(:key, :value) in photoStageLabels.entries)
                        OutlinedButton.icon(
                          key: Key('photo-$key'),
                          onPressed: busy ? null : () => onPhoto(key),
                          icon: const Icon(Icons.photo_camera_outlined),
                          label: Text(value),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                if (visit.signerName case final name?)
                  ListTile(
                    key: const Key('signed'),
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.draw),
                    title: Text('Assinado por $name'),
                    subtitle: Text(
                      [label(signerRoleLabels, visit.signerRole), formatDateTime(visit.signedAt)].join(' · '),
                    ),
                  )
                else if (open)
                  FilledButton.tonalIcon(
                    key: const Key('act-sign'),
                    onPressed: busy ? null : onSign,
                    icon: const Icon(Icons.draw),
                    label: const Text('Coletar assinatura'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.attachment});

  final LocalAttachment attachment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uploaded = attachment.status == attachmentUploaded;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.memory(
            attachment.bytes,
            width: 84,
            height: 84,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              width: 84,
              height: 84,
              color: theme.colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.image_outlined),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              uploaded ? Icons.cloud_done_outlined : Icons.cloud_upload_outlined,
              size: 14,
              color: uploaded ? theme.colorScheme.primary : theme.colorScheme.tertiary,
            ),
            const SizedBox(width: 2),
            Text(label(photoStageLabels, attachment.photoStage), style: theme.textTheme.labelSmall),
          ],
        ),
      ],
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.visit, required this.wo});

  final Visit visit;
  final WorkOrder? wo;

  @override
  Widget build(BuildContext context) {
    final wo = this.wo;
    final where = [visit.customerName, visit.branchName].whereType<String>().join(' · ');
    final asset = [visit.assetLabel, visit.productName].whereType<String>().join(' · ');
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
            _Line(Icons.report_problem_outlined, 'Problema', visit.problemDescription ?? '—'),
            if (wo != null && (wo.requesterName != null || wo.requesterPhone != null))
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
