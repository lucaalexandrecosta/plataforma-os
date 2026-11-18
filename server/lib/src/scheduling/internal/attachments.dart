import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../identity_access/identity_access.dart';
import '../../platform/db/sql_values.dart';
import '../../platform/errors/api_errors.dart';
import '../../platform/storage/object_storage.dart';
import 'technicians.dart';
import 'visits.dart';

/// Fotos e assinatura da visita (docs/06 §5.12, §5.13 e §6.10).
///
/// O aparelho registra o anexo pela fila do sync (`attachment.register`,
/// metadados com tamanho e sha256) e envia o binário depois, direto ao object
/// storage, por URL pré-assinada (`attachments.uploadUrl`); a confirmação
/// (`attachments.confirmUpload`) confere tamanho e hash e marca `uploaded`.
/// A assinatura (`signature.capture`) aponta para um anexo `signature` já
/// registrado, mesmo que o envio ainda não tenha terminado.
abstract final class Attachments {
  static const registerType = 'attachment.register';
  static const signatureType = 'signature.capture';
  static const maxPhotoBytes = 10 * 1024 * 1024;
  static const maxSignatureBytes = 1024 * 1024;
  static const photoStages = {'before', 'after', 'evidence'};
  static const signerRoles = {'site_manager', 'employee', 'other'};
  static const _photoTypes = {'image/jpeg': 'jpg', 'image/png': 'png'};
  static const _readPermissions = {'visits.schedule', 'work_orders.read', 'visits.execute'};

  static const _columns =
      'a.id, a.work_order_id, a.visit_id, a.kind, a.photo_stage, a.content_type, a.size_bytes, a.upload_status, '
      'a.caption, a.captured_at, te.name, a.latitude, a.longitude, a.created_at';
  static const _from =
      'FROM app.attachments a '
      'LEFT JOIN app.technicians te ON te.tenant_id = a.tenant_id AND te.id = a.captured_by_technician_id ';

  // ------------------------------------------------------------------ mutações do sync

  /// Registra o anexo capturado no aparelho (`attachment.register`).
  static Future<void> register(
    Session session,
    Visit visit,
    UuidValue technicianId,
    AttachmentRegisterPayload p,
    Transaction tx,
  ) async {
    _requireOpenVisit(session, visit);
    final errors = <FieldError>[];
    void fail(String path, String message) => errors.add(FieldError(path: path, code: 'INVALID', message: message));
    final String ext;
    switch (p.kind) {
      case 'photo':
        ext = _photoTypes[p.contentType] ?? '';
        if (ext.isEmpty) fail('contentType', 'Foto deve ser JPEG ou PNG.');
        if (!photoStages.contains(p.photoStage)) {
          fail('photoStage', 'Informe se a foto é de antes, depois ou evidência.');
        }
        if (p.sizeBytes > maxPhotoBytes) fail('sizeBytes', 'Foto acima de 10 MB.');
      case 'signature':
        ext = 'png';
        if (p.contentType != 'image/png') fail('contentType', 'Assinatura deve ser PNG.');
        if (p.sizeBytes > maxSignatureBytes) fail('sizeBytes', 'Assinatura acima de 1 MB.');
      default:
        ext = '';
        fail('kind', 'Tipo de anexo inválido.');
    }
    if (p.sizeBytes <= 0) fail('sizeBytes', 'Arquivo vazio.');
    if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(p.sha256)) fail('sha256', 'Hash do arquivo inválido.');
    if (errors.isNotEmpty) throw ApiErrors.validation(session, errors);
    final caption = cleanText(p.caption);
    try {
      await session.db.unsafeExecute(
        'INSERT INTO app.attachments (id, tenant_id, kind, photo_stage, work_order_id, visit_id, storage_key, '
        '       content_type, size_bytes, sha256, upload_status, caption, captured_at, captured_by_technician_id, '
        '       latitude, longitude) '
        'VALUES (@id::uuid, app.current_tenant_id(), @kind, @stage, @wo::uuid, @visit::uuid, '
        "        't/' || app.current_tenant_id() || '/attachments/' || @wo::text || '/' || @id::text || '.' || @ext::text, "
        "        @type, @size, decode(@sha, 'hex'), 'pending', @caption, @at, @tech::uuid, @lat, @lng)",
        parameters: QueryParameters.named({
          'id': p.attachmentId.uuid,
          'kind': p.kind,
          'stage': p.kind == 'photo' ? p.photoStage : null,
          'wo': visit.workOrderId.uuid,
          'visit': visit.id.uuid,
          'ext': ext,
          'type': p.contentType,
          'size': p.sizeBytes,
          'sha': p.sha256,
          'caption': caption,
          'at': p.capturedAt.toUtc(),
          'tech': technicianId.uuid,
          'lat': p.latitude,
          'lng': p.longitude,
        }),
        transaction: tx,
      );
    } on DatabaseQueryException catch (e) {
      if (isUniqueViolation(e, 'attachments_pkey')) {
        throw ApiErrors.businessRule(session, 'DUPLICATE_ATTACHMENT', 'Este anexo já foi registrado.');
      }
      rethrow;
    }
  }

  /// Grava quem assinou a visita (`signature.capture`).
  static Future<Visit> captureSignature(Session session, Visit visit, SignatureCapturePayload p, Transaction tx) async {
    _requireOpenVisit(session, visit);
    final name = cleanText(p.signerName);
    final errors = <FieldError>[
      if (name == null) FieldError(path: 'signerName', code: 'REQUIRED', message: 'Informe o nome de quem assinou.'),
      if (!signerRoles.contains(p.signerRole))
        FieldError(path: 'signerRole', code: 'INVALID', message: 'Informe quem assinou.'),
    ];
    if (errors.isNotEmpty) throw ApiErrors.validation(session, errors);
    final rows = await session.db.unsafeQuery(
      'SELECT kind, visit_id FROM app.attachments WHERE id = @id::uuid',
      parameters: QueryParameters.named({'id': p.attachmentId.uuid}),
      transaction: tx,
    );
    if (rows.isEmpty || rows.first[0] != 'signature' || sqlUuidOrNull(rows.first[1]) != visit.id) {
      throw ApiErrors.businessRule(session, 'SIGNATURE_NOT_REGISTERED', 'A imagem da assinatura não foi registrada.');
    }
    return Visits.recordSignature(
      session,
      visit.id,
      attachmentId: p.attachmentId,
      signerName: name!,
      signerDocument: cleanText(p.signerDocument),
      signerRole: p.signerRole,
      signedAt: p.signedAt,
      transaction: tx,
    );
  }

  /// O que falta para concluir a visita como resolvida, ou `null`.
  static Future<String?> missingForFinish(Session session, Visit visit) async {
    if (visit.requireSignature && visit.signatureAttachmentId == null) {
      return 'Colete a assinatura antes de concluir a visita.';
    }
    if (!visit.requirePhotos) return null;
    final rows = await session.db.unsafeQuery(
      "SELECT photo_stage FROM app.attachments WHERE visit_id = @visit::uuid AND kind = 'photo' "
      "   AND photo_stage IN ('before', 'after') AND upload_status <> 'deleted'",
      parameters: QueryParameters.named({'visit': visit.id.uuid}),
    );
    final stages = {for (final r in rows) r[0] as String};
    if (!stages.containsAll(const {'before', 'after'})) {
      return 'Tire ao menos uma foto de antes e uma de depois antes de concluir a visita.';
    }
    return null;
  }

  // ------------------------------------------------------------------ envio e download

  /// URL para o aparelho enviar o arquivo de um anexo seu ainda pendente.
  static Future<AttachmentUpload> uploadUrl(Session session, UuidValue id) async {
    final (attachment, key) = await _mine(session, id);
    if (attachment.uploadStatus == 'uploaded') {
      throw ApiErrors.businessRule(session, 'ALREADY_UPLOADED', 'Este arquivo já foi enviado.');
    }
    final storage = _storage(session);
    const expires = Duration(minutes: 15);
    final url = await storage.uploadUrl(key, attachment.contentType, expires: expires);
    return AttachmentUpload(
      attachmentId: id,
      url: url.toString(),
      contentType: attachment.contentType,
      expiresAt: DateTime.now().toUtc().add(expires),
    );
  }

  /// Confere o arquivo enviado (tamanho e sha256) e marca o anexo como
  /// enviado. Já enviado devolve como está.
  static Future<Attachment> confirmUpload(Session session, UuidValue id) async {
    final (attachment, key) = await _mine(session, id);
    if (attachment.uploadStatus == 'uploaded') return attachment;
    final storage = _storage(session);
    final Uint8List? bytes;
    try {
      bytes = await storage.read(key);
    } on Object catch (e) {
      session.log('Falha ao ler $key do object storage: $e', level: LogLevel.warning);
      throw ApiErrors.businessRule(session, 'STORAGE_UNAVAILABLE', 'Armazenamento de arquivos indisponível.');
    }
    if (bytes == null) {
      throw ApiErrors.businessRule(session, 'UPLOAD_MISSING', 'O arquivo ainda não chegou ao servidor.');
    }
    final rows = await session.db.unsafeQuery(
      "SELECT size_bytes, encode(sha256, 'hex') FROM app.attachments WHERE id = @id::uuid",
      parameters: QueryParameters.named({'id': id.uuid}),
    );
    if (bytes.length != rows.first[0] || sha256.convert(bytes).toString() != rows.first[1]) {
      throw ApiErrors.businessRule(session, 'UPLOAD_MISMATCH', 'O arquivo recebido não confere com o registrado.');
    }
    await session.db.unsafeExecute(
      "UPDATE app.attachments SET upload_status = 'uploaded', uploaded_at = now() WHERE id = @id::uuid",
      parameters: QueryParameters.named({'id': id.uuid}),
    );
    return (await _find(session, id))!.$1;
  }

  /// Anexos das visitas da OS (backoffice).
  static Future<List<Attachment>> ofWorkOrder(Session session, UuidValue workOrderId) async {
    await Authorization.requireAny(session, _readPermissions);
    final rows = await session.db.unsafeQuery(
      "SELECT $_columns, a.storage_key $_from WHERE a.work_order_id = @id::uuid AND a.upload_status <> 'deleted' "
      ' ORDER BY a.captured_at NULLS LAST, a.created_at',
      parameters: QueryParameters.named({'id': workOrderId.uuid}),
    );
    return [for (final r in rows) _map(r)];
  }

  /// URL para baixar um anexo já enviado (válida por 15 minutos).
  static Future<String> downloadUrl(Session session, UuidValue id) async {
    await Authorization.requireAny(session, _readPermissions);
    final found = await _find(session, id) ?? (throw ApiErrors.notFound(session));
    if (found.$1.uploadStatus != 'uploaded') {
      throw ApiErrors.businessRule(session, 'NOT_UPLOADED', 'O arquivo ainda não foi enviado pelo aparelho.');
    }
    return (await _storage(session).downloadUrl(found.$2)).toString();
  }

  // ------------------------------------------------------------------ internos

  static void _requireOpenVisit(Session session, Visit visit) {
    final recent =
        visit.status == 'finished' &&
        visit.finishedAt != null &&
        DateTime.now().toUtc().difference(visit.finishedAt!) < const Duration(hours: 24);
    if (!const {'on_site', 'paused'}.contains(visit.status) && !recent) {
      throw ApiErrors.businessRule(
        session,
        'CHECK_IN_REQUIRED',
        'Fotos e assinatura são registradas durante a visita, após o check-in.',
      );
    }
  }

  static ObjectStorage _storage(Session session) =>
      Storage.instance ??
      (throw ApiErrors.businessRule(session, 'STORAGE_UNAVAILABLE', 'Armazenamento de arquivos não configurado.'));

  /// Anexo capturado pelo técnico do usuário logado.
  static Future<(Attachment, String)> _mine(Session session, UuidValue id) async {
    await Authorization.require(session, Visits.executePermission);
    final me = await Technicians.mine(session);
    final rows = await session.db.unsafeQuery(
      'SELECT captured_by_technician_id FROM app.attachments WHERE id = @id::uuid',
      parameters: QueryParameters.named({'id': id.uuid}),
    );
    if (rows.isEmpty || me == null || sqlUuidOrNull(rows.first[0]) != me.id) throw ApiErrors.notFound(session);
    return (await _find(session, id))!;
  }

  static Future<(Attachment, String)?> _find(Session session, UuidValue id) async {
    final rows = await session.db.unsafeQuery(
      'SELECT $_columns, a.storage_key $_from WHERE a.id = @id::uuid',
      parameters: QueryParameters.named({'id': id.uuid}),
    );
    return rows.isEmpty ? null : (_map(rows.first), rows.first[14] as String);
  }

  static Attachment _map(List<Object?> r) => Attachment(
    id: sqlUuid(r[0]),
    workOrderId: sqlUuidOrNull(r[1]),
    visitId: sqlUuidOrNull(r[2]),
    kind: r[3] as String,
    photoStage: r[4] as String?,
    contentType: r[5] as String,
    sizeBytes: r[6] as int?,
    uploadStatus: r[7] as String,
    caption: r[8] as String?,
    capturedAt: r[9] as DateTime?,
    capturedByName: r[10] as String?,
    latitude: r[11] as double?,
    longitude: r[12] as double?,
    createdAt: r[13] as DateTime,
  );
}
