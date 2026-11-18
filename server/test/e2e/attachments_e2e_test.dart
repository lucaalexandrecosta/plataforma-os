// Fotos e assinatura da visita de ponta a ponta: registro pela fila do sync,
// envio do arquivo direto ao object storage por URL pré-assinada, conferência
// de tamanho e hash, exigências do tipo de OS ao concluir e download pelo
// backoffice.
//
// Pré-requisitos: os do tenant_isolation_e2e_test.dart e o object storage do
// infra/local (RustFS em localhost:9000, segredos s3* de teste).
@Tags(['e2e'])
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import 'support/e2e_login.dart';

void main() {
  late Client ana; // tenant_admin frio-sul
  late Client bruno; // dispatcher frio-sul
  late Client eduardo; // technician frio-sul (técnico T01), no app de campo
  late Client carla; // tenant_admin forno-norte
  late Technician t01;
  late Asset asset;
  late WorkOrderType type;
  final deviceId = UuidValue.fromString(const Uuid().v7());
  final suffix = DateTime.now().microsecondsSinceEpoch;

  final now = DateTime.now().toUtc();
  final start = DateTime.utc(now.year, now.month, now.day, 17).add(const Duration(days: 1));

  UuidValue newId() => UuidValue.fromString(const Uuid().v7());

  SyncMutation mutation(String type, Visit visit, Map<String, dynamic> payload) => SyncMutation(
    mutationId: newId(),
    type: type,
    entityId: visit.id,
    clientTimestamp: DateTime.now().toUtc(),
    payload: jsonEncode(payload),
  );

  SyncMutation visitMutation(String type, Visit visit, {VisitCheckIn? checkIn, VisitFinish? finish}) =>
      mutation(type, visit, VisitMutationPayload(checkIn: checkIn, finish: finish).toJson());

  SyncMutation register(
    Visit visit,
    UuidValue id,
    List<int> bytes, {
    String kind = 'photo',
    String? stage = 'before',
    String contentType = 'image/jpeg',
    String? sha,
  }) => mutation(
    'attachment.register',
    visit,
    AttachmentRegisterPayload(
      attachmentId: id,
      kind: kind,
      photoStage: stage,
      contentType: contentType,
      sizeBytes: bytes.length,
      sha256: sha ?? sha256.convert(bytes).toString(),
      capturedAt: DateTime.now().toUtc(),
      latitude: -27.59,
      longitude: -48.55,
    ).toJson(),
  );

  Future<List<SyncMutationResult>> push(List<SyncMutation> mutations) =>
      eduardo.technicianSync.push(SyncPushRequest(deviceId: deviceId, appVersion: '0.4.0', mutations: mutations));

  Future<void> upload(UuidValue id, List<int> bytes) async {
    final target = await eduardo.attachments.uploadUrl(id);
    final response = await http.put(
      Uri.parse(target.url),
      headers: {'content-type': target.contentType},
      body: bytes,
    );
    expect(response.statusCode, 200, reason: response.body);
  }

  Matcher apiError(String code) => throwsA(isA<ApiException>().having((e) => e.code, 'code', code));

  final checkIn = VisitCheckIn(method: 'manual', justification: 'Etiqueta ilegível');
  final photoBefore = Uint8List.fromList(List.generate(2048, (i) => i % 251));
  final photoAfter = Uint8List.fromList(List.generate(4096, (i) => (i * 7) % 253));
  final signaturePng = Uint8List.fromList([0x89, 0x50, 0x4E, 0x47, ...List.generate(300, (i) => i % 200)]);

  setUpAll(() async {
    ana = await tenantClient('ana.admin@frio-sul.test', 'frio-sul');
    bruno = await tenantClient('bruno.despacho@frio-sul.test', 'frio-sul');
    eduardo = await tenantClient('eduardo.tecnico@frio-sul.test', 'frio-sul', technicianApp: true);
    carla = await tenantClient('carla.admin@forno-norte.test', 'forno-norte');
    t01 = (await bruno.technicians.list()).singleWhere((t) => t.code == 'T01');
    final product = (await ana.products.list()).first;
    asset = await ana.assets.create(AssetInput(productId: product.id, assetTag: 'PAT-ANX-$suffix', isActive: true));
    type = await ana.workOrders.createType(
      WorkOrderTypeInput(
        code: 'ANX${suffix % 100000}',
        name: 'Corretiva com fotos e assinatura',
        category: 'corrective',
        defaultPriority: 'normal',
        requiresAsset: true,
        isActive: true,
        requirePhotos: true,
        requireSignature: true,
      ),
    );
    expect((type.requirePhotos, type.requireSignature), (true, true));
    await eduardo.technicianSync.registerDevice(DeviceRegistration(deviceId: deviceId, platform: 'android'));
    for (final v in await eduardo.visits.mine(
      now.subtract(const Duration(days: 40)),
      now.add(const Duration(days: 20)),
    )) {
      if (const {'en_route', 'on_site', 'paused'}.contains(v.status)) {
        await eduardo.visits.finish(v.id, v.version, VisitFinish(outcome: 'not_executed'));
      }
    }
  });

  test('fotos e assinatura: registro offline, envio, conferência, exigências e download', () async {
    final wo = (await bruno.workOrders.open(WorkOrderInput(workOrderTypeId: type.id, assetId: asset.id))).workOrder;
    final visit = await bruno.visits.schedule(
      wo.id,
      VisitInput(technicianId: t01.id, scheduledStart: start, scheduledEnd: start.add(const Duration(hours: 1))),
    );
    expect((visit.requirePhotos, visit.requireSignature), (true, true));

    // Antes do check-in não registra.
    final early = newId();
    var results = await push([register(visit, early, photoBefore)]);
    expect(results.single.errorCode, 'CHECK_IN_REQUIRED');

    // Check-in; registros inválidos são recusados um a um (lotes separados).
    results = await push([visitMutation('visit.check_in', visit, checkIn: checkIn)]);
    expect(results.single.status, 'applied');
    for (final bad in [
      register(visit, newId(), photoBefore, stage: null),
      register(visit, newId(), photoBefore, contentType: 'application/pdf'),
      register(visit, newId(), photoBefore, sha: 'abc'),
      register(visit, newId(), signaturePng, kind: 'signature', stage: null),
    ]) {
      expect((await push([bad])).single.errorCode, 'VALIDATION_FAILED');
    }

    // Concluir sem fotos e sem assinatura é recusado.
    final finish = VisitFinish(outcome: 'resolved', notes: 'Troca do compressor');
    results = await push([visitMutation('visit.finish', visit, finish: finish)]);
    expect(results.single.errorCode, 'EVIDENCE_REQUIRED');
    expect(results.single.errorMessage, contains('assinatura'));

    // Registro das fotos e da assinatura, e quem assinou, num lote só (offline).
    final before = newId();
    final after = newId();
    final signature = newId();
    results = await push([
      register(visit, before, photoBefore),
      register(visit, after, photoAfter, stage: 'after'),
      register(visit, signature, signaturePng, kind: 'signature', stage: null, contentType: 'image/png'),
      mutation(
        'signature.capture',
        visit,
        SignatureCapturePayload(
          attachmentId: signature,
          signerName: 'Marta Gerente',
          signerDocument: '123.456.789-00',
          signerRole: 'site_manager',
          signedAt: DateTime.now().toUtc(),
        ).toJson(),
      ),
      visitMutation('visit.finish', visit, finish: finish),
    ]);
    expect(results.map((r) => r.status), ['applied', 'applied', 'applied', 'applied', 'applied']);
    final finished = results.last.visit!;
    expect(finished.status, 'finished');
    expect((finished.signerName, finished.signerRole), ('Marta Gerente', 'site_manager'));
    expect(finished.signatureAttachmentId, signature);

    // Assinatura apontando para foto é recusada.
    final wrong = mutation(
      'signature.capture',
      visit,
      SignatureCapturePayload(
        attachmentId: before,
        signerName: 'X',
        signerRole: 'other',
        signedAt: DateTime.now().toUtc(),
      ).toJson(),
    );
    expect((await push([wrong])).single.errorCode, 'SIGNATURE_NOT_REGISTERED');

    // Envio do arquivo: confirmar antes de enviar, arquivo trocado, envio certo.
    await expectLater(eduardo.attachments.confirmUpload(before), apiError('UPLOAD_MISSING'));
    await upload(before, photoAfter);
    await expectLater(eduardo.attachments.confirmUpload(before), apiError('UPLOAD_MISMATCH'));
    await upload(before, photoBefore);
    expect((await eduardo.attachments.confirmUpload(before)).uploadStatus, 'uploaded');
    expect((await eduardo.attachments.confirmUpload(before)).uploadStatus, 'uploaded');
    await expectLater(eduardo.attachments.uploadUrl(before), apiError('ALREADY_UPLOADED'));
    await upload(signature, signaturePng);
    await eduardo.attachments.confirmUpload(signature);

    // Backoffice: lista os anexos e baixa o que já chegou.
    final listed = await bruno.attachments.ofWorkOrder(wo.id);
    expect(listed.map((a) => (a.kind, a.photoStage, a.uploadStatus)), [
      ('photo', 'before', 'uploaded'),
      ('photo', 'after', 'pending'),
      ('signature', null, 'uploaded'),
    ]);
    expect(listed.first.capturedByName, t01.name);
    await expectLater(bruno.attachments.downloadUrl(after), apiError('NOT_UPLOADED'));
    final download = await http.get(Uri.parse(await bruno.attachments.downloadUrl(before)));
    expect(download.statusCode, 200);
    expect(download.bodyBytes, photoBefore);

    // Outra empresa não vê nada; outro usuário não envia pelo técnico.
    expect(await carla.attachments.ofWorkOrder(wo.id), isEmpty);
    await expectLater(carla.attachments.downloadUrl(before), apiError('NOT_FOUND'));
    await expectLater(ana.attachments.uploadUrl(after), throwsA(isA<ApiException>()));
  });
}
