import 'package:serverpod/serverpod.dart';

import '../context/request_context.dart';
import '../errors/api_errors.dart';

/// Papéis e permissões efetivas do ator na requisição, **lidos do banco**
/// (docs/04 §5): os papéis do token servem só para a interface. Um vínculo
/// suspenso ou removido perde o acesso na hora, sem esperar o token expirar.
final class Grants {
  const Grants({required this.roles, required this.permissions});

  static const none = Grants(roles: {}, permissions: {});

  final Set<String> roles;
  final Set<String> permissions;

  bool can(String permission) => permissions.contains(permission);
  bool hasAnyRole(Set<String> wanted) => roles.any(wanted.contains);
}

/// Papéis "internos" do catálogo (docs/08 §3: leitura internos = TA, DI, BA, MG).
const internalRoles = {'tenant_admin', 'dispatcher', 'backoffice_agent', 'manager'};

final _cache = Expando<Future<Grants>>('Grants');

extension GrantsSession on Session {
  /// Uma consulta por requisição (cacheada na sessão). A RLS garante que só o
  /// vínculo do próprio usuário no tenant do contexto é visível; um token com
  /// `tid` forjado não acha vínculo e fica sem papéis.
  Future<Grants> grants() => _cache[this] ??= _load(this);

  /// `FORBIDDEN` se faltar a permissão.
  Future<Grants> requirePermission(String permission) async {
    final g = await grants();
    if (!g.can(permission)) throw ApiErrors.forbidden(this);
    return g;
  }

  /// `FORBIDDEN` se o ator não tiver nenhum dos papéis (leituras do catálogo).
  Future<Grants> requireAnyRole(Set<String> roles) async {
    final g = await grants();
    if (!g.hasAnyRole(roles)) throw ApiErrors.forbidden(this);
    return g;
  }
}

Future<Grants> _load(Session session) async {
  final ctx = session.context;
  final membershipId = ctx.membershipId;
  if (!ctx.hasTenant || membershipId == null) return Grants.none;

  final rows = await session.db.unsafeQuery(
    'SELECT mr.role_code, p.code '
    '  FROM app.tenant_memberships m '
    '  JOIN app.tenant_membership_roles mr ON mr.membership_id = m.id '
    '  JOIN app.roles r ON r.code = mr.role_code '
    '  LEFT JOIN app.role_permissions rp ON rp.role_id = r.id '
    '  LEFT JOIN app.permissions p ON p.id = rp.permission_id '
    ' WHERE m.id = @membershipId::uuid '
    "   AND m.tenant_id = @tenantId::uuid AND m.user_id = @userId::uuid AND m.status = 'active'",
    parameters: QueryParameters.named({
      'membershipId': membershipId.uuid,
      'tenantId': ctx.tenantId!.uuid,
      'userId': ctx.userId!.uuid,
    }),
  );
  return Grants(
    roles: {for (final r in rows) r[0] as String},
    permissions: {
      for (final r in rows)
        if (r[1] != null) r[1]! as String,
    },
  );
}
