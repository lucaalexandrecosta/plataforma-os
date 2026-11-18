import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/endpoints/endpoint_bases.dart';
import '../internal/attachments.dart';

/// `attachments.*` — envio e download dos arquivos de fotos e assinaturas
/// (docs/06 §6.10). O registro do anexo vem pela fila do sync
/// (`attachment.register`); aqui só as chamadas que exigem rede. Erros:
/// `FORBIDDEN`, `NOT_FOUND`, `STORAGE_UNAVAILABLE`, `ALREADY_UPLOADED`,
/// `UPLOAD_MISSING`, `UPLOAD_MISMATCH`, `NOT_UPLOADED`.
class AttachmentsEndpoint extends StaffEndpoint {
  /// URL pré-assinada (15 min) para o aparelho enviar o arquivo com PUT.
  Future<AttachmentUpload> uploadUrl(Session session, UuidValue attachmentId) =>
      Attachments.uploadUrl(session, attachmentId);

  /// Confere o arquivo enviado (tamanho e sha256) e marca como enviado.
  Future<Attachment> confirmUpload(Session session, UuidValue attachmentId) =>
      Attachments.confirmUpload(session, attachmentId);

  /// Fotos e assinaturas das visitas da OS.
  Future<List<Attachment>> ofWorkOrder(Session session, UuidValue workOrderId) =>
      Attachments.ofWorkOrder(session, workOrderId);

  /// URL pré-assinada (15 min) para baixar o arquivo.
  Future<String> downloadUrl(Session session, UuidValue attachmentId) => Attachments.downloadUrl(session, attachmentId);
}
