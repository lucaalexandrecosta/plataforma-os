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
import '../../platform/models/record_source.dart' as _i1c87mer;

abstract class CustomerSite implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CustomerSite._({
    _isc.UuidValue? id,
    required this.tenantId,
    required this.customerId,
    this.code,
    required this.name,
    this.street,
    this.streetNumber,
    this.complement,
    this.district,
    this.city,
    this.state,
    this.postalCode,
    required this.countryCode,
    this.latitude,
    this.longitude,
    this.phone,
    this.accessNotes,
    this.serviceAreaId,
    required this.isActive,
    required this.source,
    this.externalSystem,
    this.externalId,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  }) : id = id ?? const _isc.Uuid().v7obj();

  factory CustomerSite({
    _isc.UuidValue? id,
    required _isc.UuidValue tenantId,
    required _isc.UuidValue customerId,
    String? code,
    required String name,
    String? street,
    String? streetNumber,
    String? complement,
    String? district,
    String? city,
    String? state,
    String? postalCode,
    required String countryCode,
    double? latitude,
    double? longitude,
    String? phone,
    String? accessNotes,
    _isc.UuidValue? serviceAreaId,
    required bool isActive,
    required _i1c87mer.RecordSource source,
    String? externalSystem,
    String? externalId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
  }) = _CustomerSiteImpl;

  factory CustomerSite.fromJson(Map<String, dynamic> jsonSerialization) {
    return CustomerSite(
      id: jsonSerialization['id'] == null ? null : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      tenantId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['tenantId']),
      customerId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['customerId']),
      code: jsonSerialization['code'] as String?,
      name: jsonSerialization['name'] as String,
      street: jsonSerialization['street'] as String?,
      streetNumber: jsonSerialization['streetNumber'] as String?,
      complement: jsonSerialization['complement'] as String?,
      district: jsonSerialization['district'] as String?,
      city: jsonSerialization['city'] as String?,
      state: jsonSerialization['state'] as String?,
      postalCode: jsonSerialization['postalCode'] as String?,
      countryCode: jsonSerialization['countryCode'] as String,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      phone: jsonSerialization['phone'] as String?,
      accessNotes: jsonSerialization['accessNotes'] as String?,
      serviceAreaId: jsonSerialization['serviceAreaId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['serviceAreaId']),
      isActive: _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
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

  _isc.UuidValue customerId;

  String? code;

  String name;

  String? street;

  String? streetNumber;

  String? complement;

  String? district;

  String? city;

  String? state;

  String? postalCode;

  String countryCode;

  double? latitude;

  double? longitude;

  String? phone;

  String? accessNotes;

  _isc.UuidValue? serviceAreaId;

  bool isActive;

  _i1c87mer.RecordSource source;

  String? externalSystem;

  String? externalId;

  DateTime createdAt;

  DateTime updatedAt;

  int version;

  /// Returns a shallow copy of this [CustomerSite]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CustomerSite copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? tenantId,
    _isc.UuidValue? customerId,
    String? code,
    String? name,
    String? street,
    String? streetNumber,
    String? complement,
    String? district,
    String? city,
    String? state,
    String? postalCode,
    String? countryCode,
    double? latitude,
    double? longitude,
    String? phone,
    String? accessNotes,
    _isc.UuidValue? serviceAreaId = const _isc.$UndefinedUuidValue(),
    bool? isActive,
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
      '__className__': 'CustomerSite',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      'customerId': customerId.toJson(),
      if (code != null) 'code': code,
      'name': name,
      if (street != null) 'street': street,
      if (streetNumber != null) 'streetNumber': streetNumber,
      if (complement != null) 'complement': complement,
      if (district != null) 'district': district,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (postalCode != null) 'postalCode': postalCode,
      'countryCode': countryCode,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (phone != null) 'phone': phone,
      if (accessNotes != null) 'accessNotes': accessNotes,
      if (serviceAreaId != null) 'serviceAreaId': serviceAreaId?.toJson(),
      'isActive': isActive,
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
      '__className__': 'CustomerSite',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      'customerId': customerId.toJson(),
      if (code != null) 'code': code,
      'name': name,
      if (street != null) 'street': street,
      if (streetNumber != null) 'streetNumber': streetNumber,
      if (complement != null) 'complement': complement,
      if (district != null) 'district': district,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (postalCode != null) 'postalCode': postalCode,
      'countryCode': countryCode,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (phone != null) 'phone': phone,
      if (accessNotes != null) 'accessNotes': accessNotes,
      if (serviceAreaId != null) 'serviceAreaId': serviceAreaId?.toJson(),
      'isActive': isActive,
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

class _CustomerSiteImpl extends CustomerSite {
  _CustomerSiteImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue tenantId,
    required _isc.UuidValue customerId,
    String? code,
    required String name,
    String? street,
    String? streetNumber,
    String? complement,
    String? district,
    String? city,
    String? state,
    String? postalCode,
    required String countryCode,
    double? latitude,
    double? longitude,
    String? phone,
    String? accessNotes,
    _isc.UuidValue? serviceAreaId,
    required bool isActive,
    required _i1c87mer.RecordSource source,
    String? externalSystem,
    String? externalId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
  }) : super._(
         id: id,
         tenantId: tenantId,
         customerId: customerId,
         code: code,
         name: name,
         street: street,
         streetNumber: streetNumber,
         complement: complement,
         district: district,
         city: city,
         state: state,
         postalCode: postalCode,
         countryCode: countryCode,
         latitude: latitude,
         longitude: longitude,
         phone: phone,
         accessNotes: accessNotes,
         serviceAreaId: serviceAreaId,
         isActive: isActive,
         source: source,
         externalSystem: externalSystem,
         externalId: externalId,
         createdAt: createdAt,
         updatedAt: updatedAt,
         version: version,
       );

  /// Returns a shallow copy of this [CustomerSite]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CustomerSite copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? tenantId,
    _isc.UuidValue? customerId,
    Object? code = _Undefined,
    String? name,
    Object? street = _Undefined,
    Object? streetNumber = _Undefined,
    Object? complement = _Undefined,
    Object? district = _Undefined,
    Object? city = _Undefined,
    Object? state = _Undefined,
    Object? postalCode = _Undefined,
    String? countryCode,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    Object? phone = _Undefined,
    Object? accessNotes = _Undefined,
    _isc.UuidValue? serviceAreaId = const _isc.$UndefinedUuidValue(),
    bool? isActive,
    _i1c87mer.RecordSource? source,
    Object? externalSystem = _Undefined,
    Object? externalId = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return CustomerSite(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      customerId: customerId ?? this.customerId,
      code: code is String? ? code : this.code,
      name: name ?? this.name,
      street: street is String? ? street : this.street,
      streetNumber: streetNumber is String? ? streetNumber : this.streetNumber,
      complement: complement is String? ? complement : this.complement,
      district: district is String? ? district : this.district,
      city: city is String? ? city : this.city,
      state: state is String? ? state : this.state,
      postalCode: postalCode is String? ? postalCode : this.postalCode,
      countryCode: countryCode ?? this.countryCode,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      phone: phone is String? ? phone : this.phone,
      accessNotes: accessNotes is String? ? accessNotes : this.accessNotes,
      serviceAreaId: serviceAreaId is _isc.UndefinedSentinel ? this.serviceAreaId : serviceAreaId,
      isActive: isActive ?? this.isActive,
      source: source ?? this.source,
      externalSystem: externalSystem is String? ? externalSystem : this.externalSystem,
      externalId: externalId is String? ? externalId : this.externalId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }
}
