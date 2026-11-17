import 'package:serverpod/serverpod.dart';

import '../../customers/customers.dart';
import '../../generated/protocol.dart';
import '../../identity_access/identity_access.dart';
import '../../platform/db/sql_values.dart';
import '../../platform/errors/api_errors.dart';
import 'asset_registry.dart';

/// Movimentação do bem entre o estoque e as unidades dos clientes
/// (app.asset_assignments). Instalar abre a alocação e põe o bem como
/// instalado; transferir encerra a anterior na mesma transação; retirar
/// encerra e devolve ao estoque. O banco confere no COMMIT que o status e a
/// alocação vigente batem (trg_check_asset_state).
///
/// Aprovação de movimentação (tenant_settings.require_movement_approval) e o
/// termo assinado ficam para depois: com a exigência ligada, a API recusa.
abstract final class AssetMovements {
  static const _documentTypes = {'shipment_invoice', 'loan_contract', 'rental_contract', 'work_order', 'other'};
  static const _withdrawReasons = {'withdrawal', 'return_to_stock'};
  static const maxBackdate = Duration(days: 60);

  static Future<Asset> install(Session session, UuidValue assetId, int expectedVersion, AssetInstallInput input) async {
    await Authorization.require(session, AssetRegistry.managePermission);
    final docType = cleanText(input.sourceDocumentType);
    final errors = [
      if (docType != null && !_documentTypes.contains(docType))
        FieldError(path: 'sourceDocumentType', code: 'INVALID', message: 'Tipo de documento inválido.'),
      ..._dateErrors(input.startedAt, 'startedAt'),
    ];
    final site = await Customers.findSite(session, input.customerSiteId);
    if (site == null || !site.isActive) {
      errors.add(FieldError(path: 'customerSiteId', code: 'NOT_FOUND', message: 'Unidade não encontrada ou inativa.'));
    }
    if (errors.isNotEmpty) throw ApiErrors.validation(session, errors);
    final customer = await Customers.find(session, site!.customerId);
    if (customer == null || !customer.isActive) {
      throw ApiErrors.fieldError(session, 'customerSiteId', 'INACTIVE', 'O cliente desta unidade está inativo.');
    }
    final at = (input.startedAt ?? DateTime.now()).toUtc();

    await session.db.transaction((tx) async {
      final asset = await _lock(session, tx, assetId, expectedVersion);
      await _requireNoApproval(session, tx);
      final current = await _current(session, tx, assetId);
      if (current != null && current.siteId == site.id) {
        throw ApiErrors.businessRule(session, 'ALREADY_AT_SITE', 'O bem já está instalado nesta unidade.');
      }
      if (current != null && !at.isAfter(current.startedAt)) {
        throw ApiErrors.fieldError(
          session,
          'startedAt',
          'BEFORE_CURRENT',
          'A data precisa ser depois da instalação atual.',
        );
      }
      if (current != null) await _end(session, tx, current.id, at, 'transfer', null);
      await session.db.unsafeExecute(
        'INSERT INTO app.asset_assignments (tenant_id, asset_id, customer_id, customer_site_id, ownership_type, '
        '                                   started_at, start_reason, source_document_type, source_document_number, '
        '                                   notes) '
        'VALUES (app.current_tenant_id(), @assetId::uuid, @customerId::uuid, @siteId::uuid, @ownership, @at, '
        '        @reason, @docType, @docNumber, @notes)',
        parameters: QueryParameters.named({
          'assetId': assetId.uuid,
          'customerId': site.customerId.uuid,
          'siteId': site.id.uuid,
          'ownership': asset.ownership,
          'at': at,
          'reason': current == null ? 'installation' : 'transfer',
          'docType': docType,
          'docNumber': cleanText(input.sourceDocumentNumber),
          'notes': cleanText(input.notes),
        }),
        transaction: tx,
      );
      if (asset.status != 'installed') await _setStatus(session, tx, assetId, 'installed');
    });
    return (await AssetRegistry.find(session, assetId))!;
  }

  static Future<Asset> withdraw(
    Session session,
    UuidValue assetId,
    int expectedVersion,
    AssetWithdrawInput input,
  ) async {
    await Authorization.require(session, AssetRegistry.managePermission);
    final reason = input.reason;
    final errors = [
      if (!_withdrawReasons.contains(reason))
        FieldError(path: 'reason', code: 'INVALID', message: 'Escolha retirada ou devolução ao estoque.'),
      ..._dateErrors(input.endedAt, 'endedAt'),
    ];
    if (errors.isNotEmpty) throw ApiErrors.validation(session, errors);
    final at = (input.endedAt ?? DateTime.now()).toUtc();

    await session.db.transaction((tx) async {
      await _lock(session, tx, assetId, expectedVersion, allowRetired: true);
      final current = await _current(session, tx, assetId);
      if (current == null) {
        throw ApiErrors.businessRule(session, 'NOT_INSTALLED', 'O bem não está instalado em nenhum cliente.');
      }
      if (at.isBefore(current.startedAt)) {
        throw ApiErrors.fieldError(
          session,
          'endedAt',
          'BEFORE_CURRENT',
          'A data precisa ser depois da instalação.',
        );
      }
      await _end(session, tx, current.id, at, reason, cleanText(input.notes));
      await _setStatus(session, tx, assetId, 'in_stock');
    });
    return (await AssetRegistry.find(session, assetId))!;
  }

  static Future<List<AssetAssignment>> history(Session session, UuidValue assetId) async {
    await AssetRegistry.get(session, assetId); // permissão e existência
    final rows = await session.db.unsafeQuery(
      'SELECT aa.id, aa.customer_id, coalesce(c.trade_name, c.name), aa.customer_site_id, s.name, aa.ownership_type, '
      '       aa.started_at, aa.ended_at, aa.start_reason, aa.end_reason, aa.source_document_type, '
      '       aa.source_document_number, aa.notes '
      '  FROM app.asset_assignments aa '
      '  JOIN app.customers c ON c.tenant_id = aa.tenant_id AND c.id = aa.customer_id '
      '  JOIN app.customer_sites s ON s.tenant_id = aa.tenant_id AND s.id = aa.customer_site_id '
      " WHERE aa.asset_id = @assetId::uuid AND aa.approval_status IN ('not_required', 'approved') "
      ' ORDER BY aa.started_at DESC, aa.id DESC',
      parameters: QueryParameters.named({'assetId': assetId.uuid}),
    );
    return [
      for (final r in rows)
        AssetAssignment(
          id: sqlUuid(r[0]),
          customerId: sqlUuid(r[1]),
          customerName: r[2] as String,
          customerSiteId: sqlUuid(r[3]),
          customerSiteName: r[4] as String,
          ownershipType: r[5] as String,
          startedAt: r[6] as DateTime,
          endedAt: r[7] as DateTime?,
          startReason: r[8] as String,
          endReason: r[9] as String?,
          sourceDocumentType: r[10] as String?,
          sourceDocumentNumber: r[11] as String?,
          notes: r[12] as String?,
        ),
    ];
  }

  // ------------------------------------------------------------------ internos

  static List<FieldError> _dateErrors(DateTime? at, String path) {
    if (at == null) return const [];
    final now = DateTime.now().toUtc();
    return [
      if (at.toUtc().isAfter(now.add(const Duration(minutes: 5))))
        FieldError(path: path, code: 'FUTURE', message: 'A data não pode ser no futuro.'),
      if (at.toUtc().isBefore(now.subtract(maxBackdate)))
        FieldError(path: path, code: 'TOO_OLD', message: 'Registre movimentações de até 60 dias atrás.'),
    ];
  }

  static Future<({String status, String ownership})> _lock(
    Session session,
    Transaction tx,
    UuidValue assetId,
    int expectedVersion, {
    bool allowRetired = false,
  }) async {
    final rows = await session.db.unsafeQuery(
      'SELECT status, ownership_type, is_active, version FROM app.assets WHERE id = @id::uuid FOR UPDATE',
      parameters: QueryParameters.named({'id': assetId.uuid}),
      transaction: tx,
    );
    if (rows.isEmpty) throw ApiErrors.notFound(session);
    final r = rows.first;
    if (r[3] as int != expectedVersion) throw ApiErrors.versionMismatch(session, r[3] as int);
    if (!allowRetired && r[0] == 'retired') {
      throw ApiErrors.businessRule(session, 'ASSET_RETIRED', 'Bem baixado não pode ser instalado.');
    }
    if (!allowRetired && r[2] != true) {
      throw ApiErrors.businessRule(session, 'ASSET_INACTIVE', 'Bem inativo não pode ser instalado.');
    }
    return (status: r[0] as String, ownership: r[1] as String);
  }

  static Future<void> _requireNoApproval(Session session, Transaction tx) async {
    final rows = await session.db.unsafeQuery(
      'SELECT coalesce(bool_or(require_movement_approval), false) FROM app.tenant_settings',
      transaction: tx,
    );
    if (rows.first[0] == true) {
      throw ApiErrors.businessRule(
        session,
        'MOVEMENT_APPROVAL_UNSUPPORTED',
        'A empresa exige aprovação de movimentação, que ainda não está disponível. Desligue a exigência para seguir.',
      );
    }
  }

  static Future<({UuidValue id, UuidValue siteId, DateTime startedAt})?> _current(
    Session session,
    Transaction tx,
    UuidValue assetId,
  ) async {
    final rows = await session.db.unsafeQuery(
      'SELECT id, customer_site_id, started_at FROM app.asset_assignments '
      " WHERE asset_id = @assetId::uuid AND ended_at IS NULL AND approval_status IN ('not_required', 'approved') "
      ' FOR UPDATE',
      parameters: QueryParameters.named({'assetId': assetId.uuid}),
      transaction: tx,
    );
    if (rows.isEmpty) return null;
    final r = rows.first;
    return (id: sqlUuid(r[0]), siteId: sqlUuid(r[1]), startedAt: r[2] as DateTime);
  }

  static Future<void> _end(Session session, Transaction tx, UuidValue id, DateTime at, String reason, String? notes) =>
      session.db.unsafeExecute(
        'UPDATE app.asset_assignments SET ended_at = @at, end_reason = @reason, '
        "       notes = CASE WHEN @notes::text IS NULL THEN notes ELSE concat_ws(E'\\n', notes, @notes::text) END "
        ' WHERE id = @id::uuid',
        parameters: QueryParameters.named({'id': id.uuid, 'at': at, 'reason': reason, 'notes': notes}),
        transaction: tx,
      );

  static Future<void> _setStatus(Session session, Transaction tx, UuidValue assetId, String status) =>
      session.db.unsafeExecute(
        'UPDATE app.assets SET status = @status WHERE id = @id::uuid',
        parameters: QueryParameters.named({'id': assetId.uuid, 'status': status}),
        transaction: tx,
      );
}
