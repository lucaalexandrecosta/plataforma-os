import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/endpoints/endpoint_bases.dart';
import '../internal/visits.dart';

/// `visits.*` — agenda (despacho) e execução da visita pelo técnico. Toda
/// mudança recebe a versão lida (`expectedVersion`) e devolve a visita com o
/// status atual da OS. Erros: `FORBIDDEN`, `VALIDATION_FAILED`, `NOT_FOUND`,
/// `VERSION_MISMATCH`, `INVALID_TRANSITION`, `WORK_ORDER_NOT_SCHEDULABLE`,
/// `VISIT_NOT_SCHEDULED`, `ANOTHER_VISIT_ACTIVE`, `QR_ASSET_MISMATCH`,
/// `CHECK_IN_REQUIRED`.
class VisitsEndpoint extends StaffEndpoint {
  /// Visitas que começam no período [from, to) (até 62 dias).
  Future<List<Visit>> agenda(
    Session session,
    DateTime from,
    DateTime to, {
    UuidValue? technicianId,
    bool? includeCancelled,
  }) => Visits.agenda(
    session,
    from: from,
    to: to,
    technicianId: technicianId,
    includeCancelled: includeCancelled ?? false,
  );

  /// Visitas do técnico logado no período, mais as que estão em andamento.
  Future<List<Visit>> mine(Session session, DateTime from, DateTime to) => Visits.mine(session, from: from, to: to);

  Future<List<Visit>> ofWorkOrder(Session session, UuidValue workOrderId) => Visits.ofWorkOrder(session, workOrderId);

  Future<Visit> get(Session session, UuidValue id) => Visits.get(session, id);

  Future<Visit> schedule(Session session, UuidValue workOrderId, VisitInput input) =>
      Visits.schedule(session, workOrderId, input);

  Future<Visit> reschedule(Session session, UuidValue id, int expectedVersion, VisitInput input) =>
      Visits.reschedule(session, id, expectedVersion, input);

  Future<Visit> cancel(Session session, UuidValue id, int expectedVersion, String reason) =>
      Visits.cancel(session, id, expectedVersion, reason: reason);

  Future<Visit> startTravel(Session session, UuidValue id, int expectedVersion) =>
      Visits.startTravel(session, id, expectedVersion);

  Future<Visit> checkIn(Session session, UuidValue id, int expectedVersion, VisitCheckIn input) =>
      Visits.checkIn(session, id, expectedVersion, input);

  Future<Visit> pause(Session session, UuidValue id, int expectedVersion) => Visits.pause(session, id, expectedVersion);

  Future<Visit> resume(Session session, UuidValue id, int expectedVersion) =>
      Visits.resume(session, id, expectedVersion);

  Future<Visit> finish(Session session, UuidValue id, int expectedVersion, VisitFinish input) =>
      Visits.finish(session, id, expectedVersion, input);
}
