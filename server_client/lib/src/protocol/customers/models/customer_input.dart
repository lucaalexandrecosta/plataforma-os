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
import '../../customers/models/customer_kind.dart' as _itewe25f;
import '../../customers/models/document_type.dart' as _ij2uuldm;
import '../../customers/models/person_type.dart' as _iiezq3l7;

abstract class CustomerInput implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CustomerInput._({
    this.id,
    this.code,
    required this.name,
    this.tradeName,
    this.personType,
    this.documentType,
    this.documentNumber,
    this.stateRegistration,
    this.email,
    this.phone,
    this.notes,
    this.kind,
    this.skipTriage,
  });

  factory CustomerInput({
    _isc.UuidValue? id,
    String? code,
    required String name,
    String? tradeName,
    _iiezq3l7.PersonType? personType,
    _ij2uuldm.DocumentType? documentType,
    String? documentNumber,
    String? stateRegistration,
    String? email,
    String? phone,
    String? notes,
    _itewe25f.CustomerKind? kind,
    bool? skipTriage,
  }) = _CustomerInputImpl;

  factory CustomerInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return CustomerInput(
      id: jsonSerialization['id'] == null ? null : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      code: jsonSerialization['code'] as String?,
      name: jsonSerialization['name'] as String,
      tradeName: jsonSerialization['tradeName'] as String?,
      personType: jsonSerialization['personType'] == null
          ? null
          : _iiezq3l7.PersonType.fromJson((jsonSerialization['personType'] as String)),
      documentType: jsonSerialization['documentType'] == null
          ? null
          : _ij2uuldm.DocumentType.fromJson((jsonSerialization['documentType'] as String)),
      documentNumber: jsonSerialization['documentNumber'] as String?,
      stateRegistration: jsonSerialization['stateRegistration'] as String?,
      email: jsonSerialization['email'] as String?,
      phone: jsonSerialization['phone'] as String?,
      notes: jsonSerialization['notes'] as String?,
      kind: jsonSerialization['kind'] == null
          ? null
          : _itewe25f.CustomerKind.fromJson((jsonSerialization['kind'] as String)),
      skipTriage: jsonSerialization['skipTriage'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['skipTriage']),
    );
  }

  _isc.UuidValue? id;

  String? code;

  String name;

  String? tradeName;

  _iiezq3l7.PersonType? personType;

  _ij2uuldm.DocumentType? documentType;

  String? documentNumber;

  String? stateRegistration;

  String? email;

  String? phone;

  String? notes;

  _itewe25f.CustomerKind? kind;

  bool? skipTriage;

  /// Returns a shallow copy of this [CustomerInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CustomerInput copyWith({
    _isc.UuidValue? id = const _isc.$UndefinedUuidValue(),
    String? code,
    String? name,
    String? tradeName,
    _iiezq3l7.PersonType? personType,
    _ij2uuldm.DocumentType? documentType,
    String? documentNumber,
    String? stateRegistration,
    String? email,
    String? phone,
    String? notes,
    _itewe25f.CustomerKind? kind,
    bool? skipTriage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CustomerInput',
      if (id != null) 'id': id?.toJson(),
      if (code != null) 'code': code,
      'name': name,
      if (tradeName != null) 'tradeName': tradeName,
      if (personType != null) 'personType': personType?.toJson(),
      if (documentType != null) 'documentType': documentType?.toJson(),
      if (documentNumber != null) 'documentNumber': documentNumber,
      if (stateRegistration != null) 'stateRegistration': stateRegistration,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (notes != null) 'notes': notes,
      if (kind != null) 'kind': kind?.toJson(),
      if (skipTriage != null) 'skipTriage': skipTriage,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CustomerInput',
      if (id != null) 'id': id?.toJson(),
      if (code != null) 'code': code,
      'name': name,
      if (tradeName != null) 'tradeName': tradeName,
      if (personType != null) 'personType': personType?.toJson(),
      if (documentType != null) 'documentType': documentType?.toJson(),
      if (documentNumber != null) 'documentNumber': documentNumber,
      if (stateRegistration != null) 'stateRegistration': stateRegistration,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (notes != null) 'notes': notes,
      if (kind != null) 'kind': kind?.toJson(),
      if (skipTriage != null) 'skipTriage': skipTriage,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CustomerInputImpl extends CustomerInput {
  _CustomerInputImpl({
    _isc.UuidValue? id,
    String? code,
    required String name,
    String? tradeName,
    _iiezq3l7.PersonType? personType,
    _ij2uuldm.DocumentType? documentType,
    String? documentNumber,
    String? stateRegistration,
    String? email,
    String? phone,
    String? notes,
    _itewe25f.CustomerKind? kind,
    bool? skipTriage,
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
         kind: kind,
         skipTriage: skipTriage,
       );

  /// Returns a shallow copy of this [CustomerInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CustomerInput copyWith({
    _isc.UuidValue? id = const _isc.$UndefinedUuidValue(),
    Object? code = _Undefined,
    String? name,
    Object? tradeName = _Undefined,
    Object? personType = _Undefined,
    Object? documentType = _Undefined,
    Object? documentNumber = _Undefined,
    Object? stateRegistration = _Undefined,
    Object? email = _Undefined,
    Object? phone = _Undefined,
    Object? notes = _Undefined,
    Object? kind = _Undefined,
    Object? skipTriage = _Undefined,
  }) {
    return CustomerInput(
      id: id is _isc.UndefinedSentinel ? this.id : id,
      code: code is String? ? code : this.code,
      name: name ?? this.name,
      tradeName: tradeName is String? ? tradeName : this.tradeName,
      personType: personType is _iiezq3l7.PersonType? ? personType : this.personType,
      documentType: documentType is _ij2uuldm.DocumentType? ? documentType : this.documentType,
      documentNumber: documentNumber is String? ? documentNumber : this.documentNumber,
      stateRegistration: stateRegistration is String? ? stateRegistration : this.stateRegistration,
      email: email is String? ? email : this.email,
      phone: phone is String? ? phone : this.phone,
      notes: notes is String? ? notes : this.notes,
      kind: kind is _itewe25f.CustomerKind? ? kind : this.kind,
      skipTriage: skipTriage is bool? ? skipTriage : this.skipTriage,
    );
  }
}
