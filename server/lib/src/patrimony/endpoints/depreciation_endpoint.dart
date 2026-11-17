import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/endpoints/endpoint_bases.dart';
import '../internal/depreciation.dart';

/// `depreciation.*` — ficha patrimonial, memória de cálculo, posição mensal e
/// fechamento da competência (livro gerencial). Valores em centavos. Erros:
/// `FORBIDDEN`, `VALIDATION_FAILED`, `NOT_FOUND`, `VERSION_MISMATCH`,
/// `PROFILE_EXISTS`, `COST_REQUIRED`, `PERIOD_IN_FUTURE`, `ALREADY_CLOSED`,
/// `PERIOD_OUT_OF_ORDER`, `NOT_CLOSED`, `NOT_LATEST_CLOSING`.
class DepreciationEndpoint extends StaffEndpoint {
  /// Ficha do bem, ou nulo se ainda não tem.
  Future<DepreciationProfile?> profile(Session session, UuidValue assetId) => Depreciation.profile(session, assetId);

  /// Cria ([expectedVersion] nulo) ou altera a ficha.
  Future<DepreciationProfile> saveProfile(
    Session session,
    UuidValue assetId,
    int? expectedVersion,
    DepreciationProfileInput input,
  ) => Depreciation.saveProfile(session, assetId, expectedVersion, input);

  /// Memória de cálculo mês a mês.
  Future<AssetDepreciation> schedule(Session session, UuidValue assetId) => Depreciation.schedule(session, assetId);

  Future<DepreciationPosition> position(
    Session session,
    int year,
    int month, {
    UuidValue? branchId,
    UuidValue? costCenterId,
  }) => Depreciation.position(session, year: year, month: month, branchId: branchId, costCenterId: costCenterId);

  Future<List<DepreciationClosing>> closings(Session session) => Depreciation.closings(session);

  Future<DepreciationClosing> close(Session session, int year, int month) =>
      Depreciation.close(session, year: year, month: month);

  Future<DepreciationClosing> reopen(Session session, int year, int month, String reason) =>
      Depreciation.reopen(session, year: year, month: month, reason: reason);
}
