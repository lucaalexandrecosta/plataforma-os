import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import '../../labels.dart';
import '../../local/field_store.dart';
import '../../local/providers.dart';
import '../../session/session.dart';
import '../common/format.dart';
import 'sync_widgets.dart';
import 'visit_card.dart';

/// Minha agenda, lida do banco local: em andamento no topo, atrasadas e
/// depois dia a dia. Funciona sem sinal; o sync roda ao abrir, ao puxar a
/// lista, depois de cada ação e a cada 5 minutos.
class AgendaPage extends ConsumerStatefulWidget {
  const AgendaPage({super.key});

  @override
  ConsumerState<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends ConsumerState<AgendaPage> {
  FieldStore? _syncedStore;

  /// Sync inicial de cada banco aberto (ao entrar ou trocar de empresa).
  void _firstSync(FieldStore store) {
    if (identical(_syncedStore, store)) return;
    _syncedStore = store;
    WidgetsBinding.instance.addPostFrameCallback((_) => runSync(context, ref, store));
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final store = ref.watch(storeProvider);
    final me = session is SignedIn ? session.me : null;
    if (store == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    _firstSync(store);
    final today = startOfDay(ref.watch(clockProvider)());
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Minha agenda'),
            if (me != null) Text(me.tenant.displayName, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        actions: [
          SyncButton(store: store),
          PopupMenuButton<String>(
            key: const Key('user-menu'),
            icon: const Icon(Icons.account_circle),
            onSelected: (value) => switch (value) {
              'tenant' => ref.read(sessionProvider.notifier).chooseAnotherTenant(),
              _ => ref.read(sessionProvider.notifier).signOut(),
            },
            itemBuilder: (context) => [
              if (me != null) PopupMenuItem(enabled: false, child: Text(me.fullName)),
              if (session is SignedIn && session.tenants.length > 1)
                const PopupMenuItem(value: 'tenant', child: Text('Trocar de empresa')),
              const PopupMenuItem(value: 'out', child: Text('Sair')),
            ],
          ),
        ],
      ),
      body: StreamBuilder<SyncSummary>(
        stream: store.watchSummary(),
        initialData: store.summary,
        builder: (context, summarySnap) {
          final summary = summarySnap.data ?? const SyncSummary();
          return StreamBuilder<List<Visit>>(
            stream: store.watchVisits(),
            builder: (context, snap) {
              final visits = snap.data;
              if (visits == null) return const Center(child: CircularProgressIndicator());
              if (summary.error?.code == 'FORBIDDEN') {
                return const _Message(
                  icon: Icons.link_off,
                  text: 'Seu acesso não está ligado a um técnico desta empresa. Peça ao despacho para fazer o vínculo.',
                );
              }
              final sections = agendaSections(visits, today);
              final children = <Widget>[
                if (summary.notices.isNotEmpty) NoticesCard(store: store, notices: summary.notices),
                if (sections.isEmpty)
                  summary.lastSyncAt == null && summary.error == null
                      ? const _Message(icon: Icons.cloud_download, text: 'Baixando sua agenda…')
                      : const _Message(
                          icon: Icons.event_available,
                          text: 'Nenhuma visita na sua agenda nos próximos dias.',
                        ),
                for (final (title, list, daily) in sections) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 16, 4, 4),
                    child: Text(title, style: Theme.of(context).textTheme.titleMedium),
                  ),
                  for (final v in list)
                    VisitCard(
                      visit: v,
                      pending: summary.pendingVisitIds.contains(v.id.uuid),
                      onTap: () => context.push('/agenda/visita/${v.id}'),
                      dayRelativeTo: daily ? null : today,
                    ),
                ],
              ];
              return RefreshIndicator(
                onRefresh: () => runSync(context, ref, store),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                  children: children,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Em andamento; atrasadas (agendadas de dias passados); e cada dia de hoje
/// em diante, com as finalizadas do próprio dia. Canceladas ficam de fora.
/// O terceiro campo diz se a seção é de um dia só (o cartão omite o dia).
List<(String, List<Visit>, bool)> agendaSections(List<Visit> visits, DateTime today) {
  final sorted = [...visits]..sort((a, b) => a.scheduledStart.compareTo(b.scheduledStart));
  final active = sorted.where((v) => activeVisitStatuses.contains(v.status)).toList();
  final late = sorted.where((v) => v.status == 'scheduled' && startOfDay(v.scheduledStart).isBefore(today)).toList();
  final byDay = <DateTime, List<Visit>>{};
  for (final v in sorted) {
    if (v.status == 'cancelled' || activeVisitStatuses.contains(v.status)) continue;
    final day = startOfDay(v.scheduledStart);
    if (day.isBefore(today)) continue;
    byDay.putIfAbsent(day, () => []).add(v);
  }
  return [
    if (active.isNotEmpty) ('Em andamento', active, false),
    if (late.isNotEmpty) ('Atrasadas', late, false),
    for (final MapEntry(:key, :value) in byDay.entries) (formatDay(key, today), value, true),
  ];
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 96, 32, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(height: 12),
          Text(text, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
