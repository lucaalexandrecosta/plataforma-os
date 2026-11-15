import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/endpoints/endpoint_bases.dart';
import '../internal/asset_registry.dart';

/// `assets.*` — cadastro de bens. Erros: `FORBIDDEN`, `VALIDATION_FAILED`,
/// `NOT_FOUND`, `VERSION_MISMATCH`, `ERP_MASTER_READ_ONLY`.
class AssetsEndpoint extends StaffEndpoint {
  /// [search] procura no patrimônio, na série e no nome do produto.
  Future<AssetPage> list(
    Session session, {
    String? search,
    UuidValue? branchId,
    UuidValue? costCenterId,
    bool? includeInactive,
    int? limit,
    int? offset,
  }) => AssetRegistry.list(
    session,
    search: search,
    branchId: branchId,
    costCenterId: costCenterId,
    includeInactive: includeInactive ?? false,
    limit: limit ?? 50,
    offset: offset ?? 0,
  );

  Future<Asset> get(Session session, UuidValue id) => AssetRegistry.get(session, id);

  Future<Asset> create(Session session, AssetInput input) => AssetRegistry.create(session, input);

  Future<Asset> update(Session session, UuidValue id, int expectedVersion, AssetInput input) =>
      AssetRegistry.update(session, id, expectedVersion, input);
}
