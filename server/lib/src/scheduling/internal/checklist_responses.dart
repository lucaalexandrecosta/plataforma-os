import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../../catalog/catalog.dart';
import '../../generated/protocol.dart';
import '../../identity_access/identity_access.dart';
import '../../platform/db/sql_values.dart';
import '../../platform/errors/api_errors.dart';

/// Checklist da visita (docs/06 §5.9): qual modelo cada visita preenche, as
/// respostas enviadas pelo técnico e a exigência ao concluir.
///
/// O modelo da visita é o da resposta já gravada (versão nova não muda a
/// visita que já respondeu) ou, sem resposta, a versão publicada em vigor do
/// checklist padrão do tipo de OS. As respostas ficam em `answers` como um
/// objeto `{chave do item: {value, note}}`.
abstract final class ChecklistResponses {
  static const _readPermissions = {'visits.schedule', 'work_orders.read', 'visits.execute'};
  static const _yesNo = {'yes', 'no', 'na'};
  static const _okNok = {'ok', 'nok', 'na'};

  static const _columns =
      'r.id, r.work_order_id, r.visit_id, r.checklist_template_id, r.template_version, r.status, r.answers::text, '
      'r.submitted_at, te.name, r.version';
  static const _from =
      'FROM app.checklist_responses r '
      'LEFT JOIN app.technicians te ON te.tenant_id = r.tenant_id AND te.id = r.submitted_by_technician_id ';

  /// Checklists das visitas de uma OS que já têm respostas (backoffice).
  static Future<List<VisitChecklist>> ofWorkOrder(Session session, UuidValue workOrderId) async {
    await Authorization.requireAny(session, _readPermissions);
    final rows = await session.db.unsafeQuery(
      'SELECT $_columns, v.visit_number $_from '
      'JOIN app.work_order_visits v ON v.tenant_id = r.tenant_id AND v.id = r.visit_id '
      'WHERE r.work_order_id = @id::uuid ORDER BY v.visit_number, r.created_at',
      parameters: QueryParameters.named({'id': workOrderId.uuid}),
    );
    final templates = <UuidValue, ChecklistTemplate?>{};
    return [
      for (final r in rows)
        if (await _template(session, templates, sqlUuid(r[3])) case final template?)
          VisitChecklist(visitId: sqlUuid(r[2]), visitNumber: r[10] as int, template: template, response: _map(r)),
    ];
  }

  /// Checklist de cada visita de [visitIds] que tem um (sync do técnico, sem
  /// checar permissão: quem chama já checou).
  static Future<List<VisitChecklist>> forVisits(Session session, List<UuidValue> visitIds) async {
    if (visitIds.isEmpty) return const [];
    final rows = await session.db.unsafeQuery(
      'SELECT DISTINCT ON (v.id) v.id, v.visit_number, wt.default_checklist_template_id, r.id IS NOT NULL, $_columns '
      '  FROM app.work_order_visits v '
      '  JOIN app.work_orders w ON w.tenant_id = v.tenant_id AND w.id = v.work_order_id '
      '  JOIN app.work_order_types wt ON wt.tenant_id = w.tenant_id AND wt.id = w.work_order_type_id '
      '  LEFT JOIN app.checklist_responses r ON r.tenant_id = v.tenant_id AND r.visit_id = v.id '
      '  LEFT JOIN app.technicians te ON te.tenant_id = r.tenant_id AND te.id = r.submitted_by_technician_id '
      ' WHERE v.id = ANY(@ids::uuid[]) '
      '   AND (r.id IS NOT NULL OR wt.default_checklist_template_id IS NOT NULL) '
      ' ORDER BY v.id, r.updated_at DESC NULLS LAST',
      parameters: QueryParameters.named({
        'ids': [for (final id in visitIds) id.uuid],
      }),
    );
    final templates = <UuidValue, ChecklistTemplate?>{};
    final current = <UuidValue, ChecklistTemplate?>{};
    final result = <VisitChecklist>[];
    for (final r in rows) {
      final visitId = sqlUuid(r[0]);
      final visitNumber = r[1] as int;
      if (r[3] as bool) {
        final response = _map(r.sublist(4));
        final template = await _template(session, templates, response.checklistTemplateId);
        if (template != null) {
          result.add(
            VisitChecklist(visitId: visitId, visitNumber: visitNumber, template: template, response: response),
          );
        }
        continue;
      }
      final defaultId = sqlUuid(r[2]);
      final template = current.containsKey(defaultId)
          ? current[defaultId]
          : current[defaultId] = await ChecklistTemplates.currentPublished(session, defaultId);
      if (template != null) result.add(VisitChecklist(visitId: visitId, visitNumber: visitNumber, template: template));
    }
    return result;
  }

  /// Checklist da visita (ou `null` se ela não tem).
  static Future<VisitChecklist?> forVisit(Session session, UuidValue visitId) async =>
      (await forVisits(session, [visitId])).firstOrNull;

  /// Grava as respostas enviadas pelo técnico (`checklist_response.submit`),
  /// substituindo as anteriores da visita. Valida tipos, opções e obrigatórios.
  static Future<VisitChecklist> submit(
    Session session,
    Visit visit,
    UuidValue technicianId,
    ChecklistSubmitPayload payload,
    Transaction tx,
  ) async {
    if (!const {'on_site', 'paused'}.contains(visit.status)) {
      throw ApiErrors.businessRule(
        session,
        'CHECK_IN_REQUIRED',
        'O checklist é enviado durante a visita, após o check-in.',
      );
    }
    final expected = await forVisit(session, visit.id);
    final template = await ChecklistTemplates.find(session, payload.checklistTemplateId);
    if (expected == null || template == null || template.code != expected.template.code) {
      throw ApiErrors.businessRule(session, 'CHECKLIST_MISMATCH', 'Este checklist não é o desta visita.');
    }
    final answers = _validate(session, template, payload.answers);
    final values = {
      'visit': visit.id.uuid,
      'template': template.id.uuid,
      'tv': template.templateVersion,
      'answers': jsonEncode(answers),
      'tech': technicianId.uuid,
    };
    // Uma resposta por visita: o reenvio (mesmo numa versão nova do modelo)
    // substitui a anterior.
    final changed = await session.db.unsafeExecute(
      'UPDATE app.checklist_responses '
      "   SET checklist_template_id = @template::uuid, template_version = @tv, status = 'submitted', "
      '       answers = @answers::jsonb, submitted_at = now(), submitted_by_technician_id = @tech::uuid, '
      '       updated_at = now(), version = version + 1 '
      ' WHERE visit_id = @visit::uuid',
      parameters: QueryParameters.named(values),
      transaction: tx,
    );
    if (changed == 0) {
      await session.db.unsafeExecute(
        'INSERT INTO app.checklist_responses (tenant_id, work_order_id, visit_id, checklist_template_id, '
        '       template_version, status, answers, submitted_at, submitted_by_technician_id) '
        "VALUES (app.current_tenant_id(), @wo::uuid, @visit::uuid, @template::uuid, @tv, 'submitted', "
        '        @answers::jsonb, now(), @tech::uuid)',
        parameters: QueryParameters.named({...values, 'wo': visit.workOrderId.uuid}),
        transaction: tx,
      );
    }
    final rows = await session.db.unsafeQuery(
      'SELECT $_columns $_from WHERE r.visit_id = @visit::uuid',
      parameters: QueryParameters.named({'visit': visit.id.uuid}),
      transaction: tx,
    );
    return VisitChecklist(
      visitId: visit.id,
      visitNumber: visit.visitNumber,
      template: template,
      response: _map(rows.first),
    );
  }

  /// `true` se a visita pode ser concluída: não tem checklist, ou o dela foi enviado.
  static Future<bool> isSatisfied(Session session, UuidValue visitId) async {
    final checklist = await forVisit(session, visitId);
    return checklist == null || checklist.response?.status == 'submitted';
  }

  static Map<String, Object?> _validate(Session session, ChecklistTemplate template, List<ChecklistAnswer> answers) {
    final items = {for (final i in template.items) i.key!: i};
    final errors = <FieldError>[];
    final stored = <String, Object?>{};
    void fail(String key, String message) =>
        errors.add(FieldError(path: 'answers.$key', code: 'INVALID', message: message));
    for (final a in answers) {
      final item = items[a.itemKey];
      if (item == null) {
        fail(a.itemKey, 'Item que não existe no checklist.');
        continue;
      }
      final value = a.value.trim();
      if (value.isEmpty) continue;
      final ok = switch (item.type) {
        'yes_no' => _yesNo.contains(value),
        'ok_nok' => _okNok.contains(value),
        'number' => double.tryParse(value)?.isFinite ?? false,
        'choice' => item.options?.contains(value) ?? false,
        _ => value.length <= 2000,
      };
      if (!ok) {
        fail(a.itemKey, '"${item.label}": resposta inválida.');
        continue;
      }
      final note = a.note?.trim();
      stored[a.itemKey] = {'value': value, if (note != null && note.isNotEmpty) 'note': note};
    }
    for (final item in template.items) {
      if (item.required && !stored.containsKey(item.key) && !errors.any((e) => e.path == 'answers.${item.key}')) {
        errors.add(
          FieldError(path: 'answers.${item.key}', code: 'REQUIRED', message: '"${item.label}" é obrigatório.'),
        );
      }
    }
    if (errors.isNotEmpty) throw ApiErrors.validation(session, errors);
    return stored;
  }

  static Future<ChecklistTemplate?> _template(
    Session session,
    Map<UuidValue, ChecklistTemplate?> cache,
    UuidValue id,
  ) async => cache.containsKey(id) ? cache[id] : cache[id] = await ChecklistTemplates.find(session, id);

  static ChecklistResponse _map(List<Object?> r) {
    final raw = jsonDecode(r[6] as String) as Map<String, dynamic>;
    return ChecklistResponse(
      id: sqlUuid(r[0]),
      workOrderId: sqlUuid(r[1]),
      visitId: sqlUuid(r[2]),
      checklistTemplateId: sqlUuid(r[3]),
      templateVersion: r[4] as int,
      status: r[5] as String,
      answers: [
        for (final MapEntry(:key, :value) in raw.entries)
          if (value case {'value': final String v})
            ChecklistAnswer(itemKey: key, value: v, note: value['note'] as String?),
      ],
      submittedAt: r[7] as DateTime?,
      submittedByName: r[8] as String?,
      version: r[9] as int,
    );
  }
}
