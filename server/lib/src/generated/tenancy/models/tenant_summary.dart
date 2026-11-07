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
import '../../tenancy/models/tenant_status.dart' as _ivp99z2i;

abstract class TenantSummary implements _is.SerializableModel, _is.ProtocolSerialization {
  TenantSummary._({
    required this.id,
    required this.slug,
    required this.displayName,
    required this.status,
  });

  factory TenantSummary({
    required _is.UuidValue id,
    required String slug,
    required String displayName,
    required _ivp99z2i.TenantStatus status,
  }) = _TenantSummaryImpl;

  factory TenantSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return TenantSummary(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      slug: jsonSerialization['slug'] as String,
      displayName: jsonSerialization['displayName'] as String,
      status: _ivp99z2i.TenantStatus.fromJson((jsonSerialization['status'] as String)),
    );
  }

  _is.UuidValue id;

  String slug;

  String displayName;

  _ivp99z2i.TenantStatus status;

  /// Returns a shallow copy of this [TenantSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TenantSummary copyWith({
    _is.UuidValue? id,
    String? slug,
    String? displayName,
    _ivp99z2i.TenantStatus? status,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TenantSummary',
      'id': id.toJson(),
      'slug': slug,
      'displayName': displayName,
      'status': status.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TenantSummary',
      'id': id.toJson(),
      'slug': slug,
      'displayName': displayName,
      'status': status.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _TenantSummaryImpl extends TenantSummary {
  _TenantSummaryImpl({
    required _is.UuidValue id,
    required String slug,
    required String displayName,
    required _ivp99z2i.TenantStatus status,
  }) : super._(
         id: id,
         slug: slug,
         displayName: displayName,
         status: status,
       );

  /// Returns a shallow copy of this [TenantSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TenantSummary copyWith({
    _is.UuidValue? id,
    String? slug,
    String? displayName,
    _ivp99z2i.TenantStatus? status,
  }) {
    return TenantSummary(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      displayName: displayName ?? this.displayName,
      status: status ?? this.status,
    );
  }
}
