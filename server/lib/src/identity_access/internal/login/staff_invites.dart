import 'package:serverpod/serverpod.dart';

/// Convites da equipe: só quem foi convidado para algum tenant pode criar a
/// senha de acesso (função SECURITY DEFINER `app.staff_email_is_invited`).
abstract final class StaffInvites {
  static Future<bool> isInvited(Session session, String email) async {
    final result = await session.db.unsafeQuery(
      'SELECT app.staff_email_is_invited(@email)',
      parameters: QueryParameters.named({'email': email.trim()}),
    );
    return result.isNotEmpty && result.first[0] == true;
  }
}
