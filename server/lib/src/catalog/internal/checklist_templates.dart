import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../identity_access/identity_access.dart';
import '../../platform/db/sql_values.dart';
import '../../platform/errors/api_errors.dart';

/// Modelos de checklist (RF-13). Ciclo: rascunho → publicado → arquivado.
/// O publicado não muda (as respostas apontam para a versão); para alterar,
/// cria-se uma nova versão em rascunho a partir dele, e publicar a nova
/// arquiva a anterior. Fotos entram como tipo de item junto com os anexos.
abstract final class ChecklistTemplates {
  static const managePermission = 'catalog.manage';
  static const _readPermissions = {managePermission, 'work_orders.read', 'visits.schedule'};
  static const itemTypes = {'yes_no', 'ok_nok', 'number', 'text', 'choice'};
  static const maxItems = 100;

  static const _columns =
      'id, code, name, description, template_version, status, items::text, published_at, is_active, version';

  static Future<List<ChecklistTemplate>> list(Session session, {bool includeArchived = false}) async {
    await Authorization.requireAny(session, _readPermissions);
    final rows = await session.db.unsafeQuery(
      'SELECT $_columns FROM app.checklist_templates '
      " WHERE (@all OR status <> 'archived') ORDER BY lower(name), code, template_version DESC",
      parameters: QueryParameters.named({'all': includeArchived}),
    );
    return [for (final r in rows) _map(r)];
  }

  static Future<ChecklistTemplate> get(Session session, UuidValue id) async {
    await Authorization.requireAny(session, _readPermissions);
    return await find(session, id) ?? (throw ApiErrors.notFound(session));
  }

  /// Modelo do tenant ativo, sem checar permissão. `null` = inexistente.
  static Future<ChecklistTemplate?> find(Session session, UuidValue id) async {
    final rows = await session.db.unsafeQuery(
      'SELECT $_columns FROM app.checklist_templates WHERE id = @id::uuid',
      parameters: QueryParameters.named({'id': id.uuid}),
    );
    return rows.isEmpty ? null : _map(rows.first);
  }

  /// Versão publicada mais recente do mesmo código do modelo [id] (o tipo de
  /// OS guarda um id; quem usa o checklist pega sempre a versão em vigor).
  static Future<ChecklistTemplate?> currentPublished(Session session, UuidValue id) async {
    final rows = await session.db.unsafeQuery(
      'SELECT $_columns FROM app.checklist_templates '
      " WHERE status = 'published' AND is_active "
      '   AND code = (SELECT code FROM app.checklist_templates WHERE id = @id::uuid) '
      ' ORDER BY template_version DESC LIMIT 1',
      parameters: QueryParameters.named({'id': id.uuid}),
    );
    return rows.isEmpty ? null : _map(rows.first);
  }

  static Future<ChecklistTemplate> create(Session session, ChecklistTemplateInput input) async {
    await Authorization.require(session, managePermission);
    final params = _validate(session, input);
    final id = const Uuid().v7obj();
    await _write(
      session,
      () => session.db.unsafeExecute(
        'INSERT INTO app.checklist_templates (id, tenant_id, code, name, description, items) '
        'VALUES (@id::uuid, app.current_tenant_id(), @code, @name, @description, @items::jsonb)',
        parameters: QueryParameters.named({'id': id.uuid, ...params}),
      ),
    );
    return (await find(session, id))!;
  }

  /// Altera um rascunho. O código só muda na primeira versão.
  static Future<ChecklistTemplate> update(
    Session session,
    UuidValue id,
    int expectedVersion,
    ChecklistTemplateInput input,
  ) async {
    await Authorization.require(session, managePermission);
    final current = await _current(session, id, expectedVersion);
    _requireDraft(session, current);
    final params = _validate(session, input);
    if (current.templateVersion > 1 && params['code'] != current.code) {
      throw ApiErrors.fieldError(session, 'code', 'IMMUTABLE', 'O código não muda depois da primeira versão.');
    }
    final changed = await _write(
      session,
      () => session.db.unsafeExecute(
        'UPDATE app.checklist_templates SET code = @code, name = @name, description = @description, '
        '       items = @items::jsonb '
        ' WHERE id = @id::uuid AND version = @version',
        parameters: QueryParameters.named({'id': id.uuid, 'version': expectedVersion, ...params}),
      ),
    );
    if (changed == 0) throw ApiErrors.versionMismatch(session, (await find(session, id))!.version);
    return (await find(session, id))!;
  }

  /// Publica o rascunho e arquiva as versões publicadas anteriores do código.
  static Future<ChecklistTemplate> publish(Session session, UuidValue id, int expectedVersion) async {
    await Authorization.require(session, managePermission);
    final current = await _current(session, id, expectedVersion);
    _requireDraft(session, current);
    if (current.items.isEmpty) {
      throw ApiErrors.businessRule(session, 'EMPTY_CHECKLIST', 'Inclua ao menos um item antes de publicar.');
    }
    await session.db.transaction((tx) async {
      await session.db.unsafeExecute(
        "UPDATE app.checklist_templates SET status = 'archived' "
        " WHERE code = @code AND status = 'published' AND id <> @id::uuid",
        parameters: QueryParameters.named({'code': current.code, 'id': id.uuid}),
        transaction: tx,
      );
      final changed = await session.db.unsafeExecute(
        "UPDATE app.checklist_templates SET status = 'published', published_at = now() "
        ' WHERE id = @id::uuid AND version = @version',
        parameters: QueryParameters.named({'id': id.uuid, 'version': expectedVersion}),
        transaction: tx,
      );
      if (changed == 0) throw ApiErrors.versionMismatch(session, current.version);
    });
    return (await find(session, id))!;
  }

  /// Novo rascunho a partir de uma versão publicada (cópia dos itens).
  static Future<ChecklistTemplate> newVersion(Session session, UuidValue id) async {
    await Authorization.require(session, managePermission);
    final source = await find(session, id) ?? (throw ApiErrors.notFound(session));
    final rows = await session.db.unsafeQuery(
      'SELECT max(template_version), bool_or(status = \'draft\') FROM app.checklist_templates WHERE code = @code',
      parameters: QueryParameters.named({'code': source.code}),
    );
    if (rows.first[1] == true) {
      throw ApiErrors.businessRule(session, 'DRAFT_EXISTS', 'Já existe um rascunho deste checklist; edite-o.');
    }
    final newId = const Uuid().v7obj();
    await session.db.unsafeExecute(
      'INSERT INTO app.checklist_templates (id, tenant_id, code, name, description, items, template_version, '
      '                                     product_family_id) '
      'SELECT @newId::uuid, tenant_id, code, name, description, items, @next, product_family_id '
      '  FROM app.checklist_templates WHERE id = @id::uuid',
      parameters: QueryParameters.named({'newId': newId.uuid, 'id': id.uuid, 'next': (rows.first[0] as int) + 1}),
    );
    return (await find(session, newId))!;
  }

  /// Arquiva (some das listas e do uso em novas OS; as respostas ficam).
  static Future<ChecklistTemplate> archive(Session session, UuidValue id, int expectedVersion) async {
    await Authorization.require(session, managePermission);
    await _current(session, id, expectedVersion);
    final changed = await session.db.unsafeExecute(
      "UPDATE app.checklist_templates SET status = 'archived' WHERE id = @id::uuid AND version = @version",
      parameters: QueryParameters.named({'id': id.uuid, 'version': expectedVersion}),
    );
    if (changed == 0) throw ApiErrors.versionMismatch(session, (await find(session, id))!.version);
    return (await find(session, id))!;
  }

  /// Gera a chave do item a partir do texto: minúsculas, sem acento, `_`.
  static String keyFor(String label) {
    const from = 'áàâãäéèêëíìîïóòôõöúùûüç';
    const to = 'aaaaaeeeeiiiiooooouuuuc';
    final buffer = StringBuffer();
    for (final ch in label.toLowerCase().split('')) {
      final i = from.indexOf(ch);
      buffer.write(i >= 0 ? to[i] : ch);
    }
    final key = buffer.toString().replaceAll(RegExp('[^a-z0-9]+'), '_').replaceAll(RegExp(r'^_+|_+$'), '');
    return key.isEmpty ? 'item' : (key.length > 40 ? key.substring(0, 40) : key);
  }

  // ------------------------------------------------------------------ internos

  static Future<ChecklistTemplate> _current(Session session, UuidValue id, int expectedVersion) async {
    final current = await find(session, id) ?? (throw ApiErrors.notFound(session));
    if (current.version != expectedVersion) throw ApiErrors.versionMismatch(session, current.version);
    return current;
  }

  static void _requireDraft(Session session, ChecklistTemplate t) {
    if (t.status != 'draft') {
      throw ApiErrors.businessRule(
        session,
        'NOT_DRAFT',
        'Checklist publicado ou arquivado não muda. Crie uma nova versão.',
      );
    }
  }

  static Future<int> _write(Session session, Future<int> Function() body) async {
    try {
      return await body();
    } on DatabaseQueryException catch (e) {
      if (isUniqueViolation(e, 'checklist_templates_tenant_id_code_template_version_key')) {
        throw ApiErrors.fieldError(session, 'code', 'DUPLICATE', 'Já existe um checklist com este código.');
      }
      rethrow;
    }
  }

  static Map<String, Object?> _validate(Session session, ChecklistTemplateInput input) {
    final code = cleanText(input.code)?.toUpperCase();
    final name = cleanText(input.name);
    final errors = <FieldError>[
      if (code == null || code.length > 40)
        FieldError(path: 'code', code: 'REQUIRED', message: 'Informe o código (até 40 caracteres).'),
      if (name == null || name.length > 200) FieldError(path: 'name', code: 'REQUIRED', message: 'Informe o nome.'),
      if (input.items.length > maxItems)
        FieldError(path: 'items', code: 'TOO_MANY', message: 'Use até $maxItems itens.'),
    ];
    final keys = <String>{};
    final items = <Map<String, Object?>>[];
    for (var i = 0; i < input.items.length; i++) {
      final item = input.items[i];
      final path = 'items.$i';
      final label = cleanText(item.label);
      if (label == null || label.length > 200) {
        errors.add(FieldError(path: '$path.label', code: 'REQUIRED', message: 'Item ${i + 1}: informe o texto.'));
        continue;
      }
      if (!itemTypes.contains(item.type)) {
        errors.add(FieldError(path: '$path.type', code: 'INVALID', message: 'Item ${i + 1}: tipo inválido.'));
        continue;
      }
      final options = <String>[
        for (final o in item.options ?? const <String>[])
          if (cleanText(o) != null) cleanText(o)!,
      ];
      if (item.type == 'choice' && (options.length < 2 || options.toSet().length != options.length)) {
        errors.add(
          FieldError(
            path: '$path.options',
            code: 'INVALID',
            message: 'Item ${i + 1}: informe ao menos duas opções diferentes.',
          ),
        );
        continue;
      }
      var key = cleanText(item.key) ?? keyFor(label);
      if (!RegExp(r'^[a-z0-9_]{1,40}$').hasMatch(key)) key = keyFor(key);
      final base = key;
      for (var n = 2; keys.contains(key); n++) {
        key = '${base}_$n';
      }
      keys.add(key);
      items.add({
        'key': key,
        'label': label,
        'type': item.type,
        'required': item.required,
        if (item.type == 'choice') 'options': options,
        if (item.type == 'number' && cleanText(item.unit) != null) 'unit': cleanText(item.unit),
      });
    }
    if (errors.isNotEmpty) throw ApiErrors.validation(session, errors);
    return {'code': code, 'name': name, 'description': cleanText(input.description), 'items': jsonEncode(items)};
  }

  static ChecklistTemplate _map(List<Object?> r) => ChecklistTemplate(
    id: sqlUuid(r[0]),
    code: r[1] as String,
    name: r[2] as String,
    description: r[3] as String?,
    templateVersion: r[4] as int,
    status: r[5] as String,
    items: [
      for (final i in jsonDecode(r[6] as String) as List)
        ChecklistItem(
          key: (i as Map)['key'] as String?,
          label: i['label'] as String,
          type: i['type'] as String,
          required: i['required'] as bool? ?? false,
          options: (i['options'] as List?)?.cast<String>(),
          unit: i['unit'] as String?,
        ),
    ],
    publishedAt: r[7] as DateTime?,
    isActive: r[8] as bool,
    version: r[9] as int,
  );
}
