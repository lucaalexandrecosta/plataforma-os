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
import '../../catalog/models/service_kind.dart' as _iu1dhgj0;
import '../../platform/models/record_source.dart' as _i1c87mer;

abstract class CatalogService implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CatalogService._({
    _isc.UuidValue? id,
    required this.tenantId,
    required this.code,
    required this.name,
    this.description,
    required this.unitCode,
    this.defaultPrice,
    this.estimatedMinutes,
    required this.serviceKind,
    required this.isActive,
    required this.source,
    this.externalSystem,
    this.externalId,
    this.missingSince,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  }) : id = id ?? const _isc.Uuid().v7obj();

  factory CatalogService({
    _isc.UuidValue? id,
    required _isc.UuidValue tenantId,
    required String code,
    required String name,
    String? description,
    required String unitCode,
    int? defaultPrice,
    int? estimatedMinutes,
    required _iu1dhgj0.ServiceKind serviceKind,
    required bool isActive,
    required _i1c87mer.RecordSource source,
    String? externalSystem,
    String? externalId,
    DateTime? missingSince,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
  }) = _CatalogServiceImpl;

  factory CatalogService.fromJson(Map<String, dynamic> jsonSerialization) {
    return CatalogService(
      id: jsonSerialization['id'] == null ? null : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      tenantId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['tenantId']),
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      unitCode: jsonSerialization['unitCode'] as String,
      defaultPrice: jsonSerialization['defaultPrice'] as int?,
      estimatedMinutes: jsonSerialization['estimatedMinutes'] as int?,
      serviceKind: _iu1dhgj0.ServiceKind.fromJson((jsonSerialization['serviceKind'] as String)),
      isActive: _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      source: _i1c87mer.RecordSource.fromJson((jsonSerialization['source'] as String)),
      externalSystem: jsonSerialization['externalSystem'] as String?,
      externalId: jsonSerialization['externalId'] as String?,
      missingSince: jsonSerialization['missingSince'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['missingSince']),
      createdAt: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      version: jsonSerialization['version'] as int,
    );
  }

  /// The id of the object.
  _isc.UuidValue id;

  _isc.UuidValue tenantId;

  String code;

  String name;

  String? description;

  String unitCode;

  int? defaultPrice;

  int? estimatedMinutes;

  _iu1dhgj0.ServiceKind serviceKind;

  bool isActive;

  _i1c87mer.RecordSource source;

  String? externalSystem;

  String? externalId;

  DateTime? missingSince;

  DateTime createdAt;

  DateTime updatedAt;

  int version;

  /// Returns a shallow copy of this [CatalogService]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CatalogService copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? tenantId,
    String? code,
    String? name,
    String? description,
    String? unitCode,
    int? defaultPrice,
    int? estimatedMinutes,
    _iu1dhgj0.ServiceKind? serviceKind,
    bool? isActive,
    _i1c87mer.RecordSource? source,
    String? externalSystem,
    String? externalId,
    DateTime? missingSince = const _isc.$UndefinedDateTime(),
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CatalogService',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      'code': code,
      'name': name,
      if (description != null) 'description': description,
      'unitCode': unitCode,
      if (defaultPrice != null) 'defaultPrice': defaultPrice,
      if (estimatedMinutes != null) 'estimatedMinutes': estimatedMinutes,
      'serviceKind': serviceKind.toJson(),
      'isActive': isActive,
      'source': source.toJson(),
      if (externalSystem != null) 'externalSystem': externalSystem,
      if (externalId != null) 'externalId': externalId,
      if (missingSince != null) 'missingSince': missingSince?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CatalogService',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      'code': code,
      'name': name,
      if (description != null) 'description': description,
      'unitCode': unitCode,
      if (defaultPrice != null) 'defaultPrice': defaultPrice,
      if (estimatedMinutes != null) 'estimatedMinutes': estimatedMinutes,
      'serviceKind': serviceKind.toJson(),
      'isActive': isActive,
      'source': source.toJson(),
      if (externalSystem != null) 'externalSystem': externalSystem,
      if (externalId != null) 'externalId': externalId,
      if (missingSince != null) 'missingSince': missingSince?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CatalogServiceImpl extends CatalogService {
  _CatalogServiceImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue tenantId,
    required String code,
    required String name,
    String? description,
    required String unitCode,
    int? defaultPrice,
    int? estimatedMinutes,
    required _iu1dhgj0.ServiceKind serviceKind,
    required bool isActive,
    required _i1c87mer.RecordSource source,
    String? externalSystem,
    String? externalId,
    DateTime? missingSince,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
  }) : super._(
         id: id,
         tenantId: tenantId,
         code: code,
         name: name,
         description: description,
         unitCode: unitCode,
         defaultPrice: defaultPrice,
         estimatedMinutes: estimatedMinutes,
         serviceKind: serviceKind,
         isActive: isActive,
         source: source,
         externalSystem: externalSystem,
         externalId: externalId,
         missingSince: missingSince,
         createdAt: createdAt,
         updatedAt: updatedAt,
         version: version,
       );

  /// Returns a shallow copy of this [CatalogService]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CatalogService copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? tenantId,
    String? code,
    String? name,
    Object? description = _Undefined,
    String? unitCode,
    Object? defaultPrice = _Undefined,
    Object? estimatedMinutes = _Undefined,
    _iu1dhgj0.ServiceKind? serviceKind,
    bool? isActive,
    _i1c87mer.RecordSource? source,
    Object? externalSystem = _Undefined,
    Object? externalId = _Undefined,
    DateTime? missingSince = const _isc.$UndefinedDateTime(),
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return CatalogService(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      unitCode: unitCode ?? this.unitCode,
      defaultPrice: defaultPrice is int? ? defaultPrice : this.defaultPrice,
      estimatedMinutes: estimatedMinutes is int? ? estimatedMinutes : this.estimatedMinutes,
      serviceKind: serviceKind ?? this.serviceKind,
      isActive: isActive ?? this.isActive,
      source: source ?? this.source,
      externalSystem: externalSystem is String? ? externalSystem : this.externalSystem,
      externalId: externalId is String? ? externalId : this.externalId,
      missingSince: missingSince is _isc.UndefinedSentinel ? this.missingSince : missingSince,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }
}
