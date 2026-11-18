/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:http/http.dart' as _i85jenna;
import 'package:plataforma_os_client/src/protocol/assets/models/asset.dart' as _i1flw1j6;
import 'package:plataforma_os_client/src/protocol/assets/models/asset_assignment.dart' as _ilmvd2lt;
import 'package:plataforma_os_client/src/protocol/assets/models/asset_input.dart' as _i3bfa7rs;
import 'package:plataforma_os_client/src/protocol/assets/models/asset_install_input.dart' as _ixzdbb4e;
import 'package:plataforma_os_client/src/protocol/assets/models/asset_page.dart' as _ih5rjonj;
import 'package:plataforma_os_client/src/protocol/assets/models/asset_withdraw_input.dart' as _i7pva5pt;
import 'package:plataforma_os_client/src/protocol/assets/models/qr_tag.dart' as _ix23buzf;
import 'package:plataforma_os_client/src/protocol/assets/models/qr_tag_batch.dart' as _ic9pb02v;
import 'package:plataforma_os_client/src/protocol/catalog/models/checklist_template.dart' as _i4koy3wu;
import 'package:plataforma_os_client/src/protocol/catalog/models/checklist_template_input.dart' as _i08aig2p;
import 'package:plataforma_os_client/src/protocol/catalog/models/product_input.dart' as _i2gecgw3;
import 'package:plataforma_os_client/src/protocol/catalog/models/product_summary.dart' as _ihgw7zuo;
import 'package:plataforma_os_client/src/protocol/customers/models/customer.dart' as _isrde2pn;
import 'package:plataforma_os_client/src/protocol/customers/models/customer_contact.dart' as _iicdz276;
import 'package:plataforma_os_client/src/protocol/customers/models/customer_contact_input.dart' as _ixru6art;
import 'package:plataforma_os_client/src/protocol/customers/models/customer_import_report.dart' as _ilgud4gt;
import 'package:plataforma_os_client/src/protocol/customers/models/customer_import_row.dart' as _i2vmk5z7;
import 'package:plataforma_os_client/src/protocol/customers/models/customer_input.dart' as _il30a9yx;
import 'package:plataforma_os_client/src/protocol/customers/models/customer_page.dart' as _igrzlp6q;
import 'package:plataforma_os_client/src/protocol/customers/models/customer_site.dart' as _iq0mn52n;
import 'package:plataforma_os_client/src/protocol/customers/models/customer_site_input.dart' as _i10zqbaj;
import 'package:plataforma_os_client/src/protocol/identity_access/models/assignable_role.dart' as _i2g1699a;
import 'package:plataforma_os_client/src/protocol/identity_access/models/me_info.dart' as _i8cz5om6;
import 'package:plataforma_os_client/src/protocol/identity_access/models/tenant_token.dart' as _ii663qav;
import 'package:plataforma_os_client/src/protocol/identity_access/models/tenant_user.dart' as _i8ihd43z;
import 'package:plataforma_os_client/src/protocol/patrimony/models/asset_depreciation.dart' as _irg3uuam;
import 'package:plataforma_os_client/src/protocol/patrimony/models/depreciation_closing.dart' as _iqiiy4eg;
import 'package:plataforma_os_client/src/protocol/patrimony/models/depreciation_position.dart' as _i8b4ltth;
import 'package:plataforma_os_client/src/protocol/patrimony/models/depreciation_profile.dart' as _i0ewj4w5;
import 'package:plataforma_os_client/src/protocol/patrimony/models/depreciation_profile_input.dart' as _ihghh0c1;
import 'package:plataforma_os_client/src/protocol/scheduling/models/attachment.dart' as _ixilyq04;
import 'package:plataforma_os_client/src/protocol/scheduling/models/attachment_upload.dart' as _ictou6wh;
import 'package:plataforma_os_client/src/protocol/scheduling/models/technician.dart' as _ikjr2b9x;
import 'package:plataforma_os_client/src/protocol/scheduling/models/technician_input.dart' as _ixaduq6k;
import 'package:plataforma_os_client/src/protocol/scheduling/models/visit.dart' as _isvtjvq7;
import 'package:plataforma_os_client/src/protocol/scheduling/models/visit_check_in.dart' as _ias7e1vu;
import 'package:plataforma_os_client/src/protocol/scheduling/models/visit_checklist.dart' as _is9a6d8i;
import 'package:plataforma_os_client/src/protocol/scheduling/models/visit_finish.dart' as _ikfe26w9;
import 'package:plataforma_os_client/src/protocol/scheduling/models/visit_input.dart' as _ivjpdmyn;
import 'package:plataforma_os_client/src/protocol/sync/models/device_registration.dart' as _iam7n156;
import 'package:plataforma_os_client/src/protocol/sync/models/sync_mutation_result.dart' as _ief0slxz;
import 'package:plataforma_os_client/src/protocol/sync/models/sync_pull_result.dart' as _irdeaok0;
import 'package:plataforma_os_client/src/protocol/sync/models/sync_push_request.dart' as _i65q2o7k;
import 'package:plataforma_os_client/src/protocol/tenancy/models/branch.dart' as _ied3wtyg;
import 'package:plataforma_os_client/src/protocol/tenancy/models/branch_input.dart' as _il2pvpfo;
import 'package:plataforma_os_client/src/protocol/tenancy/models/cost_center.dart' as _itoq0gfy;
import 'package:plataforma_os_client/src/protocol/tenancy/models/cost_center_input.dart' as _iusx5jxf;
import 'package:plataforma_os_client/src/protocol/tenancy/models/tenant_summary.dart' as _i11upz4e;
import 'package:plataforma_os_client/src/protocol/work_orders/models/work_order.dart' as _ijkllwf7;
import 'package:plataforma_os_client/src/protocol/work_orders/models/work_order_changes.dart' as _i9dox7p2;
import 'package:plataforma_os_client/src/protocol/work_orders/models/work_order_detail.dart' as _i96vhhgb;
import 'package:plataforma_os_client/src/protocol/work_orders/models/work_order_input.dart' as _ikxgyzb6;
import 'package:plataforma_os_client/src/protocol/work_orders/models/work_order_page.dart' as _i3z3e08i;
import 'package:plataforma_os_client/src/protocol/work_orders/models/work_order_type.dart' as _iufozffx;
import 'package:plataforma_os_client/src/protocol/work_orders/models/work_order_type_input.dart' as _i6v2tjgk;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart' as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart' as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// `assets.*` — cadastro e movimentação de bens. Erros: `FORBIDDEN`,
/// `VALIDATION_FAILED`, `NOT_FOUND`, `VERSION_MISMATCH`, `ERP_MASTER_READ_ONLY`,
/// `ASSET_RETIRED`, `ASSET_INACTIVE`, `ALREADY_AT_SITE`, `NOT_INSTALLED`,
/// `MOVEMENT_APPROVAL_UNSUPPORTED`.
/// {@category Endpoint}
class EndpointAssets extends EndpointStaff {
  EndpointAssets(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'assets';

  /// [search] procura no patrimônio, na série e no nome do produto.
  _ida.Future<_ih5rjonj.AssetPage> list({
    String? search,
    _isc.UuidValue? branchId,
    _isc.UuidValue? costCenterId,
    _isc.UuidValue? customerId,
    bool? includeInactive,
    int? limit,
    int? offset,
  }) => caller.callServerEndpoint<_ih5rjonj.AssetPage>(
    'assets',
    'list',
    {
      'search': search,
      'branchId': branchId,
      'costCenterId': costCenterId,
      'customerId': customerId,
      'includeInactive': includeInactive,
      'limit': limit,
      'offset': offset,
    },
  );

  _ida.Future<_i1flw1j6.Asset> get(_isc.UuidValue id) => caller.callServerEndpoint<_i1flw1j6.Asset>(
    'assets',
    'get',
    {'id': id},
  );

  _ida.Future<_i1flw1j6.Asset> create(_i3bfa7rs.AssetInput input) => caller.callServerEndpoint<_i1flw1j6.Asset>(
    'assets',
    'create',
    {'input': input},
  );

  _ida.Future<_i1flw1j6.Asset> update(
    _isc.UuidValue id,
    int expectedVersion,
    _i3bfa7rs.AssetInput input,
  ) => caller.callServerEndpoint<_i1flw1j6.Asset>(
    'assets',
    'update',
    {
      'id': id,
      'expectedVersion': expectedVersion,
      'input': input,
    },
  );

  /// Instala o bem na unidade do cliente (comodato, locação ou do cliente).
  /// Se já estiver em outra unidade, encerra lá e vira transferência.
  _ida.Future<_i1flw1j6.Asset> install(
    _isc.UuidValue id,
    int expectedVersion,
    _ixzdbb4e.AssetInstallInput input,
  ) => caller.callServerEndpoint<_i1flw1j6.Asset>(
    'assets',
    'install',
    {
      'id': id,
      'expectedVersion': expectedVersion,
      'input': input,
    },
  );

  /// Encerra a alocação vigente; o bem volta ao estoque.
  _ida.Future<_i1flw1j6.Asset> withdraw(
    _isc.UuidValue id,
    int expectedVersion,
    _i7pva5pt.AssetWithdrawInput input,
  ) => caller.callServerEndpoint<_i1flw1j6.Asset>(
    'assets',
    'withdraw',
    {
      'id': id,
      'expectedVersion': expectedVersion,
      'input': input,
    },
  );

  /// Histórico de alocações do bem, a mais recente primeiro.
  _ida.Future<List<_ilmvd2lt.AssetAssignment>> assignments(_isc.UuidValue id) =>
      caller.callServerEndpoint<List<_ilmvd2lt.AssetAssignment>>(
        'assets',
        'assignments',
        {'id': id},
      );
}

/// `qrTags.*` — etiquetas QR (permissão `qr_tags.manage`; desfazer vínculo
/// exige `qr_tags.unbind`). Erros: `FORBIDDEN`, `VALIDATION_FAILED`,
/// `NOT_FOUND`, `TAG_ALREADY_BOUND`, `TAG_ALREADY_ON_ASSET`, `TAG_REVOKED`,
/// `TAG_NOT_BOUND`, `ASSET_ALREADY_TAGGED`, `ASSET_RETIRED`.
/// {@category Endpoint}
class EndpointQrTags extends EndpointStaff {
  EndpointQrTags(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'qrTags';

  /// Gera um lote de 1 a 500 etiquetas para imprimir.
  _ida.Future<_ic9pb02v.QrTagBatch> generateBatch(
    int quantity, {
    String? notes,
  }) => caller.callServerEndpoint<_ic9pb02v.QrTagBatch>(
    'qrTags',
    'generateBatch',
    {
      'quantity': quantity,
      'notes': notes,
    },
  );

  _ida.Future<List<_ic9pb02v.QrTagBatch>> listBatches() => caller.callServerEndpoint<List<_ic9pb02v.QrTagBatch>>(
    'qrTags',
    'listBatches',
    {},
  );

  /// Etiquetas do lote, com código curto e URL para montar o PDF de impressão.
  _ida.Future<List<_ix23buzf.QrTag>> batchTags(_isc.UuidValue batchId) =>
      caller.callServerEndpoint<List<_ix23buzf.QrTag>>(
        'qrTags',
        'batchTags',
        {'batchId': batchId},
      );

  _ida.Future<_ic9pb02v.QrTagBatch> markBatchPrinted(_isc.UuidValue batchId) =>
      caller.callServerEndpoint<_ic9pb02v.QrTagBatch>(
        'qrTags',
        'markBatchPrinted',
        {'batchId': batchId},
      );

  /// Etiqueta pelo que foi lido ou digitado: código curto, token ou URL.
  _ida.Future<_ix23buzf.QrTag> resolve(String scanned) => caller.callServerEndpoint<_ix23buzf.QrTag>(
    'qrTags',
    'resolve',
    {'scanned': scanned},
  );

  _ida.Future<_ix23buzf.QrTag> bind(
    String scanned,
    _isc.UuidValue assetId,
  ) => caller.callServerEndpoint<_ix23buzf.QrTag>(
    'qrTags',
    'bind',
    {
      'scanned': scanned,
      'assetId': assetId,
    },
  );

  _ida.Future<_ix23buzf.QrTag> unbind(_isc.UuidValue tagId) => caller.callServerEndpoint<_ix23buzf.QrTag>(
    'qrTags',
    'unbind',
    {'tagId': tagId},
  );

  /// [reason]: damaged, lost, replaced, asset_retired, misprint, security ou other.
  _ida.Future<_ix23buzf.QrTag> revoke(
    _isc.UuidValue tagId,
    String reason, {
    String? note,
  }) => caller.callServerEndpoint<_ix23buzf.QrTag>(
    'qrTags',
    'revoke',
    {
      'tagId': tagId,
      'reason': reason,
      'note': note,
    },
  );
}

/// `checklists.*` — modelos de checklist. Leitura para quem trabalha com OS;
/// alteração com `catalog.manage`. Erros: `VALIDATION_FAILED`, `NOT_FOUND`,
/// `VERSION_MISMATCH`, `NOT_DRAFT`, `EMPTY_CHECKLIST`, `DRAFT_EXISTS`.
/// {@category Endpoint}
class EndpointChecklists extends EndpointStaff {
  EndpointChecklists(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'checklists';

  /// Rascunhos e publicados (e arquivados com [includeArchived]), por nome e
  /// versão mais nova primeiro.
  _ida.Future<List<_i4koy3wu.ChecklistTemplate>> list({bool? includeArchived}) =>
      caller.callServerEndpoint<List<_i4koy3wu.ChecklistTemplate>>(
        'checklists',
        'list',
        {'includeArchived': includeArchived},
      );

  _ida.Future<_i4koy3wu.ChecklistTemplate> get(_isc.UuidValue id) =>
      caller.callServerEndpoint<_i4koy3wu.ChecklistTemplate>(
        'checklists',
        'get',
        {'id': id},
      );

  _ida.Future<_i4koy3wu.ChecklistTemplate> create(_i08aig2p.ChecklistTemplateInput input) =>
      caller.callServerEndpoint<_i4koy3wu.ChecklistTemplate>(
        'checklists',
        'create',
        {'input': input},
      );

  _ida.Future<_i4koy3wu.ChecklistTemplate> update(
    _isc.UuidValue id,
    int expectedVersion,
    _i08aig2p.ChecklistTemplateInput input,
  ) => caller.callServerEndpoint<_i4koy3wu.ChecklistTemplate>(
    'checklists',
    'update',
    {
      'id': id,
      'expectedVersion': expectedVersion,
      'input': input,
    },
  );

  _ida.Future<_i4koy3wu.ChecklistTemplate> publish(
    _isc.UuidValue id,
    int expectedVersion,
  ) => caller.callServerEndpoint<_i4koy3wu.ChecklistTemplate>(
    'checklists',
    'publish',
    {
      'id': id,
      'expectedVersion': expectedVersion,
    },
  );

  /// Novo rascunho a partir de uma versão publicada.
  _ida.Future<_i4koy3wu.ChecklistTemplate> newVersion(_isc.UuidValue id) =>
      caller.callServerEndpoint<_i4koy3wu.ChecklistTemplate>(
        'checklists',
        'newVersion',
        {'id': id},
      );

  _ida.Future<_i4koy3wu.ChecklistTemplate> archive(
    _isc.UuidValue id,
    int expectedVersion,
  ) => caller.callServerEndpoint<_i4koy3wu.ChecklistTemplate>(
    'checklists',
    'archive',
    {
      'id': id,
      'expectedVersion': expectedVersion,
    },
  );
}

/// `products.*` — modelos de equipamento para o cadastro de bens.
/// {@category Endpoint}
class EndpointProducts extends EndpointStaff {
  EndpointProducts(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'products';

  /// Equipamentos ativos; [search] procura no código e no nome.
  _ida.Future<List<_ihgw7zuo.ProductSummary>> list({String? search}) =>
      caller.callServerEndpoint<List<_ihgw7zuo.ProductSummary>>(
        'products',
        'list',
        {'search': search},
      );

  _ida.Future<_ihgw7zuo.ProductSummary> create(_i2gecgw3.ProductInput input) =>
      caller.callServerEndpoint<_ihgw7zuo.ProductSummary>(
        'products',
        'create',
        {'input': input},
      );
}

/// `customers.*` — clientes, unidades e contatos. Leitura para quem mexe com OS ou
/// bens; alteração com `customers.manage`. Erros: `FORBIDDEN`,
/// `VALIDATION_FAILED`, `NOT_FOUND`, `VERSION_MISMATCH`, `ERP_MASTER_READ_ONLY`.
/// {@category Endpoint}
class EndpointCustomers extends EndpointStaff {
  EndpointCustomers(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'customers';

  /// [search] procura no nome, nome fantasia, código e documento.
  _ida.Future<_igrzlp6q.CustomerPage> list({
    String? search,
    bool? includeInactive,
    int? limit,
    int? offset,
  }) => caller.callServerEndpoint<_igrzlp6q.CustomerPage>(
    'customers',
    'list',
    {
      'search': search,
      'includeInactive': includeInactive,
      'limit': limit,
      'offset': offset,
    },
  );

  _ida.Future<_isrde2pn.Customer> get(_isc.UuidValue id) => caller.callServerEndpoint<_isrde2pn.Customer>(
    'customers',
    'get',
    {'id': id},
  );

  _ida.Future<_isrde2pn.Customer> create(_il30a9yx.CustomerInput input) =>
      caller.callServerEndpoint<_isrde2pn.Customer>(
        'customers',
        'create',
        {'input': input},
      );

  _ida.Future<_isrde2pn.Customer> update(
    _isc.UuidValue id,
    int expectedVersion,
    _il30a9yx.CustomerInput input,
  ) => caller.callServerEndpoint<_isrde2pn.Customer>(
    'customers',
    'update',
    {
      'id': id,
      'expectedVersion': expectedVersion,
      'input': input,
    },
  );

  /// Unidades do cliente (ativas e inativas).
  _ida.Future<List<_iq0mn52n.CustomerSite>> sites(_isc.UuidValue customerId) =>
      caller.callServerEndpoint<List<_iq0mn52n.CustomerSite>>(
        'customers',
        'sites',
        {'customerId': customerId},
      );

  _ida.Future<_iq0mn52n.CustomerSite> createSite(
    _isc.UuidValue customerId,
    _i10zqbaj.CustomerSiteInput input,
  ) => caller.callServerEndpoint<_iq0mn52n.CustomerSite>(
    'customers',
    'createSite',
    {
      'customerId': customerId,
      'input': input,
    },
  );

  _ida.Future<_iq0mn52n.CustomerSite> updateSite(
    _isc.UuidValue id,
    int expectedVersion,
    _i10zqbaj.CustomerSiteInput input,
  ) => caller.callServerEndpoint<_iq0mn52n.CustomerSite>(
    'customers',
    'updateSite',
    {
      'id': id,
      'expectedVersion': expectedVersion,
      'input': input,
    },
  );

  /// Contatos do cliente (ativos e inativos).
  _ida.Future<List<_iicdz276.CustomerContact>> contacts(_isc.UuidValue customerId) =>
      caller.callServerEndpoint<List<_iicdz276.CustomerContact>>(
        'customers',
        'contacts',
        {'customerId': customerId},
      );

  _ida.Future<_iicdz276.CustomerContact> createContact(
    _isc.UuidValue customerId,
    _ixru6art.CustomerContactInput input,
  ) => caller.callServerEndpoint<_iicdz276.CustomerContact>(
    'customers',
    'createContact',
    {
      'customerId': customerId,
      'input': input,
    },
  );

  _ida.Future<_iicdz276.CustomerContact> updateContact(
    _isc.UuidValue id,
    int expectedVersion,
    _ixru6art.CustomerContactInput input,
  ) => caller.callServerEndpoint<_iicdz276.CustomerContact>(
    'customers',
    'updateContact',
    {
      'id': id,
      'expectedVersion': expectedVersion,
      'input': input,
    },
  );

  /// Importa clientes, unidades e contatos de uma planilha. Com [dryRun] só
  /// valida; com algum erro, nada é gravado (veja `CustomerImportReport`).
  _ida.Future<_ilgud4gt.CustomerImportReport> importRows(
    List<_i2vmk5z7.CustomerImportRow> rows,
    bool dryRun,
  ) => caller.callServerEndpoint<_ilgud4gt.CustomerImportReport>(
    'customers',
    'importRows',
    {
      'rows': rows,
      'dryRun': dryRun,
    },
  );
}

/// `auth.*` — escolha do tenant depois do login por e-mail e senha.
///
/// Exige a sessão de login do módulo (`emailIdp.login`), sem escopo: o token
/// de tenant não é aceito aqui.
/// {@category Endpoint}
class EndpointAuth extends _isc.EndpointRef {
  EndpointAuth(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'auth';

  /// Troca a sessão de login por um token de tenant (10 min).
  ///
  /// [technicianApp] = chamada do app de campo: exige papel de técnico ou
  /// coordenador.
  ///
  /// Erros: `UNAUTHENTICATED` (sem sessão de login), `FORBIDDEN` (sem vínculo
  /// no tenant, ou tenant inexistente), `TENANT_SUSPENDED`.
  _ida.Future<_ii663qav.TenantToken> selectTenant(
    String tenantSlug, {
    bool? technicianApp,
  }) => caller.callServerEndpoint<_ii663qav.TenantToken>(
    'auth',
    'selectTenant',
    {
      'tenantSlug': tenantSlug,
      'technicianApp': technicianApp,
    },
  );

  /// Empresas em que o usuário da sessão de login pode entrar, em ordem de
  /// nome. Erros: `UNAUTHENTICATED`, `FORBIDDEN` (usuário inativo ou sem
  /// convite).
  _ida.Future<List<_i11upz4e.TenantSummary>> myTenants() => caller.callServerEndpoint<List<_i11upz4e.TenantSummary>>(
    'auth',
    'myTenants',
    {},
  );
}

/// `emailIdp.*` — login por e-mail e senha (módulo do Serverpod).
///
/// Cada método anexa o contexto anônimo antes de tocar no banco (as tabelas do
/// módulo ficam em `public`, fora da RLS). O cadastro só abre para e-mails
/// convidados: para os demais responde um id aleatório, igual ao que o módulo
/// faz para e-mail já cadastrado, sem revelar se o e-mail existe.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) => caller.callServerEndpoint<_isc.UuidValue>(
    'emailIdp',
    'startRegistration',
    {'email': email},
  );

  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) => caller.callServerEndpoint<_isc.UuidValue>(
    'emailIdp',
    'startPasswordReset',
    {'email': email},
  );

  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// `me.*` — usuário autenticado, tenant ativo e permissões (docs/08 §3.2).
/// {@category Endpoint}
class EndpointMe extends EndpointStaff {
  EndpointMe(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'me';

  /// Usuário, tenant ativo, papéis e permissões efetivas, relidos do banco.
  _ida.Future<_i8cz5om6.MeInfo> get() => caller.callServerEndpoint<_i8cz5om6.MeInfo>(
    'me',
    'get',
    {},
  );

  /// Tenants em que o usuário tem vínculo, para a troca de tenant.
  _ida.Future<List<_i11upz4e.TenantSummary>> tenants() => caller.callServerEndpoint<List<_i11upz4e.TenantSummary>>(
    'me',
    'tenants',
    {},
  );
}

/// `refreshJwtTokens.*` — renova a sessão de login (refresh token do módulo).
/// {@category Endpoint}
class EndpointRefreshJwtTokens extends _iacc.EndpointRefreshJwtTokens {
  EndpointRefreshJwtTokens(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'refreshJwtTokens';

  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'refreshJwtTokens',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// `users.*` — controle de usuários da empresa (permissão `users.manage`,
/// que o perfil `tenant_admin` tem).
///
/// Erros: `FORBIDDEN` (sem permissão), `VALIDATION_FAILED`, `NOT_FOUND`,
/// `ALREADY_MEMBER`, `LAST_TENANT_ADMIN`, `CANNOT_CHANGE_OWN_ACCESS`,
/// `INVALID_STATUS`, `NOT_INVITED`, `INVITE_EMAIL_FAILED` (convite salvo, e-mail
/// não saiu).
/// {@category Endpoint}
class EndpointUsers extends EndpointStaff {
  EndpointUsers(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'users';

  /// Perfis que podem ser atribuídos.
  _ida.Future<List<_i2g1699a.AssignableRole>> roles() => caller.callServerEndpoint<List<_i2g1699a.AssignableRole>>(
    'users',
    'roles',
    {},
  );

  /// Pessoas com acesso à empresa (convidadas, ativas e suspensas).
  _ida.Future<List<_i8ihd43z.TenantUser>> list() => caller.callServerEndpoint<List<_i8ihd43z.TenantUser>>(
    'users',
    'list',
    {},
  );

  /// Convida pelo e-mail. A pessoa cria a senha no primeiro acesso e, ao
  /// escolher a empresa, o convite vira acesso ativo.
  _ida.Future<_i8ihd43z.TenantUser> invite(
    String email,
    String fullName,
    List<String> roles,
  ) => caller.callServerEndpoint<_i8ihd43z.TenantUser>(
    'users',
    'invite',
    {
      'email': email,
      'fullName': fullName,
      'roles': roles,
    },
  );

  /// Manda o e-mail de convite de novo (só para quem ainda não entrou).
  _ida.Future<_i8ihd43z.TenantUser> resendInvite(_isc.UuidValue membershipId) =>
      caller.callServerEndpoint<_i8ihd43z.TenantUser>(
        'users',
        'resendInvite',
        {'membershipId': membershipId},
      );

  /// Troca os perfis (a lista substitui a anterior).
  _ida.Future<_i8ihd43z.TenantUser> setRoles(
    _isc.UuidValue membershipId,
    List<String> roles,
  ) => caller.callServerEndpoint<_i8ihd43z.TenantUser>(
    'users',
    'setRoles',
    {
      'membershipId': membershipId,
      'roles': roles,
    },
  );

  _ida.Future<_i8ihd43z.TenantUser> suspend(_isc.UuidValue membershipId) =>
      caller.callServerEndpoint<_i8ihd43z.TenantUser>(
        'users',
        'suspend',
        {'membershipId': membershipId},
      );

  _ida.Future<_i8ihd43z.TenantUser> reactivate(_isc.UuidValue membershipId) =>
      caller.callServerEndpoint<_i8ihd43z.TenantUser>(
        'users',
        'reactivate',
        {'membershipId': membershipId},
      );

  /// Tira o acesso; o histórico fica e a pessoa pode ser convidada de novo.
  _ida.Future<_i8ihd43z.TenantUser> remove(_isc.UuidValue membershipId) =>
      caller.callServerEndpoint<_i8ihd43z.TenantUser>(
        'users',
        'remove',
        {'membershipId': membershipId},
      );
}

/// `depreciation.*` — ficha patrimonial, memória de cálculo, posição mensal e
/// fechamento da competência (livro gerencial). Valores em centavos. Erros:
/// `FORBIDDEN`, `VALIDATION_FAILED`, `NOT_FOUND`, `VERSION_MISMATCH`,
/// `PROFILE_EXISTS`, `COST_REQUIRED`, `PERIOD_IN_FUTURE`, `ALREADY_CLOSED`,
/// `PERIOD_OUT_OF_ORDER`, `NOT_CLOSED`, `NOT_LATEST_CLOSING`.
/// {@category Endpoint}
class EndpointDepreciation extends EndpointStaff {
  EndpointDepreciation(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'depreciation';

  /// Ficha do bem, ou nulo se ainda não tem.
  _ida.Future<_i0ewj4w5.DepreciationProfile?> profile(_isc.UuidValue assetId) =>
      caller.callServerEndpoint<_i0ewj4w5.DepreciationProfile?>(
        'depreciation',
        'profile',
        {'assetId': assetId},
      );

  /// Cria ([expectedVersion] nulo) ou altera a ficha.
  _ida.Future<_i0ewj4w5.DepreciationProfile> saveProfile(
    _isc.UuidValue assetId,
    int? expectedVersion,
    _ihghh0c1.DepreciationProfileInput input,
  ) => caller.callServerEndpoint<_i0ewj4w5.DepreciationProfile>(
    'depreciation',
    'saveProfile',
    {
      'assetId': assetId,
      'expectedVersion': expectedVersion,
      'input': input,
    },
  );

  /// Memória de cálculo mês a mês.
  _ida.Future<_irg3uuam.AssetDepreciation> schedule(_isc.UuidValue assetId) =>
      caller.callServerEndpoint<_irg3uuam.AssetDepreciation>(
        'depreciation',
        'schedule',
        {'assetId': assetId},
      );

  _ida.Future<_i8b4ltth.DepreciationPosition> position(
    int year,
    int month, {
    _isc.UuidValue? branchId,
    _isc.UuidValue? costCenterId,
  }) => caller.callServerEndpoint<_i8b4ltth.DepreciationPosition>(
    'depreciation',
    'position',
    {
      'year': year,
      'month': month,
      'branchId': branchId,
      'costCenterId': costCenterId,
    },
  );

  _ida.Future<List<_iqiiy4eg.DepreciationClosing>> closings() =>
      caller.callServerEndpoint<List<_iqiiy4eg.DepreciationClosing>>(
        'depreciation',
        'closings',
        {},
      );

  _ida.Future<_iqiiy4eg.DepreciationClosing> close(
    int year,
    int month,
  ) => caller.callServerEndpoint<_iqiiy4eg.DepreciationClosing>(
    'depreciation',
    'close',
    {
      'year': year,
      'month': month,
    },
  );

  _ida.Future<_iqiiy4eg.DepreciationClosing> reopen(
    int year,
    int month,
    String reason,
  ) => caller.callServerEndpoint<_iqiiy4eg.DepreciationClosing>(
    'depreciation',
    'reopen',
    {
      'year': year,
      'month': month,
      'reason': reason,
    },
  );
}

/// Classes-base por tipo de token (docs/08 §2.2): um token de contato nunca
/// passa num endpoint da equipe e vice-versa. A permissão fina (papel, escopo
/// de carteira, prestador ou filial) é conferida por método.
/// Backoffice e técnico: exige token de tenant (`aud = plataforma-os:staff`).
/// {@category Endpoint}
abstract class EndpointStaff extends _isc.EndpointRef {
  EndpointStaff(_isc.EndpointCaller caller) : super(caller);
}

/// App do cliente: exige token de contato.
/// {@category Endpoint}
abstract class EndpointCustomer extends _isc.EndpointRef {
  EndpointCustomer(_isc.EndpointCaller caller) : super(caller);
}

/// Métodos públicos (QR, OTP, troca de token). Cada método chama
/// `session.useAnonymousContext()` antes de usar o banco.
///
/// Atenção: todo método público de uma classe de endpoint vira RPC no
/// Serverpod; helpers ficam em extensões ou em `internal/`, nunca aqui.
/// {@category Endpoint}
abstract class EndpointPublic extends _isc.EndpointRef {
  EndpointPublic(_isc.EndpointCaller caller) : super(caller);
}

/// `attachments.*` — envio e download dos arquivos de fotos e assinaturas
/// (docs/06 §6.10). O registro do anexo vem pela fila do sync
/// (`attachment.register`); aqui só as chamadas que exigem rede. Erros:
/// `FORBIDDEN`, `NOT_FOUND`, `STORAGE_UNAVAILABLE`, `ALREADY_UPLOADED`,
/// `UPLOAD_MISSING`, `UPLOAD_MISMATCH`, `NOT_UPLOADED`.
/// {@category Endpoint}
class EndpointAttachments extends EndpointStaff {
  EndpointAttachments(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'attachments';

  /// URL pré-assinada (15 min) para o aparelho enviar o arquivo com PUT.
  _ida.Future<_ictou6wh.AttachmentUpload> uploadUrl(_isc.UuidValue attachmentId) =>
      caller.callServerEndpoint<_ictou6wh.AttachmentUpload>(
        'attachments',
        'uploadUrl',
        {'attachmentId': attachmentId},
      );

  /// Confere o arquivo enviado (tamanho e sha256) e marca como enviado.
  _ida.Future<_ixilyq04.Attachment> confirmUpload(_isc.UuidValue attachmentId) =>
      caller.callServerEndpoint<_ixilyq04.Attachment>(
        'attachments',
        'confirmUpload',
        {'attachmentId': attachmentId},
      );

  /// Fotos e assinaturas das visitas da OS.
  _ida.Future<List<_ixilyq04.Attachment>> ofWorkOrder(_isc.UuidValue workOrderId) =>
      caller.callServerEndpoint<List<_ixilyq04.Attachment>>(
        'attachments',
        'ofWorkOrder',
        {'workOrderId': workOrderId},
      );

  /// URL pré-assinada (15 min) para baixar o arquivo.
  _ida.Future<String> downloadUrl(_isc.UuidValue attachmentId) => caller.callServerEndpoint<String>(
    'attachments',
    'downloadUrl',
    {'attachmentId': attachmentId},
  );
}

/// `technicians.*` — técnicos próprios. Erros: `FORBIDDEN`,
/// `VALIDATION_FAILED`, `NOT_FOUND`, `VERSION_MISMATCH`.
/// {@category Endpoint}
class EndpointTechnicians extends EndpointStaff {
  EndpointTechnicians(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'technicians';

  _ida.Future<List<_ikjr2b9x.Technician>> list({bool? includeInactive}) =>
      caller.callServerEndpoint<List<_ikjr2b9x.Technician>>(
        'technicians',
        'list',
        {'includeInactive': includeInactive},
      );

  /// Técnico ligado a quem está logado (app de campo), ou nulo.
  _ida.Future<_ikjr2b9x.Technician?> mine() => caller.callServerEndpoint<_ikjr2b9x.Technician?>(
    'technicians',
    'mine',
    {},
  );

  _ida.Future<_ikjr2b9x.Technician> create(_ixaduq6k.TechnicianInput input) =>
      caller.callServerEndpoint<_ikjr2b9x.Technician>(
        'technicians',
        'create',
        {'input': input},
      );

  _ida.Future<_ikjr2b9x.Technician> update(
    _isc.UuidValue id,
    int expectedVersion,
    _ixaduq6k.TechnicianInput input,
  ) => caller.callServerEndpoint<_ikjr2b9x.Technician>(
    'technicians',
    'update',
    {
      'id': id,
      'expectedVersion': expectedVersion,
      'input': input,
    },
  );
}

/// `visits.*` — agenda (despacho) e execução da visita pelo técnico. Toda
/// mudança recebe a versão lida (`expectedVersion`) e devolve a visita com o
/// status atual da OS. Erros: `FORBIDDEN`, `VALIDATION_FAILED`, `NOT_FOUND`,
/// `VERSION_MISMATCH`, `INVALID_TRANSITION`, `WORK_ORDER_NOT_SCHEDULABLE`,
/// `VISIT_NOT_SCHEDULED`, `ANOTHER_VISIT_ACTIVE`, `QR_ASSET_MISMATCH`,
/// `CHECK_IN_REQUIRED`, `CHECKLIST_REQUIRED`.
/// {@category Endpoint}
class EndpointVisits extends EndpointStaff {
  EndpointVisits(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'visits';

  /// Visitas que começam no período [from, to) (até 62 dias).
  _ida.Future<List<_isvtjvq7.Visit>> agenda(
    DateTime from,
    DateTime to, {
    _isc.UuidValue? technicianId,
    bool? includeCancelled,
  }) => caller.callServerEndpoint<List<_isvtjvq7.Visit>>(
    'visits',
    'agenda',
    {
      'from': from,
      'to': to,
      'technicianId': technicianId,
      'includeCancelled': includeCancelled,
    },
  );

  /// Visitas do técnico logado no período, mais as que estão em andamento.
  _ida.Future<List<_isvtjvq7.Visit>> mine(
    DateTime from,
    DateTime to,
  ) => caller.callServerEndpoint<List<_isvtjvq7.Visit>>(
    'visits',
    'mine',
    {
      'from': from,
      'to': to,
    },
  );

  _ida.Future<List<_isvtjvq7.Visit>> ofWorkOrder(_isc.UuidValue workOrderId) =>
      caller.callServerEndpoint<List<_isvtjvq7.Visit>>(
        'visits',
        'ofWorkOrder',
        {'workOrderId': workOrderId},
      );

  /// Checklists respondidos nas visitas da OS.
  _ida.Future<List<_is9a6d8i.VisitChecklist>> checklistsOfWorkOrder(_isc.UuidValue workOrderId) =>
      caller.callServerEndpoint<List<_is9a6d8i.VisitChecklist>>(
        'visits',
        'checklistsOfWorkOrder',
        {'workOrderId': workOrderId},
      );

  _ida.Future<_isvtjvq7.Visit> get(_isc.UuidValue id) => caller.callServerEndpoint<_isvtjvq7.Visit>(
    'visits',
    'get',
    {'id': id},
  );

  _ida.Future<_isvtjvq7.Visit> schedule(
    _isc.UuidValue workOrderId,
    _ivjpdmyn.VisitInput input,
  ) => caller.callServerEndpoint<_isvtjvq7.Visit>(
    'visits',
    'schedule',
    {
      'workOrderId': workOrderId,
      'input': input,
    },
  );

  _ida.Future<_isvtjvq7.Visit> reschedule(
    _isc.UuidValue id,
    int expectedVersion,
    _ivjpdmyn.VisitInput input,
  ) => caller.callServerEndpoint<_isvtjvq7.Visit>(
    'visits',
    'reschedule',
    {
      'id': id,
      'expectedVersion': expectedVersion,
      'input': input,
    },
  );

  _ida.Future<_isvtjvq7.Visit> cancel(
    _isc.UuidValue id,
    int expectedVersion,
    String reason,
  ) => caller.callServerEndpoint<_isvtjvq7.Visit>(
    'visits',
    'cancel',
    {
      'id': id,
      'expectedVersion': expectedVersion,
      'reason': reason,
    },
  );

  _ida.Future<_isvtjvq7.Visit> startTravel(
    _isc.UuidValue id,
    int expectedVersion,
  ) => caller.callServerEndpoint<_isvtjvq7.Visit>(
    'visits',
    'startTravel',
    {
      'id': id,
      'expectedVersion': expectedVersion,
    },
  );

  _ida.Future<_isvtjvq7.Visit> checkIn(
    _isc.UuidValue id,
    int expectedVersion,
    _ias7e1vu.VisitCheckIn input,
  ) => caller.callServerEndpoint<_isvtjvq7.Visit>(
    'visits',
    'checkIn',
    {
      'id': id,
      'expectedVersion': expectedVersion,
      'input': input,
    },
  );

  _ida.Future<_isvtjvq7.Visit> pause(
    _isc.UuidValue id,
    int expectedVersion,
  ) => caller.callServerEndpoint<_isvtjvq7.Visit>(
    'visits',
    'pause',
    {
      'id': id,
      'expectedVersion': expectedVersion,
    },
  );

  _ida.Future<_isvtjvq7.Visit> resume(
    _isc.UuidValue id,
    int expectedVersion,
  ) => caller.callServerEndpoint<_isvtjvq7.Visit>(
    'visits',
    'resume',
    {
      'id': id,
      'expectedVersion': expectedVersion,
    },
  );

  _ida.Future<_isvtjvq7.Visit> finish(
    _isc.UuidValue id,
    int expectedVersion,
    _ikfe26w9.VisitFinish input,
  ) => caller.callServerEndpoint<_isvtjvq7.Visit>(
    'visits',
    'finish',
    {
      'id': id,
      'expectedVersion': expectedVersion,
      'input': input,
    },
  );
}

/// `technicianSync.*` — sincronização do app do técnico (docs/06 §6). Erros:
/// `FORBIDDEN`, `VALIDATION_FAILED`, `DEVICE_NOT_REGISTERED`, `DEVICE_BLOCKED`.
/// Recusas de cada mutação vêm no resultado, não como exceção.
/// {@category Endpoint}
class EndpointTechnicianSync extends EndpointStaff {
  EndpointTechnicianSync(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'technicianSync';

  /// Registra (ou atualiza) o aparelho; chamar ao entrar na empresa.
  _ida.Future<void> registerDevice(_iam7n156.DeviceRegistration input) => caller.callServerEndpoint<void>(
    'technicianSync',
    'registerDevice',
    {'input': input},
  );

  /// Recorte atual do técnico.
  _ida.Future<_irdeaok0.SyncPullResult> pull(_isc.UuidValue deviceId) =>
      caller.callServerEndpoint<_irdeaok0.SyncPullResult>(
        'technicianSync',
        'pull',
        {'deviceId': deviceId},
      );

  /// Aplica as ações feitas no aparelho, na ordem, e devolve um resultado por
  /// ação.
  _ida.Future<List<_ief0slxz.SyncMutationResult>> push(_i65q2o7k.SyncPushRequest request) =>
      caller.callServerEndpoint<List<_ief0slxz.SyncMutationResult>>(
        'technicianSync',
        'push',
        {'request': request},
      );
}

/// `branches.*` — filiais. Leitura para a equipe; alteração com
/// `settings.manage` (administrador). Erros: `FORBIDDEN`, `VALIDATION_FAILED`,
/// `NOT_FOUND`, `VERSION_MISMATCH`, `DEFAULT_BRANCH_REQUIRED`.
/// {@category Endpoint}
class EndpointBranches extends EndpointStaff {
  EndpointBranches(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'branches';

  _ida.Future<List<_ied3wtyg.Branch>> list({bool? includeInactive}) =>
      caller.callServerEndpoint<List<_ied3wtyg.Branch>>(
        'branches',
        'list',
        {'includeInactive': includeInactive},
      );

  _ida.Future<_ied3wtyg.Branch> create(_il2pvpfo.BranchInput input) => caller.callServerEndpoint<_ied3wtyg.Branch>(
    'branches',
    'create',
    {'input': input},
  );

  _ida.Future<_ied3wtyg.Branch> update(
    _isc.UuidValue id,
    int expectedVersion,
    _il2pvpfo.BranchInput input,
  ) => caller.callServerEndpoint<_ied3wtyg.Branch>(
    'branches',
    'update',
    {
      'id': id,
      'expectedVersion': expectedVersion,
      'input': input,
    },
  );
}

/// `costCenters.*` — centros de custo. Leitura para a equipe (com [branchId],
/// os da filial e os que valem para todas); alteração com `settings.manage`.
/// {@category Endpoint}
class EndpointCostCenters extends EndpointStaff {
  EndpointCostCenters(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'costCenters';

  _ida.Future<List<_itoq0gfy.CostCenter>> list({
    _isc.UuidValue? branchId,
    bool? includeInactive,
  }) => caller.callServerEndpoint<List<_itoq0gfy.CostCenter>>(
    'costCenters',
    'list',
    {
      'branchId': branchId,
      'includeInactive': includeInactive,
    },
  );

  _ida.Future<_itoq0gfy.CostCenter> create(_iusx5jxf.CostCenterInput input) =>
      caller.callServerEndpoint<_itoq0gfy.CostCenter>(
        'costCenters',
        'create',
        {'input': input},
      );

  _ida.Future<_itoq0gfy.CostCenter> update(
    _isc.UuidValue id,
    int expectedVersion,
    _iusx5jxf.CostCenterInput input,
  ) => caller.callServerEndpoint<_itoq0gfy.CostCenter>(
    'costCenters',
    'update',
    {
      'id': id,
      'expectedVersion': expectedVersion,
      'input': input,
    },
  );
}

/// `workOrders.*` — ordens de serviço e tipos de OS. Toda mudança recebe a
/// versão lida (`expectedVersion`). Erros: `FORBIDDEN`, `VALIDATION_FAILED`,
/// `NOT_FOUND`, `VERSION_MISMATCH`, `INVALID_TRANSITION`,
/// `WORK_ORDER_FINISHED`, `ASSET_RETIRED`, `ASSET_INACTIVE`, `TAG_NOT_BOUND`,
/// `TAG_REVOKED`.
/// {@category Endpoint}
class EndpointWorkOrders extends EndpointStaff {
  EndpointWorkOrders(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'workOrders';

  /// [search] procura no número, no patrimônio, na série e na descrição.
  /// [openOnly] = solicitada, aberta, agendada, em atendimento ou pendente.
  _ida.Future<_i3z3e08i.WorkOrderPage> list({
    String? search,
    List<String>? statuses,
    bool? openOnly,
    _isc.UuidValue? assetId,
    _isc.UuidValue? branchId,
    _isc.UuidValue? costCenterId,
    _isc.UuidValue? workOrderTypeId,
    int? limit,
    int? offset,
  }) => caller.callServerEndpoint<_i3z3e08i.WorkOrderPage>(
    'workOrders',
    'list',
    {
      'search': search,
      'statuses': statuses,
      'openOnly': openOnly,
      'assetId': assetId,
      'branchId': branchId,
      'costCenterId': costCenterId,
      'workOrderTypeId': workOrderTypeId,
      'limit': limit,
      'offset': offset,
    },
  );

  _ida.Future<_i96vhhgb.WorkOrderDetail> get(_isc.UuidValue id) => caller.callServerEndpoint<_i96vhhgb.WorkOrderDetail>(
    'workOrders',
    'get',
    {'id': id},
  );

  /// Abre a OS já aberta (`open`). A resposta traz as outras OS em aberto do
  /// mesmo bem, para o aviso de chamado duplicado.
  _ida.Future<_i96vhhgb.WorkOrderDetail> open(_ikxgyzb6.WorkOrderInput input) =>
      caller.callServerEndpoint<_i96vhhgb.WorkOrderDetail>(
        'workOrders',
        'open',
        {'input': input},
      );

  _ida.Future<_ijkllwf7.WorkOrder> update(
    _isc.UuidValue id,
    int expectedVersion,
    _i9dox7p2.WorkOrderChanges changes,
  ) => caller.callServerEndpoint<_ijkllwf7.WorkOrder>(
    'workOrders',
    'update',
    {
      'id': id,
      'expectedVersion': expectedVersion,
      'changes': changes,
    },
  );

  _ida.Future<_ijkllwf7.WorkOrder> start(
    _isc.UuidValue id,
    int expectedVersion,
  ) => caller.callServerEndpoint<_ijkllwf7.WorkOrder>(
    'workOrders',
    'start',
    {
      'id': id,
      'expectedVersion': expectedVersion,
    },
  );

  _ida.Future<_ijkllwf7.WorkOrder> hold(
    _isc.UuidValue id,
    int expectedVersion,
    String holdReason, {
    String? note,
  }) => caller.callServerEndpoint<_ijkllwf7.WorkOrder>(
    'workOrders',
    'hold',
    {
      'id': id,
      'expectedVersion': expectedVersion,
      'holdReason': holdReason,
      'note': note,
    },
  );

  _ida.Future<_ijkllwf7.WorkOrder> complete(
    _isc.UuidValue id,
    int expectedVersion,
    String resolutionNotes,
  ) => caller.callServerEndpoint<_ijkllwf7.WorkOrder>(
    'workOrders',
    'complete',
    {
      'id': id,
      'expectedVersion': expectedVersion,
      'resolutionNotes': resolutionNotes,
    },
  );

  _ida.Future<_ijkllwf7.WorkOrder> close(
    _isc.UuidValue id,
    int expectedVersion,
  ) => caller.callServerEndpoint<_ijkllwf7.WorkOrder>(
    'workOrders',
    'close',
    {
      'id': id,
      'expectedVersion': expectedVersion,
    },
  );

  _ida.Future<_ijkllwf7.WorkOrder> cancel(
    _isc.UuidValue id,
    int expectedVersion,
    String reason, {
    String? note,
  }) => caller.callServerEndpoint<_ijkllwf7.WorkOrder>(
    'workOrders',
    'cancel',
    {
      'id': id,
      'expectedVersion': expectedVersion,
      'reason': reason,
      'note': note,
    },
  );

  _ida.Future<_ijkllwf7.WorkOrder> reopen(
    _isc.UuidValue id,
    int expectedVersion,
    String reason,
  ) => caller.callServerEndpoint<_ijkllwf7.WorkOrder>(
    'workOrders',
    'reopen',
    {
      'id': id,
      'expectedVersion': expectedVersion,
      'reason': reason,
    },
  );

  _ida.Future<List<_iufozffx.WorkOrderType>> types({bool? includeInactive}) =>
      caller.callServerEndpoint<List<_iufozffx.WorkOrderType>>(
        'workOrders',
        'types',
        {'includeInactive': includeInactive},
      );

  _ida.Future<_iufozffx.WorkOrderType> createType(_i6v2tjgk.WorkOrderTypeInput input) =>
      caller.callServerEndpoint<_iufozffx.WorkOrderType>(
        'workOrders',
        'createType',
        {'input': input},
      );

  _ida.Future<_iufozffx.WorkOrderType> updateType(
    _isc.UuidValue id,
    int expectedVersion,
    _i6v2tjgk.WorkOrderTypeInput input,
  ) => caller.callServerEndpoint<_iufozffx.WorkOrderType>(
    'workOrders',
    'updateType',
    {
      'id': id,
      'expectedVersion': expectedVersion,
      'input': input,
    },
  );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection: disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    assets = EndpointAssets(this);
    qrTags = EndpointQrTags(this);
    checklists = EndpointChecklists(this);
    products = EndpointProducts(this);
    customers = EndpointCustomers(this);
    auth = EndpointAuth(this);
    emailIdp = EndpointEmailIdp(this);
    me = EndpointMe(this);
    refreshJwtTokens = EndpointRefreshJwtTokens(this);
    users = EndpointUsers(this);
    depreciation = EndpointDepreciation(this);
    attachments = EndpointAttachments(this);
    technicians = EndpointTechnicians(this);
    visits = EndpointVisits(this);
    technicianSync = EndpointTechnicianSync(this);
    branches = EndpointBranches(this);
    costCenters = EndpointCostCenters(this);
    workOrders = EndpointWorkOrders(this);
    modules = Modules(this);
  }

  late final EndpointAssets assets;

  late final EndpointQrTags qrTags;

  late final EndpointChecklists checklists;

  late final EndpointProducts products;

  late final EndpointCustomers customers;

  late final EndpointAuth auth;

  late final EndpointEmailIdp emailIdp;

  late final EndpointMe me;

  late final EndpointRefreshJwtTokens refreshJwtTokens;

  late final EndpointUsers users;

  late final EndpointDepreciation depreciation;

  late final EndpointAttachments attachments;

  late final EndpointTechnicians technicians;

  late final EndpointVisits visits;

  late final EndpointTechnicianSync technicianSync;

  late final EndpointBranches branches;

  late final EndpointCostCenters costCenters;

  late final EndpointWorkOrders workOrders;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'assets': assets,
    'qrTags': qrTags,
    'checklists': checklists,
    'products': products,
    'customers': customers,
    'auth': auth,
    'emailIdp': emailIdp,
    'me': me,
    'refreshJwtTokens': refreshJwtTokens,
    'users': users,
    'depreciation': depreciation,
    'attachments': attachments,
    'technicians': technicians,
    'visits': visits,
    'technicianSync': technicianSync,
    'branches': branches,
    'costCenters': costCenters,
    'workOrders': workOrders,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
