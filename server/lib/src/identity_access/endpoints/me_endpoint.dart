import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/context/request_context.dart';
import '../../platform/endpoints/endpoint_bases.dart';
import '../../platform/errors/api_errors.dart';
import '../../tenancy/tenancy.dart';
import '../internal/application/memberships.dart';

/// `me.*` — usuário autenticado, tenant ativo e permissões (docs/08 §3.2).
class MeEndpoint extends StaffEndpoint {
  /// Usuário, tenant ativo, papéis e permissões efetivas, relidos do banco.
  Future<MeInfo> get(Session session) async {
    final ctx = session.context;
    final userId = ctx.userId!;
    final tenantId = ctx.tenantId!;

    final membership = await Memberships.activeFor(session, userId: userId, tenantId: tenantId);
    if (membership == null) throw ApiErrors.forbidden(session, 'Seu acesso a esta empresa foi removido.');

    final user = await AppUser.db.findById(session, userId);
    final tenant = await TenantDirectory.get(session, tenantId);
    if (user == null || tenant == null) throw ApiErrors.forbidden(session);
    if (!TenantDirectory.isOperational(tenant)) throw ApiErrors.tenantSuspended(session);

    return MeInfo(
      userId: user.id,
      fullName: user.fullName,
      email: user.email,
      locale: user.locale,
      tenant: TenantDirectory.summary(tenant),
      roles: await Memberships.rolesOf(session, membership.id),
      permissions: await Memberships.permissionsOf(session, membership.id),
    );
  }

  /// Tenants em que o usuário tem vínculo, para a troca de tenant.
  Future<List<TenantSummary>> tenants(Session session) async {
    final memberships = await Memberships.ofUser(session, session.context.userId!);
    final tenants = await TenantDirectory.getMany(session, {for (final m in memberships) m.tenantId});
    return [for (final t in tenants) TenantDirectory.summary(t)];
  }
}
