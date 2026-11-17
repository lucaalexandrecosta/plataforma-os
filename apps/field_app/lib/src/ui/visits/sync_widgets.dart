import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/gateway.dart';
import '../../local/database.dart';
import '../../local/field_store.dart';
import '../../session/session.dart';
import '../common/format.dart';

/// Roda o sync pedido pela pessoa. Sem rede não é erro (a fila espera);
/// sessão vencida volta ao login.
Future<void> runSync(BuildContext context, WidgetRef ref, FieldStore store) async {
  try {
    await store.sync();
  } on SessionLost {
    ref.read(sessionProvider.notifier).lost();
  } on GatewayException {
    // Fica no resumo do sync (ícone e folha).
  }
}

/// Ícone do sync na barra: pendências, enviando, sem conexão ou em dia.
class SyncButton extends ConsumerWidget {
  const SyncButton({super.key, required this.store});

  final FieldStore store;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<SyncSummary>(
      stream: store.watchSummary(),
      initialData: store.summary,
      builder: (context, snap) {
        final s = snap.data ?? const SyncSummary();
        final icon = s.syncing
            ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : Icon(
                s.error != null
                    ? Icons.cloud_off
                    : s.pending > 0
                    ? Icons.cloud_upload
                    : Icons.cloud_done,
              );
        return IconButton(
          key: const Key('sync-button'),
          tooltip: 'Sincronização',
          icon: Badge(isLabelVisible: s.pending > 0, label: Text('${s.pending}'), child: icon),
          onPressed: () => showModalBottomSheet<void>(
            context: context,
            showDragHandle: true,
            builder: (_) => _SyncSheet(store: store),
          ),
        );
      },
    );
  }
}

class _SyncSheet extends ConsumerWidget {
  const _SyncSheet({required this.store});

  final FieldStore store;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<SyncSummary>(
      stream: store.watchSummary(),
      initialData: store.summary,
      builder: (context, snap) {
        final s = snap.data ?? const SyncSummary();
        final theme = Theme.of(context);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Sincronização', style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                Text(
                  s.pending == 0
                      ? 'Tudo enviado.'
                      : '${s.pending} ${s.pending == 1 ? 'ação' : 'ações'} aguardando envio.',
                  key: const Key('sync-pending'),
                ),
                Text('Último sync: ${s.lastSyncAt == null ? 'ainda não' : formatDateTime(s.lastSyncAt)}'),
                if (s.error case final error?) ...[
                  const SizedBox(height: 8),
                  Text(error.message, style: TextStyle(color: theme.colorScheme.error)),
                  const Text('As ações ficam guardadas no aparelho e vão quando houver conexão.'),
                ],
                const SizedBox(height: 16),
                FilledButton.icon(
                  key: const Key('sync-now'),
                  icon: const Icon(Icons.sync),
                  label: const Text('Sincronizar agora'),
                  onPressed: s.syncing ? null : () => runSync(context, ref, store),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Avisos do sync (ação recusada, visita cancelada ou transferida).
class NoticesCard extends StatelessWidget {
  const NoticesCard({super.key, required this.store, required this.notices});

  final FieldStore store;
  final List<Notice> notices;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      key: const Key('notices'),
      color: scheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: scheme.onErrorContainer),
                const SizedBox(width: 8),
                Text('Precisa da sua atenção', style: TextStyle(color: scheme.onErrorContainer)),
              ],
            ),
            const SizedBox(height: 8),
            for (final n in notices)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(n.message, style: TextStyle(color: scheme.onErrorContainer)),
              ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                key: const Key('notices-ok'),
                onPressed: store.markNoticesRead,
                child: const Text('Entendi'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
