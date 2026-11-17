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

abstract class Customer implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Customer._({
    required this.id,
    this.code,
    required this.name,
    this.tradeName,
    required this.personType,
    required this.documentType,
    this.documentNumber,
    this.stateRegistration,
    this.email,
    this.phone,
    this.notes,
    required this.isActive,
    required this.source,
    required this.siteCount,
    required this.version,
  });

  factory Customer({
    required _isc.UuidValue id,
    String? code,
    required String name,
    String? tradeName,
    required String personType,
    required String documentType,
    String? documentNumber,
    String? stateRegistration,
    String? email,
    String? phone,
    String? notes,
    required bool isActive,
    required String source,
    required int siteCount,
    required int version,
  }) = _CustomerImpl;

  factory Customer.fromJson(Map<String, dynamic> jsonSerialization) {
    return Customer(
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      code: jsonSerialization['code'] as String?,
      name: jsonSerialization['name'] as String,
      tradeName: jsonSerialization['tradeName'] as String?,
      personType: jsonSerialization['personType'] as String,
      documentType: jsonSerialization['documentType'] as String,
      documentNumber: jsonSerialization['documentNumber'] as String?,
      stateRegistration: jsonSerialization['stateRegistration'] as String?,
      email: jsonSerialization['email'] as String?,
      phone: jsonSerialization['phone'] as String?,
      notes: jsonSerialization['notes'] as String?,
      isActive: _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      source: jsonSerialization['source'] as String,
      siteCount: jsonSerialization['siteCount'] as int,
      version: jsonSerialization['version'] as int,
    );
  }

  _isc.UuidValue id;

  String? code;

  String name;

  String? tradeName;

  String personType;

  String documentType;

  String? documentNumber;

  String? stateRegistration;

  String? email;

  String? phone;

  String? notes;

  bool isActive;

  String source;

  int siteCount;

  int version;

  /// Returns a shallow copy of this [Customer]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Customer copyWith({
    _isc.UuidValue? id,
    String? code,
    String? name,
    String? tradeName,
    String? personType,
    String? documentType,
    String? documentNumber,
    String? stateRegistration,
    String? email,
    String? phone,
    String? notes,
    bool? isActive,
    String? source,
    int? siteCount,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Customer',
      'id': id.toJson(),
      if (code != null) 'code': code,
      'name': name,
      if (tradeName != null) 'tradeName': tradeName,
      'personType': personType,
      'documentType': documentType,
      if (documentNumber != null) 'documentNumber': documentNumber,
      if (stateRegistration != null) 'stateRegistration': stateRegistration,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (notes != null) 'notes': notes,
      'isActive': isActive,
      'source': source,
      'siteCount': siteCount,
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Customer',
      'id': id.toJson(),
      if (code != null) 'code': code,
      'name': name,
      if (tradeName != null) 'tradeName': tradeName,
      'personType': personType,
      'documentType': documentType,
      if (documentNumber != null) 'documentNumber': documentNumber,
      if (stateRegistration != null) 'stateRegistration': stateRegistration,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (notes != null) 'notes': notes,
      'isActive': isActive,
      'source': source,
      'siteCount': siteCount,
      'version': version,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CustomerImpl extends Customer {
  _CustomerImpl({
    required _isc.UuidValue id,
    String? code,
    required String name,
    String? tradeName,
    required String personType,
    required String documentType,
    String? documentNumber,
    String? stateRegistration,
    String? email,
    String? phone,
    String? notes,
    required bool isActive,
    required String source,
    required int siteCount,
    required int version,
  }) : super._(
         id: id,
         code: code,
         name: name,
         tradeName: tradeName,
         personType: personType,
         documentType: documentType,
         documentNumber: documentNumber,
         stateRegistration: stateRegistration,
         email: email,
         phone: phone,
         notes: notes,
         isActive: isActive,
         source: source,
         siteCount: siteCount,
         version: version,
       );

  /// Returns a shallow copy of this [Customer]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Customer copyWith({
    _isc.UuidValue? id,
    Object? code = _Undefined,
    String? name,
    Object? tradeName = _Undefined,
    String? personType,
    String? documentType,
    Object? documentNumber = _Undefined,
    Object? stateRegistration = _Undefined,
    Object? email = _Undefined,
    Object? phone = _Undefined,
    Object? notes = _Undefined,
    bool? isActive,
    String? source,
    int? siteCount,
    int? version,
  }) {
    return Customer(
      id: id ?? this.id,
      code: code is String? ? code : this.code,
      name: name ?? this.name,
      tradeName: tradeName is String? ? tradeName : this.tradeName,
      personType: personType ?? this.personType,
      documentType: documentType ?? this.documentType,
      documentNumber: documentNumber is String? ? documentNumber : this.documentNumber,
      stateRegistration: stateRegistration is String? ? stateRegistration : this.stateRegistration,
      email: email is String? ? email : this.email,
      phone: phone is String? ? phone : this.phone,
      notes: notes is String? ? notes : this.notes,
      isActive: isActive ?? this.isActive,
      source: source ?? this.source,
      siteCount: siteCount ?? this.siteCount,
      version: version ?? this.version,
    );
  }
}
