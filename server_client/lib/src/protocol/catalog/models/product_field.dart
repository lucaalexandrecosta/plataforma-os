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

enum ProductField implements _isc.SerializableModel {
  description,
  productFamilyId,
  gtin,
  defaultWarrantyMonths,
  referencePrice,
  labelPositionInstructions;

  static ProductField fromJson(String name) {
    switch (name) {
      case 'description':
        return ProductField.description;
      case 'productFamilyId':
        return ProductField.productFamilyId;
      case 'gtin':
        return ProductField.gtin;
      case 'defaultWarrantyMonths':
        return ProductField.defaultWarrantyMonths;
      case 'referencePrice':
        return ProductField.referencePrice;
      case 'labelPositionInstructions':
        return ProductField.labelPositionInstructions;
      default:
        throw ArgumentError('Value "$name" cannot be converted to "ProductField"');
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
