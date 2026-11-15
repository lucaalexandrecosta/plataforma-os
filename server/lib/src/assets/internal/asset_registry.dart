import 'package:plataforma_os_core/plataforma_os_core.dart';
import 'package:serverpod/serverpod.dart';

import '../../catalog/catalog.dart';
import '../../generated/protocol.dart';
import '../../identity_access/identity_access.dart';
import '../../platform/db/sql_values.dart';
import '../../platform/errors/api_errors.dart';
import '../../tenancy/tenancy.dart';

/// Cadastro de bens. Leitura com `assets.manage` ou `work_orders.read`;
/// alteração com `assets.manage`. Status e alocação em cliente mudam pelas
/// movimentações (próxima etapa), não por aqui.
abstract final class AssetRegistry {
  static const managePermission = 'assets.manage';
  static const _readPermissions = {'assets.manage', 'work_orders.read'};
  static const _ownershipTypes = {'tenant_loan', 'tenant_rental', 'customer_owned'};

  static const _select =
      'SELECT a.id, a.product_id, p.name, a.serial_number, a.asset_tag, a.status, a.ownership_type, a.branch_id, '
      '       a.cost_center_id, a.location_note, a.warranty_until, a.acquisition_date, a.acquisition_cost, '
      '       a.supplier_name, a.acquisition_document, a.notes, a.is_active, a.source, a.version, q.short_code '
      '  FROM app.assets a JOIN app.products p ON p.tenant_id = a.tenant_id AND p.id = a.product_id '
      "  LEFT JOIN app.qr_tags q ON q.tenant_id = a.tenant_id AND q.asset_id = a.id AND q.status = 'bound' ";

  static Future<AssetPage> list(
    Session session, {
    String? search,
    UuidValue? branchId,
    UuidValue? costCenterId,
    bool includeInactive = false,
    int limit = 50,
    int offset = 0,
  }) async {
    await Authorization.requireAny(session, _readPermissions);
    final term = cleanText(search);
    const where =
        ' WHERE (@all OR a.is_active) '
        '   AND (@branchId::uuid IS NULL OR a.branch_id = @branchId::uuid) '
        '   AND (@costCenterId::uuid IS NULL OR a.cost_center_id = @costCenterId::uuid) '
        "   AND (@term::text IS NULL OR a.asset_tag ILIKE '%' || @term || '%' OR a.serial_number ILIKE '%' || @term || '%' "
        "        OR p.name ILIKE '%' || @term || '%' OR q.short_code = upper(replace(@term, '-', ''))) ";
    final params = {
      'all': includeInactive,
      'branchId': branchId?.uuid,
      'costCenterId': costCenterId?.uuid,
      'term': term,
    };
    final rows = await session.db.unsafeQuery(
      '$_select$where ORDER BY a.asset_tag NULLS LAST, a.serial_number, a.id LIMIT @limit OFFSET @offset',
      parameters: QueryParameters.named({...params, 'limit': limit.clamp(1, 200), 'offset': offset < 0 ? 0 : offset}),
    );
    final total = await session.db.unsafeQuery(
      'SELECT count(*) FROM app.assets a JOIN app.products p ON p.tenant_id = a.tenant_id AND p.id = a.product_id '
      "LEFT JOIN app.qr_tags q ON q.tenant_id = a.tenant_id AND q.asset_id = a.id AND q.status = 'bound' $where",
      parameters: QueryParameters.named(params),
    );
    return AssetPage(items: [for (final r in rows) _map(r)], total: total.first[0] as int);
  }

  static Future<Asset> get(Session session, UuidValue id) async {
    await Authorization.requireAny(session, _readPermissions);
    return await _find(session, id) ?? (throw ApiErrors.notFound(session));
  }

  static Future<Asset> create(Session session, AssetInput input) async {
    await Authorization.require(session, managePermission);
    final params = await _validate(session, input);
    final id = const Uuid().v7obj();
    await _write(
      session,
      () => session.db.unsafeExecute(
        'INSERT INTO app.assets (id, tenant_id, product_id, serial_number, asset_tag, ownership_type, branch_id, '
        '                        cost_center_id, location_note, warranty_until, acquisition_date, acquisition_cost, '
        '                        supplier_name, acquisition_document, notes, is_active) '
        'VALUES (@id::uuid, app.current_tenant_id(), @productId::uuid, @serialNumber, @assetTag, @ownershipType, '
        '        @branchId::uuid, @costCenterId::uuid, @locationNote, @warrantyUntil::date, @acquisitionDate::date, '
        '        @acquisitionCost, @supplierName, @acquisitionDocument, @notes, @isActive)',
        parameters: QueryParameters.named({'id': id.uuid, ...params}),
      ),
    );
    return (await _find(session, id))!;
  }

  static Future<Asset> update(Session session, UuidValue id, int expectedVersion, AssetInput input) async {
    await Authorization.require(session, managePermission);
    final params = await _validate(session, input);
    final current = await _find(session, id);
    if (current == null) throw ApiErrors.notFound(session);
    if (current.version != expectedVersion) throw ApiErrors.versionMismatch(session, current.version);
    final changed = await _write(
      session,
      () => session.db.unsafeExecute(
        'UPDATE app.assets SET product_id = @productId::uuid, serial_number = @serialNumber, asset_tag = @assetTag, '
        '       ownership_type = @ownershipType, branch_id = @branchId::uuid, cost_center_id = @costCenterId::uuid, '
        '       location_note = @locationNote, warranty_until = @warrantyUntil::date, '
        '       acquisition_date = @acquisitionDate::date, acquisition_cost = @acquisitionCost, '
        '       supplier_name = @supplierName, acquisition_document = @acquisitionDocument, notes = @notes, '
        '       is_active = @isActive '
        ' WHERE id = @id::uuid AND version = @version',
        parameters: QueryParameters.named({'id': id.uuid, 'version': expectedVersion, ...params}),
      ),
    );
    if (changed == 0) throw ApiErrors.versionMismatch(session, (await _find(session, id))!.version);
    return (await _find(session, id))!;
  }

  /// Dados do bem que a OS herda na abertura (sem checar permissão: quem
  /// chama já conferiu a dele). `null` = inexistente ou de outro tenant.
  static Future<AssetForWorkOrder?> findForWorkOrder(Session session, UuidValue id) async {
    final rows = await session.db.unsafeQuery(
      'SELECT a.id, coalesce(a.asset_tag, a.serial_number), a.status, a.is_active, a.branch_id, a.cost_center_id, '
      '       a.current_customer_id, a.current_customer_site_id '
      '  FROM app.assets a WHERE a.id = @id::uuid',
      parameters: QueryParameters.named({'id': id.uuid}),
    );
    if (rows.isEmpty) return null;
    final r = rows.first;
    return AssetForWorkOrder(
      id: sqlUuid(r[0]),
      label: r[1] as String,
      status: r[2] as String,
      isActive: r[3] as bool,
      branchId: sqlUuidOrNull(r[4]),
      costCenterId: sqlUuidOrNull(r[5]),
      customerId: sqlUuidOrNull(r[6]),
      customerSiteId: sqlUuidOrNull(r[7]),
    );
  }

  // ------------------------------------------------------------------ internos

  static Future<Asset?> _find(Session session, UuidValue id) async {
    final rows = await session.db.unsafeQuery(
      '$_select WHERE a.id = @id::uuid',
      parameters: QueryParameters.named({'id': id.uuid}),
    );
    return rows.isEmpty ? null : _map(rows.first);
  }

  static Future<int> _write(Session session, Future<int> Function() body) async {
    try {
      return await body();
    } on DatabaseQueryException catch (e) {
      if (isUniqueViolation(e, 'assets_tag_key')) {
        throw ApiErrors.fieldError(session, 'assetTag', 'DUPLICATE', 'Já existe um bem com este número de patrimônio.');
      }
      if (isUniqueViolation(e, 'assets_serial_key')) {
        throw ApiErrors.fieldError(
          session,
          'serialNumber',
          'DUPLICATE',
          'Já existe um bem deste produto com este número de série.',
        );
      }
      if (isErpMasterGuard(e)) {
        throw ApiErrors.businessRule(
          session,
          'ERP_MASTER_READ_ONLY',
          'Este bem vem do ERP: produto, série, patrimônio, filial e aquisição só mudam lá.',
        );
      }
      rethrow;
    }
  }

  static Future<Map<String, Object?>> _validate(Session session, AssetInput input) async {
    final serial = cleanText(input.serialNumber);
    final tag = cleanText(input.assetTag);
    final ownership = cleanText(input.ownershipType) ?? 'tenant_loan';
    final branch = input.branchId == null ? null : await Branches.find(session, input.branchId!);
    final costCenter = input.costCenterId == null ? null : await CostCenters.find(session, input.costCenterId!);
    final errors = [
      if (await Products.find(session, input.productId) == null)
        FieldError(path: 'productId', code: 'NOT_FOUND', message: 'Produto não encontrado.'),
      if (serial == null && tag == null)
        FieldError(path: 'assetTag', code: 'REQUIRED', message: 'Informe o número de patrimônio ou o número de série.'),
      if (!_ownershipTypes.contains(ownership))
        FieldError(path: 'ownershipType', code: 'INVALID', message: 'Tipo de posse inválido.'),
      if (input.branchId != null && branch == null)
        FieldError(path: 'branchId', code: 'NOT_FOUND', message: 'Filial não encontrada.'),
      if (input.costCenterId != null && costCenter == null)
        FieldError(path: 'costCenterId', code: 'NOT_FOUND', message: 'Centro de custo não encontrado.'),
      if (costCenter != null &&
          costCenter.branchId != null &&
          input.branchId != null &&
          costCenter.branchId != input.branchId)
        FieldError(path: 'costCenterId', code: 'BRANCH_MISMATCH', message: 'Este centro de custo é de outra filial.'),
      if ((input.acquisitionCost ?? 0) < 0)
        FieldError(path: 'acquisitionCost', code: 'INVALID', message: 'O valor de aquisição não pode ser negativo.'),
    ];
    if (errors.isNotEmpty) throw ApiErrors.validation(session, errors);
    return {
      'productId': input.productId.uuid,
      'serialNumber': serial,
      'assetTag': tag,
      'ownershipType': ownership,
      'branchId': input.branchId?.uuid,
      'costCenterId': input.costCenterId?.uuid,
      'locationNote': cleanText(input.locationNote),
      'warrantyUntil': sqlDateParam(input.warrantyUntil),
      'acquisitionDate': sqlDateParam(input.acquisitionDate),
      'acquisitionCost': input.acquisitionCost,
      'supplierName': cleanText(input.supplierName),
      'acquisitionDocument': cleanText(input.acquisitionDocument),
      'notes': cleanText(input.notes),
      'isActive': input.isActive,
    };
  }

  static Asset _map(List<Object?> r) => Asset(
    id: sqlUuid(r[0]),
    productId: sqlUuid(r[1]),
    productName: r[2] as String,
    serialNumber: r[3] as String?,
    assetTag: r[4] as String?,
    status: r[5] as String,
    ownershipType: r[6] as String,
    branchId: sqlUuidOrNull(r[7]),
    costCenterId: sqlUuidOrNull(r[8]),
    locationNote: r[9] as String?,
    warrantyUntil: sqlDateOrNull(r[10]),
    acquisitionDate: sqlDateOrNull(r[11]),
    acquisitionCost: r[12] as int?,
    supplierName: r[13] as String?,
    acquisitionDocument: r[14] as String?,
    notes: r[15] as String?,
    isActive: r[16] as bool,
    source: r[17] as String,
    version: r[18] as int,
    qrShortCode: r[19] == null ? null : QrCodes.formatShortCode(r[19] as String),
  );
}

/// O que a abertura de OS precisa saber do bem.
final class AssetForWorkOrder {
  const AssetForWorkOrder({
    required this.id,
    required this.label,
    required this.status,
    required this.isActive,
    required this.branchId,
    required this.costCenterId,
    required this.customerId,
    required this.customerSiteId,
  });

  final UuidValue id;
  final String label;
  final String status;
  final bool isActive;
  final UuidValue? branchId;
  final UuidValue? costCenterId;

  /// Alocação vigente em cliente (comodato); nulos = bem interno.
  final UuidValue? customerId;
  final UuidValue? customerSiteId;
}
