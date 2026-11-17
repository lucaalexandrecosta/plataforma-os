import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import '../../labels.dart';
import '../../session/session.dart';
import '../common/errors.dart';
import '../common/format.dart';
import 'visit_card.dart';

/// Relógio do app; os testes fixam o "agora".
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// Janela da agenda: de D−2 (atrasadas) a D+14 (docs/06, questão 4).
const agendaDaysBack = 2;
const agendaDaysAhead = 14;

/// Minha agenda: em andamento no topo, atrasadas e depois dia a dia.
class AgendaPage extends ConsumerStatefulWidget {
  const AgendaPage({super.key});

  @override
  ConsumerState<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends ConsumerState<AgendaPage> {
  late Future<_Agenda> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_Agenda> _load() async {
    final gateway = ref.read(gatewayProvider);
    final today = startOfDay(ref.read(clockProvider)());
    final technician = await gateway.myTechnician();
    if (technician == null) return _Agenda(null, const [], today);
    final visits = await gateway.myVisits(
      today.subtract(const Duration(days: agendaDaysBack)),
      today.add(const Duration(days: agendaDaysAhead + 1)),
    );
    return _Agenda(technician, visits, today);
  }

  Future<void> _reload() async {
    final next = _load();
    setState(() {
      _future = next;
    });
    try {
      await next;
    } on Object {
      // O FutureBuilder mostra o erro.
    }
  }

  Future<void> _open(Visit visit) async {
    await context.push('/agenda/visita/${visit.id}');
    if (mounted) await _reload();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final me = session is SignedIn ? session.me : null;
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
          IconButton(tooltip: 'Atualizar', icon: const Icon(Icons.refresh), onPressed: _reload),
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
      body: FutureBuilder<_Agenda>(
        future: _future,
        builder: (context, snap) {
          if (snap.hasError) return ErrorPanel(error: snap.error!, onRetry: _reload);
          final agenda = snap.data;
          if (agenda == null) return const Center(child: CircularProgressIndicator());
          if (agenda.technician == null) {
            return const _Message(
              icon: Icons.link_off,
              text: 'Seu acesso não está ligado a um técnico desta empresa. Peça ao despacho para fazer o vínculo.',
            );
          }
          final sections = agenda.sections();
          return RefreshIndicator(
            onRefresh: _reload,
            child: sections.isEmpty
                ? ListView(
                    children: const [
                      SizedBox(height: 120),
                      _Message(icon: Icons.event_available, text: 'Nenhuma visita na sua agenda nos próximos dias.'),
                    ],
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                    children: [
                      for (final (title, visits, daily) in sections) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 16, 4, 4),
                          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
                        ),
                        for (final v in visits)
                          VisitCard(
                            visit: v,
                            onTap: () => _open(v),
                            dayRelativeTo: daily ? null : agenda.today,
                          ),
                      ],
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class _Agenda {
  _Agenda(this.technician, this.visits, this.today);

  final Technician? technician;
  final List<Visit> visits;
  final DateTime today;

  /// Em andamento; atrasadas (agendadas de dias passados); e cada dia de hoje
  /// em diante, com as finalizadas do próprio dia. Canceladas ficam de fora.
  /// O terceiro campo diz se a seção é de um dia só (o cartão omite o dia).
  List<(String, List<Visit>, bool)> sections() {
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
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(text, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
