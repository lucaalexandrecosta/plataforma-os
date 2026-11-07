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
import 'package:plataforma_os_server/src/generated/protocol.dart' as _isma42go;
import 'package:serverpod/serverpod.dart' as _is;
import '../../tenancy/models/tenant_summary.dart' as _ia3vjv2o;

abstract class TenantToken implements _is.SerializableModel, _is.ProtocolSerialization {
  TenantToken._({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.tenant,
    required this.roles,
  });

  factory TenantToken({
    required String accessToken,
    required String tokenType,
    required int expiresIn,
    required _ia3vjv2o.TenantSummary tenant,
    required List<String> roles,
  }) = _TenantTokenImpl;

  factory TenantToken.fromJson(Map<String, dynamic> jsonSerialization) {
    return TenantToken(
      accessToken: jsonSerialization['accessToken'] as String,
      tokenType: jsonSerialization['tokenType'] as String,
      expiresIn: jsonSerialization['expiresIn'] as int,
      tenant: _isma42go.Protocol().deserialize<_ia3vjv2o.TenantSummary>(jsonSerialization['tenant']),
      roles: _isma42go.Protocol().deserialize<List<String>>(jsonSerialization['roles']),
    );
  }

  String accessToken;

  String tokenType;

  int expiresIn;

  _ia3vjv2o.TenantSummary tenant;

  List<String> roles;

  /// Returns a shallow copy of this [TenantToken]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TenantToken copyWith({
    String? accessToken,
    String? tokenType,
    int? expiresIn,
    _ia3vjv2o.TenantSummary? tenant,
    List<String>? roles,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TenantToken',
      'accessToken': accessToken,
      'tokenType': tokenType,
      'expiresIn': expiresIn,
      'tenant': tenant.toJson(),
      'roles': roles.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TenantToken',
      'accessToken': accessToken,
      'tokenType': tokenType,
      'expiresIn': expiresIn,
      'tenant': tenant.toJsonForProtocol(),
      'roles': roles.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _TenantTokenImpl extends TenantToken {
  _TenantTokenImpl({
    required String accessToken,
    required String tokenType,
    required int expiresIn,
    required _ia3vjv2o.TenantSummary tenant,
    required List<String> roles,
  }) : super._(
         accessToken: accessToken,
         tokenType: tokenType,
         expiresIn: expiresIn,
         tenant: tenant,
         roles: roles,
       );

  /// Returns a shallow copy of this [TenantToken]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TenantToken copyWith({
    String? accessToken,
    String? tokenType,
    int? expiresIn,
    _ia3vjv2o.TenantSummary? tenant,
    List<String>? roles,
  }) {
    return TenantToken(
      accessToken: accessToken ?? this.accessToken,
      tokenType: tokenType ?? this.tokenType,
      expiresIn: expiresIn ?? this.expiresIn,
      tenant: tenant ?? this.tenant.copyWith(),
      roles: roles ?? this.roles.map((e0) => e0).toList(),
    );
  }
}
