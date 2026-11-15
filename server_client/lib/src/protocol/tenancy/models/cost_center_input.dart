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

abstract class CostCenterInput implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CostCenterInput._({
    required this.code,
    required this.name,
    this.branchId,
    this.erpCode,
    required this.isActive,
  });

  factory CostCenterInput({
    required String code,
    required String name,
    _isc.UuidValue? branchId,
    String? erpCode,
    required bool isActive,
  }) = _CostCenterInputImpl;

  factory CostCenterInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return CostCenterInput(
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      branchId: jsonSerialization['branchId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['branchId']),
      erpCode: jsonSerialization['erpCode'] as String?,
      isActive: _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  String code;

  String name;

  _isc.UuidValue? branchId;

  String? erpCode;

  bool isActive;

  /// Returns a shallow copy of this [CostCenterInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CostCenterInput copyWith({
    String? code,
    String? name,
    _isc.UuidValue? branchId = const _isc.$UndefinedUuidValue(),
    String? erpCode,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CostCenterInput',
      'code': code,
      'name': name,
      if (branchId != null) 'branchId': branchId?.toJson(),
      if (erpCode != null) 'erpCode': erpCode,
      'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CostCenterInput',
      'code': code,
      'name': name,
      if (branchId != null) 'branchId': branchId?.toJson(),
      if (erpCode != null) 'erpCode': erpCode,
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CostCenterInputImpl extends CostCenterInput {
  _CostCenterInputImpl({
    required String code,
    required String name,
    _isc.UuidValue? branchId,
    String? erpCode,
    required bool isActive,
  }) : super._(
         code: code,
         name: name,
         branchId: branchId,
         erpCode: erpCode,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [CostCenterInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CostCenterInput copyWith({
    String? code,
    String? name,
    _isc.UuidValue? branchId = const _isc.$UndefinedUuidValue(),
    Object? erpCode = _Undefined,
    bool? isActive,
  }) {
    return CostCenterInput(
      code: code ?? this.code,
      name: name ?? this.name,
      branchId: branchId is _isc.UndefinedSentinel ? this.branchId : branchId,
      erpCode: erpCode is String? ? erpCode : this.erpCode,
      isActive: isActive ?? this.isActive,
    );
  }
}
