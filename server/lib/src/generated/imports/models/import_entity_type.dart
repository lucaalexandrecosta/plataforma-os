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

enum ImportEntityType implements _is.SerializableModel {
  customers,
  customer_sites,
  customer_contacts,
  products,
  services,
  assets;

  static ImportEntityType fromJson(String name) {
    switch (name) {
      case 'customers':
        return ImportEntityType.customers;
      case 'customer_sites':
        return ImportEntityType.customer_sites;
      case 'customer_contacts':
        return ImportEntityType.customer_contacts;
      case 'products':
        return ImportEntityType.products;
      case 'services':
        return ImportEntityType.services;
      case 'assets':
        return ImportEntityType.assets;
      default:
        throw ArgumentError('Value "$name" cannot be converted to "ImportEntityType"');
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
