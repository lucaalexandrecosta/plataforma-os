import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../identity_access/identity_access.dart';
import '../../platform/db/sql_values.dart';
import '../../platform/errors/api_errors.dart';
import 'branches.dart';

/// Centros de custo do tenant. Leitura para qualquer pessoa com acesso;
/// alteração com `settings.manage`.
abstract final class CostCenters {
  static const _columns = 'id, code, name, branch_id, erp_code, is_active, version';

  static Future<List<CostCenter>> list(Session session, {UuidValue? branchId, bool includeInactive = false}) async {
    await Authorization.requireMember(session);
    // Com filial: os da filial e os que valem para todas.
    final rows = await session.db.unsafeQuery(
      'SELECT $_columns FROM app.cost_centers '
      ' WHERE (@all OR is_active) AND (@branchId::uuid IS NULL OR branch_id IS NULL OR branch_id = @branchId::uuid) '
      ' ORDER BY code',
      parameters: QueryParameters.named({'all': includeInactive, 'branchId': branchId?.uuid}),
    );
    return [for (final r in rows) _map(r)];
  }

  static Future<CostCenter?> find(Session session, UuidValue id, {Transaction? transaction}) async {
    final rows = await session.db.unsafeQuery(
      'SELECT $_columns FROM app.cost_centers WHERE id = @id::uuid',
      parameters: QueryParameters.named({'id': id.uuid}),
      transaction: transaction,
    );
    return rows.isEmpty ? null : _map(rows.first);
  }

  static Future<CostCenter> create(Session session, CostCenterInput input) async {
    await Authorization.require(session, Branches.managePermission);
    final params = await _validate(session, input);
    final id = const Uuid().v7obj();
    await _write(
      session,
      () => session.db.unsafeExecute(
        'INSERT INTO app.cost_centers (id, tenant_id, code, name, branch_id, erp_code, is_active) '
        'VALUES (@id::uuid, app.current_tenant_id(), @code, @name, @branchId::uuid, @erpCode, @isActive)',
        parameters: QueryParameters.named({'id': id.uuid, ...params}),
      ),
    );
    return (await find(session, id))!;
  }

  static Future<CostCenter> update(Session session, UuidValue id, int expectedVersion, CostCenterInput input) async {
    await Authorization.require(session, Branches.managePermission);
    final params = await _validate(session, input);
    final current = await find(session, id);
    if (current == null) throw ApiErrors.notFound(session);
    if (current.version != expectedVersion) throw ApiErrors.versionMismatch(session, current.version);
    final changed = await _write(
      session,
      () => session.db.unsafeExecute(
        'UPDATE app.cost_centers SET code = @code, name = @name, branch_id = @branchId::uuid, erp_code = @erpCode, '
        '       is_active = @isActive '
        ' WHERE id = @id::uuid AND version = @version',
        parameters: QueryParameters.named({'id': id.uuid, 'version': expectedVersion, ...params}),
      ),
    );
    if (changed == 0) throw ApiErrors.versionMismatch(session, (await find(session, id))!.version);
    return (await find(session, id))!;
  }

  static Future<int> _write(Session session, Future<int> Function() body) async {
    try {
      return await body();
    } on DatabaseQueryException catch (e) {
      if (isUniqueViolation(e, 'cost_centers_tenant_id_code_key')) {
        throw ApiErrors.fieldError(session, 'code', 'DUPLICATE', 'Já existe um centro de custo com este código.');
      }
      if (isUniqueViolation(e, 'cost_centers_erp_code_key')) {
        throw ApiErrors.fieldError(
          session,
          'erpCode',
          'DUPLICATE',
          'Já existe um centro de custo com este código do ERP.',
        );
      }
      rethrow;
    }
  }

  static Future<Map<String, Object?>> _validate(Session session, CostCenterInput input) async {
    final code = cleanText(input.code);
    final name = cleanText(input.name);
    final errors = [
      if (code == null || code.length > 30)
        FieldError(path: 'code', code: 'REQUIRED', message: 'Informe o código (até 30).'),
      if (name == null || name.length > 120) FieldError(path: 'name', code: 'REQUIRED', message: 'Informe o nome.'),
      if (input.branchId != null && await Branches.find(session, input.branchId!) == null)
        FieldError(path: 'branchId', code: 'NOT_FOUND', message: 'Filial não encontrada.'),
    ];
    if (errors.isNotEmpty) throw ApiErrors.validation(session, errors);
    return {
      'code': code,
      'name': name,
      'branchId': input.branchId?.uuid,
      'erpCode': cleanText(input.erpCode),
      'isActive': input.isActive,
    };
  }

  static CostCenter _map(List<Object?> r) => CostCenter(
    id: sqlUuid(r[0]),
    code: r[1] as String,
    name: r[2] as String,
    branchId: sqlUuidOrNull(r[3]),
    erpCode: r[4] as String?,
    isActive: r[5] as bool,
    version: r[6] as int,
  );
}
