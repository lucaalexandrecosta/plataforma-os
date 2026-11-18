import 'package:plataforma_os_backoffice/src/api/gateway.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:serverpod_client/serverpod_client.dart' show UuidValue;

/// Gateway em memória para os testes de widget.
class FakeGateway implements Gateway {
  FakeGateway({List<TenantSummary>? tenants, this.permissions = allPermissions}) : tenants = tenants ?? [frioSul];

  static const allPermissions = [
    'work_orders.read',
    'work_orders.create',
    'work_orders.update',
    'work_orders.triage',
    'work_orders.close',
    'work_orders.reopen',
    'assets.manage',
    'visits.schedule',
    'depreciation.read',
    'depreciation.manage',
    'depreciation.close',
    'users.manage',
    'qr_tags.manage',
    'qr_tags.unbind',
    'settings.manage',
    'catalog.manage',
    'customers.manage',
  ];

  static final frioSul = TenantSummary(
    id: UuidValue.fromString('00000000-0000-4000-8000-000000000001'),
    slug: 'frio-sul',
    displayName: 'Frio Sul',
    status: TenantStatus.active,
  );
  static final fornoNorte = TenantSummary(
    id: UuidValue.fromString('00000000-0000-4000-8000-000000000002'),
    slug: 'forno-norte',
    displayName: 'Forno Norte',
    status: TenantStatus.active,
  );

  final List<TenantSummary> tenants;
  final List<String> permissions;
  final calls = <String>[];
  final workOrderList = <WorkOrder>[];

  /// Próximo erro a lançar (uma vez) na chamada com esse nome.
  final failNext = <String, GatewayException>{};

  String? enteredSlug;

  void _maybeFail(String call) {
    calls.add(call);
    final error = failNext.remove(call);
    if (error != null) throw error;
  }

  static final corrective = WorkOrderType(
    id: UuidValue.fromString('00000000-0000-4000-8000-0000000000a1'),
    code: 'COR',
    name: 'Corretiva',
    category: 'corrective',
    defaultPriority: 'normal',
    requiresAsset: true,
    isActive: true,
    version: 1,
  );

  static final asset1 = Asset(
    id: UuidValue.fromString('00000000-0000-4000-8000-0000000000b1'),
    productId: UuidValue.fromString('00000000-0000-4000-8000-0000000000c1'),
    productName: 'Freezer horizontal',
    serialNumber: 'SN-1',
    assetTag: 'PAT-001',
    status: 'installed',
    ownershipType: 'tenant_loan',
    acquisitionCost: 123456,
    qrShortCode: 'ABCD-2345',
    isActive: true,
    source: 'local',
    version: 1,
  );

  static WorkOrder sample({String status = 'open', int n = 1, int version = 1}) => WorkOrder(
    id: UuidValue.fromString('00000000-0000-4000-8000-${n.toString().padLeft(12, '0')}'),
    number: '2026-${n.toString().padLeft(6, '0')}',
    workOrderTypeId: corrective.id,
    workOrderTypeName: 'Corretiva',
    status: status,
    priority: 'normal',
    origin: 'backoffice',
    entryMethod: 'asset_list',
    assetId: asset1.id,
    assetLabel: 'PAT-001',
    productName: 'Freezer horizontal',
    costCenterName: '1.01 · Produção',
    problemDescription: 'Não liga',
    reopenedCount: 0,
    createdAt: DateTime.utc(2026, 11, 16, 13),
    statusChangedAt: DateTime.utc(2026, 11, 16, 13),
    version: version,
  );

  WorkOrder _replace(WorkOrder wo, String status) {
    final updated = wo.copyWith(status: status, version: wo.version + 1);
    final i = workOrderList.indexWhere((w) => w.id == wo.id);
    if (i >= 0) workOrderList[i] = updated;
    return updated;
  }

  // login
  @override
  Future<void> login(String email, String password) async {
    _maybeFail('login');
    if (password != 'certa123') throw const GatewayException('E-mail ou senha incorretos.');
  }

  @override
  Future<UuidValue> startRegistration(String email) async {
    _maybeFail('startRegistration');
    return UuidValue.fromString('00000000-0000-4000-8000-0000000000f1');
  }

  @override
  Future<void> finishRegistration(UuidValue requestId, String code, String password) async =>
      _maybeFail('finishRegistration');

  @override
  Future<List<TenantSummary>> myTenants() async {
    _maybeFail('myTenants');
    return tenants;
  }

  @override
  Future<MeInfo> enterTenant(String slug) async {
    _maybeFail('enterTenant');
    enteredSlug = slug;
    return MeInfo(
      userId: UuidValue.fromString('00000000-0000-4000-8000-0000000000e1'),
      fullName: 'Ana Admin',
      email: 'ana@frio-sul.test',
      locale: 'pt-BR',
      tenant: tenants.singleWhere((t) => t.slug == slug),
      roles: const ['tenant_admin'],
      permissions: permissions,
    );
  }

  @override
  void signOut() => calls.add('signOut');

  // usuários
  static final roleList = [
    AssignableRole(code: 'dispatcher', name: 'Despacho', description: 'Agenda visitas'),
    AssignableRole(code: 'technician', name: 'Técnico'),
    AssignableRole(code: 'tenant_admin', name: 'Administrador'),
  ];

  final userList = <TenantUser>[
    TenantUser(
      membershipId: UuidValue.fromString('00000000-0000-4000-8000-0000000001e1'),
      userId: UuidValue.fromString('00000000-0000-4000-8000-0000000000e1'),
      fullName: 'Ana Admin',
      email: 'ana@frio-sul.test',
      status: MembershipStatus.active,
      roles: const ['tenant_admin'],
      hasLogin: true,
      lastAccessAt: DateTime(2026, 11, 17, 9, 30),
    ),
    TenantUser(
      membershipId: UuidValue.fromString('00000000-0000-4000-8000-0000000001e2'),
      userId: UuidValue.fromString('00000000-0000-4000-8000-0000000000e2'),
      fullName: 'Bruno Despacho',
      email: 'bruno@frio-sul.test',
      status: MembershipStatus.active,
      roles: const ['dispatcher'],
      hasLogin: true,
    ),
  ];

  List<String>? lastInviteRoles;

  TenantUser _replaceUser(TenantUser u) {
    userList[userList.indexWhere((x) => x.membershipId == u.membershipId)] = u;
    return u;
  }

  @override
  Future<List<AssignableRole>> assignableRoles() async {
    _maybeFail('assignableRoles');
    return roleList;
  }

  @override
  Future<List<TenantUser>> users() async {
    _maybeFail('users');
    return [
      for (final u in userList)
        if (u.status != MembershipStatus.removed) u,
    ];
  }

  @override
  Future<TenantUser> inviteUser(String email, String fullName, List<String> roles) async {
    _maybeFail('inviteUser');
    lastInviteRoles = roles;
    final n = userList.length + 1;
    final u = TenantUser(
      membershipId: UuidValue.fromString('00000000-0000-4000-8000-0000000001e$n'),
      userId: UuidValue.fromString('00000000-0000-4000-8000-0000000000e$n'),
      fullName: fullName.trim(),
      email: email.trim(),
      status: MembershipStatus.invited,
      roles: roles,
      hasLogin: false,
    );
    userList.add(u);
    if (inviteEmailFails) {
      throw const GatewayException(
        'O convite foi salvo, mas o e-mail não saiu. Tente "Reenviar convite" daqui a pouco.',
        code: 'INVITE_EMAIL_FAILED',
      );
    }
    return u;
  }

  /// O convite é salvo, mas o e-mail falha (INVITE_EMAIL_FAILED).
  var inviteEmailFails = false;

  @override
  Future<TenantUser> setUserRoles(TenantUser user, List<String> roles) async {
    _maybeFail('setUserRoles');
    return _replaceUser(user.copyWith(roles: roles));
  }

  final resentInvites = <String>[];

  @override
  Future<TenantUser> resendInvite(TenantUser user) async {
    _maybeFail('resendInvite');
    resentInvites.add(user.email ?? '');
    return user;
  }

  @override
  Future<TenantUser> suspendUser(TenantUser user) async {
    _maybeFail('suspendUser');
    return _replaceUser(user.copyWith(status: MembershipStatus.suspended));
  }

  @override
  Future<TenantUser> reactivateUser(TenantUser user) async {
    _maybeFail('reactivateUser');
    return _replaceUser(user.copyWith(status: MembershipStatus.active));
  }

  @override
  Future<TenantUser> removeUser(TenantUser user) async {
    _maybeFail('removeUser');
    return _replaceUser(user.copyWith(status: MembershipStatus.removed));
  }

  // etiquetas QR
  Asset currentAsset = asset1;
  final batchList = <QrTagBatch>[];
  final tagList = <QrTag>[];
  int printedBatches = 0;

  QrTag _tag(String scanned) {
    final i = tagList.indexWhere((t) => t.shortCode == scanned.trim().toUpperCase() || t.url == scanned.trim());
    if (i < 0) throw const GatewayException('Etiqueta não encontrada.', code: 'NOT_FOUND');
    return tagList[i];
  }

  QrTag _replaceTag(QrTag t) {
    tagList[tagList.indexWhere((x) => x.id == t.id)] = t;
    return t;
  }

  @override
  Future<List<QrTagBatch>> qrBatches() async {
    _maybeFail('qrBatches');
    return [
      for (final b in batchList.reversed)
        b.copyWith(boundCount: tagList.where((t) => t.batchId == b.id && t.status == 'bound').length),
    ];
  }

  @override
  Future<QrTagBatch> generateQrBatch(int quantity, {String? notes}) async {
    _maybeFail('generateQrBatch');
    final n = batchList.length + 1;
    final batch = QrTagBatch(
      id: UuidValue.fromString('00000000-0000-4000-8000-0000000002${n.toString().padLeft(2, '0')}'),
      code: 'LOTE-${n.toString().padLeft(4, '0')}',
      quantity: quantity,
      notes: notes == null || notes.trim().isEmpty ? null : notes.trim(),
      boundCount: 0,
      createdAt: DateTime(2026, 11, 17, 10),
    );
    batchList.add(batch);
    for (var i = 0; i < quantity; i++) {
      final k = tagList.length + 1;
      final code = 'Q${k.toString().padLeft(3, '0')}-${n.toString().padLeft(4, '0')}';
      tagList.add(
        QrTag(
          id: UuidValue.fromString('00000000-0000-4000-8001-${k.toString().padLeft(12, '0')}'),
          shortCode: code,
          url: 'https://qr.example/q/$code',
          status: 'generated',
          batchId: batch.id,
          printCount: 0,
        ),
      );
    }
    return batch;
  }

  @override
  Future<List<QrTag>> qrBatchTags(UuidValue batchId) async {
    _maybeFail('qrBatchTags');
    return [
      for (final t in tagList)
        if (t.batchId == batchId) t,
    ];
  }

  @override
  Future<QrTagBatch> markQrBatchPrinted(UuidValue batchId) async {
    _maybeFail('markQrBatchPrinted');
    printedBatches++;
    for (final t in [...tagList]) {
      if (t.batchId == batchId) {
        _replaceTag(
          t.copyWith(status: t.status == 'generated' ? 'printed' : t.status, printCount: t.printCount + 1),
        );
      }
    }
    final i = batchList.indexWhere((b) => b.id == batchId);
    return batchList[i] = batchList[i].copyWith(printedAt: DateTime(2026, 11, 17, 11));
  }

  @override
  Future<QrTag> resolveQrTag(String scanned) async {
    _maybeFail('resolveQrTag');
    return _tag(scanned);
  }

  @override
  Future<QrTag> bindQrTag(String scanned, UuidValue assetId) async {
    _maybeFail('bindQrTag');
    final t = _tag(scanned);
    if (t.status == 'bound') {
      throw const GatewayException('Esta etiqueta já está em outro bem.', code: 'TAG_ALREADY_BOUND');
    }
    currentAsset = currentAsset.copyWith(qrShortCode: t.shortCode);
    return _replaceTag(t.copyWith(status: 'bound', assetId: assetId, assetLabel: currentAsset.assetTag));
  }

  @override
  Future<QrTag> unbindQrTag(QrTag tag) async {
    _maybeFail('unbindQrTag');
    currentAsset = Asset.fromJson({...currentAsset.toJson()}..remove('qrShortCode'));
    return _replaceTag(
      QrTag.fromJson(
        {...tag.toJson(), 'status': 'printed'}
          ..remove('assetId')
          ..remove('assetLabel'),
      ),
    );
  }

  @override
  Future<QrTag> revokeQrTag(QrTag tag, String reason, {String? note}) async {
    _maybeFail('revokeQrTag');
    if (tag.assetId != null || currentAsset.qrShortCode == tag.shortCode) {
      currentAsset = Asset.fromJson({...currentAsset.toJson()}..remove('qrShortCode'));
    }
    return _replaceTag(tag.copyWith(status: 'revoked', revokedReason: reason));
  }

  // clientes
  final customerList = <Customer>[];
  final siteList = <CustomerSite>[];
  final contactList = <CustomerContact>[];

  Customer _withSites(Customer c) =>
      c.copyWith(siteCount: siteList.where((s) => s.customerId == c.id && s.isActive).length);

  Customer _customerFrom(CustomerInput input, {required String id, required int version}) {
    final doc = input.documentNumber;
    return Customer.fromJson({
      ...input.toJson(),
      'id': id,
      'documentType': doc == null ? 'none' : (input.personType == 'individual' ? 'cpf' : 'cnpj'),
      'source': 'local',
      'siteCount': 0,
      'version': version,
    });
  }

  @override
  Future<CustomerPage> customers({String? search, bool includeInactive = false, int limit = 50, int offset = 0}) async {
    _maybeFail('customers');
    final term = search?.trim().toLowerCase() ?? '';
    final items = [
      for (final c in customerList)
        if ((includeInactive || c.isActive) &&
            (term.isEmpty || '${c.name} ${c.tradeName ?? ''} ${c.code ?? ''}'.toLowerCase().contains(term)))
          _withSites(c),
    ];
    return CustomerPage(items: items.skip(offset).take(limit).toList(), total: items.length);
  }

  @override
  Future<Customer> customer(UuidValue id) async {
    _maybeFail('customer');
    return _withSites(customerList.singleWhere((c) => c.id == id));
  }

  @override
  Future<Customer> createCustomer(CustomerInput input) async {
    _maybeFail('createCustomer');
    final c = _customerFrom(
      input,
      id: '00000000-0000-4000-8000-0000000006${(customerList.length + 1).toString().padLeft(2, '0')}',
      version: 1,
    );
    customerList.add(c);
    return c;
  }

  @override
  Future<Customer> updateCustomer(Customer customer, CustomerInput input) async {
    _maybeFail('updateCustomer');
    final c = _customerFrom(input, id: customer.id.uuid, version: customer.version + 1);
    customerList[customerList.indexWhere((x) => x.id == c.id)] = c;
    return c;
  }

  @override
  Future<List<CustomerSite>> customerSites(UuidValue customerId) async {
    _maybeFail('customerSites');
    return [
      for (final s in siteList)
        if (s.customerId == customerId) s,
    ];
  }

  @override
  Future<CustomerSite> createCustomerSite(UuidValue customerId, CustomerSiteInput input) async {
    _maybeFail('createCustomerSite');
    final s = CustomerSite.fromJson({
      ...input.toJson(),
      'id': '00000000-0000-4000-8000-0000000007${(siteList.length + 1).toString().padLeft(2, '0')}',
      'customerId': customerId.uuid,
      'source': 'local',
      'version': 1,
    });
    siteList.add(s);
    return s;
  }

  @override
  Future<CustomerSite> updateCustomerSite(CustomerSite site, CustomerSiteInput input) async {
    _maybeFail('updateCustomerSite');
    final s = CustomerSite.fromJson({
      ...input.toJson(),
      'id': site.id.uuid,
      'customerId': site.customerId.uuid,
      'source': site.source,
      'version': site.version + 1,
    });
    siteList[siteList.indexWhere((x) => x.id == s.id)] = s;
    return s;
  }

  CustomerContact _contactFrom(
    CustomerContactInput input, {
    required String id,
    required UuidValue customerId,
    required int version,
  }) {
    final digits = input.phone?.replaceAll(RegExp(r'\D'), '');
    final siteId = input.customerSiteId;
    return CustomerContact.fromJson({
      ...input.toJson(),
      'id': id,
      'customerId': customerId.uuid,
      'phone': digits == null || digits.isEmpty ? null : '+55$digits',
      'customerSiteName': siteId == null ? null : siteList.singleWhere((s) => s.id == siteId).name,
      'status': 'active',
      'source': 'local',
      'version': version,
    });
  }

  @override
  Future<List<CustomerContact>> customerContacts(UuidValue customerId) async {
    _maybeFail('customerContacts');
    return [
      for (final c in contactList)
        if (c.customerId == customerId) c,
    ];
  }

  @override
  Future<CustomerContact> createCustomerContact(UuidValue customerId, CustomerContactInput input) async {
    _maybeFail('createCustomerContact');
    final c = _contactFrom(
      input,
      id: '00000000-0000-4000-8000-0000000008${(contactList.length + 1).toString().padLeft(2, '0')}',
      customerId: customerId,
      version: 1,
    );
    contactList.add(c);
    return c;
  }

  @override
  Future<CustomerContact> updateCustomerContact(CustomerContact contact, CustomerContactInput input) async {
    _maybeFail('updateCustomerContact');
    final c = _contactFrom(input, id: contact.id.uuid, customerId: contact.customerId, version: contact.version + 1);
    contactList[contactList.indexWhere((x) => x.id == c.id)] = c;
    return c;
  }

  /// Importação simplificada: só exige nome e cria clientes novos.
  final importCalls = <(int, bool)>[];

  @override
  Future<CustomerImportReport> importCustomers(List<CustomerImportRow> rows, {required bool dryRun}) async {
    _maybeFail('importCustomers');
    importCalls.add((rows.length, dryRun));
    final errors = [
      for (final r in rows)
        if (r.name == null) CustomerImportError(line: r.line, column: 'nome', message: 'Informe o nome.'),
    ];
    final apply = errors.isEmpty && !dryRun;
    if (apply) {
      for (final r in rows) {
        await createCustomer(
          CustomerInput(
            code: r.code,
            name: r.name!,
            personType: 'company',
            documentNumber: r.documentNumber,
            isActive: true,
          ),
        );
      }
    }
    return CustomerImportReport(
      dryRun: dryRun,
      applied: apply,
      rows: rows.length,
      customersCreated: rows.length,
      customersExisting: 0,
      sitesCreated: rows.where((r) => r.siteName != null).length,
      sitesExisting: 0,
      contactsCreated: rows.where((r) => r.contactName != null).length,
      contactsExisting: 0,
      errors: errors,
    );
  }

  // cadastros
  @override
  Future<List<Branch>> branches({bool includeInactive = false}) async {
    _maybeFail('branches');
    return [
      for (final b in branchList)
        if (includeInactive || b.isActive) b,
    ];
  }

  final branchList = <Branch>[];
  final costCenterList = <CostCenter>[];
  final productList = <ProductSummary>[];

  @override
  Future<Branch> createBranch(BranchInput input) async {
    _maybeFail('createBranch');
    if (branchList.any((b) => b.code == input.code)) {
      throw const GatewayException(
        'Revise os campos destacados.',
        code: 'VALIDATION_FAILED',
        fieldErrors: {'code': 'Já existe uma filial com este código.'},
      );
    }
    final b = Branch.fromJson({
      ...input.toJson(),
      'id': '00000000-0000-4000-8000-0000000003${(branchList.length + 1).toString().padLeft(2, '0')}',
      'version': 1,
    });
    branchList.add(b);
    return b;
  }

  @override
  Future<Branch> updateBranch(Branch branch, BranchInput input) async {
    _maybeFail('updateBranch');
    final b = Branch.fromJson({...input.toJson(), 'id': branch.id.uuid, 'version': branch.version + 1});
    branchList[branchList.indexWhere((x) => x.id == b.id)] = b;
    return b;
  }

  @override
  Future<List<CostCenter>> costCenters({bool includeInactive = false}) async {
    _maybeFail('costCenters');
    return [
      for (final c in costCenterList)
        if (includeInactive || c.isActive) c,
    ];
  }

  @override
  Future<CostCenter> createCostCenter(CostCenterInput input) async {
    _maybeFail('createCostCenter');
    final c = CostCenter.fromJson({
      ...input.toJson(),
      'id': '00000000-0000-4000-8000-0000000004${(costCenterList.length + 1).toString().padLeft(2, '0')}',
      'version': 1,
    });
    costCenterList.add(c);
    return c;
  }

  @override
  Future<CostCenter> updateCostCenter(CostCenter costCenter, CostCenterInput input) async {
    _maybeFail('updateCostCenter');
    final c = CostCenter.fromJson({...input.toJson(), 'id': costCenter.id.uuid, 'version': costCenter.version + 1});
    costCenterList[costCenterList.indexWhere((x) => x.id == c.id)] = c;
    return c;
  }

  @override
  Future<List<ProductSummary>> products({String? search}) async {
    _maybeFail('products');
    return productList;
  }

  @override
  Future<ProductSummary> createProduct(ProductInput input) async {
    _maybeFail('createProduct');
    final p = ProductSummary(
      id: UuidValue.fromString(
        '00000000-0000-4000-8000-0000000005${(productList.length + 1).toString().padLeft(2, '0')}',
      ),
      code: input.code,
      name: input.name,
      isActive: true,
    );
    productList.add(p);
    return p;
  }

  @override
  Future<AssetPage> assets({String? search, UuidValue? customerId, int limit = 50, int offset = 0}) async {
    _maybeFail('assets');
    final items = [
      if (customerId == null || currentAsset.customerId == customerId) currentAsset,
    ];
    return AssetPage(items: items, total: items.length);
  }

  final assignmentList = <AssetAssignment>[];
  AssetInstallInput? lastInstall;

  @override
  Future<Asset> installAsset(Asset asset, AssetInstallInput input) async {
    _maybeFail('installAsset');
    lastInstall = input;
    final site = siteList.singleWhere((s) => s.id == input.customerSiteId);
    final customer = customerList.singleWhere((c) => c.id == site.customerId);
    final now = DateTime(2026, 11, 17, 15);
    final transfer = assignmentList.isNotEmpty && assignmentList.first.endedAt == null;
    if (transfer) assignmentList[0] = assignmentList[0].copyWith(endedAt: now, endReason: 'transfer');
    assignmentList.insert(
      0,
      AssetAssignment(
        id: UuidValue.fromString(
          '00000000-0000-4000-8000-0000000008${(assignmentList.length + 1).toString().padLeft(2, '0')}',
        ),
        customerId: customer.id,
        customerName: customer.tradeName ?? customer.name,
        customerSiteId: site.id,
        customerSiteName: site.name,
        ownershipType: asset.ownershipType,
        startedAt: now,
        startReason: transfer ? 'transfer' : 'installation',
        sourceDocumentType: input.sourceDocumentType,
        sourceDocumentNumber: input.sourceDocumentNumber,
        notes: input.notes,
      ),
    );
    return currentAsset = asset.copyWith(
      status: 'installed',
      customerId: customer.id,
      customerName: customer.tradeName ?? customer.name,
      customerSiteId: site.id,
      customerSiteName: site.name,
      version: asset.version + 1,
    );
  }

  @override
  Future<Asset> withdrawAsset(Asset asset, AssetWithdrawInput input) async {
    _maybeFail('withdrawAsset');
    assignmentList[0] = assignmentList[0].copyWith(endedAt: DateTime(2026, 11, 17, 16), endReason: input.reason);
    final json = asset.toJson()
      ..remove('customerId')
      ..remove('customerName')
      ..remove('customerSiteId')
      ..remove('customerSiteName');
    return currentAsset = Asset.fromJson({...json, 'status': 'in_stock', 'version': asset.version + 1});
  }

  @override
  Future<List<AssetAssignment>> assetAssignments(UuidValue assetId) async {
    _maybeFail('assetAssignments');
    return [...assignmentList];
  }

  @override
  Future<Asset> asset(UuidValue id) async => currentAsset;

  AssetInput? lastAssetInput;

  Asset _assetFrom(AssetInput input, {required UuidValue id, required int version, String source = 'local'}) {
    final product = productList.where((p) => p.id == input.productId).firstOrNull;
    return Asset.fromJson({
      ...input.toJson(),
      'id': id.uuid,
      'productName': product?.name ?? currentAsset.productName,
      'status': 'in_stock',
      'ownershipType': input.ownershipType ?? 'tenant_loan',
      'source': source,
      'version': version,
    });
  }

  @override
  Future<Asset> createAsset(AssetInput input) async {
    _maybeFail('createAsset');
    lastAssetInput = input;
    return currentAsset = _assetFrom(
      input,
      id: UuidValue.fromString('00000000-0000-4000-8000-0000000000b9'),
      version: 1,
    );
  }

  @override
  Future<Asset> updateAsset(Asset asset, AssetInput input) async {
    _maybeFail('updateAsset');
    lastAssetInput = input;
    return currentAsset = _assetFrom(input, id: asset.id, version: asset.version + 1, source: asset.source);
  }

  // OS
  @override
  Future<WorkOrderPage> workOrders({
    String? search,
    List<String>? statuses,
    bool openOnly = false,
    UuidValue? assetId,
    int limit = 50,
    int offset = 0,
  }) async {
    _maybeFail('workOrders');
    final items = workOrderList
        .where((w) => statuses == null || statuses.contains(w.status))
        .where((w) => search == null || search.isEmpty || w.number.contains(search))
        .toList();
    return WorkOrderPage(items: items, total: items.length);
  }

  @override
  Future<WorkOrderDetail> workOrder(UuidValue id) async {
    _maybeFail('workOrder');
    final wo = workOrderList.singleWhere((w) => w.id == id);
    return WorkOrderDetail(
      workOrder: wo,
      history: [
        WorkOrderStatusChange(toStatus: 'open', changedAt: wo.createdAt, changedByName: 'Ana Admin'),
      ],
      otherOpenOnAsset: const [],
    );
  }

  @override
  Future<List<WorkOrderType>> workOrderTypes() async => [corrective];

  WorkOrderInput? lastInput;

  @override
  Future<WorkOrderDetail> openWorkOrder(WorkOrderInput input) async {
    _maybeFail('openWorkOrder');
    lastInput = input;
    final wo = sample(n: workOrderList.length + 1);
    workOrderList.add(wo);
    return WorkOrderDetail(workOrder: wo, history: const [], otherOpenOnAsset: const []);
  }

  @override
  Future<WorkOrder> startWorkOrder(WorkOrder wo) async {
    _maybeFail('startWorkOrder');
    return _replace(wo, 'in_progress');
  }

  @override
  Future<WorkOrder> holdWorkOrder(WorkOrder wo, String holdReason, String? note) async {
    _maybeFail('holdWorkOrder');
    return _replace(wo, 'on_hold');
  }

  @override
  Future<WorkOrder> completeWorkOrder(WorkOrder wo, String resolutionNotes) async {
    _maybeFail('completeWorkOrder');
    return _replace(wo, 'completed');
  }

  @override
  Future<WorkOrder> closeWorkOrder(WorkOrder wo) async {
    _maybeFail('closeWorkOrder');
    return _replace(wo, 'closed');
  }

  String? lastCancelReason;

  @override
  Future<WorkOrder> cancelWorkOrder(WorkOrder wo, String reason, String? note) async {
    _maybeFail('cancelWorkOrder');
    lastCancelReason = reason;
    return _replace(wo, 'cancelled');
  }

  @override
  Future<WorkOrder> reopenWorkOrder(WorkOrder wo, String reason) async {
    _maybeFail('reopenWorkOrder');
    return _replace(wo, 'open');
  }

  // agenda
  final technicianList = <Technician>[
    Technician(
      id: UuidValue.fromString('00000000-0000-4000-8000-0000000000d1'),
      code: 'T01',
      name: 'Eduardo Técnico',
      isActive: true,
      version: 1,
    ),
  ];
  final visitList = <Visit>[];
  VisitInput? lastVisitInput;
  DateTime? lastAgendaFrom;
  DateTime? lastAgendaTo;

  static Visit sampleVisit(WorkOrder wo, Technician t, DateTime start, {int number = 1, String status = 'scheduled'}) =>
      Visit(
        id: UuidValue.fromString('00000000-0000-4000-9000-${number.toString().padLeft(12, '0')}'),
        workOrderId: wo.id,
        workOrderNumber: wo.number,
        workOrderStatus: 'scheduled',
        workOrderPriority: wo.priority,
        problemDescription: wo.problemDescription,
        assetLabel: wo.assetLabel,
        productName: wo.productName,
        visitNumber: number,
        technicianId: t.id,
        technicianName: t.name,
        status: status,
        scheduledStart: start,
        scheduledEnd: start.add(const Duration(hours: 2)),
        checkInOffSite: false,
        version: 1,
      );

  @override
  Future<List<Technician>> technicians({bool includeInactive = false}) async {
    _maybeFail('technicians');
    return [
      for (final t in technicianList)
        if (includeInactive || t.isActive) t,
    ];
  }

  @override
  Future<Technician> createTechnician(TechnicianInput input) async {
    _maybeFail('createTechnician');
    final t = Technician(
      id: UuidValue.fromString('00000000-0000-4000-8000-0000000000d${technicianList.length + 1}'),
      code: input.code,
      name: input.name,
      email: input.email,
      phone: input.phone,
      isActive: input.isActive,
      version: 1,
    );
    technicianList.add(t);
    return t;
  }

  @override
  Future<Technician> updateTechnician(Technician technician, TechnicianInput input) async {
    _maybeFail('updateTechnician');
    final t = technician.copyWith(
      code: input.code,
      name: input.name,
      isActive: input.isActive,
      version: technician.version + 1,
    );
    technicianList[technicianList.indexWhere((x) => x.id == t.id)] = t;
    return t;
  }

  @override
  Future<List<Visit>> agenda(
    DateTime from,
    DateTime to, {
    UuidValue? technicianId,
    bool includeCancelled = false,
  }) async {
    _maybeFail('agenda');
    lastAgendaFrom = from;
    lastAgendaTo = to;
    return [
      for (final v in visitList)
        if (!v.scheduledStart.isBefore(from) &&
            v.scheduledStart.isBefore(to) &&
            (includeCancelled || v.status != 'cancelled'))
          v,
    ];
  }

  @override
  Future<List<Visit>> visitsOfWorkOrder(UuidValue workOrderId) async => [
    for (final v in visitList)
      if (v.workOrderId == workOrderId) v,
  ];

  @override
  Future<Visit> scheduleVisit(UuidValue workOrderId, VisitInput input) async {
    _maybeFail('scheduleVisit');
    lastVisitInput = input;
    final wo = workOrderList.singleWhere((w) => w.id == workOrderId);
    final t = technicianList.singleWhere((x) => x.id == input.technicianId);
    final v = sampleVisit(
      wo,
      t,
      input.scheduledStart,
      number: visitList.length + 1,
    ).copyWith(scheduledEnd: input.scheduledEnd);
    visitList.add(v);
    _replace(wo, 'scheduled');
    return v;
  }

  @override
  Future<Visit> rescheduleVisit(Visit visit, VisitInput input) async {
    _maybeFail('rescheduleVisit');
    lastVisitInput = input;
    final v = visit.copyWith(
      scheduledStart: input.scheduledStart,
      scheduledEnd: input.scheduledEnd,
      version: visit.version + 1,
    );
    visitList[visitList.indexWhere((x) => x.id == v.id)] = v;
    return v;
  }

  String? lastVisitCancelReason;

  @override
  Future<Visit> cancelVisit(Visit visit, String reason) async {
    _maybeFail('cancelVisit');
    lastVisitCancelReason = reason;
    final v = visit.copyWith(status: 'cancelled', cancellationReason: reason, version: visit.version + 1);
    visitList[visitList.indexWhere((x) => x.id == v.id)] = v;
    return v;
  }

  // depreciação
  DepreciationProfile? profile;
  DepreciationProfileInput? lastProfileInput;
  int? lastProfileVersion;
  final closingList = <DepreciationClosing>[];

  @override
  Future<DepreciationProfile?> depreciationProfile(UuidValue assetId) async => profile;

  @override
  Future<DepreciationProfile> saveDepreciationProfile(
    UuidValue assetId,
    int? expectedVersion,
    DepreciationProfileInput input,
  ) async {
    _maybeFail('saveDepreciationProfile');
    lastProfileInput = input;
    lastProfileVersion = expectedVersion;
    return profile = DepreciationProfile(
      assetId: assetId,
      method: input.method,
      annualRate: input.annualRate.replaceAll(',', '.'),
      startDate: input.startDate,
      startRule: input.startRule ?? 'pro_rata_days',
      depreciableCost: input.depreciableCost,
      effectiveCost: input.depreciableCost ?? asset1.acquisitionCost,
      residualValue: input.residualValue ?? 0,
      notes: input.notes,
      version: (expectedVersion ?? 0) + 1,
    );
  }

  @override
  Future<AssetDepreciation> depreciationSchedule(UuidValue assetId) async => AssetDepreciation(
    profile: profile!,
    cost: 123456,
    residualValue: 0,
    lines: [
      DepreciationLine(
        year: 2026,
        month: 1,
        amount: 1029,
        accumulated: 1029,
        netBookValue: 122427,
        rule: 'linear',
        disposed: false,
      ),
    ],
  );

  bool _isClosed(int year, int month) =>
      closingList.any((c) => c.year == year && c.month == month && c.status == 'closed');

  @override
  Future<DepreciationPosition> depreciationPosition(int year, int month, {UuidValue? costCenterId}) async {
    _maybeFail('depreciationPosition');
    final total = DepreciationGroupTotal(
      assetCount: 1,
      cost: 123456,
      monthlyAmount: 1029,
      accumulated: 2058,
      netBookValue: 121398,
    );
    return DepreciationPosition(
      year: year,
      month: month,
      closed: _isClosed(year, month),
      items: [
        DepreciationPositionItem(
          assetId: asset1.id,
          assetLabel: 'PAT-001',
          productName: 'Freezer horizontal',
          costCenterName: '1.01 · Produção',
          cost: 123456,
          monthlyAmount: 1029,
          accumulated: 2058,
          netBookValue: 121398,
        ),
      ],
      byCostCenter: [total.copyWith(name: '1.01 · Produção')],
      byBranch: [total],
      total: total,
    );
  }

  @override
  Future<List<DepreciationClosing>> depreciationClosings() async => closingList;

  @override
  Future<DepreciationClosing> closeDepreciation(int year, int month) async {
    _maybeFail('closeDepreciation');
    final c = DepreciationClosing(
      id: UuidValue.fromString('00000000-0000-4000-a000-${(year * 100 + month).toString().padLeft(12, '0')}'),
      year: year,
      month: month,
      status: 'closed',
      assetCount: 1,
      totalAmount: 1029,
      closedAt: DateTime.utc(2026, 11, 17, 12),
      closedByName: 'Ana Admin',
    );
    closingList.insert(0, c);
    return c;
  }

  @override
  Future<DepreciationClosing> reopenDepreciation(int year, int month, String reason) async {
    _maybeFail('reopenDepreciation');
    final i = closingList.indexWhere((c) => c.year == year && c.month == month && c.status == 'closed');
    final c = closingList[i].copyWith(
      status: 'reopened',
      reopenedAt: DateTime.utc(2026, 11, 17, 13),
      reopenReason: reason,
    );
    closingList[i] = c;
    return c;
  }
}
