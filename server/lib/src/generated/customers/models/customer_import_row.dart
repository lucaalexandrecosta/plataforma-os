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

abstract class CustomerImportRow implements _is.SerializableModel, _is.ProtocolSerialization {
  CustomerImportRow._({
    required this.line,
    this.code,
    this.name,
    this.tradeName,
    this.personType,
    this.documentNumber,
    this.stateRegistration,
    this.email,
    this.phone,
    this.notes,
    this.siteName,
    this.siteCode,
    this.postalCode,
    this.street,
    this.streetNumber,
    this.complement,
    this.district,
    this.city,
    this.state,
    this.sitePhone,
    this.accessNotes,
    this.contactName,
    this.contactPhone,
    this.contactEmail,
    this.contactJobTitle,
  });

  factory CustomerImportRow({
    required int line,
    String? code,
    String? name,
    String? tradeName,
    String? personType,
    String? documentNumber,
    String? stateRegistration,
    String? email,
    String? phone,
    String? notes,
    String? siteName,
    String? siteCode,
    String? postalCode,
    String? street,
    String? streetNumber,
    String? complement,
    String? district,
    String? city,
    String? state,
    String? sitePhone,
    String? accessNotes,
    String? contactName,
    String? contactPhone,
    String? contactEmail,
    String? contactJobTitle,
  }) = _CustomerImportRowImpl;

  factory CustomerImportRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return CustomerImportRow(
      line: jsonSerialization['line'] as int,
      code: jsonSerialization['code'] as String?,
      name: jsonSerialization['name'] as String?,
      tradeName: jsonSerialization['tradeName'] as String?,
      personType: jsonSerialization['personType'] as String?,
      documentNumber: jsonSerialization['documentNumber'] as String?,
      stateRegistration: jsonSerialization['stateRegistration'] as String?,
      email: jsonSerialization['email'] as String?,
      phone: jsonSerialization['phone'] as String?,
      notes: jsonSerialization['notes'] as String?,
      siteName: jsonSerialization['siteName'] as String?,
      siteCode: jsonSerialization['siteCode'] as String?,
      postalCode: jsonSerialization['postalCode'] as String?,
      street: jsonSerialization['street'] as String?,
      streetNumber: jsonSerialization['streetNumber'] as String?,
      complement: jsonSerialization['complement'] as String?,
      district: jsonSerialization['district'] as String?,
      city: jsonSerialization['city'] as String?,
      state: jsonSerialization['state'] as String?,
      sitePhone: jsonSerialization['sitePhone'] as String?,
      accessNotes: jsonSerialization['accessNotes'] as String?,
      contactName: jsonSerialization['contactName'] as String?,
      contactPhone: jsonSerialization['contactPhone'] as String?,
      contactEmail: jsonSerialization['contactEmail'] as String?,
      contactJobTitle: jsonSerialization['contactJobTitle'] as String?,
    );
  }

  int line;

  String? code;

  String? name;

  String? tradeName;

  String? personType;

  String? documentNumber;

  String? stateRegistration;

  String? email;

  String? phone;

  String? notes;

  String? siteName;

  String? siteCode;

  String? postalCode;

  String? street;

  String? streetNumber;

  String? complement;

  String? district;

  String? city;

  String? state;

  String? sitePhone;

  String? accessNotes;

  String? contactName;

  String? contactPhone;

  String? contactEmail;

  String? contactJobTitle;

  /// Returns a shallow copy of this [CustomerImportRow]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CustomerImportRow copyWith({
    int? line,
    String? code,
    String? name,
    String? tradeName,
    String? personType,
    String? documentNumber,
    String? stateRegistration,
    String? email,
    String? phone,
    String? notes,
    String? siteName,
    String? siteCode,
    String? postalCode,
    String? street,
    String? streetNumber,
    String? complement,
    String? district,
    String? city,
    String? state,
    String? sitePhone,
    String? accessNotes,
    String? contactName,
    String? contactPhone,
    String? contactEmail,
    String? contactJobTitle,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CustomerImportRow',
      'line': line,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (tradeName != null) 'tradeName': tradeName,
      if (personType != null) 'personType': personType,
      if (documentNumber != null) 'documentNumber': documentNumber,
      if (stateRegistration != null) 'stateRegistration': stateRegistration,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (notes != null) 'notes': notes,
      if (siteName != null) 'siteName': siteName,
      if (siteCode != null) 'siteCode': siteCode,
      if (postalCode != null) 'postalCode': postalCode,
      if (street != null) 'street': street,
      if (streetNumber != null) 'streetNumber': streetNumber,
      if (complement != null) 'complement': complement,
      if (district != null) 'district': district,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (sitePhone != null) 'sitePhone': sitePhone,
      if (accessNotes != null) 'accessNotes': accessNotes,
      if (contactName != null) 'contactName': contactName,
      if (contactPhone != null) 'contactPhone': contactPhone,
      if (contactEmail != null) 'contactEmail': contactEmail,
      if (contactJobTitle != null) 'contactJobTitle': contactJobTitle,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CustomerImportRow',
      'line': line,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (tradeName != null) 'tradeName': tradeName,
      if (personType != null) 'personType': personType,
      if (documentNumber != null) 'documentNumber': documentNumber,
      if (stateRegistration != null) 'stateRegistration': stateRegistration,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (notes != null) 'notes': notes,
      if (siteName != null) 'siteName': siteName,
      if (siteCode != null) 'siteCode': siteCode,
      if (postalCode != null) 'postalCode': postalCode,
      if (street != null) 'street': street,
      if (streetNumber != null) 'streetNumber': streetNumber,
      if (complement != null) 'complement': complement,
      if (district != null) 'district': district,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (sitePhone != null) 'sitePhone': sitePhone,
      if (accessNotes != null) 'accessNotes': accessNotes,
      if (contactName != null) 'contactName': contactName,
      if (contactPhone != null) 'contactPhone': contactPhone,
      if (contactEmail != null) 'contactEmail': contactEmail,
      if (contactJobTitle != null) 'contactJobTitle': contactJobTitle,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CustomerImportRowImpl extends CustomerImportRow {
  _CustomerImportRowImpl({
    required int line,
    String? code,
    String? name,
    String? tradeName,
    String? personType,
    String? documentNumber,
    String? stateRegistration,
    String? email,
    String? phone,
    String? notes,
    String? siteName,
    String? siteCode,
    String? postalCode,
    String? street,
    String? streetNumber,
    String? complement,
    String? district,
    String? city,
    String? state,
    String? sitePhone,
    String? accessNotes,
    String? contactName,
    String? contactPhone,
    String? contactEmail,
    String? contactJobTitle,
  }) : super._(
         line: line,
         code: code,
         name: name,
         tradeName: tradeName,
         personType: personType,
         documentNumber: documentNumber,
         stateRegistration: stateRegistration,
         email: email,
         phone: phone,
         notes: notes,
         siteName: siteName,
         siteCode: siteCode,
         postalCode: postalCode,
         street: street,
         streetNumber: streetNumber,
         complement: complement,
         district: district,
         city: city,
         state: state,
         sitePhone: sitePhone,
         accessNotes: accessNotes,
         contactName: contactName,
         contactPhone: contactPhone,
         contactEmail: contactEmail,
         contactJobTitle: contactJobTitle,
       );

  /// Returns a shallow copy of this [CustomerImportRow]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CustomerImportRow copyWith({
    int? line,
    Object? code = _Undefined,
    Object? name = _Undefined,
    Object? tradeName = _Undefined,
    Object? personType = _Undefined,
    Object? documentNumber = _Undefined,
    Object? stateRegistration = _Undefined,
    Object? email = _Undefined,
    Object? phone = _Undefined,
    Object? notes = _Undefined,
    Object? siteName = _Undefined,
    Object? siteCode = _Undefined,
    Object? postalCode = _Undefined,
    Object? street = _Undefined,
    Object? streetNumber = _Undefined,
    Object? complement = _Undefined,
    Object? district = _Undefined,
    Object? city = _Undefined,
    Object? state = _Undefined,
    Object? sitePhone = _Undefined,
    Object? accessNotes = _Undefined,
    Object? contactName = _Undefined,
    Object? contactPhone = _Undefined,
    Object? contactEmail = _Undefined,
    Object? contactJobTitle = _Undefined,
  }) {
    return CustomerImportRow(
      line: line ?? this.line,
      code: code is String? ? code : this.code,
      name: name is String? ? name : this.name,
      tradeName: tradeName is String? ? tradeName : this.tradeName,
      personType: personType is String? ? personType : this.personType,
      documentNumber: documentNumber is String? ? documentNumber : this.documentNumber,
      stateRegistration: stateRegistration is String? ? stateRegistration : this.stateRegistration,
      email: email is String? ? email : this.email,
      phone: phone is String? ? phone : this.phone,
      notes: notes is String? ? notes : this.notes,
      siteName: siteName is String? ? siteName : this.siteName,
      siteCode: siteCode is String? ? siteCode : this.siteCode,
      postalCode: postalCode is String? ? postalCode : this.postalCode,
      street: street is String? ? street : this.street,
      streetNumber: streetNumber is String? ? streetNumber : this.streetNumber,
      complement: complement is String? ? complement : this.complement,
      district: district is String? ? district : this.district,
      city: city is String? ? city : this.city,
      state: state is String? ? state : this.state,
      sitePhone: sitePhone is String? ? sitePhone : this.sitePhone,
      accessNotes: accessNotes is String? ? accessNotes : this.accessNotes,
      contactName: contactName is String? ? contactName : this.contactName,
      contactPhone: contactPhone is String? ? contactPhone : this.contactPhone,
      contactEmail: contactEmail is String? ? contactEmail : this.contactEmail,
      contactJobTitle: contactJobTitle is String? ? contactJobTitle : this.contactJobTitle,
    );
  }
}
