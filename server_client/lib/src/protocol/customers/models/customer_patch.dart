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
import 'package:plataforma_os_client/src/protocol/protocol.dart' as _inlzmlpe;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../../customers/models/customer_field.dart' as _ilm0whvp;
import '../../customers/models/customer_kind.dart' as _itewe25f;
import '../../customers/models/document_type.dart' as _ij2uuldm;
import '../../customers/models/person_type.dart' as _iiezq3l7;

abstract class CustomerPatch implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CustomerPatch._({
    this.code,
    this.name,
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
    this.clear,
  });

  factory CustomerPatch({
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
    List<_ilm0whvp.CustomerField>? clear,
  }) = _CustomerPatchImpl;

  factory CustomerPatch.fromJson(Map<String, dynamic> jsonSerialization) {
    return CustomerPatch(
      code: jsonSerialization['code'] as String?,
      name: jsonSerialization['name'] as String?,
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
      clear: jsonSerialization['clear'] == null
          ? null
          : _inlzmlpe.Protocol().deserialize<List<_ilm0whvp.CustomerField>>(jsonSerialization['clear']),
    );
  }

  String? code;

  String? name;

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

  List<_ilm0whvp.CustomerField>? clear;

  /// Returns a shallow copy of this [CustomerPatch]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CustomerPatch copyWith({
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
    List<_ilm0whvp.CustomerField>? clear = const _isc.$UndefinedList<_ilm0whvp.CustomerField>(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CustomerPatch',
      if (code != null) 'code': code,
      if (name != null) 'name': name,
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
      if (clear != null) 'clear': clear?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CustomerPatch',
      if (code != null) 'code': code,
      if (name != null) 'name': name,
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
      if (clear != null) 'clear': clear?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CustomerPatchImpl extends CustomerPatch {
  _CustomerPatchImpl({
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
    List<_ilm0whvp.CustomerField>? clear,
  }) : super._(
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
         clear: clear,
       );

  /// Returns a shallow copy of this [CustomerPatch]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CustomerPatch copyWith({
    Object? code = _Undefined,
    Object? name = _Undefined,
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
    List<_ilm0whvp.CustomerField>? clear = const _isc.$UndefinedList<_ilm0whvp.CustomerField>(),
  }) {
    return CustomerPatch(
      code: code is String? ? code : this.code,
      name: name is String? ? name : this.name,
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
      clear: clear is _isc.UndefinedSentinel ? this.clear?.map((e0) => e0).toList() : clear,
    );
  }
}
