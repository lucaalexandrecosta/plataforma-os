import 'package:plataforma_os_core/plataforma_os_core.dart';
import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../identity_access/identity_access.dart';
import '../../platform/db/sql_values.dart';
import '../../platform/errors/api_errors.dart';

/// Etiquetas QR: gerar lote, marcar como impresso, vincular ao bem, desfazer
/// vínculo (exceção auditada) e revogar. Token (128 bits, na URL) e código
/// curto (8 caracteres com verificador) são globalmente únicos e gerados aqui
/// com `QrCodes` do pacote core. As transições de status são garantidas no
/// banco (trg_guard_status); o servidor dá a mensagem certa antes.
abstract final class QrTags {
  static const managePermission = 'qr_tags.manage';
  static const unbindPermission = 'qr_tags.unbind';
  static const revokeReasons = {'damaged', 'lost', 'replaced', 'asset_retired', 'misprint', 'security', 'other'};
  static const maxBatch = 500;

  static const _select =
      'SELECT t.id, t.short_code, t.token, t.status, t.batch_id, t.asset_id, coalesce(a.asset_tag, a.serial_number), '
      '       t.print_count, t.revoked_reason '
      '  FROM app.qr_tags t LEFT JOIN app.assets a ON a.tenant_id = t.tenant_id AND a.id = t.asset_id ';

  static Future<QrTagBatch> generateBatch(Session session, {required int quantity, String? notes}) async {
    await Authorization.require(session, managePermission);
    if (quantity < 1 || quantity > maxBatch) {
      throw ApiErrors.fieldError(session, 'quantity', 'INVALID', 'Gere de 1 a $maxBatch etiquetas por lote.');
    }
    final batchId = const Uuid().v7obj();
    for (var attempt = 0; ; attempt++) {
      try {
        await session.db.transaction((tx) async {
          final next = await session.db.unsafeQuery('SELECT count(*) + 1 FROM app.qr_tag_batches', transaction: tx);
          final code = 'LOTE-${(next.first[0] as int).toString().padLeft(4, '0')}';
          await session.db.unsafeExecute(
            'INSERT INTO app.qr_tag_batches (id, tenant_id, code, quantity, notes) '
            'VALUES (@id::uuid, app.current_tenant_id(), @code, @quantity, @notes)',
            parameters: QueryParameters.named({
              'id': batchId.uuid,
              'code': code,
              'quantity': quantity,
              'notes': cleanText(notes),
            }),
            transaction: tx,
          );
          await session.db.unsafeExecute(
            'INSERT INTO app.qr_tags (tenant_id, token, short_code, batch_id) '
            'SELECT app.current_tenant_id(), t, s, @batchId::uuid FROM unnest(@tokens::text[], @codes::text[]) AS x(t, s)',
            parameters: QueryParameters.named({
              'batchId': batchId.uuid,
              'tokens': [for (var i = 0; i < quantity; i++) QrCodes.generateToken()],
              'codes': [for (var i = 0; i < quantity; i++) QrCodes.generateShortCode()],
            }),
            transaction: tx,
          );
        });
        break;
      } on DatabaseQueryException catch (e) {
        // Código do lote disputado por outro pedido ou colisão (raríssima) de
        // código curto: tenta de novo com valores novos.
        if (isUniqueViolation(e) && attempt < 3) continue;
        rethrow;
      }
    }
    return (await _batches(session, batchId)).single;
  }

  static Future<List<QrTagBatch>> listBatches(Session session) async {
    await Authorization.require(session, managePermission);
    return _batches(session, null);
  }

  static Future<List<QrTag>> batchTags(Session session, UuidValue batchId) async {
    await Authorization.require(session, managePermission);
    final rows = await session.db.unsafeQuery(
      '$_select WHERE t.batch_id = @batchId::uuid ORDER BY t.id',
      parameters: QueryParameters.named({'batchId': batchId.uuid}),
    );
    if (rows.isEmpty) throw ApiErrors.notFound(session);
    return [for (final r in rows) _map(session, r)];
  }

  /// Registra a impressão do lote: etiquetas ainda não vinculadas passam a
  /// `printed`; todas somam uma impressão.
  static Future<QrTagBatch> markBatchPrinted(Session session, UuidValue batchId) async {
    await Authorization.require(session, managePermission);
    final changed = await session.db.unsafeExecute(
      'UPDATE app.qr_tag_batches SET printed_at = now(), printed_by = app.current_user_id() WHERE id = @id::uuid',
      parameters: QueryParameters.named({'id': batchId.uuid}),
    );
    if (changed == 0) throw ApiErrors.notFound(session);
    await session.db.unsafeExecute(
      "UPDATE app.qr_tags SET status = CASE WHEN status = 'generated' THEN 'printed' ELSE status END, "
      '       printed_at = now(), print_count = print_count + 1, last_printed_by = app.current_user_id() '
      " WHERE batch_id = @id::uuid AND status <> 'revoked'",
      parameters: QueryParameters.named({'id': batchId.uuid}),
    );
    return (await _batches(session, batchId)).single;
  }

  /// Etiqueta pelo que a pessoa leu ou digitou: código curto (com ou sem
  /// hífen), token ou a URL inteira. De outra empresa = `NOT_FOUND`.
  static Future<QrTag> resolve(Session session, String scanned) async {
    await Authorization.requireAny(session, const {managePermission, 'assets.manage', 'work_orders.read'});
    return await _findByScan(session, scanned) ?? (throw ApiErrors.notFound(session, 'Etiqueta não encontrada.'));
  }

  static Future<QrTag> bind(Session session, {required String scanned, required UuidValue assetId}) async {
    await Authorization.require(session, managePermission);
    final tag = await _findByScan(session, scanned) ?? (throw ApiErrors.notFound(session, 'Etiqueta não encontrada.'));
    if (tag.status == 'bound') {
      throw ApiErrors.businessRule(
        session,
        tag.assetId == assetId ? 'TAG_ALREADY_ON_ASSET' : 'TAG_ALREADY_BOUND',
        tag.assetId == assetId ? 'Esta etiqueta já está neste bem.' : 'Esta etiqueta já está em outro bem.',
      );
    }
    if (tag.status == 'revoked') {
      throw ApiErrors.businessRule(session, 'TAG_REVOKED', 'Esta etiqueta foi revogada e não pode ser usada.');
    }
    final asset = await session.db.unsafeQuery(
      'SELECT is_active, status FROM app.assets WHERE id = @id::uuid',
      parameters: QueryParameters.named({'id': assetId.uuid}),
    );
    if (asset.isEmpty) throw ApiErrors.fieldError(session, 'assetId', 'NOT_FOUND', 'Bem não encontrado.');
    if (asset.first[1] == 'retired') {
      throw ApiErrors.businessRule(session, 'ASSET_RETIRED', 'Bem baixado não recebe etiqueta.');
    }
    try {
      await session.db.unsafeExecute(
        "UPDATE app.qr_tags SET status = 'bound', asset_id = @assetId::uuid, bound_at = now(), "
        "       bound_by = app.current_user_id(), bound_via = 'backoffice' "
        ' WHERE id = @id::uuid',
        parameters: QueryParameters.named({'id': tag.id.uuid, 'assetId': assetId.uuid}),
      );
    } on DatabaseQueryException catch (e) {
      if (isUniqueViolation(e, 'qr_tags_one_bound_per_asset_key')) {
        throw ApiErrors.businessRule(
          session,
          'ASSET_ALREADY_TAGGED',
          'Este bem já tem uma etiqueta. Revogue a atual (motivo "substituída") antes de vincular outra.',
        );
      }
      rethrow;
    }
    return (await _findById(session, tag.id))!;
  }

  /// Desfaz um vínculo feito por engano (volta a `printed`). Exceção
  /// auditada, só com `qr_tags.unbind`.
  static Future<QrTag> unbind(Session session, UuidValue tagId) async {
    await Authorization.require(session, unbindPermission);
    final tag = await _findById(session, tagId) ?? (throw ApiErrors.notFound(session));
    if (tag.status != 'bound') {
      throw ApiErrors.businessRule(session, 'TAG_NOT_BOUND', 'Esta etiqueta não está vinculada a nenhum bem.');
    }
    await session.db.unsafeExecute(
      "UPDATE app.qr_tags SET status = 'printed' WHERE id = @id::uuid",
      parameters: QueryParameters.named({'id': tagId.uuid}),
    );
    return (await _findById(session, tagId))!;
  }

  static Future<QrTag> revoke(Session session, UuidValue tagId, {required String reason, String? note}) async {
    await Authorization.require(session, managePermission);
    if (!revokeReasons.contains(reason)) {
      throw ApiErrors.fieldError(session, 'reason', 'INVALID', 'Motivo de revogação inválido.');
    }
    final tag = await _findById(session, tagId) ?? (throw ApiErrors.notFound(session));
    if (tag.status == 'revoked') {
      throw ApiErrors.businessRule(session, 'TAG_REVOKED', 'Esta etiqueta já foi revogada.');
    }
    await session.db.unsafeExecute(
      "UPDATE app.qr_tags SET status = 'revoked', revoked_at = now(), revoked_by = app.current_user_id(), "
      '       revoked_reason = @reason, revocation_note = @note '
      ' WHERE id = @id::uuid',
      parameters: QueryParameters.named({'id': tagId.uuid, 'reason': reason, 'note': cleanText(note)}),
    );
    return (await _findById(session, tagId))!;
  }

  // ------------------------------------------------------------------ internos

  static Future<QrTag?> _findByScan(Session session, String scanned) async {
    var input = scanned.trim();
    final slash = input.lastIndexOf('/q/');
    if (slash >= 0) input = input.substring(slash + 3).split(RegExp('[?#/]')).first;
    final String column;
    final String value;
    final shortCode = QrCodes.parseShortCode(input);
    if (shortCode != null) {
      column = 'short_code';
      value = shortCode;
    } else if (QrCodes.isValidToken(input.toUpperCase())) {
      column = 'token';
      value = input.toUpperCase();
    } else {
      return null;
    }
    final rows = await session.db.unsafeQuery(
      '$_select WHERE t.$column = @value',
      parameters: QueryParameters.named({'value': value}),
    );
    return rows.isEmpty ? null : _map(session, rows.first);
  }

  static Future<QrTag?> _findById(Session session, UuidValue id) async {
    final rows = await session.db.unsafeQuery(
      '$_select WHERE t.id = @id::uuid',
      parameters: QueryParameters.named({'id': id.uuid}),
    );
    return rows.isEmpty ? null : _map(session, rows.first);
  }

  static Future<List<QrTagBatch>> _batches(Session session, UuidValue? id) async {
    final rows = await session.db.unsafeQuery(
      'SELECT b.id, b.code, b.quantity, b.notes, b.printed_at, '
      "       (SELECT count(*) FROM app.qr_tags t WHERE t.tenant_id = b.tenant_id AND t.batch_id = b.id AND t.status = 'bound'), "
      '       b.created_at '
      '  FROM app.qr_tag_batches b '
      ' WHERE (@id::uuid IS NULL OR b.id = @id::uuid) '
      ' ORDER BY b.created_at DESC',
      parameters: QueryParameters.named({'id': id?.uuid}),
    );
    return [
      for (final r in rows)
        QrTagBatch(
          id: sqlUuid(r[0]),
          code: r[1] as String,
          quantity: r[2] as int,
          notes: r[3] as String?,
          printedAt: r[4] as DateTime?,
          boundCount: r[5] as int,
          createdAt: r[6] as DateTime,
        ),
    ];
  }

  /// Endereço público da etiqueta: servidor web do Serverpod (página leve do
  /// QR, docs/08), `/q/<token>`.
  static String _url(String token) {
    final web = Serverpod.instance.config.webServer;
    if (web == null) return '/q/$token';
    final defaultPort =
        (web.publicScheme == 'https' && web.publicPort == 443) || (web.publicScheme == 'http' && web.publicPort == 80);
    final port = defaultPort ? '' : ':${web.publicPort}';
    return '${web.publicScheme}://${web.publicHost}$port/q/$token';
  }

  static QrTag _map(Session session, List<Object?> r) => QrTag(
    id: sqlUuid(r[0]),
    shortCode: QrCodes.formatShortCode(r[1] as String),
    url: _url(r[2] as String),
    status: r[3] as String,
    batchId: sqlUuidOrNull(r[4]),
    assetId: sqlUuidOrNull(r[5]),
    assetLabel: r[6] as String?,
    printCount: r[7] as int,
    revokedReason: r[8] as String?,
  );
}
