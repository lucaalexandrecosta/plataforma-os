import 'package:plataforma_os_core/plataforma_os_core.dart';
import 'package:test/test.dart';

void main() {
  group('WorkOrderStatus', () {
    test('valores do banco ida e volta', () {
      for (final s in WorkOrderStatus.values) {
        expect(WorkOrderStatus.fromDb(s.dbValue), s);
      }
      expect(WorkOrderStatus.inProgress.dbValue, 'in_progress');
      expect(WorkOrderStatus.onHold.dbValue, 'on_hold');
    });

    test('tabela igual à do trigger trg_guard_status', () {
      // Cópia literal de c_allowed em app.tg_work_order_status_guard.
      const trigger = {
        'requested': ['open', 'completed', 'cancelled'],
        'open': ['scheduled', 'in_progress', 'completed', 'cancelled'],
        'scheduled': ['open', 'in_progress', 'on_hold', 'cancelled'],
        'in_progress': ['on_hold', 'completed', 'open', 'scheduled'],
        'on_hold': ['scheduled', 'in_progress', 'open', 'cancelled'],
        'completed': ['closed', 'open'],
        'closed': ['open'],
        'cancelled': ['open'],
      };
      for (final from in WorkOrderStatus.values) {
        for (final to in WorkOrderStatus.values) {
          expect(
            from.canTransitionTo(to),
            trigger[from.dbValue]!.contains(to.dbValue),
            reason: '${from.dbValue} → ${to.dbValue}',
          );
        }
      }
    });

    test('requested → in_progress é inválida', () {
      expect(WorkOrderStatus.requested.canTransitionTo(WorkOrderStatus.inProgress), isFalse);
    });

    test('resolução remota só de requested/open e sem visita ativa', () {
      const remote = ResolutionMode.remote;
      expect(WorkOrderStatus.requested.canTransitionWith(WorkOrderStatus.completed, mode: remote), isTrue);
      expect(WorkOrderStatus.open.canTransitionWith(WorkOrderStatus.completed, mode: remote), isTrue);
      expect(WorkOrderStatus.open.canTransitionWith(WorkOrderStatus.completed), isFalse, reason: 'modo field');
      expect(
        WorkOrderStatus.open.canTransitionWith(WorkOrderStatus.completed, mode: remote, hasActiveVisit: true),
        isFalse,
      );
      expect(WorkOrderStatus.inProgress.canTransitionWith(WorkOrderStatus.completed, mode: remote), isFalse);
      expect(WorkOrderStatus.inProgress.canTransitionWith(WorkOrderStatus.completed), isTrue);
    });

    test('reabertura', () {
      expect(WorkOrderStatus.closed.isReopeningTo(WorkOrderStatus.open), isTrue);
      expect(WorkOrderStatus.scheduled.isReopeningTo(WorkOrderStatus.open), isFalse);
    });
  });

  group('VisitStatus', () {
    test('tabela igual à do trigger da visita', () {
      const trigger = {
        'scheduled': ['en_route', 'on_site', 'finished', 'cancelled'],
        'en_route': ['on_site', 'finished', 'cancelled'],
        'on_site': ['paused', 'finished'],
        'paused': ['on_site', 'finished'],
        'finished': <String>[],
        'cancelled': <String>[],
      };
      for (final from in VisitStatus.values) {
        for (final to in VisitStatus.values) {
          expect(
            from.canTransitionTo(to),
            trigger[from.dbValue]!.contains(to.dbValue),
            reason: '${from.dbValue} → ${to.dbValue}',
          );
        }
      }
    });

    test('sem check-in só termina como ausente ou não executada', () {
      expect(VisitStatus.scheduled.canFinishWith(VisitOutcome.resolved), isFalse);
      expect(VisitStatus.enRoute.canFinishWith(VisitOutcome.customerAbsent), isTrue);
      expect(VisitStatus.onSite.canFinishWith(VisitOutcome.resolved), isTrue);
      expect(VisitStatus.finished.canFinishWith(VisitOutcome.resolved), isFalse);
    });
  });

  group('UuidV7', () {
    final now = DateTime.utc(2026, 11, 7, 12);
    test('aceita v7 e lê o instante', () {
      expect(UuidV7.isV7('0197f000-0001-7000-8000-000000000001'), isTrue);
      expect(UuidV7.timestampOf('0197f000-0001-7000-8000-000000000001').year, 2025);
    });
    test('recusa v4 e futuro distante', () {
      expect(UuidV7.isAcceptable('3f2b8c1e-6a4d-4e1f-9b2a-7c3d5e6f7a8b', now: now), isFalse);
      final future = now.add(const Duration(days: 30)).millisecondsSinceEpoch.toRadixString(16).padLeft(12, '0');
      final id = '${future.substring(0, 8)}-${future.substring(8)}-7000-8000-000000000000';
      expect(UuidV7.isAcceptable(id, now: now), isFalse);
    });
  });
}
