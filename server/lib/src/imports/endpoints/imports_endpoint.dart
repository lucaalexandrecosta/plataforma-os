import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/endpoints/endpoint_bases.dart';
import '../internal/import_service.dart';

/// `imports` (docs/08 §3.10): modelo, prévia com erros por linha,
/// confirmação, cancelamento, histórico e relatório de erros. Permissão
/// `imports.run` (tenant_admin e backoffice_agent).
class ImportsEndpoint extends StaffEndpoint {
  Future<List<ImportEntityType>> available(Session session) => ImportService.available(session);

  Future<ImportTemplate> template(Session session, ImportEntityType entityType) =>
      ImportService.template(session, entityType);

  Future<ImportPreview> preview(Session session, ImportEntityType entityType, String fileName, ByteData content) =>
      ImportService.preview(session, entityType, fileName, content);

  Future<ImportRunInfo> confirm(Session session, UuidValue runId, int expectedVersion) =>
      ImportService.confirm(session, runId, expectedVersion);

  Future<ImportRunInfo> cancel(Session session, UuidValue runId, int expectedVersion) =>
      ImportService.cancel(session, runId, expectedVersion);

  Future<ImportRunPage> list(Session session, ImportEntityType? entityType, PageRequest? page) =>
      ImportService.list(session, entityType, page);

  Future<ImportRunInfo> get(Session session, UuidValue runId) => ImportService.get(session, runId);

  Future<ByteData> errorReport(Session session, UuidValue runId) => ImportService.errorReport(session, runId);
}
