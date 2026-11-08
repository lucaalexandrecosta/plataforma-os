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

enum CustomerSiteField implements _is.SerializableModel {
  code,
  street,
  streetNumber,
  complement,
  district,
  city,
  state,
  postalCode,
  location,
  phone,
  accessNotes;

  static CustomerSiteField fromJson(String name) {
    switch (name) {
      case 'code':
        return CustomerSiteField.code;
      case 'street':
        return CustomerSiteField.street;
      case 'streetNumber':
        return CustomerSiteField.streetNumber;
      case 'complement':
        return CustomerSiteField.complement;
      case 'district':
        return CustomerSiteField.district;
      case 'city':
        return CustomerSiteField.city;
      case 'state':
        return CustomerSiteField.state;
      case 'postalCode':
        return CustomerSiteField.postalCode;
      case 'location':
        return CustomerSiteField.location;
      case 'phone':
        return CustomerSiteField.phone;
      case 'accessNotes':
        return CustomerSiteField.accessNotes;
      default:
        throw ArgumentError('Value "$name" cannot be converted to "CustomerSiteField"');
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
