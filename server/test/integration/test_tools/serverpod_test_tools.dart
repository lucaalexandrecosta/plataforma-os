/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: no_leading_underscores_for_local_identifiers

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'dart:io' as _idi;
import 'package:plataforma_os_server/src/generated/assets/models/asset.dart' as _iceem167;
import 'package:plataforma_os_server/src/generated/assets/models/asset_assignment.dart' as _iqmm5djm;
import 'package:plataforma_os_server/src/generated/assets/models/asset_input.dart' as _i58orcz5;
import 'package:plataforma_os_server/src/generated/assets/models/asset_install_input.dart' as _iggraypf;
import 'package:plataforma_os_server/src/generated/assets/models/asset_page.dart' as _i7jxv3j6;
import 'package:plataforma_os_server/src/generated/assets/models/asset_withdraw_input.dart' as _ilt8ymra;
import 'package:plataforma_os_server/src/generated/assets/models/qr_tag.dart' as _idzaz83i;
import 'package:plataforma_os_server/src/generated/assets/models/qr_tag_batch.dart' as _i07n19u6;
import 'package:plataforma_os_server/src/generated/catalog/models/checklist_template.dart' as _inu2ctxp;
import 'package:plataforma_os_server/src/generated/catalog/models/checklist_template_input.dart' as _ifjv7krc;
import 'package:plataforma_os_server/src/generated/catalog/models/product_input.dart' as _iku7g2we;
import 'package:plataforma_os_server/src/generated/catalog/models/product_summary.dart' as _ico54ik3;
import 'package:plataforma_os_server/src/generated/customers/models/customer.dart' as _iejihgcl;
import 'package:plataforma_os_server/src/generated/customers/models/customer_contact.dart' as _in02tur2;
import 'package:plataforma_os_server/src/generated/customers/models/customer_contact_input.dart' as _i0rc22zw;
import 'package:plataforma_os_server/src/generated/customers/models/customer_import_report.dart' as _icd2pnum;
import 'package:plataforma_os_server/src/generated/customers/models/customer_import_row.dart' as _is65d1g1;
import 'package:plataforma_os_server/src/generated/customers/models/customer_input.dart' as _iw3fixvn;
import 'package:plataforma_os_server/src/generated/customers/models/customer_page.dart' as _ivfmmfkq;
import 'package:plataforma_os_server/src/generated/customers/models/customer_site.dart' as _ing115qe;
import 'package:plataforma_os_server/src/generated/customers/models/customer_site_input.dart' as _iv6e8owq;
import 'package:plataforma_os_server/src/generated/identity_access/models/assignable_role.dart' as _iur1xixc;
import 'package:plataforma_os_server/src/generated/identity_access/models/me_info.dart' as _i70n7l3r;
import 'package:plataforma_os_server/src/generated/identity_access/models/tenant_token.dart' as _inkkpwsp;
import 'package:plataforma_os_server/src/generated/identity_access/models/tenant_user.dart' as _iqhozu6i;
import 'package:plataforma_os_server/src/generated/patrimony/models/asset_depreciation.dart' as _ic6r3pi5;
import 'package:plataforma_os_server/src/generated/patrimony/models/depreciation_closing.dart' as _ip56mlnh;
import 'package:plataforma_os_server/src/generated/patrimony/models/depreciation_position.dart' as _ijwc67wv;
import 'package:plataforma_os_server/src/generated/patrimony/models/depreciation_profile.dart' as _idh96kkc;
import 'package:plataforma_os_server/src/generated/patrimony/models/depreciation_profile_input.dart' as _ims07aom;
import 'package:plataforma_os_server/src/generated/scheduling/models/technician.dart' as _ixvhwnkq;
import 'package:plataforma_os_server/src/generated/scheduling/models/technician_input.dart' as _i4g4d70s;
import 'package:plataforma_os_server/src/generated/scheduling/models/visit.dart' as _iezjjcq0;
import 'package:plataforma_os_server/src/generated/scheduling/models/visit_check_in.dart' as _in4grqdw;
import 'package:plataforma_os_server/src/generated/scheduling/models/visit_checklist.dart' as _iblxfzeg;
import 'package:plataforma_os_server/src/generated/scheduling/models/visit_finish.dart' as _izl7q3ap;
import 'package:plataforma_os_server/src/generated/scheduling/models/visit_input.dart' as _isygpo5n;
import 'package:plataforma_os_server/src/generated/sync/models/device_registration.dart' as _ifayztnr;
import 'package:plataforma_os_server/src/generated/sync/models/sync_mutation_result.dart' as _ilt9w9x8;
import 'package:plataforma_os_server/src/generated/sync/models/sync_pull_result.dart' as _iw54s95p;
import 'package:plataforma_os_server/src/generated/sync/models/sync_push_request.dart' as _is7nu1l0;
import 'package:plataforma_os_server/src/generated/tenancy/models/branch.dart' as _i7vupwwc;
import 'package:plataforma_os_server/src/generated/tenancy/models/branch_input.dart' as _i6djw631;
import 'package:plataforma_os_server/src/generated/tenancy/models/cost_center.dart' as _islkyssd;
import 'package:plataforma_os_server/src/generated/tenancy/models/cost_center_input.dart' as _irkypkua;
import 'package:plataforma_os_server/src/generated/tenancy/models/tenant_summary.dart' as _inphvrgt;
import 'package:plataforma_os_server/src/generated/work_orders/models/work_order.dart' as _ih47bshy;
import 'package:plataforma_os_server/src/generated/work_orders/models/work_order_changes.dart' as _im8hf6je;
import 'package:plataforma_os_server/src/generated/work_orders/models/work_order_detail.dart' as _i5ujk65j;
import 'package:plataforma_os_server/src/generated/work_orders/models/work_order_input.dart' as _is40rk4d;
import 'package:plataforma_os_server/src/generated/work_orders/models/work_order_page.dart' as _im7kyfxz;
import 'package:plataforma_os_server/src/generated/work_orders/models/work_order_type.dart' as _ith5np2m;
import 'package:plataforma_os_server/src/generated/work_orders/models/work_order_type_input.dart' as _i56uux5g;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart' as _iacs;
import 'package:serverpod_test/serverpod_test.dart' as _ist;
import 'package:plataforma_os_server/src/generated/protocol.dart';
import 'package:plataforma_os_server/src/generated/endpoints.dart';
export 'package:serverpod_test/serverpod_test_public_exports.dart';

/// Creates a new test group that takes a callback that can be used to write tests.
/// The callback has two parameters: `sessionBuilder` and `endpoints`.
/// `sessionBuilder` is used to build a `Session` object that represents the server state during an endpoint call and is used to set up scenarios.
/// `endpoints` contains all your Serverpod endpoints and lets you call them:
/// ```dart
/// withServerpod('Given Example endpoint', (sessionBuilder, endpoints) {
///   test('when calling `hello` then should return greeting', () async {
///     final greeting = await endpoints.example.hello(sessionBuilder, 'Michael');
///     expect(greeting, 'Hello Michael');
///   });
/// });
/// ```
///
/// **Configuration options**
///
/// [applyMigrations] Whether pending migrations should be applied when starting Serverpod. Defaults to `true`
///
/// [enableSessionLogging] Whether session logging should be enabled. Defaults to `false`
///
/// [ephemeralDatabase] Whether this group gets its own empty database, created when the group starts and dropped when it finishes. Defaults to `true`.
/// Set this to `false` to use the database configured for [runMode], including a previously seeded database. [configOverride] can still replace that database. The configured database is not created or dropped, so groups that share it cannot run in parallel. [rollbackDatabase] still controls whether writes inside the group are rolled back.
///
/// [rollbackDatabase] Options for when to rollback the database during the test lifecycle.
/// By default `withServerpod` does all database operations inside a transaction that is rolled back after each `test` case.
/// Just like the following enum describes, the behavior of the automatic rollbacks can be configured:
/// ```dart
/// /// Options for when to rollback the database during the test lifecycle.
/// enum RollbackDatabase {
///   /// After each test. This is the default.
///   afterEach,
///
///   /// After all tests.
///   afterAll,
///
///   /// Disable rolling back the database.
///   disabled,
/// }
/// ```
///
/// [runMode] The run mode that Serverpod should be running in. Defaults to `test`.
///
/// [serverpodLoggingMode] The logging mode used when creating Serverpod. Defaults to `ServerpodLoggingMode.normal`
///
/// [serverpodStartTimeout] The timeout to use when starting Serverpod, which connects to the database among other things. Defaults to `Duration(seconds: 120)`.
///
/// [testServerOutputMode] Options for controlling test server output during test execution. Defaults to `TestServerOutputMode.normal`.
/// ```dart
/// /// Options for controlling test server output during test execution.
/// enum TestServerOutputMode {
///   /// Default mode - only stderr is printed (stdout suppressed).
///   /// This hides normal startup/shutdown logs while preserving error messages.
///   normal,
///
///   /// All logging - both stdout and stderr are printed.
///   /// Useful for debugging when you need to see all server output.
///   verbose,
///
///   /// No logging - both stdout and stderr are suppressed.
///   /// Completely silent mode, useful when you don't want any server output.
///   silent,
/// }
/// ```
///
/// [configOverride] A function to override the server configuration. This function is called with
/// the default server configuration after it is loaded from the config/ directory
/// and before it is used to start the server. Use this to override particular
/// settings in the server configuration.
///
/// [databaseInterceptor] Optional interceptor that replaces the default database for each session.
/// See [Serverpod.databaseInterceptor] for more information.
///
/// [testGroupTagsOverride] By default Serverpod test tools tags the `withServerpod` test group with `"integration"`.
/// This is to provide a simple way to only run unit or integration tests.
/// This property allows this tag to be overridden to something else. Defaults to `['integration']`.
///
/// [experimentalFeatures] Optionally specify experimental features. See [Serverpod] for more information.
///
/// [serverDirectory] The server package directory `config/<runMode>.yaml`, `config/passwords.yaml`,
/// and `migrations/<module>/...` are resolved against. Defaults to
/// [Directory.current] at the time the test boots. Pass this when the test
/// isolate's cwd is not the server package root (e.g. running tests from a
/// workspace parent directory) so config and migrations are still loaded
/// from the right place.
@_ist.isTestGroup
void withServerpod(
  String testGroupName,
  _ist.TestClosure<TestEndpoints> testClosure, {
  bool? applyMigrations,
  _is.ServerpodConfig Function(_is.ServerpodConfig)? configOverride,
  _is.DatabaseInterceptor? databaseInterceptor,
  bool? enableSessionLogging,
  bool? ephemeralDatabase,
  _is.ExperimentalFeatures? experimentalFeatures,
  _ist.RollbackDatabase? rollbackDatabase,
  String? runMode,
  _is.RuntimeParametersListBuilder? runtimeParametersBuilder,
  _idi.Directory? serverDirectory,
  _is.ServerpodLoggingMode? serverpodLoggingMode,
  Duration? serverpodStartTimeout,
  List<String>? testGroupTagsOverride,
  _ist.TestServerOutputMode? testServerOutputMode,
}) {
  _ist.buildWithServerpod<_InternalTestEndpoints>(
    testGroupName,
    _ist.TestServerpod(
      testEndpoints: _InternalTestEndpoints(),
      endpoints: Endpoints(),
      serializationManager: Protocol(),
      runMode: runMode,
      applyMigrations: applyMigrations,
      ephemeralDatabase: ephemeralDatabase,
      isDatabaseEnabled: true,
      serverpodLoggingMode: serverpodLoggingMode,
      testServerOutputMode: testServerOutputMode,
      serverDirectory: serverDirectory,
      experimentalFeatures: experimentalFeatures,
      configOverride: configOverride,
      runtimeParametersBuilder: runtimeParametersBuilder,
      databaseInterceptor: databaseInterceptor,
    ),
    maybeRollbackDatabase: rollbackDatabase,
    maybeEnableSessionLogging: enableSessionLogging,
    maybeTestGroupTagsOverride: testGroupTagsOverride,
    maybeServerpodStartTimeout: serverpodStartTimeout,
    maybeTestServerOutputMode: testServerOutputMode,
  )(testClosure);
}

class TestEndpoints {
  late final _AssetsEndpoint assets;

  late final _QrTagsEndpoint qrTags;

  late final _ChecklistsEndpoint checklists;

  late final _ProductsEndpoint products;

  late final _CustomersEndpoint customers;

  late final _AuthEndpoint auth;

  late final _EmailIdpEndpoint emailIdp;

  late final _MeEndpoint me;

  late final _RefreshJwtTokensEndpoint refreshJwtTokens;

  late final _UsersEndpoint users;

  late final _DepreciationEndpoint depreciation;

  late final _TechniciansEndpoint technicians;

  late final _VisitsEndpoint visits;

  late final _TechnicianSyncEndpoint technicianSync;

  late final _BranchesEndpoint branches;

  late final _CostCentersEndpoint costCenters;

  late final _WorkOrdersEndpoint workOrders;
}

class _InternalTestEndpoints extends TestEndpoints implements _ist.InternalTestEndpoints {
  @override
  void initialize(
    _is.SerializationManager serializationManager,
    _is.EndpointDispatch endpoints,
  ) {
    assets = _AssetsEndpoint(
      endpoints,
      serializationManager,
    );
    qrTags = _QrTagsEndpoint(
      endpoints,
      serializationManager,
    );
    checklists = _ChecklistsEndpoint(
      endpoints,
      serializationManager,
    );
    products = _ProductsEndpoint(
      endpoints,
      serializationManager,
    );
    customers = _CustomersEndpoint(
      endpoints,
      serializationManager,
    );
    auth = _AuthEndpoint(
      endpoints,
      serializationManager,
    );
    emailIdp = _EmailIdpEndpoint(
      endpoints,
      serializationManager,
    );
    me = _MeEndpoint(
      endpoints,
      serializationManager,
    );
    refreshJwtTokens = _RefreshJwtTokensEndpoint(
      endpoints,
      serializationManager,
    );
    users = _UsersEndpoint(
      endpoints,
      serializationManager,
    );
    depreciation = _DepreciationEndpoint(
      endpoints,
      serializationManager,
    );
    technicians = _TechniciansEndpoint(
      endpoints,
      serializationManager,
    );
    visits = _VisitsEndpoint(
      endpoints,
      serializationManager,
    );
    technicianSync = _TechnicianSyncEndpoint(
      endpoints,
      serializationManager,
    );
    branches = _BranchesEndpoint(
      endpoints,
      serializationManager,
    );
    costCenters = _CostCentersEndpoint(
      endpoints,
      serializationManager,
    );
    workOrders = _WorkOrdersEndpoint(
      endpoints,
      serializationManager,
    );
  }
}

class _AssetsEndpoint {
  _AssetsEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<_i7jxv3j6.AssetPage> list(
    _ist.TestSessionBuilder sessionBuilder, {
    String? search,
    _is.UuidValue? branchId,
    _is.UuidValue? costCenterId,
    _is.UuidValue? customerId,
    bool? includeInactive,
    int? limit,
    int? offset,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'assets',
        method: 'list',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'assets',
          methodName: 'list',
          parameters: _ist.testObjectToJson({
            'search': search,
            'branchId': branchId,
            'costCenterId': costCenterId,
            'customerId': customerId,
            'includeInactive': includeInactive,
            'limit': limit,
            'offset': offset,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i7jxv3j6.AssetPage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iceem167.Asset> get(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'assets',
        method: 'get',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'assets',
          methodName: 'get',
          parameters: _ist.testObjectToJson({'id': id}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iceem167.Asset>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iceem167.Asset> create(
    _ist.TestSessionBuilder sessionBuilder,
    _i58orcz5.AssetInput input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'assets',
        method: 'create',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'assets',
          methodName: 'create',
          parameters: _ist.testObjectToJson({'input': input}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iceem167.Asset>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iceem167.Asset> update(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
    _i58orcz5.AssetInput input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'assets',
        method: 'update',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'assets',
          methodName: 'update',
          parameters: _ist.testObjectToJson({
            'id': id,
            'expectedVersion': expectedVersion,
            'input': input,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iceem167.Asset>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iceem167.Asset> install(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
    _iggraypf.AssetInstallInput input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'assets',
        method: 'install',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'assets',
          methodName: 'install',
          parameters: _ist.testObjectToJson({
            'id': id,
            'expectedVersion': expectedVersion,
            'input': input,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iceem167.Asset>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iceem167.Asset> withdraw(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
    _ilt8ymra.AssetWithdrawInput input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'assets',
        method: 'withdraw',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'assets',
          methodName: 'withdraw',
          parameters: _ist.testObjectToJson({
            'id': id,
            'expectedVersion': expectedVersion,
            'input': input,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iceem167.Asset>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_iqmm5djm.AssetAssignment>> assignments(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'assets',
        method: 'assignments',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'assets',
          methodName: 'assignments',
          parameters: _ist.testObjectToJson({'id': id}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_iqmm5djm.AssetAssignment>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _QrTagsEndpoint {
  _QrTagsEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<_i07n19u6.QrTagBatch> generateBatch(
    _ist.TestSessionBuilder sessionBuilder,
    int quantity, {
    String? notes,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'qrTags',
        method: 'generateBatch',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'qrTags',
          methodName: 'generateBatch',
          parameters: _ist.testObjectToJson({
            'quantity': quantity,
            'notes': notes,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i07n19u6.QrTagBatch>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_i07n19u6.QrTagBatch>> listBatches(_ist.TestSessionBuilder sessionBuilder) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'qrTags',
        method: 'listBatches',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'qrTags',
          methodName: 'listBatches',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_i07n19u6.QrTagBatch>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_idzaz83i.QrTag>> batchTags(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue batchId,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'qrTags',
        method: 'batchTags',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'qrTags',
          methodName: 'batchTags',
          parameters: _ist.testObjectToJson({'batchId': batchId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_idzaz83i.QrTag>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i07n19u6.QrTagBatch> markBatchPrinted(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue batchId,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'qrTags',
        method: 'markBatchPrinted',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'qrTags',
          methodName: 'markBatchPrinted',
          parameters: _ist.testObjectToJson({'batchId': batchId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i07n19u6.QrTagBatch>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_idzaz83i.QrTag> resolve(
    _ist.TestSessionBuilder sessionBuilder,
    String scanned,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'qrTags',
        method: 'resolve',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'qrTags',
          methodName: 'resolve',
          parameters: _ist.testObjectToJson({'scanned': scanned}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_idzaz83i.QrTag>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_idzaz83i.QrTag> bind(
    _ist.TestSessionBuilder sessionBuilder,
    String scanned,
    _is.UuidValue assetId,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'qrTags',
        method: 'bind',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'qrTags',
          methodName: 'bind',
          parameters: _ist.testObjectToJson({
            'scanned': scanned,
            'assetId': assetId,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_idzaz83i.QrTag>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_idzaz83i.QrTag> unbind(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue tagId,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'qrTags',
        method: 'unbind',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'qrTags',
          methodName: 'unbind',
          parameters: _ist.testObjectToJson({'tagId': tagId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_idzaz83i.QrTag>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_idzaz83i.QrTag> revoke(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue tagId,
    String reason, {
    String? note,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'qrTags',
        method: 'revoke',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'qrTags',
          methodName: 'revoke',
          parameters: _ist.testObjectToJson({
            'tagId': tagId,
            'reason': reason,
            'note': note,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_idzaz83i.QrTag>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _ChecklistsEndpoint {
  _ChecklistsEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<List<_inu2ctxp.ChecklistTemplate>> list(
    _ist.TestSessionBuilder sessionBuilder, {
    bool? includeArchived,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'checklists',
        method: 'list',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'checklists',
          methodName: 'list',
          parameters: _ist.testObjectToJson({'includeArchived': includeArchived}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_inu2ctxp.ChecklistTemplate>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_inu2ctxp.ChecklistTemplate> get(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'checklists',
        method: 'get',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'checklists',
          methodName: 'get',
          parameters: _ist.testObjectToJson({'id': id}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_inu2ctxp.ChecklistTemplate>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_inu2ctxp.ChecklistTemplate> create(
    _ist.TestSessionBuilder sessionBuilder,
    _ifjv7krc.ChecklistTemplateInput input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'checklists',
        method: 'create',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'checklists',
          methodName: 'create',
          parameters: _ist.testObjectToJson({'input': input}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_inu2ctxp.ChecklistTemplate>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_inu2ctxp.ChecklistTemplate> update(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
    _ifjv7krc.ChecklistTemplateInput input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'checklists',
        method: 'update',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'checklists',
          methodName: 'update',
          parameters: _ist.testObjectToJson({
            'id': id,
            'expectedVersion': expectedVersion,
            'input': input,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_inu2ctxp.ChecklistTemplate>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_inu2ctxp.ChecklistTemplate> publish(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'checklists',
        method: 'publish',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'checklists',
          methodName: 'publish',
          parameters: _ist.testObjectToJson({
            'id': id,
            'expectedVersion': expectedVersion,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_inu2ctxp.ChecklistTemplate>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_inu2ctxp.ChecklistTemplate> newVersion(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'checklists',
        method: 'newVersion',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'checklists',
          methodName: 'newVersion',
          parameters: _ist.testObjectToJson({'id': id}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_inu2ctxp.ChecklistTemplate>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_inu2ctxp.ChecklistTemplate> archive(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'checklists',
        method: 'archive',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'checklists',
          methodName: 'archive',
          parameters: _ist.testObjectToJson({
            'id': id,
            'expectedVersion': expectedVersion,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_inu2ctxp.ChecklistTemplate>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _ProductsEndpoint {
  _ProductsEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<List<_ico54ik3.ProductSummary>> list(
    _ist.TestSessionBuilder sessionBuilder, {
    String? search,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'products',
        method: 'list',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'products',
          methodName: 'list',
          parameters: _ist.testObjectToJson({'search': search}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_ico54ik3.ProductSummary>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ico54ik3.ProductSummary> create(
    _ist.TestSessionBuilder sessionBuilder,
    _iku7g2we.ProductInput input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'products',
        method: 'create',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'products',
          methodName: 'create',
          parameters: _ist.testObjectToJson({'input': input}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ico54ik3.ProductSummary>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _CustomersEndpoint {
  _CustomersEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<_ivfmmfkq.CustomerPage> list(
    _ist.TestSessionBuilder sessionBuilder, {
    String? search,
    bool? includeInactive,
    int? limit,
    int? offset,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'customers',
        method: 'list',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customers',
          methodName: 'list',
          parameters: _ist.testObjectToJson({
            'search': search,
            'includeInactive': includeInactive,
            'limit': limit,
            'offset': offset,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ivfmmfkq.CustomerPage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iejihgcl.Customer> get(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'customers',
        method: 'get',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customers',
          methodName: 'get',
          parameters: _ist.testObjectToJson({'id': id}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iejihgcl.Customer>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iejihgcl.Customer> create(
    _ist.TestSessionBuilder sessionBuilder,
    _iw3fixvn.CustomerInput input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'customers',
        method: 'create',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customers',
          methodName: 'create',
          parameters: _ist.testObjectToJson({'input': input}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iejihgcl.Customer>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iejihgcl.Customer> update(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
    _iw3fixvn.CustomerInput input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'customers',
        method: 'update',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customers',
          methodName: 'update',
          parameters: _ist.testObjectToJson({
            'id': id,
            'expectedVersion': expectedVersion,
            'input': input,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iejihgcl.Customer>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_ing115qe.CustomerSite>> sites(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue customerId,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'customers',
        method: 'sites',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customers',
          methodName: 'sites',
          parameters: _ist.testObjectToJson({'customerId': customerId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_ing115qe.CustomerSite>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ing115qe.CustomerSite> createSite(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue customerId,
    _iv6e8owq.CustomerSiteInput input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'customers',
        method: 'createSite',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customers',
          methodName: 'createSite',
          parameters: _ist.testObjectToJson({
            'customerId': customerId,
            'input': input,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ing115qe.CustomerSite>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ing115qe.CustomerSite> updateSite(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
    _iv6e8owq.CustomerSiteInput input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'customers',
        method: 'updateSite',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customers',
          methodName: 'updateSite',
          parameters: _ist.testObjectToJson({
            'id': id,
            'expectedVersion': expectedVersion,
            'input': input,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ing115qe.CustomerSite>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_in02tur2.CustomerContact>> contacts(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue customerId,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'customers',
        method: 'contacts',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customers',
          methodName: 'contacts',
          parameters: _ist.testObjectToJson({'customerId': customerId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_in02tur2.CustomerContact>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_in02tur2.CustomerContact> createContact(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue customerId,
    _i0rc22zw.CustomerContactInput input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'customers',
        method: 'createContact',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customers',
          methodName: 'createContact',
          parameters: _ist.testObjectToJson({
            'customerId': customerId,
            'input': input,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_in02tur2.CustomerContact>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_in02tur2.CustomerContact> updateContact(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
    _i0rc22zw.CustomerContactInput input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'customers',
        method: 'updateContact',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customers',
          methodName: 'updateContact',
          parameters: _ist.testObjectToJson({
            'id': id,
            'expectedVersion': expectedVersion,
            'input': input,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_in02tur2.CustomerContact>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_icd2pnum.CustomerImportReport> importRows(
    _ist.TestSessionBuilder sessionBuilder,
    List<_is65d1g1.CustomerImportRow> rows,
    bool dryRun,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'customers',
        method: 'importRows',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customers',
          methodName: 'importRows',
          parameters: _ist.testObjectToJson({
            'rows': rows,
            'dryRun': dryRun,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_icd2pnum.CustomerImportReport>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _AuthEndpoint {
  _AuthEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<_inkkpwsp.TenantToken> selectTenant(
    _ist.TestSessionBuilder sessionBuilder,
    String tenantSlug, {
    bool? technicianApp,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'auth',
        method: 'selectTenant',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'auth',
          methodName: 'selectTenant',
          parameters: _ist.testObjectToJson({
            'tenantSlug': tenantSlug,
            'technicianApp': technicianApp,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_inkkpwsp.TenantToken>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_inphvrgt.TenantSummary>> myTenants(_ist.TestSessionBuilder sessionBuilder) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'auth',
        method: 'myTenants',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'auth',
          methodName: 'myTenants',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_inphvrgt.TenantSummary>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _EmailIdpEndpoint {
  _EmailIdpEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<_iacs.AuthSuccess> login(
    _ist.TestSessionBuilder sessionBuilder, {
    required String email,
    required String password,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'emailIdp',
        method: 'login',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'emailIdp',
          methodName: 'login',
          parameters: _ist.testObjectToJson({
            'email': email,
            'password': password,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iacs.AuthSuccess>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_is.UuidValue> startRegistration(
    _ist.TestSessionBuilder sessionBuilder, {
    required String email,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'emailIdp',
        method: 'startRegistration',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'emailIdp',
          methodName: 'startRegistration',
          parameters: _ist.testObjectToJson({'email': email}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_is.UuidValue>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String> verifyRegistrationCode(
    _ist.TestSessionBuilder sessionBuilder, {
    required _is.UuidValue accountRequestId,
    required String verificationCode,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'emailIdp',
        method: 'verifyRegistrationCode',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'emailIdp',
          methodName: 'verifyRegistrationCode',
          parameters: _ist.testObjectToJson({
            'accountRequestId': accountRequestId,
            'verificationCode': verificationCode,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iacs.AuthSuccess> finishRegistration(
    _ist.TestSessionBuilder sessionBuilder, {
    required String registrationToken,
    required String password,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'emailIdp',
        method: 'finishRegistration',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'emailIdp',
          methodName: 'finishRegistration',
          parameters: _ist.testObjectToJson({
            'registrationToken': registrationToken,
            'password': password,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iacs.AuthSuccess>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_is.UuidValue> startPasswordReset(
    _ist.TestSessionBuilder sessionBuilder, {
    required String email,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'emailIdp',
        method: 'startPasswordReset',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'emailIdp',
          methodName: 'startPasswordReset',
          parameters: _ist.testObjectToJson({'email': email}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_is.UuidValue>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String> verifyPasswordResetCode(
    _ist.TestSessionBuilder sessionBuilder, {
    required _is.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'emailIdp',
        method: 'verifyPasswordResetCode',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'emailIdp',
          methodName: 'verifyPasswordResetCode',
          parameters: _ist.testObjectToJson({
            'passwordResetRequestId': passwordResetRequestId,
            'verificationCode': verificationCode,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> finishPasswordReset(
    _ist.TestSessionBuilder sessionBuilder, {
    required String finishPasswordResetToken,
    required String newPassword,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'emailIdp',
        method: 'finishPasswordReset',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'emailIdp',
          methodName: 'finishPasswordReset',
          parameters: _ist.testObjectToJson({
            'finishPasswordResetToken': finishPasswordResetToken,
            'newPassword': newPassword,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<bool> hasAccount(_ist.TestSessionBuilder sessionBuilder) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'emailIdp',
        method: 'hasAccount',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'emailIdp',
          methodName: 'hasAccount',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _MeEndpoint {
  _MeEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<_i70n7l3r.MeInfo> get(_ist.TestSessionBuilder sessionBuilder) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'me',
        method: 'get',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'me',
          methodName: 'get',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i70n7l3r.MeInfo>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_inphvrgt.TenantSummary>> tenants(_ist.TestSessionBuilder sessionBuilder) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'me',
        method: 'tenants',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'me',
          methodName: 'tenants',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_inphvrgt.TenantSummary>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _RefreshJwtTokensEndpoint {
  _RefreshJwtTokensEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<_iacs.AuthSuccess> refreshAccessToken(
    _ist.TestSessionBuilder sessionBuilder, {
    String? refreshToken,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'refreshJwtTokens',
        method: 'refreshAccessToken',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'refreshJwtTokens',
          methodName: 'refreshAccessToken',
          parameters: _ist.testObjectToJson({'refreshToken': refreshToken}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iacs.AuthSuccess>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _UsersEndpoint {
  _UsersEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<List<_iur1xixc.AssignableRole>> roles(_ist.TestSessionBuilder sessionBuilder) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'users',
        method: 'roles',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'users',
          methodName: 'roles',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_iur1xixc.AssignableRole>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_iqhozu6i.TenantUser>> list(_ist.TestSessionBuilder sessionBuilder) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'users',
        method: 'list',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'users',
          methodName: 'list',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_iqhozu6i.TenantUser>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iqhozu6i.TenantUser> invite(
    _ist.TestSessionBuilder sessionBuilder,
    String email,
    String fullName,
    List<String> roles,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'users',
        method: 'invite',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'users',
          methodName: 'invite',
          parameters: _ist.testObjectToJson({
            'email': email,
            'fullName': fullName,
            'roles': roles,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iqhozu6i.TenantUser>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iqhozu6i.TenantUser> resendInvite(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue membershipId,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'users',
        method: 'resendInvite',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'users',
          methodName: 'resendInvite',
          parameters: _ist.testObjectToJson({'membershipId': membershipId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iqhozu6i.TenantUser>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iqhozu6i.TenantUser> setRoles(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue membershipId,
    List<String> roles,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'users',
        method: 'setRoles',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'users',
          methodName: 'setRoles',
          parameters: _ist.testObjectToJson({
            'membershipId': membershipId,
            'roles': roles,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iqhozu6i.TenantUser>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iqhozu6i.TenantUser> suspend(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue membershipId,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'users',
        method: 'suspend',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'users',
          methodName: 'suspend',
          parameters: _ist.testObjectToJson({'membershipId': membershipId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iqhozu6i.TenantUser>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iqhozu6i.TenantUser> reactivate(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue membershipId,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'users',
        method: 'reactivate',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'users',
          methodName: 'reactivate',
          parameters: _ist.testObjectToJson({'membershipId': membershipId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iqhozu6i.TenantUser>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iqhozu6i.TenantUser> remove(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue membershipId,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'users',
        method: 'remove',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'users',
          methodName: 'remove',
          parameters: _ist.testObjectToJson({'membershipId': membershipId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iqhozu6i.TenantUser>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _DepreciationEndpoint {
  _DepreciationEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<_idh96kkc.DepreciationProfile?> profile(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue assetId,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'depreciation',
        method: 'profile',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'depreciation',
          methodName: 'profile',
          parameters: _ist.testObjectToJson({'assetId': assetId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_idh96kkc.DepreciationProfile?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_idh96kkc.DepreciationProfile> saveProfile(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue assetId,
    int? expectedVersion,
    _ims07aom.DepreciationProfileInput input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'depreciation',
        method: 'saveProfile',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'depreciation',
          methodName: 'saveProfile',
          parameters: _ist.testObjectToJson({
            'assetId': assetId,
            'expectedVersion': expectedVersion,
            'input': input,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_idh96kkc.DepreciationProfile>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ic6r3pi5.AssetDepreciation> schedule(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue assetId,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'depreciation',
        method: 'schedule',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'depreciation',
          methodName: 'schedule',
          parameters: _ist.testObjectToJson({'assetId': assetId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ic6r3pi5.AssetDepreciation>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ijwc67wv.DepreciationPosition> position(
    _ist.TestSessionBuilder sessionBuilder,
    int year,
    int month, {
    _is.UuidValue? branchId,
    _is.UuidValue? costCenterId,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'depreciation',
        method: 'position',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'depreciation',
          methodName: 'position',
          parameters: _ist.testObjectToJson({
            'year': year,
            'month': month,
            'branchId': branchId,
            'costCenterId': costCenterId,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ijwc67wv.DepreciationPosition>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_ip56mlnh.DepreciationClosing>> closings(_ist.TestSessionBuilder sessionBuilder) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'depreciation',
        method: 'closings',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'depreciation',
          methodName: 'closings',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_ip56mlnh.DepreciationClosing>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ip56mlnh.DepreciationClosing> close(
    _ist.TestSessionBuilder sessionBuilder,
    int year,
    int month,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'depreciation',
        method: 'close',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'depreciation',
          methodName: 'close',
          parameters: _ist.testObjectToJson({
            'year': year,
            'month': month,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ip56mlnh.DepreciationClosing>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ip56mlnh.DepreciationClosing> reopen(
    _ist.TestSessionBuilder sessionBuilder,
    int year,
    int month,
    String reason,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'depreciation',
        method: 'reopen',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'depreciation',
          methodName: 'reopen',
          parameters: _ist.testObjectToJson({
            'year': year,
            'month': month,
            'reason': reason,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ip56mlnh.DepreciationClosing>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _TechniciansEndpoint {
  _TechniciansEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<List<_ixvhwnkq.Technician>> list(
    _ist.TestSessionBuilder sessionBuilder, {
    bool? includeInactive,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'technicians',
        method: 'list',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'technicians',
          methodName: 'list',
          parameters: _ist.testObjectToJson({'includeInactive': includeInactive}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_ixvhwnkq.Technician>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ixvhwnkq.Technician?> mine(_ist.TestSessionBuilder sessionBuilder) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'technicians',
        method: 'mine',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'technicians',
          methodName: 'mine',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ixvhwnkq.Technician?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ixvhwnkq.Technician> create(
    _ist.TestSessionBuilder sessionBuilder,
    _i4g4d70s.TechnicianInput input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'technicians',
        method: 'create',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'technicians',
          methodName: 'create',
          parameters: _ist.testObjectToJson({'input': input}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ixvhwnkq.Technician>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ixvhwnkq.Technician> update(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
    _i4g4d70s.TechnicianInput input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'technicians',
        method: 'update',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'technicians',
          methodName: 'update',
          parameters: _ist.testObjectToJson({
            'id': id,
            'expectedVersion': expectedVersion,
            'input': input,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ixvhwnkq.Technician>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _VisitsEndpoint {
  _VisitsEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<List<_iezjjcq0.Visit>> agenda(
    _ist.TestSessionBuilder sessionBuilder,
    DateTime from,
    DateTime to, {
    _is.UuidValue? technicianId,
    bool? includeCancelled,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'visits',
        method: 'agenda',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'visits',
          methodName: 'agenda',
          parameters: _ist.testObjectToJson({
            'from': from,
            'to': to,
            'technicianId': technicianId,
            'includeCancelled': includeCancelled,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_iezjjcq0.Visit>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_iezjjcq0.Visit>> mine(
    _ist.TestSessionBuilder sessionBuilder,
    DateTime from,
    DateTime to,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'visits',
        method: 'mine',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'visits',
          methodName: 'mine',
          parameters: _ist.testObjectToJson({
            'from': from,
            'to': to,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_iezjjcq0.Visit>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_iezjjcq0.Visit>> ofWorkOrder(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue workOrderId,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'visits',
        method: 'ofWorkOrder',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'visits',
          methodName: 'ofWorkOrder',
          parameters: _ist.testObjectToJson({'workOrderId': workOrderId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_iezjjcq0.Visit>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_iblxfzeg.VisitChecklist>> checklistsOfWorkOrder(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue workOrderId,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'visits',
        method: 'checklistsOfWorkOrder',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'visits',
          methodName: 'checklistsOfWorkOrder',
          parameters: _ist.testObjectToJson({'workOrderId': workOrderId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_iblxfzeg.VisitChecklist>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iezjjcq0.Visit> get(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'visits',
        method: 'get',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'visits',
          methodName: 'get',
          parameters: _ist.testObjectToJson({'id': id}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iezjjcq0.Visit>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iezjjcq0.Visit> schedule(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue workOrderId,
    _isygpo5n.VisitInput input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'visits',
        method: 'schedule',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'visits',
          methodName: 'schedule',
          parameters: _ist.testObjectToJson({
            'workOrderId': workOrderId,
            'input': input,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iezjjcq0.Visit>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iezjjcq0.Visit> reschedule(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
    _isygpo5n.VisitInput input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'visits',
        method: 'reschedule',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'visits',
          methodName: 'reschedule',
          parameters: _ist.testObjectToJson({
            'id': id,
            'expectedVersion': expectedVersion,
            'input': input,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iezjjcq0.Visit>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iezjjcq0.Visit> cancel(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
    String reason,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'visits',
        method: 'cancel',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'visits',
          methodName: 'cancel',
          parameters: _ist.testObjectToJson({
            'id': id,
            'expectedVersion': expectedVersion,
            'reason': reason,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iezjjcq0.Visit>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iezjjcq0.Visit> startTravel(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'visits',
        method: 'startTravel',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'visits',
          methodName: 'startTravel',
          parameters: _ist.testObjectToJson({
            'id': id,
            'expectedVersion': expectedVersion,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iezjjcq0.Visit>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iezjjcq0.Visit> checkIn(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
    _in4grqdw.VisitCheckIn input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'visits',
        method: 'checkIn',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'visits',
          methodName: 'checkIn',
          parameters: _ist.testObjectToJson({
            'id': id,
            'expectedVersion': expectedVersion,
            'input': input,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iezjjcq0.Visit>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iezjjcq0.Visit> pause(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'visits',
        method: 'pause',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'visits',
          methodName: 'pause',
          parameters: _ist.testObjectToJson({
            'id': id,
            'expectedVersion': expectedVersion,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iezjjcq0.Visit>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iezjjcq0.Visit> resume(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'visits',
        method: 'resume',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'visits',
          methodName: 'resume',
          parameters: _ist.testObjectToJson({
            'id': id,
            'expectedVersion': expectedVersion,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iezjjcq0.Visit>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iezjjcq0.Visit> finish(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
    _izl7q3ap.VisitFinish input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'visits',
        method: 'finish',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'visits',
          methodName: 'finish',
          parameters: _ist.testObjectToJson({
            'id': id,
            'expectedVersion': expectedVersion,
            'input': input,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iezjjcq0.Visit>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _TechnicianSyncEndpoint {
  _TechnicianSyncEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<void> registerDevice(
    _ist.TestSessionBuilder sessionBuilder,
    _ifayztnr.DeviceRegistration input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'technicianSync',
        method: 'registerDevice',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'technicianSync',
          methodName: 'registerDevice',
          parameters: _ist.testObjectToJson({'input': input}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iw54s95p.SyncPullResult> pull(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue deviceId,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'technicianSync',
        method: 'pull',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'technicianSync',
          methodName: 'pull',
          parameters: _ist.testObjectToJson({'deviceId': deviceId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iw54s95p.SyncPullResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_ilt9w9x8.SyncMutationResult>> push(
    _ist.TestSessionBuilder sessionBuilder,
    _is7nu1l0.SyncPushRequest request,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'technicianSync',
        method: 'push',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'technicianSync',
          methodName: 'push',
          parameters: _ist.testObjectToJson({'request': request}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_ilt9w9x8.SyncMutationResult>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _BranchesEndpoint {
  _BranchesEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<List<_i7vupwwc.Branch>> list(
    _ist.TestSessionBuilder sessionBuilder, {
    bool? includeInactive,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'branches',
        method: 'list',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'branches',
          methodName: 'list',
          parameters: _ist.testObjectToJson({'includeInactive': includeInactive}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_i7vupwwc.Branch>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i7vupwwc.Branch> create(
    _ist.TestSessionBuilder sessionBuilder,
    _i6djw631.BranchInput input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'branches',
        method: 'create',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'branches',
          methodName: 'create',
          parameters: _ist.testObjectToJson({'input': input}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i7vupwwc.Branch>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i7vupwwc.Branch> update(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
    _i6djw631.BranchInput input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'branches',
        method: 'update',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'branches',
          methodName: 'update',
          parameters: _ist.testObjectToJson({
            'id': id,
            'expectedVersion': expectedVersion,
            'input': input,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i7vupwwc.Branch>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _CostCentersEndpoint {
  _CostCentersEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<List<_islkyssd.CostCenter>> list(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? branchId,
    bool? includeInactive,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'costCenters',
        method: 'list',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'costCenters',
          methodName: 'list',
          parameters: _ist.testObjectToJson({
            'branchId': branchId,
            'includeInactive': includeInactive,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_islkyssd.CostCenter>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_islkyssd.CostCenter> create(
    _ist.TestSessionBuilder sessionBuilder,
    _irkypkua.CostCenterInput input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'costCenters',
        method: 'create',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'costCenters',
          methodName: 'create',
          parameters: _ist.testObjectToJson({'input': input}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_islkyssd.CostCenter>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_islkyssd.CostCenter> update(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
    _irkypkua.CostCenterInput input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'costCenters',
        method: 'update',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'costCenters',
          methodName: 'update',
          parameters: _ist.testObjectToJson({
            'id': id,
            'expectedVersion': expectedVersion,
            'input': input,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_islkyssd.CostCenter>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _WorkOrdersEndpoint {
  _WorkOrdersEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<_im7kyfxz.WorkOrderPage> list(
    _ist.TestSessionBuilder sessionBuilder, {
    String? search,
    List<String>? statuses,
    bool? openOnly,
    _is.UuidValue? assetId,
    _is.UuidValue? branchId,
    _is.UuidValue? costCenterId,
    _is.UuidValue? workOrderTypeId,
    int? limit,
    int? offset,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'workOrders',
        method: 'list',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'workOrders',
          methodName: 'list',
          parameters: _ist.testObjectToJson({
            'search': search,
            'statuses': statuses,
            'openOnly': openOnly,
            'assetId': assetId,
            'branchId': branchId,
            'costCenterId': costCenterId,
            'workOrderTypeId': workOrderTypeId,
            'limit': limit,
            'offset': offset,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_im7kyfxz.WorkOrderPage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i5ujk65j.WorkOrderDetail> get(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'workOrders',
        method: 'get',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'workOrders',
          methodName: 'get',
          parameters: _ist.testObjectToJson({'id': id}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i5ujk65j.WorkOrderDetail>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i5ujk65j.WorkOrderDetail> open(
    _ist.TestSessionBuilder sessionBuilder,
    _is40rk4d.WorkOrderInput input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'workOrders',
        method: 'open',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'workOrders',
          methodName: 'open',
          parameters: _ist.testObjectToJson({'input': input}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i5ujk65j.WorkOrderDetail>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ih47bshy.WorkOrder> update(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
    _im8hf6je.WorkOrderChanges changes,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'workOrders',
        method: 'update',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'workOrders',
          methodName: 'update',
          parameters: _ist.testObjectToJson({
            'id': id,
            'expectedVersion': expectedVersion,
            'changes': changes,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ih47bshy.WorkOrder>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ih47bshy.WorkOrder> start(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'workOrders',
        method: 'start',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'workOrders',
          methodName: 'start',
          parameters: _ist.testObjectToJson({
            'id': id,
            'expectedVersion': expectedVersion,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ih47bshy.WorkOrder>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ih47bshy.WorkOrder> hold(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
    String holdReason, {
    String? note,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'workOrders',
        method: 'hold',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'workOrders',
          methodName: 'hold',
          parameters: _ist.testObjectToJson({
            'id': id,
            'expectedVersion': expectedVersion,
            'holdReason': holdReason,
            'note': note,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ih47bshy.WorkOrder>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ih47bshy.WorkOrder> complete(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
    String resolutionNotes,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'workOrders',
        method: 'complete',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'workOrders',
          methodName: 'complete',
          parameters: _ist.testObjectToJson({
            'id': id,
            'expectedVersion': expectedVersion,
            'resolutionNotes': resolutionNotes,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ih47bshy.WorkOrder>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ih47bshy.WorkOrder> close(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'workOrders',
        method: 'close',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'workOrders',
          methodName: 'close',
          parameters: _ist.testObjectToJson({
            'id': id,
            'expectedVersion': expectedVersion,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ih47bshy.WorkOrder>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ih47bshy.WorkOrder> cancel(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
    String reason, {
    String? note,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'workOrders',
        method: 'cancel',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'workOrders',
          methodName: 'cancel',
          parameters: _ist.testObjectToJson({
            'id': id,
            'expectedVersion': expectedVersion,
            'reason': reason,
            'note': note,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ih47bshy.WorkOrder>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ih47bshy.WorkOrder> reopen(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
    String reason,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'workOrders',
        method: 'reopen',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'workOrders',
          methodName: 'reopen',
          parameters: _ist.testObjectToJson({
            'id': id,
            'expectedVersion': expectedVersion,
            'reason': reason,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ih47bshy.WorkOrder>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_ith5np2m.WorkOrderType>> types(
    _ist.TestSessionBuilder sessionBuilder, {
    bool? includeInactive,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'workOrders',
        method: 'types',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'workOrders',
          methodName: 'types',
          parameters: _ist.testObjectToJson({'includeInactive': includeInactive}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_ith5np2m.WorkOrderType>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ith5np2m.WorkOrderType> createType(
    _ist.TestSessionBuilder sessionBuilder,
    _i56uux5g.WorkOrderTypeInput input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'workOrders',
        method: 'createType',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'workOrders',
          methodName: 'createType',
          parameters: _ist.testObjectToJson({'input': input}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ith5np2m.WorkOrderType>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ith5np2m.WorkOrderType> updateType(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
    _i56uux5g.WorkOrderTypeInput input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'workOrders',
        method: 'updateType',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'workOrders',
          methodName: 'updateType',
          parameters: _ist.testObjectToJson({
            'id': id,
            'expectedVersion': expectedVersion,
            'input': input,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ith5np2m.WorkOrderType>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}
