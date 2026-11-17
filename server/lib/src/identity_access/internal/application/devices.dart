import 'package:serverpod/serverpod.dart';

import '../../../platform/errors/api_errors.dart';

/// Aparelhos dos apps móveis (`app.devices`, docs/06 §5.2 passo 3). Nesta
/// etapa só o app do técnico registra: o id é gerado no aparelho, um por
/// empresa (a chave da tabela é só o id), e o sync recusa aparelho bloqueado.
abstract final class Devices {
  static const platforms = {'android', 'ios', 'web'};

  /// Registra ou atualiza o aparelho da pessoa logada, ligado ao técnico.
  /// Aparelho de outra pessoa ou bloqueado → `DEVICE_BLOCKED`.
  static Future<void> registerTechnicianDevice(
    Session session, {
    required UuidValue deviceId,
    required UuidValue technicianId,
    required String platform,
    String? appVersion,
    String? osVersion,
    String? deviceModel,
  }) async {
    if (!platforms.contains(platform)) {
      throw ApiErrors.fieldError(session, 'platform', 'INVALID', 'Plataforma inválida.');
    }
    final existing = await session.db.unsafeQuery(
      'SELECT user_id, status FROM app.devices WHERE id = @id::uuid',
      parameters: QueryParameters.named({'id': deviceId.uuid}),
    );
    final params = {
      'id': deviceId.uuid,
      'tech': technicianId.uuid,
      'platform': platform,
      'appVersion': _clip(appVersion, 40),
      'osVersion': _clip(osVersion, 60),
      'model': _clip(deviceModel, 120),
    };
    if (existing.isEmpty) {
      await session.db.unsafeExecute(
        'INSERT INTO app.devices (id, tenant_id, user_id, app_kind, platform, technician_id, app_version, '
        '                         os_version, device_model, last_seen_at) '
        "VALUES (@id::uuid, app.current_tenant_id(), app.current_user_id(), 'technician_app', @platform, "
        '        @tech::uuid, @appVersion, @osVersion, @model, now())',
        parameters: QueryParameters.named(params),
      );
      return;
    }
    await _checkOwnActive(session, existing.first);
    await session.db.unsafeExecute(
      'UPDATE app.devices SET platform = @platform, technician_id = @tech::uuid, app_version = @appVersion, '
      '       os_version = @osVersion, device_model = @model, last_seen_at = now() '
      ' WHERE id = @id::uuid',
      parameters: QueryParameters.named(params),
    );
  }

  /// Confere que o aparelho é da pessoa logada e está ativo, e marca o sync.
  static Future<void> requireActive(Session session, UuidValue deviceId) async {
    final rows = await session.db.unsafeQuery(
      'SELECT user_id, status FROM app.devices WHERE id = @id::uuid',
      parameters: QueryParameters.named({'id': deviceId.uuid}),
    );
    if (rows.isEmpty) {
      throw ApiErrors.businessRule(session, 'DEVICE_NOT_REGISTERED', 'Aparelho não registrado. Entre de novo.');
    }
    await _checkOwnActive(session, rows.first);
    await session.db.unsafeExecute(
      'UPDATE app.devices SET last_seen_at = now(), last_sync_at = now() WHERE id = @id::uuid',
      parameters: QueryParameters.named({'id': deviceId.uuid}),
    );
  }

  static Future<void> _checkOwnActive(Session session, List<Object?> row) async {
    final mine = await session.db.unsafeQuery('SELECT app.current_user_id()');
    final userId = row[0];
    final status = row[1] as String;
    if (userId.toString() != mine.first[0].toString() || status != 'active') {
      throw ApiErrors.businessRule(
        session,
        'DEVICE_BLOCKED',
        'Este aparelho foi bloqueado para esta conta. Fale com o administrador.',
      );
    }
  }

  static String? _clip(String? text, int max) {
    final t = text?.trim();
    if (t == null || t.isEmpty) return null;
    return t.length <= max ? t : t.substring(0, max);
  }
}
