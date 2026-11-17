import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../identity_access/identity_access.dart';
import '../../platform/context/request_context.dart';
import '../../platform/db/sql_values.dart';
import '../../platform/errors/api_errors.dart';
import '../../tenancy/tenancy.dart';

/// Técnicos próprios da empresa. Leitura com `visits.schedule` ou
/// `work_orders.read`; alteração com `visits.schedule`. Prestadores
/// (técnicos terceirizados) ficam para depois.
abstract final class Technicians {
  static const managePermission = 'visits.schedule';
  static const _readPermissions = {'visits.schedule', 'work_orders.read'};
  static const _columns = 'id, code, name, email, phone_e164, user_id, branch_id, is_active, version';
  static final _e164 = RegExp(r'^\+[1-9][0-9]{7,14}$');

  static Future<List<Technician>> list(Session session, {bool includeInactive = false}) async {
    await Authorization.requireAny(session, _readPermissions);
    final rows = await session.db.unsafeQuery(
      "SELECT $_columns FROM app.technicians WHERE kind = 'employee' AND (@all OR is_active) ORDER BY name",
      parameters: QueryParameters.named({'all': includeInactive}),
    );
    return [for (final r in rows) _map(r)];
  }

  /// Técnico ligado à pessoa logada, se houver (app de campo).
  static Future<Technician?> mine(Session session) async {
    await Authorization.requireMember(session);
    final rows = await session.db.unsafeQuery(
      'SELECT $_columns FROM app.technicians WHERE user_id = app.current_user_id() AND is_active',
    );
    return rows.isEmpty ? null : _map(rows.first);
  }

  static Future<Technician?> find(Session session, UuidValue id, {Transaction? transaction}) async {
    final rows = await session.db.unsafeQuery(
      'SELECT $_columns FROM app.technicians WHERE id = @id::uuid',
      parameters: QueryParameters.named({'id': id.uuid}),
      transaction: transaction,
    );
    return rows.isEmpty ? null : _map(rows.first);
  }

  static Future<Technician> create(Session session, TechnicianInput input) async {
    await Authorization.require(session, managePermission);
    final params = await _validate(session, input);
    final id = const Uuid().v7obj();
    await _write(
      session,
      () => session.db.unsafeExecute(
        'INSERT INTO app.technicians (id, tenant_id, code, name, email, phone_e164, user_id, branch_id, is_active, '
        '                             deactivated_at) '
        'VALUES (@id::uuid, app.current_tenant_id(), @code, @name, @email, @phone, @userId::uuid, @branchId::uuid, '
        '        @isActive, CASE WHEN @isActive THEN NULL ELSE now() END)',
        parameters: QueryParameters.named({'id': id.uuid, ...params}),
      ),
    );
    return (await find(session, id))!;
  }

  static Future<Technician> update(Session session, UuidValue id, int expectedVersion, TechnicianInput input) async {
    await Authorization.require(session, managePermission);
    final params = await _validate(session, input);
    final current = await find(session, id);
    if (current == null) throw ApiErrors.notFound(session);
    if (current.version != expectedVersion) throw ApiErrors.versionMismatch(session, current.version);
    final changed = await _write(
      session,
      () => session.db.unsafeExecute(
        'UPDATE app.technicians SET code = @code, name = @name, email = @email, phone_e164 = @phone, '
        '       user_id = @userId::uuid, branch_id = @branchId::uuid, is_active = @isActive, '
        '       deactivated_at = CASE WHEN @isActive THEN NULL ELSE coalesce(deactivated_at, now()) END '
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
      if (isUniqueViolation(e, 'technicians_tenant_id_code_key')) {
        throw ApiErrors.fieldError(session, 'code', 'DUPLICATE', 'Já existe um técnico com este código.');
      }
      if (isUniqueViolation(e, 'technicians_user_key')) {
        throw ApiErrors.fieldError(session, 'userId', 'DUPLICATE', 'Esta pessoa já está ligada a outro técnico.');
      }
      rethrow;
    }
  }

  static Future<Map<String, Object?>> _validate(Session session, TechnicianInput input) async {
    final code = cleanText(input.code)?.toUpperCase();
    final name = cleanText(input.name);
    final phone = cleanText(input.phone)?.replaceAll(RegExp(r'[\s().-]'), '');
    final member = input.userId == null
        ? null
        : await Memberships.activeFor(session, userId: input.userId!, tenantId: session.context.tenantId!);
    final errors = [
      if (code == null) FieldError(path: 'code', code: 'REQUIRED', message: 'Informe o código.'),
      if (name == null) FieldError(path: 'name', code: 'REQUIRED', message: 'Informe o nome.'),
      if (phone != null && !_e164.hasMatch(phone))
        FieldError(path: 'phone', code: 'INVALID', message: 'Telefone no formato +55 51 99999-0000.'),
      if (input.userId != null && member == null)
        FieldError(path: 'userId', code: 'NOT_FOUND', message: 'Esta pessoa não tem acesso ativo à empresa.'),
      if (input.branchId != null && await Branches.find(session, input.branchId!) == null)
        FieldError(path: 'branchId', code: 'NOT_FOUND', message: 'Filial não encontrada.'),
    ];
    if (errors.isNotEmpty) throw ApiErrors.validation(session, errors);
    return {
      'code': code,
      'name': name,
      'email': cleanText(input.email)?.toLowerCase(),
      'phone': phone,
      'userId': input.userId?.uuid,
      'branchId': input.branchId?.uuid,
      'isActive': input.isActive,
    };
  }

  static Technician _map(List<Object?> r) => Technician(
    id: sqlUuid(r[0]),
    code: r[1] as String,
    name: r[2] as String,
    email: r[3] as String?,
    phone: r[4] as String?,
    userId: sqlUuidOrNull(r[5]),
    branchId: sqlUuidOrNull(r[6]),
    isActive: r[7] as bool,
    version: r[8] as int,
  );
}
