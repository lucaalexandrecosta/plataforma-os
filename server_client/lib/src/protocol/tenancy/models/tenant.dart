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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../../tenancy/models/tenant_status.dart' as _ivp99z2i;

abstract class Tenant implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Tenant._({
    _isc.UuidValue? id,
    required this.slug,
    required this.legalName,
    required this.displayName,
    this.documentNumber,
    required this.status,
    required this.planId,
    required this.version,
  }) : id = id ?? const _isc.Uuid().v7obj();

  factory Tenant({
    _isc.UuidValue? id,
    required String slug,
    required String legalName,
    required String displayName,
    String? documentNumber,
    required _ivp99z2i.TenantStatus status,
    required _isc.UuidValue planId,
    required int version,
  }) = _TenantImpl;

  factory Tenant.fromJson(Map<String, dynamic> jsonSerialization) {
    return Tenant(
      id: jsonSerialization['id'] == null ? null : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      slug: jsonSerialization['slug'] as String,
      legalName: jsonSerialization['legalName'] as String,
      displayName: jsonSerialization['displayName'] as String,
      documentNumber: jsonSerialization['documentNumber'] as String?,
      status: _ivp99z2i.TenantStatus.fromJson((jsonSerialization['status'] as String)),
      planId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['planId']),
      version: jsonSerialization['version'] as int,
    );
  }

  /// The id of the object.
  _isc.UuidValue id;

  String slug;

  String legalName;

  String displayName;

  String? documentNumber;

  _ivp99z2i.TenantStatus status;

  _isc.UuidValue planId;

  int version;

  /// Returns a shallow copy of this [Tenant]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Tenant copyWith({
    _isc.UuidValue? id,
    String? slug,
    String? legalName,
    String? displayName,
    String? documentNumber,
    _ivp99z2i.TenantStatus? status,
    _isc.UuidValue? planId,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Tenant',
      'id': id.toJson(),
      'slug': slug,
      'legalName': legalName,
      'displayName': displayName,
      if (documentNumber != null) 'documentNumber': documentNumber,
      'status': status.toJson(),
      'planId': planId.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Tenant',
      'id': id.toJson(),
      'slug': slug,
      'legalName': legalName,
      'displayName': displayName,
      if (documentNumber != null) 'documentNumber': documentNumber,
      'status': status.toJson(),
      'planId': planId.toJson(),
      'version': version,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TenantImpl extends Tenant {
  _TenantImpl({
    _isc.UuidValue? id,
    required String slug,
    required String legalName,
    required String displayName,
    String? documentNumber,
    required _ivp99z2i.TenantStatus status,
    required _isc.UuidValue planId,
    required int version,
  }) : super._(
         id: id,
         slug: slug,
         legalName: legalName,
         displayName: displayName,
         documentNumber: documentNumber,
         status: status,
         planId: planId,
         version: version,
       );

  /// Returns a shallow copy of this [Tenant]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Tenant copyWith({
    _isc.UuidValue? id,
    String? slug,
    String? legalName,
    String? displayName,
    Object? documentNumber = _Undefined,
    _ivp99z2i.TenantStatus? status,
    _isc.UuidValue? planId,
    int? version,
  }) {
    return Tenant(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      legalName: legalName ?? this.legalName,
      displayName: displayName ?? this.displayName,
      documentNumber: documentNumber is String? ? documentNumber : this.documentNumber,
      status: status ?? this.status,
      planId: planId ?? this.planId,
      version: version ?? this.version,
    );
  }
}
