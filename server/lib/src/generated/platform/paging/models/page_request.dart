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

abstract class PageRequest implements _is.SerializableModel, _is.ProtocolSerialization {
  PageRequest._({
    this.limit,
    this.sort,
    this.descending,
    this.cursor,
    this.includeTotal,
  });

  factory PageRequest({
    int? limit,
    String? sort,
    bool? descending,
    String? cursor,
    bool? includeTotal,
  }) = _PageRequestImpl;

  factory PageRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return PageRequest(
      limit: jsonSerialization['limit'] as int?,
      sort: jsonSerialization['sort'] as String?,
      descending: jsonSerialization['descending'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['descending']),
      cursor: jsonSerialization['cursor'] as String?,
      includeTotal: jsonSerialization['includeTotal'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['includeTotal']),
    );
  }

  int? limit;

  String? sort;

  bool? descending;

  String? cursor;

  bool? includeTotal;

  /// Returns a shallow copy of this [PageRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PageRequest copyWith({
    int? limit,
    String? sort,
    bool? descending,
    String? cursor,
    bool? includeTotal,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PageRequest',
      if (limit != null) 'limit': limit,
      if (sort != null) 'sort': sort,
      if (descending != null) 'descending': descending,
      if (cursor != null) 'cursor': cursor,
      if (includeTotal != null) 'includeTotal': includeTotal,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PageRequest',
      if (limit != null) 'limit': limit,
      if (sort != null) 'sort': sort,
      if (descending != null) 'descending': descending,
      if (cursor != null) 'cursor': cursor,
      if (includeTotal != null) 'includeTotal': includeTotal,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PageRequestImpl extends PageRequest {
  _PageRequestImpl({
    int? limit,
    String? sort,
    bool? descending,
    String? cursor,
    bool? includeTotal,
  }) : super._(
         limit: limit,
         sort: sort,
         descending: descending,
         cursor: cursor,
         includeTotal: includeTotal,
       );

  /// Returns a shallow copy of this [PageRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PageRequest copyWith({
    Object? limit = _Undefined,
    Object? sort = _Undefined,
    Object? descending = _Undefined,
    Object? cursor = _Undefined,
    Object? includeTotal = _Undefined,
  }) {
    return PageRequest(
      limit: limit is int? ? limit : this.limit,
      sort: sort is String? ? sort : this.sort,
      descending: descending is bool? ? descending : this.descending,
      cursor: cursor is String? ? cursor : this.cursor,
      includeTotal: includeTotal is bool? ? includeTotal : this.includeTotal,
    );
  }
}
