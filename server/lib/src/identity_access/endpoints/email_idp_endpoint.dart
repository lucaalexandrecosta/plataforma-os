import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../../platform/endpoints/endpoint_bases.dart';
import '../internal/login/staff_invites.dart';

/// `emailIdp.*` — login por e-mail e senha (módulo do Serverpod).
///
/// Cada método anexa o contexto anônimo antes de tocar no banco (as tabelas do
/// módulo ficam em `public`, fora da RLS). O cadastro só abre para e-mails
/// convidados: para os demais responde um id aleatório, igual ao que o módulo
/// faz para e-mail já cadastrado, sem revelar se o e-mail existe.
class EmailIdpEndpoint extends EmailIdpBaseEndpoint {
  @override
  Future<AuthSuccess> login(Session session, {required String email, required String password}) {
    session.useAnonymousContext();
    return super.login(session, email: email, password: password);
  }

  @override
  Future<UuidValue> startRegistration(Session session, {required String email}) async {
    session.useAnonymousContext();
    if (!await StaffInvites.isInvited(session, email)) {
      session.log('Cadastro recusado: e-mail sem convite.', level: LogLevel.debug);
      return const Uuid().v7obj();
    }
    return super.startRegistration(session, email: email);
  }

  @override
  Future<String> verifyRegistrationCode(
    Session session, {
    required UuidValue accountRequestId,
    required String verificationCode,
  }) {
    session.useAnonymousContext();
    return super.verifyRegistrationCode(
      session,
      accountRequestId: accountRequestId,
      verificationCode: verificationCode,
    );
  }

  @override
  Future<AuthSuccess> finishRegistration(
    Session session, {
    required String registrationToken,
    required String password,
  }) {
    session.useAnonymousContext();
    return super.finishRegistration(session, registrationToken: registrationToken, password: password);
  }

  @override
  Future<UuidValue> startPasswordReset(Session session, {required String email}) {
    session.useAnonymousContext();
    return super.startPasswordReset(session, email: email);
  }

  @override
  Future<String> verifyPasswordResetCode(
    Session session, {
    required UuidValue passwordResetRequestId,
    required String verificationCode,
  }) {
    session.useAnonymousContext();
    return super.verifyPasswordResetCode(
      session,
      passwordResetRequestId: passwordResetRequestId,
      verificationCode: verificationCode,
    );
  }

  @override
  Future<void> finishPasswordReset(
    Session session, {
    required String finishPasswordResetToken,
    required String newPassword,
  }) {
    session.useAnonymousContext();
    return super.finishPasswordReset(
      session,
      finishPasswordResetToken: finishPasswordResetToken,
      newPassword: newPassword,
    );
  }

  @override
  Future<bool> hasAccount(Session session) {
    session.useAnonymousContext();
    return super.hasAccount(session);
  }
}
