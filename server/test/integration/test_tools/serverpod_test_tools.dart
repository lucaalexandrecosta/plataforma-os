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
import 'package:plataforma_os_server/src/generated/customers/models/customer.dart' as _iejihgcl;
import 'package:plataforma_os_server/src/generated/customers/models/customer_contact.dart' as _in02tur2;
import 'package:plataforma_os_server/src/generated/customers/models/customer_contact_filter.dart' as _ipdid8a4;
import 'package:plataforma_os_server/src/generated/customers/models/customer_contact_input.dart' as _i0rc22zw;
import 'package:plataforma_os_server/src/generated/customers/models/customer_contact_page.dart' as _iy5j62ks;
import 'package:plataforma_os_server/src/generated/customers/models/customer_contact_patch.dart' as _i8odeyb5;
import 'package:plataforma_os_server/src/generated/customers/models/customer_filter.dart' as _ipd66tax;
import 'package:plataforma_os_server/src/generated/customers/models/customer_input.dart' as _iw3fixvn;
import 'package:plataforma_os_server/src/generated/customers/models/customer_page.dart' as _ivfmmfkq;
import 'package:plataforma_os_server/src/generated/customers/models/customer_patch.dart' as _iw5xmx3u;
import 'package:plataforma_os_server/src/generated/customers/models/customer_site.dart' as _ing115qe;
import 'package:plataforma_os_server/src/generated/customers/models/customer_site_filter.dart' as _im9gx6w1;
import 'package:plataforma_os_server/src/generated/customers/models/customer_site_input.dart' as _iv6e8owq;
import 'package:plataforma_os_server/src/generated/customers/models/customer_site_page.dart' as _ihau93w4;
import 'package:plataforma_os_server/src/generated/customers/models/customer_site_patch.dart' as _iqxf8m4v;
import 'package:plataforma_os_server/src/generated/identity_access/models/me_info.dart' as _i70n7l3r;
import 'package:plataforma_os_server/src/generated/identity_access/models/tenant_token.dart' as _inkkpwsp;
import 'package:plataforma_os_server/src/generated/platform/paging/models/page_request.dart' as _i4pk1ojl;
import 'package:plataforma_os_server/src/generated/tenancy/models/tenant_summary.dart' as _inphvrgt;
import 'package:serverpod/serverpod.dart' as _is;
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
  late final _CustomerContactsEndpoint customerContacts;

  late final _CustomerSitesEndpoint customerSites;

  late final _CustomersEndpoint customers;

  late final _AuthEndpoint auth;

  late final _MeEndpoint me;
}

class _InternalTestEndpoints extends TestEndpoints implements _ist.InternalTestEndpoints {
  @override
  void initialize(
    _is.SerializationManager serializationManager,
    _is.EndpointDispatch endpoints,
  ) {
    customerContacts = _CustomerContactsEndpoint(
      endpoints,
      serializationManager,
    );
    customerSites = _CustomerSitesEndpoint(
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
    me = _MeEndpoint(
      endpoints,
      serializationManager,
    );
  }
}

class _CustomerContactsEndpoint {
  _CustomerContactsEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<_iy5j62ks.CustomerContactPage> list(
    _ist.TestSessionBuilder sessionBuilder,
    _ipdid8a4.CustomerContactFilter? filter,
    _i4pk1ojl.PageRequest? page,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'customerContacts',
        method: 'list',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customerContacts',
          methodName: 'list',
          parameters: _ist.testObjectToJson({
            'filter': filter,
            'page': page,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iy5j62ks.CustomerContactPage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_in02tur2.CustomerContact> get(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'customerContacts',
        method: 'get',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customerContacts',
          methodName: 'get',
          parameters: _ist.testObjectToJson({'id': id}),
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

  _ida.Future<_in02tur2.CustomerContact> create(
    _ist.TestSessionBuilder sessionBuilder,
    _i0rc22zw.CustomerContactInput input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'customerContacts',
        method: 'create',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customerContacts',
          methodName: 'create',
          parameters: _ist.testObjectToJson({'input': input}),
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

  _ida.Future<_in02tur2.CustomerContact> update(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    _i8odeyb5.CustomerContactPatch patch,
    int expectedVersion,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'customerContacts',
        method: 'update',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customerContacts',
          methodName: 'update',
          parameters: _ist.testObjectToJson({
            'id': id,
            'patch': patch,
            'expectedVersion': expectedVersion,
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

  _ida.Future<_in02tur2.CustomerContact> approve(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'customerContacts',
        method: 'approve',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customerContacts',
          methodName: 'approve',
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
                as _ida.Future<_in02tur2.CustomerContact>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_in02tur2.CustomerContact> block(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    String reason,
    int expectedVersion,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'customerContacts',
        method: 'block',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customerContacts',
          methodName: 'block',
          parameters: _ist.testObjectToJson({
            'id': id,
            'reason': reason,
            'expectedVersion': expectedVersion,
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

  _ida.Future<_in02tur2.CustomerContact> unblock(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'customerContacts',
        method: 'unblock',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customerContacts',
          methodName: 'unblock',
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
                as _ida.Future<_in02tur2.CustomerContact>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_in02tur2.CustomerContact> deactivate(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    String reason,
    int expectedVersion,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'customerContacts',
        method: 'deactivate',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customerContacts',
          methodName: 'deactivate',
          parameters: _ist.testObjectToJson({
            'id': id,
            'reason': reason,
            'expectedVersion': expectedVersion,
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

  _ida.Future<_in02tur2.CustomerContact> reactivate(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'customerContacts',
        method: 'reactivate',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customerContacts',
          methodName: 'reactivate',
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
                as _ida.Future<_in02tur2.CustomerContact>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _CustomerSitesEndpoint {
  _CustomerSitesEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<_ihau93w4.CustomerSitePage> list(
    _ist.TestSessionBuilder sessionBuilder,
    _im9gx6w1.CustomerSiteFilter? filter,
    _i4pk1ojl.PageRequest? page,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'customerSites',
        method: 'list',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customerSites',
          methodName: 'list',
          parameters: _ist.testObjectToJson({
            'filter': filter,
            'page': page,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ihau93w4.CustomerSitePage>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ing115qe.CustomerSite> get(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'customerSites',
        method: 'get',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customerSites',
          methodName: 'get',
          parameters: _ist.testObjectToJson({'id': id}),
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

  _ida.Future<_ing115qe.CustomerSite> create(
    _ist.TestSessionBuilder sessionBuilder,
    _iv6e8owq.CustomerSiteInput input,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'customerSites',
        method: 'create',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customerSites',
          methodName: 'create',
          parameters: _ist.testObjectToJson({'input': input}),
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

  _ida.Future<_ing115qe.CustomerSite> update(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    _iqxf8m4v.CustomerSitePatch patch,
    int expectedVersion,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'customerSites',
        method: 'update',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customerSites',
          methodName: 'update',
          parameters: _ist.testObjectToJson({
            'id': id,
            'patch': patch,
            'expectedVersion': expectedVersion,
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

  _ida.Future<_ing115qe.CustomerSite> deactivate(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    String reason,
    int expectedVersion,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'customerSites',
        method: 'deactivate',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customerSites',
          methodName: 'deactivate',
          parameters: _ist.testObjectToJson({
            'id': id,
            'reason': reason,
            'expectedVersion': expectedVersion,
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

  _ida.Future<_ing115qe.CustomerSite> reactivate(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'customerSites',
        method: 'reactivate',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customerSites',
          methodName: 'reactivate',
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
                as _ida.Future<_ing115qe.CustomerSite>);
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
    _ist.TestSessionBuilder sessionBuilder,
    _ipd66tax.CustomerFilter? filter,
    _i4pk1ojl.PageRequest? page,
  ) async {
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
            'filter': filter,
            'page': page,
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
    _iw5xmx3u.CustomerPatch patch,
    int expectedVersion,
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
            'patch': patch,
            'expectedVersion': expectedVersion,
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

  _ida.Future<_iejihgcl.Customer> deactivate(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    String reason,
    int expectedVersion,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'customers',
        method: 'deactivate',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customers',
          methodName: 'deactivate',
          parameters: _ist.testObjectToJson({
            'id': id,
            'reason': reason,
            'expectedVersion': expectedVersion,
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

  _ida.Future<_iejihgcl.Customer> reactivate(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue id,
    int expectedVersion,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'customers',
        method: 'reactivate',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'customers',
          methodName: 'reactivate',
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
                as _ida.Future<_iejihgcl.Customer>);
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

  _ida.Future<_inkkpwsp.TenantToken> exchangeIdpToken(
    _ist.TestSessionBuilder sessionBuilder,
    String idpToken,
    String tenantSlug,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession = (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
        endpoint: 'auth',
        method: 'exchangeIdpToken',
      );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'auth',
          methodName: 'exchangeIdpToken',
          parameters: _ist.testObjectToJson({
            'idpToken': idpToken,
            'tenantSlug': tenantSlug,
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
