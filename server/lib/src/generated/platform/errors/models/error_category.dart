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

enum ErrorCategory implements _is.SerializableModel {
  validation,
  unauthenticated,
  forbidden,
  notFound,
  conflict,
  versionMismatch,
  payloadTooLarge,
  businessRule,
  upgradeRequired,
  rateLimited,
  unavailable;

  static ErrorCategory fromJson(String name) {
    switch (name) {
      case 'validation':
        return ErrorCategory.validation;
      case 'unauthenticated':
        return ErrorCategory.unauthenticated;
      case 'forbidden':
        return ErrorCategory.forbidden;
      case 'notFound':
        return ErrorCategory.notFound;
      case 'conflict':
        return ErrorCategory.conflict;
      case 'versionMismatch':
        return ErrorCategory.versionMismatch;
      case 'payloadTooLarge':
        return ErrorCategory.payloadTooLarge;
      case 'businessRule':
        return ErrorCategory.businessRule;
      case 'upgradeRequired':
        return ErrorCategory.upgradeRequired;
      case 'rateLimited':
        return ErrorCategory.rateLimited;
      case 'unavailable':
        return ErrorCategory.unavailable;
      default:
        throw ArgumentError('Value "$name" cannot be converted to "ErrorCategory"');
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
