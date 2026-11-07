import 'package:plataforma_os_server/src/platform/context/request_context.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  final tenant = UuidValue.withValidation('0197f000-0001-7000-8000-000000000001');
  final user = UuidValue.withValidation('0197f000-0100-7000-8000-000000000001');

  test('variáveis de sessão do contexto com tenant', () {
    final ctx = RequestContext.tenant(tenantId: tenant, userId: user, actorType: ActorType.user, correlationId: 'c1');
    expect(ctx.sessionVariables, {
      'app.tenant_id': tenant.uuid,
      'app.user_id': user.uuid,
      'app.actor_type': 'user',
      'app.correlation_id': 'c1',
    });
    expect(ctx.isRefinable, isFalse, reason: 'contexto com tenant é definitivo');
  });

  test('anônimo e usuário sem tenant: sem app.tenant_id (RLS falha fechada)', () {
    final anon = RequestContext.anonymous(correlationId: 'c2');
    expect(anon.sessionVariables['app.tenant_id'], '');
    expect(anon.isRefinable, isTrue);
    final u = RequestContext.userWithoutTenant(userId: user, correlationId: 'c3');
    expect(u.sessionVariables['app.tenant_id'], '');
    expect(u.sessionVariables['app.user_id'], user.uuid);
    expect(u.isRefinable, isTrue);
  });

  test('job de sistema carrega o tenant do envelope', () {
    final job = RequestContext.system(correlationId: 'job-1', tenantId: tenant);
    expect(job.hasTenant, isTrue);
    expect(job.sessionVariables['app.actor_type'], 'system');
  });
}
