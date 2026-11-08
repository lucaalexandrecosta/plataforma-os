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
import 'package:plataforma_os_server/src/generated/protocol.dart' as _isma42go;
import 'package:serverpod/serverpod.dart' as _is;
import '../../customers/models/customer_site_field.dart' as _ig4xibir;

abstract class CustomerSitePatch implements _is.SerializableModel, _is.ProtocolSerialization {
  CustomerSitePatch._({
    this.code,
    this.name,
    this.street,
    this.streetNumber,
    this.complement,
    this.district,
    this.city,
    this.state,
    this.postalCode,
    this.countryCode,
    this.latitude,
    this.longitude,
    this.phone,
    this.accessNotes,
    this.clear,
  });

  factory CustomerSitePatch({
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
    List<_ig4xibir.CustomerSiteField>? clear,
  }) = _CustomerSitePatchImpl;

  factory CustomerSitePatch.fromJson(Map<String, dynamic> jsonSerialization) {
    return CustomerSitePatch(
      code: jsonSerialization['code'] as String?,
      name: jsonSerialization['name'] as String?,
      street: jsonSerialization['street'] as String?,
      streetNumber: jsonSerialization['streetNumber'] as String?,
      complement: jsonSerialization['complement'] as String?,
      district: jsonSerialization['district'] as String?,
      city: jsonSerialization['city'] as String?,
      state: jsonSerialization['state'] as String?,
      postalCode: jsonSerialization['postalCode'] as String?,
      countryCode: jsonSerialization['countryCode'] as String?,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      phone: jsonSerialization['phone'] as String?,
      accessNotes: jsonSerialization['accessNotes'] as String?,
      clear: jsonSerialization['clear'] == null
          ? null
          : _isma42go.Protocol().deserialize<List<_ig4xibir.CustomerSiteField>>(jsonSerialization['clear']),
    );
  }

  String? code;

  String? name;

  String? street;

  String? streetNumber;

  String? complement;

  String? district;

  String? city;

  String? state;

  String? postalCode;

  String? countryCode;

  double? latitude;

  double? longitude;

  String? phone;

  String? accessNotes;

  List<_ig4xibir.CustomerSiteField>? clear;

  /// Returns a shallow copy of this [CustomerSitePatch]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CustomerSitePatch copyWith({
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
    List<_ig4xibir.CustomerSiteField>? clear = const _is.$UndefinedList<_ig4xibir.CustomerSiteField>(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CustomerSitePatch',
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (street != null) 'street': street,
      if (streetNumber != null) 'streetNumber': streetNumber,
      if (complement != null) 'complement': complement,
      if (district != null) 'district': district,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (postalCode != null) 'postalCode': postalCode,
      if (countryCode != null) 'countryCode': countryCode,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (phone != null) 'phone': phone,
      if (accessNotes != null) 'accessNotes': accessNotes,
      if (clear != null) 'clear': clear?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CustomerSitePatch',
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (street != null) 'street': street,
      if (streetNumber != null) 'streetNumber': streetNumber,
      if (complement != null) 'complement': complement,
      if (district != null) 'district': district,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (postalCode != null) 'postalCode': postalCode,
      if (countryCode != null) 'countryCode': countryCode,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (phone != null) 'phone': phone,
      if (accessNotes != null) 'accessNotes': accessNotes,
      if (clear != null) 'clear': clear?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CustomerSitePatchImpl extends CustomerSitePatch {
  _CustomerSitePatchImpl({
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
    List<_ig4xibir.CustomerSiteField>? clear,
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
         countryCode: countryCode,
         latitude: latitude,
         longitude: longitude,
         phone: phone,
         accessNotes: accessNotes,
         clear: clear,
       );

  /// Returns a shallow copy of this [CustomerSitePatch]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CustomerSitePatch copyWith({
    Object? code = _Undefined,
    Object? name = _Undefined,
    Object? street = _Undefined,
    Object? streetNumber = _Undefined,
    Object? complement = _Undefined,
    Object? district = _Undefined,
    Object? city = _Undefined,
    Object? state = _Undefined,
    Object? postalCode = _Undefined,
    Object? countryCode = _Undefined,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    Object? phone = _Undefined,
    Object? accessNotes = _Undefined,
    List<_ig4xibir.CustomerSiteField>? clear = const _is.$UndefinedList<_ig4xibir.CustomerSiteField>(),
  }) {
    return CustomerSitePatch(
      code: code is String? ? code : this.code,
      name: name is String? ? name : this.name,
      street: street is String? ? street : this.street,
      streetNumber: streetNumber is String? ? streetNumber : this.streetNumber,
      complement: complement is String? ? complement : this.complement,
      district: district is String? ? district : this.district,
      city: city is String? ? city : this.city,
      state: state is String? ? state : this.state,
      postalCode: postalCode is String? ? postalCode : this.postalCode,
      countryCode: countryCode is String? ? countryCode : this.countryCode,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      phone: phone is String? ? phone : this.phone,
      accessNotes: accessNotes is String? ? accessNotes : this.accessNotes,
      clear: clear is _is.UndefinedSentinel ? this.clear?.map((e0) => e0).toList() : clear,
    );
  }
}
