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
import 'package:serverpod/serverpod.dart' as _is;

abstract class CostCenter implements _is.SerializableModel, _is.ProtocolSerialization {
  CostCenter._({
    required this.id,
    required this.code,
    required this.name,
    this.branchId,
    this.erpCode,
    required this.isActive,
    required this.version,
  });

  factory CostCenter({
    required _is.UuidValue id,
    required String code,
    required String name,
    _is.UuidValue? branchId,
    String? erpCode,
    required bool isActive,
    required int version,
  }) = _CostCenterImpl;

  factory CostCenter.fromJson(Map<String, dynamic> jsonSerialization) {
    return CostCenter(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      branchId: jsonSerialization['branchId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['branchId']),
      erpCode: jsonSerialization['erpCode'] as String?,
      isActive: _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      version: jsonSerialization['version'] as int,
    );
  }

  _is.UuidValue id;

  String code;

  String name;

  _is.UuidValue? branchId;

  String? erpCode;

  bool isActive;

  int version;

  /// Returns a shallow copy of this [CostCenter]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CostCenter copyWith({
    _is.UuidValue? id,
    String? code,
    String? name,
    _is.UuidValue? branchId = const _is.$UndefinedUuidValue(),
    String? erpCode,
    bool? isActive,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CostCenter',
      'id': id.toJson(),
      'code': code,
      'name': name,
      if (branchId != null) 'branchId': branchId?.toJson(),
      if (erpCode != null) 'erpCode': erpCode,
      'isActive': isActive,
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CostCenter',
      'id': id.toJson(),
      'code': code,
      'name': name,
      if (branchId != null) 'branchId': branchId?.toJson(),
      if (erpCode != null) 'erpCode': erpCode,
      'isActive': isActive,
      'version': version,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CostCenterImpl extends CostCenter {
  _CostCenterImpl({
    required _is.UuidValue id,
    required String code,
    required String name,
    _is.UuidValue? branchId,
    String? erpCode,
    required bool isActive,
    required int version,
  }) : super._(
         id: id,
         code: code,
         name: name,
         branchId: branchId,
         erpCode: erpCode,
         isActive: isActive,
         version: version,
       );

  /// Returns a shallow copy of this [CostCenter]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CostCenter copyWith({
    _is.UuidValue? id,
    String? code,
    String? name,
    _is.UuidValue? branchId = const _is.$UndefinedUuidValue(),
    Object? erpCode = _Undefined,
    bool? isActive,
    int? version,
  }) {
    return CostCenter(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      branchId: branchId is _is.UndefinedSentinel ? this.branchId : branchId,
      erpCode: erpCode is String? ? erpCode : this.erpCode,
      isActive: isActive ?? this.isActive,
      version: version ?? this.version,
    );
  }
}
