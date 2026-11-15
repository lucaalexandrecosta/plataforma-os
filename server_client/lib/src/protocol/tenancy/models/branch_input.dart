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

abstract class BranchInput implements _isc.SerializableModel, _isc.ProtocolSerialization {
  BranchInput._({
    required this.code,
    required this.legalName,
    this.tradeName,
    this.documentNumber,
    this.city,
    this.state,
    this.erpBranchCode,
    required this.isDefault,
    required this.isActive,
  });

  factory BranchInput({
    required String code,
    required String legalName,
    String? tradeName,
    String? documentNumber,
    String? city,
    String? state,
    String? erpBranchCode,
    required bool isDefault,
    required bool isActive,
  }) = _BranchInputImpl;

  factory BranchInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return BranchInput(
      code: jsonSerialization['code'] as String,
      legalName: jsonSerialization['legalName'] as String,
      tradeName: jsonSerialization['tradeName'] as String?,
      documentNumber: jsonSerialization['documentNumber'] as String?,
      city: jsonSerialization['city'] as String?,
      state: jsonSerialization['state'] as String?,
      erpBranchCode: jsonSerialization['erpBranchCode'] as String?,
      isDefault: _isc.BoolJsonExtension.fromJson(jsonSerialization['isDefault']),
      isActive: _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  String code;

  String legalName;

  String? tradeName;

  String? documentNumber;

  String? city;

  String? state;

  String? erpBranchCode;

  bool isDefault;

  bool isActive;

  /// Returns a shallow copy of this [BranchInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  BranchInput copyWith({
    String? code,
    String? legalName,
    String? tradeName,
    String? documentNumber,
    String? city,
    String? state,
    String? erpBranchCode,
    bool? isDefault,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BranchInput',
      'code': code,
      'legalName': legalName,
      if (tradeName != null) 'tradeName': tradeName,
      if (documentNumber != null) 'documentNumber': documentNumber,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (erpBranchCode != null) 'erpBranchCode': erpBranchCode,
      'isDefault': isDefault,
      'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BranchInput',
      'code': code,
      'legalName': legalName,
      if (tradeName != null) 'tradeName': tradeName,
      if (documentNumber != null) 'documentNumber': documentNumber,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (erpBranchCode != null) 'erpBranchCode': erpBranchCode,
      'isDefault': isDefault,
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BranchInputImpl extends BranchInput {
  _BranchInputImpl({
    required String code,
    required String legalName,
    String? tradeName,
    String? documentNumber,
    String? city,
    String? state,
    String? erpBranchCode,
    required bool isDefault,
    required bool isActive,
  }) : super._(
         code: code,
         legalName: legalName,
         tradeName: tradeName,
         documentNumber: documentNumber,
         city: city,
         state: state,
         erpBranchCode: erpBranchCode,
         isDefault: isDefault,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [BranchInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  BranchInput copyWith({
    String? code,
    String? legalName,
    Object? tradeName = _Undefined,
    Object? documentNumber = _Undefined,
    Object? city = _Undefined,
    Object? state = _Undefined,
    Object? erpBranchCode = _Undefined,
    bool? isDefault,
    bool? isActive,
  }) {
    return BranchInput(
      code: code ?? this.code,
      legalName: legalName ?? this.legalName,
      tradeName: tradeName is String? ? tradeName : this.tradeName,
      documentNumber: documentNumber is String? ? documentNumber : this.documentNumber,
      city: city is String? ? city : this.city,
      state: state is String? ? state : this.state,
      erpBranchCode: erpBranchCode is String? ? erpBranchCode : this.erpBranchCode,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
    );
  }
}
