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

abstract class CatalogServiceInput implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CatalogServiceInput._({
    this.id,
    required this.code,
    required this.name,
    this.description,
    this.unitCode,
    this.defaultPrice,
    this.estimatedMinutes,
    this.serviceKind,
  });

  factory CatalogServiceInput({
    _isc.UuidValue? id,
    required String code,
    required String name,
    String? description,
    String? unitCode,
    int? defaultPrice,
    int? estimatedMinutes,
    _iu1dhgj0.ServiceKind? serviceKind,
  }) = _CatalogServiceInputImpl;

  factory CatalogServiceInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return CatalogServiceInput(
      id: jsonSerialization['id'] == null ? null : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      unitCode: jsonSerialization['unitCode'] as String?,
      defaultPrice: jsonSerialization['defaultPrice'] as int?,
      estimatedMinutes: jsonSerialization['estimatedMinutes'] as int?,
      serviceKind: jsonSerialization['serviceKind'] == null
          ? null
          : _iu1dhgj0.ServiceKind.fromJson((jsonSerialization['serviceKind'] as String)),
    );
  }

  _isc.UuidValue? id;

  String code;

  String name;

  String? description;

  String? unitCode;

  int? defaultPrice;

  int? estimatedMinutes;

  _iu1dhgj0.ServiceKind? serviceKind;

  /// Returns a shallow copy of this [CatalogServiceInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CatalogServiceInput copyWith({
    _isc.UuidValue? id = const _isc.$UndefinedUuidValue(),
    String? code,
    String? name,
    String? description,
    String? unitCode,
    int? defaultPrice,
    int? estimatedMinutes,
    _iu1dhgj0.ServiceKind? serviceKind,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CatalogServiceInput',
      if (id != null) 'id': id?.toJson(),
      'code': code,
      'name': name,
      if (description != null) 'description': description,
      if (unitCode != null) 'unitCode': unitCode,
      if (defaultPrice != null) 'defaultPrice': defaultPrice,
      if (estimatedMinutes != null) 'estimatedMinutes': estimatedMinutes,
      if (serviceKind != null) 'serviceKind': serviceKind?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CatalogServiceInput',
      if (id != null) 'id': id?.toJson(),
      'code': code,
      'name': name,
      if (description != null) 'description': description,
      if (unitCode != null) 'unitCode': unitCode,
      if (defaultPrice != null) 'defaultPrice': defaultPrice,
      if (estimatedMinutes != null) 'estimatedMinutes': estimatedMinutes,
      if (serviceKind != null) 'serviceKind': serviceKind?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CatalogServiceInputImpl extends CatalogServiceInput {
  _CatalogServiceInputImpl({
    _isc.UuidValue? id,
    required String code,
    required String name,
    String? description,
    String? unitCode,
    int? defaultPrice,
    int? estimatedMinutes,
    _iu1dhgj0.ServiceKind? serviceKind,
  }) : super._(
         id: id,
         code: code,
         name: name,
         description: description,
         unitCode: unitCode,
         defaultPrice: defaultPrice,
         estimatedMinutes: estimatedMinutes,
         serviceKind: serviceKind,
       );

  /// Returns a shallow copy of this [CatalogServiceInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CatalogServiceInput copyWith({
    _isc.UuidValue? id = const _isc.$UndefinedUuidValue(),
    String? code,
    String? name,
    Object? description = _Undefined,
    Object? unitCode = _Undefined,
    Object? defaultPrice = _Undefined,
    Object? estimatedMinutes = _Undefined,
    Object? serviceKind = _Undefined,
  }) {
    return CatalogServiceInput(
      id: id is _isc.UndefinedSentinel ? this.id : id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      unitCode: unitCode is String? ? unitCode : this.unitCode,
      defaultPrice: defaultPrice is int? ? defaultPrice : this.defaultPrice,
      estimatedMinutes: estimatedMinutes is int? ? estimatedMinutes : this.estimatedMinutes,
      serviceKind: serviceKind is _iu1dhgj0.ServiceKind? ? serviceKind : this.serviceKind,
    );
  }
}
