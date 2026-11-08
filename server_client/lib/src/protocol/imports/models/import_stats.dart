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

abstract class ImportStats implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ImportStats._({
    required this.totalRows,
    required this.toCreate,
    required this.toUpdate,
    required this.unchanged,
    required this.errorRows,
    this.created,
    this.updated,
  });

  factory ImportStats({
    required int totalRows,
    required int toCreate,
    required int toUpdate,
    required int unchanged,
    required int errorRows,
    int? created,
    int? updated,
  }) = _ImportStatsImpl;

  factory ImportStats.fromJson(Map<String, dynamic> jsonSerialization) {
    return ImportStats(
      totalRows: jsonSerialization['totalRows'] as int,
      toCreate: jsonSerialization['toCreate'] as int,
      toUpdate: jsonSerialization['toUpdate'] as int,
      unchanged: jsonSerialization['unchanged'] as int,
      errorRows: jsonSerialization['errorRows'] as int,
      created: jsonSerialization['created'] as int?,
      updated: jsonSerialization['updated'] as int?,
    );
  }

  int totalRows;

  int toCreate;

  int toUpdate;

  int unchanged;

  int errorRows;

  int? created;

  int? updated;

  /// Returns a shallow copy of this [ImportStats]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ImportStats copyWith({
    int? totalRows,
    int? toCreate,
    int? toUpdate,
    int? unchanged,
    int? errorRows,
    int? created,
    int? updated,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ImportStats',
      'totalRows': totalRows,
      'toCreate': toCreate,
      'toUpdate': toUpdate,
      'unchanged': unchanged,
      'errorRows': errorRows,
      if (created != null) 'created': created,
      if (updated != null) 'updated': updated,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ImportStats',
      'totalRows': totalRows,
      'toCreate': toCreate,
      'toUpdate': toUpdate,
      'unchanged': unchanged,
      'errorRows': errorRows,
      if (created != null) 'created': created,
      if (updated != null) 'updated': updated,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ImportStatsImpl extends ImportStats {
  _ImportStatsImpl({
    required int totalRows,
    required int toCreate,
    required int toUpdate,
    required int unchanged,
    required int errorRows,
    int? created,
    int? updated,
  }) : super._(
         totalRows: totalRows,
         toCreate: toCreate,
         toUpdate: toUpdate,
         unchanged: unchanged,
         errorRows: errorRows,
         created: created,
         updated: updated,
       );

  /// Returns a shallow copy of this [ImportStats]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ImportStats copyWith({
    int? totalRows,
    int? toCreate,
    int? toUpdate,
    int? unchanged,
    int? errorRows,
    Object? created = _Undefined,
    Object? updated = _Undefined,
  }) {
    return ImportStats(
      totalRows: totalRows ?? this.totalRows,
      toCreate: toCreate ?? this.toCreate,
      toUpdate: toUpdate ?? this.toUpdate,
      unchanged: unchanged ?? this.unchanged,
      errorRows: errorRows ?? this.errorRows,
      created: created is int? ? created : this.created,
      updated: updated is int? ? updated : this.updated,
    );
  }
}
