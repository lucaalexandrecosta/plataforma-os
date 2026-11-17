import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/endpoints/endpoint_bases.dart';
import '../internal/asset_movements.dart';
import '../internal/asset_registry.dart';

/// `assets.*` — cadastro e movimentação de bens. Erros: `FORBIDDEN`,
/// `VALIDATION_FAILED`, `NOT_FOUND`, `VERSION_MISMATCH`, `ERP_MASTER_READ_ONLY`,
/// `ASSET_RETIRED`, `ASSET_INACTIVE`, `ALREADY_AT_SITE`, `NOT_INSTALLED`,
/// `MOVEMENT_APPROVAL_UNSUPPORTED`.
class AssetsEndpoint extends StaffEndpoint {
  /// [search] procura no patrimônio, na série e no nome do produto.
  Future<AssetPage> list(
    Session session, {
    String? search,
    UuidValue? branchId,
    UuidValue? costCenterId,
    UuidValue? customerId,
    bool? includeInactive,
    int? limit,
    int? offset,
  }) => AssetRegistry.list(
    session,
    search: search,
    branchId: branchId,
    costCenterId: costCenterId,
    customerId: customerId,
    includeInactive: includeInactive ?? false,
    limit: limit ?? 50,
    offset: offset ?? 0,
  );

  Future<Asset> get(Session session, UuidValue id) => AssetRegistry.get(session, id);

  Future<Asset> create(Session session, AssetInput input) => AssetRegistry.create(session, input);

  Future<Asset> update(Session session, UuidValue id, int expectedVersion, AssetInput input) =>
      AssetRegistry.update(session, id, expectedVersion, input);

  /// Instala o bem na unidade do cliente (comodato, locação ou do cliente).
  /// Se já estiver em outra unidade, encerra lá e vira transferência.
  Future<Asset> install(Session session, UuidValue id, int expectedVersion, AssetInstallInput input) =>
      AssetMovements.install(session, id, expectedVersion, input);

  /// Encerra a alocação vigente; o bem volta ao estoque.
  Future<Asset> withdraw(Session session, UuidValue id, int expectedVersion, AssetWithdrawInput input) =>
      AssetMovements.withdraw(session, id, expectedVersion, input);

  /// Histórico de alocações do bem, a mais recente primeiro.
  Future<List<AssetAssignment>> assignments(Session session, UuidValue id) => AssetMovements.history(session, id);
}
