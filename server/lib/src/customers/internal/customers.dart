import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../identity_access/identity_access.dart';
import '../../platform/db/sql_values.dart';
import '../../platform/errors/api_errors.dart';

/// Clientes e unidades do tenant (onde ficam os bens em comodato e para quem
/// se abre OS). Leitura para quem trabalha com OS ou bens; alteração com
/// `customers.manage`. Contatos em customer_contacts.dart; importação por
/// planilha vem depois.
abstract final class Customers {
  static const managePermission = 'customers.manage';
  static const _readPermissions = {managePermission, 'work_orders.read', 'assets.manage', 'visits.schedule'};

  static const _personTypes = {'company', 'individual'};

  static const _columns =
      'c.id, c.code, c.name, c.trade_name, c.person_type, c.document_type, c.document_number, c.state_registration, '
      'c.email, c.phone, c.notes, c.is_active, c.source, '
      '(SELECT count(*) FROM app.customer_sites s WHERE s.tenant_id = c.tenant_id AND s.customer_id = c.id '
      '   AND s.is_active)::int, c.version';

  static const _siteColumns =
      'id, customer_id, code, name, street, street_number, complement, district, city, state, postal_code, '
      'latitude, longitude, phone, access_notes, is_active, source, version';

  // ------------------------------------------------------------------ clientes

  static Future<CustomerPage> list(
    Session session, {
    String? search,
    bool includeInactive = false,
    int limit = 50,
    int offset = 0,
  }) async {
    await Authorization.requireAny(session, _readPermissions);
    final term = cleanText(search);
    final digits = term?.replaceAll(RegExp(r'\D'), '');
    const where =
        ' WHERE (@all OR c.is_active) '
        "   AND (@term::text IS NULL OR c.name ILIKE '%' || @term || '%' OR c.trade_name ILIKE '%' || @term || '%' "
        "        OR c.code ILIKE '%' || @term || '%' "
        "        OR (@digits::text <> '' AND c.document_number LIKE @digits || '%')) ";
    final params = {'all': includeInactive, 'term': term, 'digits': digits ?? ''};
    final total = await session.db.unsafeQuery(
      'SELECT count(*)::int FROM app.customers c $where',
      parameters: QueryParameters.named(params),
    );
    final rows = await session.db.unsafeQuery(
      'SELECT $_columns FROM app.customers c $where '
      ' ORDER BY lower(coalesce(c.trade_name, c.name)), c.id LIMIT @limit OFFSET @offset',
      parameters: QueryParameters.named({
        ...params,
        'limit': limit.clamp(1, 200),
        'offset': offset < 0 ? 0 : offset,
      }),
    );
    return CustomerPage(items: [for (final r in rows) _map(r)], total: total.first[0] as int);
  }

  static Future<Customer> get(Session session, UuidValue id) async {
    await Authorization.requireAny(session, _readPermissions);
    return await _find(session, id) ?? (throw ApiErrors.notFound(session));
  }

  static Future<Customer> create(Session session, CustomerInput input) async {
    await Authorization.require(session, managePermission);
    final params = _validate(session, input);
    final id = const Uuid().v7obj();
    await _write(
      session,
      () => session.db.unsafeExecute(
        'INSERT INTO app.customers (id, tenant_id, code, name, trade_name, person_type, document_type, '
        '                           document_number, state_registration, email, phone, notes, is_active, '
        '                           deactivated_at) '
        'VALUES (@id::uuid, app.current_tenant_id(), @code, @name, @tradeName, @personType, @documentType, '
        '        @documentNumber, @stateRegistration, @email, @phone, @notes, @isActive, '
        '        CASE WHEN @isActive THEN NULL ELSE now() END)',
        parameters: QueryParameters.named({'id': id.uuid, ...params}),
      ),
    );
    return (await _find(session, id))!;
  }

  static Future<Customer> update(Session session, UuidValue id, int expectedVersion, CustomerInput input) async {
    await Authorization.require(session, managePermission);
    final params = _validate(session, input);
    final current = await _find(session, id);
    if (current == null) throw ApiErrors.notFound(session);
    if (current.version != expectedVersion) throw ApiErrors.versionMismatch(session, current.version);
    final changed = await _write(
      session,
      () => session.db.unsafeExecute(
        'UPDATE app.customers SET code = @code, name = @name, trade_name = @tradeName, person_type = @personType, '
        '       document_type = @documentType, document_number = @documentNumber, '
        '       state_registration = @stateRegistration, email = @email, phone = @phone, notes = @notes, '
        '       is_active = @isActive, '
        '       deactivated_at = CASE WHEN @isActive THEN NULL ELSE coalesce(deactivated_at, now()) END '
        ' WHERE id = @id::uuid AND version = @version',
        parameters: QueryParameters.named({'id': id.uuid, 'version': expectedVersion, ...params}),
      ),
    );
    if (changed == 0) throw ApiErrors.versionMismatch(session, (await _find(session, id))!.version);
    return (await _find(session, id))!;
  }

  /// Cliente do tenant ativo, sem checar permissão (para outros módulos que
  /// já conferiram a deles). `null` = inexistente ou de outro tenant.
  static Future<Customer?> find(Session session, UuidValue id) => _find(session, id);

  // ------------------------------------------------------------------ unidades

  static Future<List<CustomerSite>> sites(Session session, UuidValue customerId) async {
    await Authorization.requireAny(session, _readPermissions);
    if (await _find(session, customerId) == null) throw ApiErrors.notFound(session);
    final rows = await session.db.unsafeQuery(
      'SELECT $_siteColumns FROM app.customer_sites WHERE customer_id = @customerId::uuid '
      ' ORDER BY NOT is_active, lower(name), id',
      parameters: QueryParameters.named({'customerId': customerId.uuid}),
    );
    return [for (final r in rows) _mapSite(r)];
  }

  /// Unidade do tenant ativo, sem checar permissão. `null` = inexistente.
  static Future<CustomerSite?> findSite(Session session, UuidValue id) async {
    final rows = await session.db.unsafeQuery(
      'SELECT $_siteColumns FROM app.customer_sites WHERE id = @id::uuid',
      parameters: QueryParameters.named({'id': id.uuid}),
    );
    return rows.isEmpty ? null : _mapSite(rows.first);
  }

  static Future<CustomerSite> createSite(Session session, UuidValue customerId, CustomerSiteInput input) async {
    await Authorization.require(session, managePermission);
    if (await _find(session, customerId) == null) throw ApiErrors.notFound(session);
    final params = _validateSite(session, input);
    final id = const Uuid().v7obj();
    await _write(
      session,
      () => session.db.unsafeExecute(
        'INSERT INTO app.customer_sites (id, tenant_id, customer_id, code, name, street, street_number, complement, '
        '                                district, city, state, postal_code, latitude, longitude, phone, '
        '                                access_notes, is_active) '
        'VALUES (@id::uuid, app.current_tenant_id(), @customerId::uuid, @code, @name, @street, @streetNumber, '
        '        @complement, @district, @city, @state, @postalCode, @latitude, @longitude, @phone, @accessNotes, '
        '        @isActive)',
        parameters: QueryParameters.named({'id': id.uuid, 'customerId': customerId.uuid, ...params}),
      ),
    );
    return (await findSite(session, id))!;
  }

  static Future<CustomerSite> updateSite(
    Session session,
    UuidValue id,
    int expectedVersion,
    CustomerSiteInput input,
  ) async {
    await Authorization.require(session, managePermission);
    final params = _validateSite(session, input);
    final current = await findSite(session, id);
    if (current == null) throw ApiErrors.notFound(session);
    if (current.version != expectedVersion) throw ApiErrors.versionMismatch(session, current.version);
    final changed = await _write(
      session,
      () => session.db.unsafeExecute(
        'UPDATE app.customer_sites SET code = @code, name = @name, street = @street, street_number = @streetNumber, '
        '       complement = @complement, district = @district, city = @city, state = @state, '
        '       postal_code = @postalCode, latitude = @latitude, longitude = @longitude, phone = @phone, '
        '       access_notes = @accessNotes, is_active = @isActive '
        ' WHERE id = @id::uuid AND version = @version',
        parameters: QueryParameters.named({'id': id.uuid, 'version': expectedVersion, ...params}),
      ),
    );
    if (changed == 0) throw ApiErrors.versionMismatch(session, (await findSite(session, id))!.version);
    return (await findSite(session, id))!;
  }

  // ------------------------------------------------------------------ internos

  static Future<Customer?> _find(Session session, UuidValue id) async {
    final rows = await session.db.unsafeQuery(
      'SELECT $_columns FROM app.customers c WHERE c.id = @id::uuid',
      parameters: QueryParameters.named({'id': id.uuid}),
    );
    return rows.isEmpty ? null : _map(rows.first);
  }

  static Future<int> _write(Session session, Future<int> Function() body) async {
    try {
      return await body();
    } on DatabaseQueryException catch (e) {
      if (isUniqueViolation(e, 'customers_code_key')) {
        throw ApiErrors.fieldError(session, 'code', 'DUPLICATE', 'Já existe um cliente com este código.');
      }
      if (isErpMasterGuard(e)) {
        throw ApiErrors.businessRule(
          session,
          'ERP_MASTER_READ_ONLY',
          'Este cadastro vem do ERP: nome, documento e endereço só mudam lá.',
        );
      }
      rethrow;
    }
  }

  static Map<String, Object?> _validate(Session session, CustomerInput input) {
    final name = cleanText(input.name);
    final code = cleanText(input.code);
    final email = cleanText(input.email)?.toLowerCase();
    final document = input.documentNumber?.replaceAll(RegExp(r'\D'), '');
    final hasDocument = document != null && document.isNotEmpty;
    final personType = input.personType;
    final expected = personType == 'individual' ? 11 : 14;
    final errors = [
      if (name == null || name.length > 200) FieldError(path: 'name', code: 'REQUIRED', message: 'Informe o nome.'),
      if (code != null && code.length > 40)
        FieldError(path: 'code', code: 'INVALID', message: 'O código tem até 40 caracteres.'),
      if (!_personTypes.contains(personType))
        FieldError(path: 'personType', code: 'INVALID', message: 'Escolha empresa ou pessoa física.'),
      if (hasDocument && document.length != expected)
        FieldError(
          path: 'documentNumber',
          code: 'INVALID',
          message: personType == 'individual' ? 'O CPF tem 11 dígitos.' : 'O CNPJ tem 14 dígitos.',
        ),
      if (email != null && !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email))
        FieldError(path: 'email', code: 'INVALID', message: 'E-mail inválido.'),
    ];
    if (errors.isNotEmpty) throw ApiErrors.validation(session, errors);
    return {
      'code': code,
      'name': name,
      'tradeName': cleanText(input.tradeName),
      'personType': personType,
      'documentType': !hasDocument ? 'none' : (personType == 'individual' ? 'cpf' : 'cnpj'),
      'documentNumber': hasDocument ? document : null,
      'stateRegistration': cleanText(input.stateRegistration),
      'email': email,
      'phone': cleanText(input.phone),
      'notes': cleanText(input.notes),
      'isActive': input.isActive,
    };
  }

  static Map<String, Object?> _validateSite(Session session, CustomerSiteInput input) {
    final name = cleanText(input.name);
    final state = cleanText(input.state)?.toUpperCase();
    final postal = input.postalCode?.replaceAll(RegExp(r'\D'), '');
    final lat = input.latitude;
    final lng = input.longitude;
    final errors = [
      if (name == null || name.length > 200) FieldError(path: 'name', code: 'REQUIRED', message: 'Informe o nome.'),
      if (state != null && !RegExp(r'^[A-Z]{2}$').hasMatch(state))
        FieldError(path: 'state', code: 'INVALID', message: 'Use a sigla da UF (ex.: RS).'),
      if (postal != null && postal.isNotEmpty && postal.length != 8)
        FieldError(path: 'postalCode', code: 'INVALID', message: 'O CEP tem 8 dígitos.'),
      if ((lat == null) != (lng == null))
        FieldError(path: 'latitude', code: 'INVALID', message: 'Informe latitude e longitude juntas.'),
      if (lat != null && (lat < -90 || lat > 90))
        FieldError(path: 'latitude', code: 'INVALID', message: 'Latitude entre -90 e 90.'),
      if (lng != null && (lng < -180 || lng > 180))
        FieldError(path: 'longitude', code: 'INVALID', message: 'Longitude entre -180 e 180.'),
    ];
    if (errors.isNotEmpty) throw ApiErrors.validation(session, errors);
    return {
      'code': cleanText(input.code),
      'name': name,
      'street': cleanText(input.street),
      'streetNumber': cleanText(input.streetNumber),
      'complement': cleanText(input.complement),
      'district': cleanText(input.district),
      'city': cleanText(input.city),
      'state': state,
      'postalCode': (postal == null || postal.isEmpty) ? null : postal,
      'latitude': lat,
      'longitude': lng,
      'phone': cleanText(input.phone),
      'accessNotes': cleanText(input.accessNotes),
      'isActive': input.isActive,
    };
  }

  static Customer _map(List<Object?> r) => Customer(
    id: sqlUuid(r[0]),
    code: r[1] as String?,
    name: r[2] as String,
    tradeName: r[3] as String?,
    personType: r[4] as String,
    documentType: r[5] as String,
    documentNumber: r[6] as String?,
    stateRegistration: r[7] as String?,
    email: r[8] as String?,
    phone: r[9] as String?,
    notes: r[10] as String?,
    isActive: r[11] as bool,
    source: r[12] as String,
    siteCount: r[13] as int,
    version: r[14] as int,
  );

  static CustomerSite _mapSite(List<Object?> r) => CustomerSite(
    id: sqlUuid(r[0]),
    customerId: sqlUuid(r[1]),
    code: r[2] as String?,
    name: r[3] as String,
    street: r[4] as String?,
    streetNumber: r[5] as String?,
    complement: r[6] as String?,
    district: r[7] as String?,
    city: r[8] as String?,
    state: r[9] as String?,
    postalCode: r[10] as String?,
    latitude: r[11] as double?,
    longitude: r[12] as double?,
    phone: r[13] as String?,
    accessNotes: r[14] as String?,
    isActive: r[15] as bool,
    source: r[16] as String,
    version: r[17] as int,
  );
}
