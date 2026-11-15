import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../identity_access/identity_access.dart';
import '../../platform/db/sql_values.dart';
import '../../platform/errors/api_errors.dart';

/// Filiais do tenant. Leitura para qualquer pessoa com acesso (formulários);
/// alteração com `settings.manage`. Uma filial padrão por tenant.
abstract final class Branches {
  static const managePermission = 'settings.manage';

  static const _columns =
      'id, code, legal_name, trade_name, document_number, city, state, erp_branch_code, is_default, is_active, version';

  static Future<List<Branch>> list(Session session, {bool includeInactive = false}) async {
    await Authorization.requireMember(session);
    final rows = await session.db.unsafeQuery(
      'SELECT $_columns FROM app.branches WHERE (@all OR is_active) ORDER BY is_default DESC, code',
      parameters: QueryParameters.named({'all': includeInactive}),
    );
    return [for (final r in rows) _map(r)];
  }

  /// Filial do tenant ativo, ou `null` (inexistente ou de outro tenant).
  static Future<Branch?> find(Session session, UuidValue id, {Transaction? transaction}) async {
    final rows = await session.db.unsafeQuery(
      'SELECT $_columns FROM app.branches WHERE id = @id::uuid',
      parameters: QueryParameters.named({'id': id.uuid}),
      transaction: transaction,
    );
    return rows.isEmpty ? null : _map(rows.first);
  }

  /// Filial padrão do tenant ativo, se houver (destino de bem sem filial).
  static Future<Branch?> findDefault(Session session, {Transaction? transaction}) async {
    final rows = await session.db.unsafeQuery(
      'SELECT $_columns FROM app.branches WHERE is_default AND is_active',
      transaction: transaction,
    );
    return rows.isEmpty ? null : _map(rows.first);
  }

  static Future<Branch> create(Session session, BranchInput input) async {
    await Authorization.require(session, managePermission);
    final data = _validate(session, input);
    final id = const Uuid().v7obj();
    await _write(session, () async {
      await session.db.transaction((tx) async {
        if (data.isDefault) await _clearDefault(session, tx);
        await session.db.unsafeExecute(
          'INSERT INTO app.branches (id, tenant_id, code, legal_name, trade_name, document_number, city, state, '
          '                          erp_branch_code, is_default, is_active) '
          'VALUES (@id::uuid, app.current_tenant_id(), @code, @legalName, @tradeName, @documentNumber, @city, @state, '
          '        @erpBranchCode, @isDefault, @isActive)',
          parameters: QueryParameters.named({'id': id.uuid, ...data.params}),
          transaction: tx,
        );
      });
    });
    return (await find(session, id))!;
  }

  static Future<Branch> update(Session session, UuidValue id, int expectedVersion, BranchInput input) async {
    await Authorization.require(session, managePermission);
    final data = _validate(session, input);
    await _write(session, () async {
      await session.db.transaction((tx) async {
        final current = await find(session, id, transaction: tx);
        if (current == null) throw ApiErrors.notFound(session);
        if (current.version != expectedVersion) throw ApiErrors.versionMismatch(session, current.version);
        if (current.isDefault && !data.isDefault) {
          throw ApiErrors.businessRule(
            session,
            'DEFAULT_BRANCH_REQUIRED',
            'A empresa precisa de uma filial padrão: marque outra como padrão em vez de desmarcar esta.',
          );
        }
        if (data.isDefault && !current.isDefault) await _clearDefault(session, tx);
        final changed = await session.db.unsafeExecute(
          'UPDATE app.branches SET code = @code, legal_name = @legalName, trade_name = @tradeName, '
          '       document_number = @documentNumber, city = @city, state = @state, erp_branch_code = @erpBranchCode, '
          '       is_default = @isDefault, is_active = @isActive '
          ' WHERE id = @id::uuid AND version = @version',
          parameters: QueryParameters.named({'id': id.uuid, 'version': expectedVersion, ...data.params}),
          transaction: tx,
        );
        if (changed == 0) throw ApiErrors.versionMismatch(session, (await find(session, id, transaction: tx))!.version);
      });
    });
    return (await find(session, id))!;
  }

  // ------------------------------------------------------------------ internos

  static Future<void> _clearDefault(Session session, Transaction tx) => session.db.unsafeExecute(
    'UPDATE app.branches SET is_default = false WHERE is_default',
    transaction: tx,
  );

  static Future<void> _write(Session session, Future<void> Function() body) async {
    try {
      await body();
    } on DatabaseQueryException catch (e) {
      if (isUniqueViolation(e, 'branches_tenant_id_code_key')) {
        throw ApiErrors.fieldError(session, 'code', 'DUPLICATE', 'Já existe uma filial com este código.');
      }
      if (isUniqueViolation(e, 'branches_document_key')) {
        throw ApiErrors.fieldError(session, 'documentNumber', 'DUPLICATE', 'Já existe uma filial com este CNPJ.');
      }
      if (isUniqueViolation(e, 'branches_erp_code_key')) {
        throw ApiErrors.fieldError(
          session,
          'erpBranchCode',
          'DUPLICATE',
          'Já existe uma filial com este código do ERP.',
        );
      }
      if (e.code == '23514') {
        throw ApiErrors.fieldError(session, 'isActive', 'INVALID', 'A filial padrão precisa estar ativa.');
      }
      rethrow;
    }
  }

  static ({bool isDefault, Map<String, Object?> params}) _validate(Session session, BranchInput input) {
    final code = cleanText(input.code);
    final legalName = cleanText(input.legalName);
    final document = input.documentNumber?.replaceAll(RegExp(r'\D'), '');
    final state = cleanText(input.state)?.toUpperCase();
    final errors = [
      if (code == null || code.length > 20)
        FieldError(path: 'code', code: 'REQUIRED', message: 'Informe o código (até 20).'),
      if (legalName == null || legalName.length > 200)
        FieldError(path: 'legalName', code: 'REQUIRED', message: 'Informe a razão social.'),
      if (document != null && document.isNotEmpty && document.length != 14)
        FieldError(path: 'documentNumber', code: 'INVALID', message: 'O CNPJ tem 14 dígitos.'),
      if (state != null && !RegExp(r'^[A-Z]{2}$').hasMatch(state))
        FieldError(path: 'state', code: 'INVALID', message: 'Use a sigla da UF (ex.: RS).'),
      if (input.isDefault && !input.isActive)
        FieldError(path: 'isActive', code: 'INVALID', message: 'A filial padrão precisa estar ativa.'),
    ];
    if (errors.isNotEmpty) throw ApiErrors.validation(session, errors);
    return (
      isDefault: input.isDefault,
      params: {
        'code': code,
        'legalName': legalName,
        'tradeName': cleanText(input.tradeName),
        'documentNumber': (document == null || document.isEmpty) ? null : document,
        'city': cleanText(input.city),
        'state': state,
        'erpBranchCode': cleanText(input.erpBranchCode),
        'isDefault': input.isDefault,
        'isActive': input.isActive,
      },
    );
  }

  static Branch _map(List<Object?> r) => Branch(
    id: sqlUuid(r[0]),
    code: r[1] as String,
    legalName: r[2] as String,
    tradeName: r[3] as String?,
    documentNumber: r[4] as String?,
    city: r[5] as String?,
    state: r[6] as String?,
    erpBranchCode: r[7] as String?,
    isDefault: r[8] as bool,
    isActive: r[9] as bool,
    version: r[10] as int,
  );
}
