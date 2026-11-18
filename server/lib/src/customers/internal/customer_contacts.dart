import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../identity_access/identity_access.dart';
import '../../platform/db/sql_values.dart';
import '../../platform/errors/api_errors.dart';
import 'customers.dart';

/// Contatos dos clientes (app.customer_contacts): quem abre chamados e
/// recebe avisos. Leitura e escrita com as mesmas permissões de clientes.
/// Aprovação de contatos vindos do QR, bloqueio e consentimento de WhatsApp
/// ficam para o app do cliente e as notificações.
abstract final class CustomerContacts {
  static const _roles = {'customer_contact', 'customer_admin'};
  static const _channels = {'whatsapp', 'sms', 'email'};

  static const _columns =
      'cc.id, cc.customer_id, cc.customer_site_id, s.name, cc.name, cc.email, cc.phone_e164, cc.job_title, '
      'cc.contact_role, cc.status, cc.can_open_requests, cc.preferred_channel, cc.is_active, cc.source, cc.version';
  static const _from =
      'app.customer_contacts cc '
      'LEFT JOIN app.customer_sites s ON s.tenant_id = cc.tenant_id AND s.id = cc.customer_site_id';

  static Future<List<CustomerContact>> list(Session session, UuidValue customerId) async {
    await Customers.get(session, customerId); // permissão e existência
    final rows = await session.db.unsafeQuery(
      'SELECT $_columns FROM $_from WHERE cc.customer_id = @customerId::uuid '
      ' ORDER BY NOT cc.is_active, lower(cc.name), cc.id',
      parameters: QueryParameters.named({'customerId': customerId.uuid}),
    );
    return [for (final r in rows) _map(r)];
  }

  static Future<CustomerContact> create(Session session, UuidValue customerId, CustomerContactInput input) async {
    await Authorization.require(session, Customers.managePermission);
    if (await Customers.find(session, customerId) == null) throw ApiErrors.notFound(session);
    final params = await _validate(session, customerId, input);
    final id = const Uuid().v7obj();
    await session.db.unsafeExecute(
      'INSERT INTO app.customer_contacts (id, tenant_id, customer_id, customer_site_id, name, email, phone_e164, '
      '                                   job_title, contact_role, can_open_requests, preferred_channel, is_active) '
      'VALUES (@id::uuid, app.current_tenant_id(), @customerId::uuid, @siteId::uuid, @name, @email, @phone, '
      '        @jobTitle, @role, @canOpen, @channel, @isActive)',
      parameters: QueryParameters.named({'id': id.uuid, 'customerId': customerId.uuid, ...params}),
    );
    return (await _find(session, id))!;
  }

  static Future<CustomerContact> update(
    Session session,
    UuidValue id,
    int expectedVersion,
    CustomerContactInput input,
  ) async {
    await Authorization.require(session, Customers.managePermission);
    final current = await _find(session, id);
    if (current == null) throw ApiErrors.notFound(session);
    final params = await _validate(session, current.customerId, input);
    if (current.version != expectedVersion) throw ApiErrors.versionMismatch(session, current.version);
    final int changed;
    try {
      changed = await session.db.unsafeExecute(
        'UPDATE app.customer_contacts SET customer_site_id = @siteId::uuid, name = @name, email = @email, '
        '       phone_e164 = @phone, job_title = @jobTitle, contact_role = @role, can_open_requests = @canOpen, '
        '       preferred_channel = @channel, is_active = @isActive '
        ' WHERE id = @id::uuid AND version = @version',
        parameters: QueryParameters.named({'id': id.uuid, 'version': expectedVersion, ...params}),
      );
    } on DatabaseQueryException catch (e) {
      if (isErpMasterGuard(e)) {
        throw ApiErrors.businessRule(
          session,
          'ERP_MASTER_READ_ONLY',
          'Este contato vem do ERP: nome, e-mail e telefone só mudam lá.',
        );
      }
      rethrow;
    }
    if (changed == 0) throw ApiErrors.versionMismatch(session, (await _find(session, id))!.version);
    return (await _find(session, id))!;
  }

  /// Normaliza o telefone para E.164. Números brasileiros sem DDI (10 ou 11
  /// dígitos) ganham +55. `null` = vazio; lança [FormatException] se inválido.
  static String? normalizePhone(String? raw) {
    final text = cleanText(raw);
    if (text == null) return null;
    final digits = text.replaceAll(RegExp(r'\D'), '');
    final e164 = text.startsWith('+')
        ? '+$digits'
        : (digits.length == 10 || digits.length == 11)
        ? '+55$digits'
        : '+$digits';
    if (!RegExp(r'^\+[1-9][0-9]{7,14}$').hasMatch(e164)) throw const FormatException();
    return e164;
  }

  // ------------------------------------------------------------------ internos

  static Future<CustomerContact?> _find(Session session, UuidValue id) async {
    final rows = await session.db.unsafeQuery(
      'SELECT $_columns FROM $_from WHERE cc.id = @id::uuid',
      parameters: QueryParameters.named({'id': id.uuid}),
    );
    return rows.isEmpty ? null : _map(rows.first);
  }

  static Future<Map<String, Object?>> _validate(
    Session session,
    UuidValue customerId,
    CustomerContactInput input,
  ) async {
    final name = cleanText(input.name);
    final email = cleanText(input.email)?.toLowerCase();
    final channel = cleanText(input.preferredChannel);
    String? phone;
    var phoneInvalid = false;
    try {
      phone = normalizePhone(input.phone);
    } on FormatException {
      phoneInvalid = true;
    }
    final siteId = input.customerSiteId;
    final site = siteId == null ? null : await Customers.findSite(session, siteId);
    final errors = [
      if (name == null || name.length > 200) FieldError(path: 'name', code: 'REQUIRED', message: 'Informe o nome.'),
      if (email != null && !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email))
        FieldError(path: 'email', code: 'INVALID', message: 'E-mail inválido.'),
      if (phoneInvalid)
        FieldError(path: 'phone', code: 'INVALID', message: 'Telefone inválido. Use DDD e número, ex.: 51 99999-8888.'),
      if (email == null && phone == null && !phoneInvalid)
        FieldError(path: 'phone', code: 'REQUIRED', message: 'Informe telefone ou e-mail.'),
      if (!_roles.contains(input.contactRole))
        FieldError(path: 'contactRole', code: 'INVALID', message: 'Papel do contato inválido.'),
      if (channel != null && !_channels.contains(channel))
        FieldError(path: 'preferredChannel', code: 'INVALID', message: 'Canal inválido.'),
      if ((channel == 'whatsapp' || channel == 'sms') && phone == null && !phoneInvalid)
        FieldError(path: 'preferredChannel', code: 'NEEDS_PHONE', message: 'Esse canal precisa de telefone.'),
      if (channel == 'email' && email == null)
        FieldError(path: 'preferredChannel', code: 'NEEDS_EMAIL', message: 'Esse canal precisa de e-mail.'),
      if (siteId != null && (site == null || site.customerId != customerId))
        FieldError(path: 'customerSiteId', code: 'NOT_FOUND', message: 'Unidade não encontrada neste cliente.'),
    ];
    if (errors.isNotEmpty) throw ApiErrors.validation(session, errors);
    return {
      'siteId': siteId?.uuid,
      'name': name,
      'email': email,
      'phone': phone,
      'jobTitle': cleanText(input.jobTitle),
      'role': input.contactRole,
      'canOpen': input.canOpenRequests,
      'channel': channel,
      'isActive': input.isActive,
    };
  }

  static CustomerContact _map(List<Object?> r) => CustomerContact(
    id: sqlUuid(r[0]),
    customerId: sqlUuid(r[1]),
    customerSiteId: r[2] == null ? null : sqlUuid(r[2]),
    customerSiteName: r[3] as String?,
    name: r[4] as String,
    email: r[5] as String?,
    phone: r[6] as String?,
    jobTitle: r[7] as String?,
    contactRole: r[8] as String,
    status: r[9] as String,
    canOpenRequests: r[10] as bool,
    preferredChannel: r[11] as String?,
    isActive: r[12] as bool,
    source: r[13] as String,
    version: r[14] as int,
  );
}
