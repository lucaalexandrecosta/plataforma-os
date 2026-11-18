import 'package:plataforma_os_client/plataforma_os_client.dart';

/// Tipos das mutações de anexo (docs/06 §6.7); entityId é a visita.
const attachmentRegisterType = 'attachment.register';
const signatureCaptureType = 'signature.capture';

/// Fotos e assinatura: registro aceito no servidor, falta enviar o arquivo.
const attachmentQueued = 'queued';
const attachmentRegistered = 'registered';
const attachmentUploaded = 'uploaded';
const attachmentFailed = 'failed';

/// O que falta para concluir a visita como resolvida (mesmas regras do
/// servidor), ou nulo. [photoStages]: momento de cada foto da visita.
String? missingEvidence(Visit visit, Iterable<String?> photoStages) {
  if (visit.requireSignature && visit.signatureAttachmentId == null) {
    return 'Colete a assinatura antes de concluir a visita.';
  }
  if (visit.requirePhotos && !photoStages.toSet().containsAll(const {'before', 'after'})) {
    return 'Tire ao menos uma foto de antes e uma de depois antes de concluir a visita.';
  }
  return null;
}

/// Aplica a assinatura na visita mostrada (mudança otimista).
Visit applySignature(Visit visit, SignatureCapturePayload p) => visit.copyWith(
  signatureAttachmentId: p.attachmentId,
  signerName: p.signerName,
  signerRole: p.signerRole,
  signedAt: p.signedAt,
);
