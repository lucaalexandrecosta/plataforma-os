import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

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
                _deliverCode(pod, session, purpose: 'primeiro acesso', email: email, code: verificationCode),
        sendPasswordResetVerificationCode:
            (
              session, {
              required email,
              required passwordResetRequestId,
              required verificationCode,
              required transaction,
            }) => _deliverCode(pod, session, purpose: 'troca de senha', email: email, code: verificationCode),
      ),
    ];
  }

  /// Mínimo de 8 caracteres, com letra e número.
  static bool isStrongEnough(String password) =>
      password.length >= 8 && password.contains(RegExp('[A-Za-z]')) && password.contains(RegExp('[0-9]'));

  /// Entrega do código. O envio por e-mail entra com o módulo de notificações
  /// (outbox + SES); até lá, em desenvolvimento e teste o código vai para o
  /// log, e fora deles o cadastro falha em vez de engolir o código.
  static void _deliverCode(
    Serverpod pod,
    Session session, {
    required String purpose,
    required String email,
    required String code,
  }) {
    if (pod.runMode == ServerpodRunMode.development || pod.runMode == ServerpodRunMode.test) {
      session.log('Código de $purpose para $email: $code', level: LogLevel.info);
      return;
    }
    throw StateError('Envio de e-mail ainda não configurado: o código de $purpose não pode ser entregue.');
  }
}
