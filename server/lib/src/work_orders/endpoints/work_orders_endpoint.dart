import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/endpoints/endpoint_bases.dart';
import '../internal/work_orders.dart';

/// `workOrders.*` — ordens de serviço e tipos de OS. Toda mudança recebe a
/// versão lida (`expectedVersion`). Erros: `FORBIDDEN`, `VALIDATION_FAILED`,
/// `NOT_FOUND`, `VERSION_MISMATCH`, `INVALID_TRANSITION`,
/// `WORK_ORDER_FINISHED`, `ASSET_RETIRED`, `ASSET_INACTIVE`, `TAG_NOT_BOUND`,
/// `TAG_REVOKED`.
class WorkOrdersEndpoint extends StaffEndpoint {
  /// [search] procura no número, no patrimônio, na série e na descrição.
  /// [openOnly] = solicitada, aberta, agendada, em atendimento ou pendente.
  Future<WorkOrderPage> list(
    Session session, {
    String? search,
    List<String>? statuses,
    bool? openOnly,
    UuidValue? assetId,
    UuidValue? branchId,
    UuidValue? costCenterId,
    UuidValue? workOrderTypeId,
    int? limit,
    int? offset,
  }) => WorkOrders.list(
    session,
    search: search,
    statuses: statuses,
    openOnly: openOnly ?? false,
    assetId: assetId,
    branchId: branchId,
    costCenterId: costCenterId,
    workOrderTypeId: workOrderTypeId,
    limit: limit ?? 50,
    offset: offset ?? 0,
  );

  Future<WorkOrderDetail> get(Session session, UuidValue id) => WorkOrders.get(session, id);

  /// Abre a OS já aberta (`open`). A resposta traz as outras OS em aberto do
  /// mesmo bem, para o aviso de chamado duplicado.
  Future<WorkOrderDetail> open(Session session, WorkOrderInput input) => WorkOrders.open(session, input);

  Future<WorkOrder> update(Session session, UuidValue id, int expectedVersion, WorkOrderChanges changes) =>
      WorkOrders.update(session, id, expectedVersion, changes);

  Future<WorkOrder> start(Session session, UuidValue id, int expectedVersion) =>
      WorkOrders.start(session, id, expectedVersion);

  Future<WorkOrder> hold(Session session, UuidValue id, int expectedVersion, String holdReason, {String? note}) =>
      WorkOrders.hold(session, id, expectedVersion, holdReason: holdReason, note: note);

  Future<WorkOrder> complete(Session session, UuidValue id, int expectedVersion, String resolutionNotes) =>
      WorkOrders.complete(session, id, expectedVersion, resolutionNotes: resolutionNotes);

  Future<WorkOrder> close(Session session, UuidValue id, int expectedVersion) =>
      WorkOrders.close(session, id, expectedVersion);

  Future<WorkOrder> cancel(Session session, UuidValue id, int expectedVersion, String reason, {String? note}) =>
      WorkOrders.cancel(session, id, expectedVersion, reason: reason, note: note);

  Future<WorkOrder> reopen(Session session, UuidValue id, int expectedVersion, String reason) =>
      WorkOrders.reopen(session, id, expectedVersion, reason: reason);

  Future<List<WorkOrderType>> types(Session session, {bool? includeInactive}) =>
      WorkOrders.types(session, includeInactive: includeInactive ?? false);

  Future<WorkOrderType> createType(Session session, WorkOrderTypeInput input) => WorkOrders.createType(session, input);

  Future<WorkOrderType> updateType(Session session, UuidValue id, int expectedVersion, WorkOrderTypeInput input) =>
      WorkOrders.updateType(session, id, expectedVersion, input);
}
