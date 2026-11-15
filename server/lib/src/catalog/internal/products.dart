import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../identity_access/identity_access.dart';
import '../../platform/db/sql_values.dart';
import '../../platform/errors/api_errors.dart';

/// Catálogo de produtos, no mínimo que o cadastro de bens precisa: o modelo
/// do equipamento (o bem é a unidade física). Peças, serviços e famílias
/// entram com a OS.
abstract final class Products {
  static const _columns = 'id, code, name, is_active';

  static Future<List<ProductSummary>> list(Session session, {String? search}) async {
    await Authorization.requireAny(session, const {'catalog.manage', 'assets.manage', 'work_orders.read'});
    final term = cleanText(search);
    final rows = await session.db.unsafeQuery(
      'SELECT $_columns FROM app.products '
      " WHERE is_active AND product_kind = 'equipment' "
      "   AND (@term::text IS NULL OR code ILIKE '%' || @term || '%' OR name ILIKE '%' || @term || '%') "
      ' ORDER BY name LIMIT 200',
      parameters: QueryParameters.named({'term': term}),
    );
    return [for (final r in rows) _map(r)];
  }

  static Future<ProductSummary?> find(Session session, UuidValue id) async {
    final rows = await session.db.unsafeQuery(
      'SELECT $_columns FROM app.products WHERE id = @id::uuid',
      parameters: QueryParameters.named({'id': id.uuid}),
    );
    return rows.isEmpty ? null : _map(rows.first);
  }

  static Future<ProductSummary> create(Session session, ProductInput input) async {
    await Authorization.requireAny(session, const {'catalog.manage', 'assets.manage'});
    final code = cleanText(input.code);
    final name = cleanText(input.name);
    final errors = [
      if (code == null || code.length > 40)
        FieldError(path: 'code', code: 'REQUIRED', message: 'Informe o código (até 40).'),
      if (name == null || name.length > 200) FieldError(path: 'name', code: 'REQUIRED', message: 'Informe o nome.'),
    ];
    if (errors.isNotEmpty) throw ApiErrors.validation(session, errors);
    final id = const Uuid().v7obj();
    try {
      await session.db.unsafeExecute(
        'INSERT INTO app.products (id, tenant_id, code, name, description, product_kind, is_serialized, tracks_assets) '
        "VALUES (@id::uuid, app.current_tenant_id(), @code, @name, @description, 'equipment', true, true)",
        parameters: QueryParameters.named({
          'id': id.uuid,
          'code': code,
          'name': name,
          'description': cleanText(input.description),
        }),
      );
    } on DatabaseQueryException catch (e) {
      if (isUniqueViolation(e, 'products_tenant_id_code_key')) {
        throw ApiErrors.fieldError(session, 'code', 'DUPLICATE', 'Já existe um produto com este código.');
      }
      rethrow;
    }
    return (await find(session, id))!;
  }

  static ProductSummary _map(List<Object?> r) =>
      ProductSummary(id: sqlUuid(r[0]), code: r[1] as String, name: r[2] as String, isActive: r[3] as bool);
}
