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

abstract class CustomerSiteInput implements _is.SerializableModel, _is.ProtocolSerialization {
  CustomerSiteInput._({
    this.code,
    required this.name,
    this.street,
    this.streetNumber,
    this.complement,
    this.district,
    this.city,
    this.state,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.phone,
    this.accessNotes,
    required this.isActive,
  });

  factory CustomerSiteInput({
    String? code,
    required String name,
    String? street,
    String? streetNumber,
    String? complement,
    String? district,
    String? city,
    String? state,
    String? postalCode,
    double? latitude,
    double? longitude,
    String? phone,
    String? accessNotes,
    required bool isActive,
  }) = _CustomerSiteInputImpl;

  factory CustomerSiteInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return CustomerSiteInput(
      code: jsonSerialization['code'] as String?,
      name: jsonSerialization['name'] as String,
      street: jsonSerialization['street'] as String?,
      streetNumber: jsonSerialization['streetNumber'] as String?,
      complement: jsonSerialization['complement'] as String?,
      district: jsonSerialization['district'] as String?,
      city: jsonSerialization['city'] as String?,
      state: jsonSerialization['state'] as String?,
      postalCode: jsonSerialization['postalCode'] as String?,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      phone: jsonSerialization['phone'] as String?,
      accessNotes: jsonSerialization['accessNotes'] as String?,
      isActive: _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  String? code;

  String name;

  String? street;

  String? streetNumber;

  String? complement;

  String? district;

  String? city;

  String? state;

  String? postalCode;

  double? latitude;

  double? longitude;

  String? phone;

  String? accessNotes;

  bool isActive;

  /// Returns a shallow copy of this [CustomerSiteInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CustomerSiteInput copyWith({
    String? code,
    String? name,
    String? street,
    String? streetNumber,
    String? complement,
    String? district,
    String? city,
    String? state,
    String? postalCode,
    double? latitude,
    double? longitude,
    String? phone,
    String? accessNotes,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CustomerSiteInput',
      if (code != null) 'code': code,
      'name': name,
      if (street != null) 'street': street,
      if (streetNumber != null) 'streetNumber': streetNumber,
      if (complement != null) 'complement': complement,
      if (district != null) 'district': district,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (postalCode != null) 'postalCode': postalCode,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (phone != null) 'phone': phone,
      if (accessNotes != null) 'accessNotes': accessNotes,
      'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CustomerSiteInput',
      if (code != null) 'code': code,
      'name': name,
      if (street != null) 'street': street,
      if (streetNumber != null) 'streetNumber': streetNumber,
      if (complement != null) 'complement': complement,
      if (district != null) 'district': district,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (postalCode != null) 'postalCode': postalCode,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (phone != null) 'phone': phone,
      if (accessNotes != null) 'accessNotes': accessNotes,
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CustomerSiteInputImpl extends CustomerSiteInput {
  _CustomerSiteInputImpl({
    String? code,
    required String name,
    String? street,
    String? streetNumber,
    String? complement,
    String? district,
    String? city,
    String? state,
    String? postalCode,
    double? latitude,
    double? longitude,
    String? phone,
    String? accessNotes,
    required bool isActive,
  }) : super._(
         code: code,
         name: name,
         street: street,
         streetNumber: streetNumber,
         complement: complement,
         district: district,
         city: city,
         state: state,
         postalCode: postalCode,
         latitude: latitude,
         longitude: longitude,
         phone: phone,
         accessNotes: accessNotes,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [CustomerSiteInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CustomerSiteInput copyWith({
    Object? code = _Undefined,
    String? name,
    Object? street = _Undefined,
    Object? streetNumber = _Undefined,
    Object? complement = _Undefined,
    Object? district = _Undefined,
    Object? city = _Undefined,
    Object? state = _Undefined,
    Object? postalCode = _Undefined,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    Object? phone = _Undefined,
    Object? accessNotes = _Undefined,
    bool? isActive,
  }) {
    return CustomerSiteInput(
      code: code is String? ? code : this.code,
      name: name ?? this.name,
      street: street is String? ? street : this.street,
      streetNumber: streetNumber is String? ? streetNumber : this.streetNumber,
      complement: complement is String? ? complement : this.complement,
      district: district is String? ? district : this.district,
      city: city is String? ? city : this.city,
      state: state is String? ? state : this.state,
      postalCode: postalCode is String? ? postalCode : this.postalCode,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      phone: phone is String? ? phone : this.phone,
      accessNotes: accessNotes is String? ? accessNotes : this.accessNotes,
      isActive: isActive ?? this.isActive,
    );
  }
}
