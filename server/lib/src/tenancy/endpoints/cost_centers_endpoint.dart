import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/endpoints/endpoint_bases.dart';
import '../internal/cost_centers.dart';

/// `costCenters.*` — centros de custo. Leitura para a equipe (com [branchId],
/// os da filial e os que valem para todas); alteração com `settings.manage`.
class CostCentersEndpoint extends StaffEndpoint {
  Future<List<CostCenter>> list(Session session, {UuidValue? branchId, bool? includeInactive}) =>
      CostCenters.list(session, branchId: branchId, includeInactive: includeInactive ?? false);

  Future<CostCenter> create(Session session, CostCenterInput input) => CostCenters.create(session, input);

  Future<CostCenter> update(Session session, UuidValue id, int expectedVersion, CostCenterInput input) =>
      CostCenters.update(session, id, expectedVersion, input);
}
