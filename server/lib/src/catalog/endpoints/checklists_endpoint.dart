import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/endpoints/endpoint_bases.dart';
import '../internal/checklist_templates.dart';

/// `checklists.*` — modelos de checklist. Leitura para quem trabalha com OS;
/// alteração com `catalog.manage`. Erros: `VALIDATION_FAILED`, `NOT_FOUND`,
/// `VERSION_MISMATCH`, `NOT_DRAFT`, `EMPTY_CHECKLIST`, `DRAFT_EXISTS`.
class ChecklistsEndpoint extends StaffEndpoint {
  /// Rascunhos e publicados (e arquivados com [includeArchived]), por nome e
  /// versão mais nova primeiro.
  Future<List<ChecklistTemplate>> list(Session session, {bool? includeArchived}) =>
      ChecklistTemplates.list(session, includeArchived: includeArchived ?? false);

  Future<ChecklistTemplate> get(Session session, UuidValue id) => ChecklistTemplates.get(session, id);

  Future<ChecklistTemplate> create(Session session, ChecklistTemplateInput input) =>
      ChecklistTemplates.create(session, input);

  Future<ChecklistTemplate> update(Session session, UuidValue id, int expectedVersion, ChecklistTemplateInput input) =>
      ChecklistTemplates.update(session, id, expectedVersion, input);

  Future<ChecklistTemplate> publish(Session session, UuidValue id, int expectedVersion) =>
      ChecklistTemplates.publish(session, id, expectedVersion);

  /// Novo rascunho a partir de uma versão publicada.
  Future<ChecklistTemplate> newVersion(Session session, UuidValue id) => ChecklistTemplates.newVersion(session, id);

  Future<ChecklistTemplate> archive(Session session, UuidValue id, int expectedVersion) =>
      ChecklistTemplates.archive(session, id, expectedVersion);
}
