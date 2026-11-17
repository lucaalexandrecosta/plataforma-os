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

abstract class CustomerInput implements _is.SerializableModel, _is.ProtocolSerialization {
  CustomerInput._({
    this.code,
    required this.name,
    this.tradeName,
    required this.personType,
    this.documentNumber,
    this.stateRegistration,
    this.email,
    this.phone,
    this.notes,
    required this.isActive,
  });

  factory CustomerInput({
    String? code,
    required String name,
    String? tradeName,
    required String personType,
    String? documentNumber,
    String? stateRegistration,
    String? email,
    String? phone,
    String? notes,
    required bool isActive,
  }) = _CustomerInputImpl;

  factory CustomerInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return CustomerInput(
      code: jsonSerialization['code'] as String?,
      name: jsonSerialization['name'] as String,
      tradeName: jsonSerialization['tradeName'] as String?,
      personType: jsonSerialization['personType'] as String,
      documentNumber: jsonSerialization['documentNumber'] as String?,
      stateRegistration: jsonSerialization['stateRegistration'] as String?,
      email: jsonSerialization['email'] as String?,
      phone: jsonSerialization['phone'] as String?,
      notes: jsonSerialization['notes'] as String?,
      isActive: _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  String? code;

  String name;

  String? tradeName;

  String personType;

  String? documentNumber;

  String? stateRegistration;

  String? email;

  String? phone;

  String? notes;

  bool isActive;

  /// Returns a shallow copy of this [CustomerInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CustomerInput copyWith({
    String? code,
    String? name,
    String? tradeName,
    String? personType,
    String? documentNumber,
    String? stateRegistration,
    String? email,
    String? phone,
    String? notes,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CustomerInput',
      if (code != null) 'code': code,
      'name': name,
      if (tradeName != null) 'tradeName': tradeName,
      'personType': personType,
      if (documentNumber != null) 'documentNumber': documentNumber,
      if (stateRegistration != null) 'stateRegistration': stateRegistration,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (notes != null) 'notes': notes,
      'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CustomerInput',
      if (code != null) 'code': code,
      'name': name,
      if (tradeName != null) 'tradeName': tradeName,
      'personType': personType,
      if (documentNumber != null) 'documentNumber': documentNumber,
      if (stateRegistration != null) 'stateRegistration': stateRegistration,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (notes != null) 'notes': notes,
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CustomerInputImpl extends CustomerInput {
  _CustomerInputImpl({
    String? code,
    required String name,
    String? tradeName,
    required String personType,
    String? documentNumber,
    String? stateRegistration,
    String? email,
    String? phone,
    String? notes,
    required bool isActive,
  }) : super._(
         code: code,
         name: name,
         tradeName: tradeName,
         personType: personType,
         documentNumber: documentNumber,
         stateRegistration: stateRegistration,
         email: email,
         phone: phone,
         notes: notes,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [CustomerInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CustomerInput copyWith({
    Object? code = _Undefined,
    String? name,
    Object? tradeName = _Undefined,
    String? personType,
    Object? documentNumber = _Undefined,
    Object? stateRegistration = _Undefined,
    Object? email = _Undefined,
    Object? phone = _Undefined,
    Object? notes = _Undefined,
    bool? isActive,
  }) {
    return CustomerInput(
      code: code is String? ? code : this.code,
      name: name ?? this.name,
      tradeName: tradeName is String? ? tradeName : this.tradeName,
      personType: personType ?? this.personType,
      documentNumber: documentNumber is String? ? documentNumber : this.documentNumber,
      stateRegistration: stateRegistration is String? ? stateRegistration : this.stateRegistration,
      email: email is String? ? email : this.email,
      phone: phone is String? ? phone : this.phone,
      notes: notes is String? ? notes : this.notes,
      isActive: isActive ?? this.isActive,
    );
  }
}
