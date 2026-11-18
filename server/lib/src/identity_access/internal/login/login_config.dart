import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../../../platform/email/email.dart';
import '../../../platform/email/templates.dart';

/// Login próprio da plataforma (decisão de 15/11/2026, sem Keycloak):
/// e-mail e senha pelo módulo `serverpod_auth_idp`, com sessão de login em
/// JWT. A sessão de login só identifica a pessoa; o acesso aos dados vem do
/// token ES256 do tenant emitido por `auth.selectTenant`.
///
/// Segredos (config/passwords.yaml em dev; cofre em homologação/produção):
/// `emailSecretHashPepper`, `jwtRefreshTokenHashPepper` e
/// `jwtHmacSha512PrivateKey`.
abstract final class LoginConfig {
  /// Código fixo de verificação no modo `test` (e2e e testes de integração).
  static const testVerificationCode = '000000';

  static List<TokenManagerBuilder> tokenManagers() => [
    JwtConfigFromPasswords(
      accessTokenLifetime: const Duration(minutes: 10),
      refreshTokenLifetime: const Duration(days: 14),
      issuer: 'plataforma-os:login',
    ),
  ];

  static List<IdentityProviderBuilder> identityProviders(Serverpod pod) {
    final isTest = pod.runMode == ServerpodRunMode.test;
    String code() => isTest ? testVerificationCode : defaultVerificationCodeGenerator();
    return [
      EmailIdpConfigFromPasswords(
        registrationVerificationCodeGenerator: code,
        passwordResetVerificationCodeGenerator: code,
        passwordValidationFunction: isStrongEnough,
        sendRegistrationVerificationCode:
            (session, {required email, required accountRequestId, required verificationCode, required transaction}) =>
                _deliverCode(session, email: email, code: verificationCode, passwordReset: false),
        sendPasswordResetVerificationCode:
            (
              session, {
              required email,
              required passwordResetRequestId,
              required verificationCode,
              required transaction,
            }) => _deliverCode(session, email: email, code: verificationCode, passwordReset: true),
      ),
    ];
  }

  /// Mínimo de 8 caracteres, com letra e número.
  static bool isStrongEnough(String password) =>
      password.length >= 8 && password.contains(RegExp('[A-Za-z]')) && password.contains(RegExp('[0-9]'));

  /// Entrega do código por e-mail (veja `Email`: SMTP configurado ou, em
  /// desenvolvimento e teste, o log). Sem envio configurado, o pedido falha
  /// em vez de engolir o código.
  static Future<void> _deliverCode(
    Session session, {
    required String email,
    required String code,
    required bool passwordReset,
  }) => Email.send(session, EmailTemplates.verificationCode(to: email, code: code, passwordReset: passwordReset));
}
