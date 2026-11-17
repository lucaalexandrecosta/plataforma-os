import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/endpoints/endpoint_bases.dart';
import '../internal/technicians.dart';

/// `technicians.*` — técnicos próprios. Erros: `FORBIDDEN`,
/// `VALIDATION_FAILED`, `NOT_FOUND`, `VERSION_MISMATCH`.
class TechniciansEndpoint extends StaffEndpoint {
  Future<List<Technician>> list(Session session, {bool? includeInactive}) =>
      Technicians.list(session, includeInactive: includeInactive ?? false);

  /// Técnico ligado a quem está logado (app de campo), ou nulo.
  Future<Technician?> mine(Session session) => Technicians.mine(session);

  Future<Technician> create(Session session, TechnicianInput input) => Technicians.create(session, input);

  Future<Technician> update(Session session, UuidValue id, int expectedVersion, TechnicianInput input) =>
      Technicians.update(session, id, expectedVersion, input);
}
