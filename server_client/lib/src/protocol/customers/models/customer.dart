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
import '../../platform/models/record_source.dart' as _i1c87mer;

abstract class Customer implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Customer._({
    _isc.UuidValue? id,
    required this.tenantId,
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
    required this.kind,
    this.primarySalesRepId,
    required this.skipTriage,
    required this.isActive,
    this.deactivatedAt,
    required this.source,
    this.externalSystem,
    this.externalId,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  }) : id = id ?? const _isc.Uuid().v7obj();

  factory Customer({
    _isc.UuidValue? id,
    required _isc.UuidValue tenantId,
    String? code,
    required String name,
    String? tradeName,
    required _iiezq3l7.PersonType personType,
    required _ij2uuldm.DocumentType documentType,
    String? documentNumber,
    String? stateRegistration,
    String? email,
    String? phone,
    String? notes,
    required _itewe25f.CustomerKind kind,
    _isc.UuidValue? primarySalesRepId,
    required bool skipTriage,
    required bool isActive,
    DateTime? deactivatedAt,
    required _i1c87mer.RecordSource source,
    String? externalSystem,
    String? externalId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
  }) = _CustomerImpl;

  factory Customer.fromJson(Map<String, dynamic> jsonSerialization) {
    return Customer(
      id: jsonSerialization['id'] == null ? null : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      tenantId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['tenantId']),
      code: jsonSerialization['code'] as String?,
      name: jsonSerialization['name'] as String,
      tradeName: jsonSerialization['tradeName'] as String?,
      personType: _iiezq3l7.PersonType.fromJson((jsonSerialization['personType'] as String)),
      documentType: _ij2uuldm.DocumentType.fromJson((jsonSerialization['documentType'] as String)),
      documentNumber: jsonSerialization['documentNumber'] as String?,
      stateRegistration: jsonSerialization['stateRegistration'] as String?,
      email: jsonSerialization['email'] as String?,
      phone: jsonSerialization['phone'] as String?,
      notes: jsonSerialization['notes'] as String?,
      kind: _itewe25f.CustomerKind.fromJson((jsonSerialization['kind'] as String)),
      primarySalesRepId: jsonSerialization['primarySalesRepId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['primarySalesRepId']),
      skipTriage: _isc.BoolJsonExtension.fromJson(jsonSerialization['skipTriage']),
      isActive: _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      deactivatedAt: jsonSerialization['deactivatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['deactivatedAt']),
      source: _i1c87mer.RecordSource.fromJson((jsonSerialization['source'] as String)),
      externalSystem: jsonSerialization['externalSystem'] as String?,
      externalId: jsonSerialization['externalId'] as String?,
      createdAt: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      version: jsonSerialization['version'] as int,
    );
  }

  /// The id of the object.
  _isc.UuidValue id;

  _isc.UuidValue tenantId;

  String? code;

  String name;

  String? tradeName;

  _iiezq3l7.PersonType personType;

  _ij2uuldm.DocumentType documentType;

  String? documentNumber;

  String? stateRegistration;

  String? email;

  String? phone;

  String? notes;

  _itewe25f.CustomerKind kind;

  _isc.UuidValue? primarySalesRepId;

  bool skipTriage;

  bool isActive;

  DateTime? deactivatedAt;

  _i1c87mer.RecordSource source;

  String? externalSystem;

  String? externalId;

  DateTime createdAt;

  DateTime updatedAt;

  int version;

  /// Returns a shallow copy of this [Customer]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Customer copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? tenantId,
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
    _isc.UuidValue? primarySalesRepId = const _isc.$UndefinedUuidValue(),
    bool? skipTriage,
    bool? isActive,
    DateTime? deactivatedAt = const _isc.$UndefinedDateTime(),
    _i1c87mer.RecordSource? source,
    String? externalSystem,
    String? externalId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Customer',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      if (code != null) 'code': code,
      'name': name,
      if (tradeName != null) 'tradeName': tradeName,
      'personType': personType.toJson(),
      'documentType': documentType.toJson(),
      if (documentNumber != null) 'documentNumber': documentNumber,
      if (stateRegistration != null) 'stateRegistration': stateRegistration,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (notes != null) 'notes': notes,
      'kind': kind.toJson(),
      if (primarySalesRepId != null) 'primarySalesRepId': primarySalesRepId?.toJson(),
      'skipTriage': skipTriage,
      'isActive': isActive,
      if (deactivatedAt != null) 'deactivatedAt': deactivatedAt?.toJson(),
      'source': source.toJson(),
      if (externalSystem != null) 'externalSystem': externalSystem,
      if (externalId != null) 'externalId': externalId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Customer',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      if (code != null) 'code': code,
      'name': name,
      if (tradeName != null) 'tradeName': tradeName,
      'personType': personType.toJson(),
      'documentType': documentType.toJson(),
      if (documentNumber != null) 'documentNumber': documentNumber,
      if (stateRegistration != null) 'stateRegistration': stateRegistration,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (notes != null) 'notes': notes,
      'kind': kind.toJson(),
      if (primarySalesRepId != null) 'primarySalesRepId': primarySalesRepId?.toJson(),
      'skipTriage': skipTriage,
      'isActive': isActive,
      if (deactivatedAt != null) 'deactivatedAt': deactivatedAt?.toJson(),
      'source': source.toJson(),
      if (externalSystem != null) 'externalSystem': externalSystem,
      if (externalId != null) 'externalId': externalId,
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

class _CustomerImpl extends Customer {
  _CustomerImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue tenantId,
    String? code,
    required String name,
    String? tradeName,
    required _iiezq3l7.PersonType personType,
    required _ij2uuldm.DocumentType documentType,
    String? documentNumber,
    String? stateRegistration,
    String? email,
    String? phone,
    String? notes,
    required _itewe25f.CustomerKind kind,
    _isc.UuidValue? primarySalesRepId,
    required bool skipTriage,
    required bool isActive,
    DateTime? deactivatedAt,
    required _i1c87mer.RecordSource source,
    String? externalSystem,
    String? externalId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
  }) : super._(
         id: id,
         tenantId: tenantId,
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
         primarySalesRepId: primarySalesRepId,
         skipTriage: skipTriage,
         isActive: isActive,
         deactivatedAt: deactivatedAt,
         source: source,
         externalSystem: externalSystem,
         externalId: externalId,
         createdAt: createdAt,
         updatedAt: updatedAt,
         version: version,
       );

  /// Returns a shallow copy of this [Customer]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Customer copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? tenantId,
    Object? code = _Undefined,
    String? name,
    Object? tradeName = _Undefined,
    _iiezq3l7.PersonType? personType,
    _ij2uuldm.DocumentType? documentType,
    Object? documentNumber = _Undefined,
    Object? stateRegistration = _Undefined,
    Object? email = _Undefined,
    Object? phone = _Undefined,
    Object? notes = _Undefined,
    _itewe25f.CustomerKind? kind,
    _isc.UuidValue? primarySalesRepId = const _isc.$UndefinedUuidValue(),
    bool? skipTriage,
    bool? isActive,
    DateTime? deactivatedAt = const _isc.$UndefinedDateTime(),
    _i1c87mer.RecordSource? source,
    Object? externalSystem = _Undefined,
    Object? externalId = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return Customer(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
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
      kind: kind ?? this.kind,
      primarySalesRepId: primarySalesRepId is _isc.UndefinedSentinel ? this.primarySalesRepId : primarySalesRepId,
      skipTriage: skipTriage ?? this.skipTriage,
      isActive: isActive ?? this.isActive,
      deactivatedAt: deactivatedAt is _isc.UndefinedSentinel ? this.deactivatedAt : deactivatedAt,
      source: source ?? this.source,
      externalSystem: externalSystem is String? ? externalSystem : this.externalSystem,
      externalId: externalId is String? ? externalId : this.externalId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }
}
