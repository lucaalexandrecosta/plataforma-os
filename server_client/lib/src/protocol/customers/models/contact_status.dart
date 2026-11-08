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

enum ContactStatus implements _isc.SerializableModel {
  active,
  pending_approval,
  blocked;

  static ContactStatus fromJson(String name) {
    switch (name) {
      case 'active':
        return ContactStatus.active;
      case 'pending_approval':
        return ContactStatus.pending_approval;
      case 'blocked':
        return ContactStatus.blocked;
      default:
        throw ArgumentError('Value "$name" cannot be converted to "ContactStatus"');
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
