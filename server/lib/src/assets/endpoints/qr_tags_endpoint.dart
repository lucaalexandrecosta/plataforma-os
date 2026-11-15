import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/endpoints/endpoint_bases.dart';
import '../internal/qr_tags.dart';

/// `qrTags.*` — etiquetas QR (permissão `qr_tags.manage`; desfazer vínculo
/// exige `qr_tags.unbind`). Erros: `FORBIDDEN`, `VALIDATION_FAILED`,
/// `NOT_FOUND`, `TAG_ALREADY_BOUND`, `TAG_ALREADY_ON_ASSET`, `TAG_REVOKED`,
/// `TAG_NOT_BOUND`, `ASSET_ALREADY_TAGGED`, `ASSET_RETIRED`.
class QrTagsEndpoint extends StaffEndpoint {
  /// Gera um lote de 1 a 500 etiquetas para imprimir.
  Future<QrTagBatch> generateBatch(Session session, int quantity, {String? notes}) =>
      QrTags.generateBatch(session, quantity: quantity, notes: notes);

  Future<List<QrTagBatch>> listBatches(Session session) => QrTags.listBatches(session);

  /// Etiquetas do lote, com código curto e URL para montar o PDF de impressão.
  Future<List<QrTag>> batchTags(Session session, UuidValue batchId) => QrTags.batchTags(session, batchId);

  Future<QrTagBatch> markBatchPrinted(Session session, UuidValue batchId) => QrTags.markBatchPrinted(session, batchId);

  /// Etiqueta pelo que foi lido ou digitado: código curto, token ou URL.
  Future<QrTag> resolve(Session session, String scanned) => QrTags.resolve(session, scanned);

  Future<QrTag> bind(Session session, String scanned, UuidValue assetId) =>
      QrTags.bind(session, scanned: scanned, assetId: assetId);

  Future<QrTag> unbind(Session session, UuidValue tagId) => QrTags.unbind(session, tagId);

  /// [reason]: damaged, lost, replaced, asset_retired, misprint, security ou other.
  Future<QrTag> revoke(Session session, UuidValue tagId, String reason, {String? note}) =>
      QrTags.revoke(session, tagId, reason: reason, note: note);
}
