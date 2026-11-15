import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';
import '../../../platform/context/request_context.dart';
import '../../../platform/errors/api_errors.dart';
import 'memberships.dart';

/// Autorização fina por permissão (`<recurso>.<ação>`), sempre relida do
/// banco: os papéis do token servem só para a UI (docs/04 §5).
abstract final class Authorization {
  /// Vínculo ativo do ator no tenant, se ele tiver [permission]; senão
  /// `FORBIDDEN`.
  static Future<TenantMembership> require(Session session, String permission) async {
    final ctx = session.context;
    final membership = await Memberships.activeFor(session, userId: ctx.userId!, tenantId: ctx.tenantId!);
    if (membership == null) throw ApiErrors.forbidden(session, 'Seu acesso a esta empresa foi removido.');
    final permissions = await Memberships.permissionsOf(session, membership.id);
    if (!permissions.contains(permission)) throw ApiErrors.forbidden(session);
    return membership;
  }

  /// Como [require], aceitando qualquer uma das [permissions].
  static Future<TenantMembership> requireAny(Session session, Set<String> permissions) async {
    final ctx = session.context;
    final membership = await Memberships.activeFor(session, userId: ctx.userId!, tenantId: ctx.tenantId!);
    if (membership == null) throw ApiErrors.forbidden(session, 'Seu acesso a esta empresa foi removido.');
    final granted = await Memberships.permissionsOf(session, membership.id);
    if (!granted.any(permissions.contains)) throw ApiErrors.forbidden(session);
    return membership;
  }

  /// Só exige vínculo ativo (leituras de apoio, como listas de filiais).
  static Future<TenantMembership> requireMember(Session session) async {
    final ctx = session.context;
    final membership = await Memberships.activeFor(session, userId: ctx.userId!, tenantId: ctx.tenantId!);
    if (membership == null) throw ApiErrors.forbidden(session, 'Seu acesso a esta empresa foi removido.');
    return membership;
  }
}
