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
import 'package:plataforma_os_client/src/protocol/assets/models/asset_input.dart' as _i3bfa7rs;
import 'package:plataforma_os_client/src/protocol/assets/models/asset_page.dart' as _ih5rjonj;
import 'package:plataforma_os_client/src/protocol/assets/models/qr_tag.dart' as _ix23buzf;
import 'package:plataforma_os_client/src/protocol/assets/models/qr_tag_batch.dart' as _ic9pb02v;
import 'package:plataforma_os_client/src/protocol/catalog/models/product_input.dart' as _i2gecgw3;
import 'package:plataforma_os_client/src/protocol/catalog/models/product_summary.dart' as _ihgw7zuo;
import 'package:plataforma_os_client/src/protocol/identity_access/models/assignable_role.dart' as _i2g1699a;
import 'package:plataforma_os_client/src/protocol/identity_access/models/me_info.dart' as _i8cz5om6;
import 'package:plataforma_os_client/src/protocol/identity_access/models/tenant_token.dart' as _ii663qav;
import 'package:plataforma_os_client/src/protocol/identity_access/models/tenant_user.dart' as _i8ihd43z;
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

/// `assets.*` — cadastro de bens. Erros: `FORBIDDEN`, `VALIDATION_FAILED`,
/// `NOT_FOUND`, `VERSION_MISMATCH`, `ERP_MASTER_READ_ONLY`.
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
/// `INVALID_STATUS`.
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
    products = EndpointProducts(this);
    auth = EndpointAuth(this);
    emailIdp = EndpointEmailIdp(this);
    me = EndpointMe(this);
    refreshJwtTokens = EndpointRefreshJwtTokens(this);
    users = EndpointUsers(this);
    branches = EndpointBranches(this);
    costCenters = EndpointCostCenters(this);
    workOrders = EndpointWorkOrders(this);
    modules = Modules(this);
  }

  late final EndpointAssets assets;

  late final EndpointQrTags qrTags;

  late final EndpointProducts products;

  late final EndpointAuth auth;

  late final EndpointEmailIdp emailIdp;

  late final EndpointMe me;

  late final EndpointRefreshJwtTokens refreshJwtTokens;

  late final EndpointUsers users;

  late final EndpointBranches branches;

  late final EndpointCostCenters costCenters;

  late final EndpointWorkOrders workOrders;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'assets': assets,
    'qrTags': qrTags,
    'products': products,
    'auth': auth,
    'emailIdp': emailIdp,
    'me': me,
    'refreshJwtTokens': refreshJwtTokens,
    'users': users,
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
