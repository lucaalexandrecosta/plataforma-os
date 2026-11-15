import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/endpoints/endpoint_bases.dart';
import '../internal/branches.dart';

/// `branches.*` — filiais. Leitura para a equipe; alteração com
/// `settings.manage` (administrador). Erros: `FORBIDDEN`, `VALIDATION_FAILED`,
/// `NOT_FOUND`, `VERSION_MISMATCH`, `DEFAULT_BRANCH_REQUIRED`.
class BranchesEndpoint extends StaffEndpoint {
  Future<List<Branch>> list(Session session, {bool? includeInactive}) =>
      Branches.list(session, includeInactive: includeInactive ?? false);

  Future<Branch> create(Session session, BranchInput input) => Branches.create(session, input);

  Future<Branch> update(Session session, UuidValue id, int expectedVersion, BranchInput input) =>
      Branches.update(session, id, expectedVersion, input);
}
