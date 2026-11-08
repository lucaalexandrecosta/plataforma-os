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
import '../../catalog/models/service_field.dart' as _imlowk4m;
import '../../catalog/models/service_kind.dart' as _iu1dhgj0;

abstract class CatalogServicePatch implements _is.SerializableModel, _is.ProtocolSerialization {
  CatalogServicePatch._({
    this.code,
    this.name,
    this.description,
    this.unitCode,
    this.defaultPrice,
    this.estimatedMinutes,
    this.serviceKind,
    this.clear,
  });

  factory CatalogServicePatch({
    String? code,
    String? name,
    String? description,
    String? unitCode,
    int? defaultPrice,
    int? estimatedMinutes,
    _iu1dhgj0.ServiceKind? serviceKind,
    List<_imlowk4m.CatalogServiceField>? clear,
  }) = _CatalogServicePatchImpl;

  factory CatalogServicePatch.fromJson(Map<String, dynamic> jsonSerialization) {
    return CatalogServicePatch(
      code: jsonSerialization['code'] as String?,
      name: jsonSerialization['name'] as String?,
      description: jsonSerialization['description'] as String?,
      unitCode: jsonSerialization['unitCode'] as String?,
      defaultPrice: jsonSerialization['defaultPrice'] as int?,
      estimatedMinutes: jsonSerialization['estimatedMinutes'] as int?,
      serviceKind: jsonSerialization['serviceKind'] == null
          ? null
          : _iu1dhgj0.ServiceKind.fromJson((jsonSerialization['serviceKind'] as String)),
      clear: jsonSerialization['clear'] == null
          ? null
          : _isma42go.Protocol().deserialize<List<_imlowk4m.CatalogServiceField>>(jsonSerialization['clear']),
    );
  }

  String? code;

  String? name;

  String? description;

  String? unitCode;

  int? defaultPrice;

  int? estimatedMinutes;

  _iu1dhgj0.ServiceKind? serviceKind;

  List<_imlowk4m.CatalogServiceField>? clear;

  /// Returns a shallow copy of this [CatalogServicePatch]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CatalogServicePatch copyWith({
    String? code,
    String? name,
    String? description,
    String? unitCode,
    int? defaultPrice,
    int? estimatedMinutes,
    _iu1dhgj0.ServiceKind? serviceKind,
    List<_imlowk4m.CatalogServiceField>? clear = const _is.$UndefinedList<_imlowk4m.CatalogServiceField>(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CatalogServicePatch',
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (unitCode != null) 'unitCode': unitCode,
      if (defaultPrice != null) 'defaultPrice': defaultPrice,
      if (estimatedMinutes != null) 'estimatedMinutes': estimatedMinutes,
      if (serviceKind != null) 'serviceKind': serviceKind?.toJson(),
      if (clear != null) 'clear': clear?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CatalogServicePatch',
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (unitCode != null) 'unitCode': unitCode,
      if (defaultPrice != null) 'defaultPrice': defaultPrice,
      if (estimatedMinutes != null) 'estimatedMinutes': estimatedMinutes,
      if (serviceKind != null) 'serviceKind': serviceKind?.toJson(),
      if (clear != null) 'clear': clear?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CatalogServicePatchImpl extends CatalogServicePatch {
  _CatalogServicePatchImpl({
    String? code,
    String? name,
    String? description,
    String? unitCode,
    int? defaultPrice,
    int? estimatedMinutes,
    _iu1dhgj0.ServiceKind? serviceKind,
    List<_imlowk4m.CatalogServiceField>? clear,
  }) : super._(
         code: code,
         name: name,
         description: description,
         unitCode: unitCode,
         defaultPrice: defaultPrice,
         estimatedMinutes: estimatedMinutes,
         serviceKind: serviceKind,
         clear: clear,
       );

  /// Returns a shallow copy of this [CatalogServicePatch]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CatalogServicePatch copyWith({
    Object? code = _Undefined,
    Object? name = _Undefined,
    Object? description = _Undefined,
    Object? unitCode = _Undefined,
    Object? defaultPrice = _Undefined,
    Object? estimatedMinutes = _Undefined,
    Object? serviceKind = _Undefined,
    List<_imlowk4m.CatalogServiceField>? clear = const _is.$UndefinedList<_imlowk4m.CatalogServiceField>(),
  }) {
    return CatalogServicePatch(
      code: code is String? ? code : this.code,
      name: name is String? ? name : this.name,
      description: description is String? ? description : this.description,
      unitCode: unitCode is String? ? unitCode : this.unitCode,
      defaultPrice: defaultPrice is int? ? defaultPrice : this.defaultPrice,
      estimatedMinutes: estimatedMinutes is int? ? estimatedMinutes : this.estimatedMinutes,
      serviceKind: serviceKind is _iu1dhgj0.ServiceKind? ? serviceKind : this.serviceKind,
      clear: clear is _is.UndefinedSentinel ? this.clear?.map((e0) => e0).toList() : clear,
    );
  }
}
