import 'dart:convert';

import 'package:plataforma_os_server/src/platform/auth/access_token_service.dart';
import 'package:plataforma_os_server/src/platform/auth/token_claims.dart';
import 'package:plataforma_os_server/src/platform/context/request_context.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

// Chaves só de teste (geradas para este arquivo; nunca usadas fora dele).
const _privA = '''-----BEGIN PRIVATE KEY-----
MIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQgBHBCWiRGZWdxfnRY
3/hrOu8uHl9OX3LQcKCVPxRKc6uhRANCAARJ9qx/atBk4xJz1COjOp5M2xm8SV6B
8U+IaDexKR4rGw160msu9nsEcoXmMimJHxNro+fc/IvIYuF2DxMdwtwJ
-----END PRIVATE KEY-----''';
const _pubA = '''-----BEGIN PUBLIC KEY-----
MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAESfasf2rQZOMSc9QjozqeTNsZvEle
gfFPiGg3sSkeKxsNetJrLvZ7BHKF5jIpiR8Ta6Pn3PyLyGLhdg8THcLcCQ==
-----END PUBLIC KEY-----''';
const _privB = '''-----BEGIN PRIVATE KEY-----
MIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQgZasVPUm4yP7NeeEb
hS3DtsMt5Pd/XP0LFsV6ApDXeRyhRANCAARTdXSfENu4vH+5YNWwg84lWAPM5aEi
kNRBc/vsCO474+nCed/TFq2Ph8rQcvrhJBmSUvCW9nlKDpvZ4zMbLMN9
-----END PRIVATE KEY-----''';
const _pubB = '''-----BEGIN PUBLIC KEY-----
MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEU3V0nxDbuLx/uWDVsIPOJVgDzOWh
IpDUQXP77AjuO+Ppwnnf0xatj4fK0HL64SQZklLwlvZ5Sg6b2eMzGyzDfQ==
-----END PUBLIC KEY-----''';

final _tenantA = UuidValue.withValidation('0197f000-0001-7000-8000-000000000001');
final _user = UuidValue.withValidation('0197f000-0100-7000-8000-000000000001');
final _membership = UuidValue.withValidation('0197f000-0001-7200-8000-000000000001');

void main() {
  var now = DateTime.utc(2026, 11, 7, 12);
  AccessTokenService service({String issuer = 'https://api.test', List<SigningKey>? keys, String kid = 'a'}) =>
      AccessTokenService(
        issuer: issuer,
        activeKid: kid,
        keys: keys ?? [SigningKey(kid: 'a', privateKeyPem: _privA, publicKeyPem: _pubA)],
        clock: () => now,
      );

  String issue(AccessTokenService s, {TokenKind kind = TokenKind.staff}) => s
      .issue(
        kind: kind,
        userId: _user,
        tenantId: _tenantA,
        actorType: ActorType.user,
        sessionId: 'sid-1',
        membershipId: _membership,
        roles: const ['tenant_admin'],
      )
      .token;

  String b64(Map<String, Object?> json) => base64Url.encode(utf8.encode(jsonEncode(json))).replaceAll('=', '');
  Map<String, dynamic> part(String token, int i) =>
      jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(token.split('.')[i])))) as Map<String, dynamic>;

  setUp(() => now = DateTime.utc(2026, 11, 7, 12));

  test('emite e valida: claims e contexto do tenant', () {
    final s = service();
    final token = issue(s);
    final claims = s.verify(token);
    expect(claims, isNotNull);
    expect(claims!.tenantId, _tenantA);
    expect(claims.subject, _user);
    expect(claims.membershipId, _membership);
    expect(claims.kind, TokenKind.staff);
    expect(claims.expiresAt.difference(claims.issuedAt), const Duration(minutes: 10));

    final header = part(token, 0);
    expect(header['alg'], 'ES256');
    expect(header['kid'], 'a');
    expect(header['typ'], 'tenant-access+jwt');
    final payload = part(token, 1);
    expect(payload['aud'], 'plataforma-os:staff');
    expect(payload.keys, isNot(contains('email')), reason: 'sem dados pessoais no token');

    final ctx = claims.toRequestContext('corr-1');
    expect(ctx.sessionVariables['app.tenant_id'], _tenantA.uuid);
    expect(ctx.sessionVariables['app.actor_type'], 'user');
  });

  test('expira (com 60 s de tolerância)', () {
    final s = service();
    final token = issue(s);
    now = now.add(const Duration(minutes: 10, seconds: 59));
    expect(s.verify(token), isNotNull);
    now = now.add(const Duration(seconds: 2));
    expect(s.verify(token), isNull);
  });

  test('recusa alg none', () {
    final token = issue(service());
    final payload = token.split('.')[1];
    final forged = '${b64({'alg': 'none', 'typ': 'tenant-access+jwt', 'kid': 'a'})}.$payload.';
    expect(service().verify(forged), isNull);
  });

  test('recusa troca de algoritmo (HS256 com a chave pública como segredo)', () {
    final token = issue(service());
    final payload = token.split('.')[1];
    final forged = '${b64({'alg': 'HS256', 'typ': 'tenant-access+jwt', 'kid': 'a'})}.$payload.${token.split('.')[2]}';
    expect(service().verify(forged), isNull);
  });

  test('recusa kid desconhecido e assinatura de outra chave', () {
    final other = service(
      keys: [SigningKey(kid: 'a', privateKeyPem: _privB, publicKeyPem: _pubB)],
    );
    expect(service().verify(issue(other)), isNull, reason: 'mesmo kid, chave diferente');
    final otherKid = service(
      keys: [SigningKey(kid: 'b', privateKeyPem: _privB, publicKeyPem: _pubB)],
      kid: 'b',
    );
    expect(service().verify(issue(otherKid)), isNull, reason: 'kid desconhecido');
  });

  test('aceita a chave anterior durante a rotação', () {
    final old = service(
      keys: [SigningKey(kid: 'b', privateKeyPem: _privB, publicKeyPem: _pubB)],
      kid: 'b',
    );
    final rotated = service(
      keys: [
        SigningKey(kid: 'a', privateKeyPem: _privA, publicKeyPem: _pubA),
        SigningKey(kid: 'b', publicKeyPem: _pubB),
      ],
    );
    expect(rotated.verify(issue(old)), isNotNull);
  });

  test('recusa assinatura truncada, payload adulterado e outro emissor', () {
    final s = service();
    final token = issue(s);
    expect(s.verify(token.substring(0, token.length - 5)), isNull);
    final p = part(token, 1)..['tid'] = '0197f000-0002-7000-8000-000000000002';
    final parts = token.split('.');
    expect(s.verify('${parts[0]}.${b64(p)}.${parts[2]}'), isNull, reason: 'trocar o tenant invalida a assinatura');
    expect(service(issuer: 'https://outro').verify(token), isNull);
    expect(s.verify('lixo'), isNull);
  });

  test('token de contato não passa como token da equipe (typ e aud amarrados)', () {
    final s = service();
    final customer = issue(s, kind: TokenKind.customer);
    expect(s.verify(customer)!.kind, TokenKind.customer);
    final parts = customer.split('.');
    final staffHeader = b64({...part(customer, 0), 'typ': 'tenant-access+jwt'});
    expect(s.verify('$staffHeader.${parts[1]}.${parts[2]}'), isNull);
  });
}
