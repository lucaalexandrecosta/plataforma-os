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
import 'package:plataforma_os_client/src/protocol/protocol.dart' as _inlzmlpe;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../../imports/models/import_entity_type.dart' as _incxtnh4;
import '../../imports/models/import_stats.dart' as _ivcszkn4;
import '../../imports/models/sync_run_status.dart' as _iuo8pohf;

abstract class ImportRunInfo implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ImportRunInfo._({
    required this.id,
    required this.entityType,
    required this.status,
    this.fileName,
    required this.stats,
    required this.hasErrorReport,
    this.errorMessage,
    required this.createdAt,
    this.finishedAt,
    required this.version,
  });

  factory ImportRunInfo({
    required _isc.UuidValue id,
    required _incxtnh4.ImportEntityType entityType,
    required _iuo8pohf.SyncRunStatus status,
    String? fileName,
    required _ivcszkn4.ImportStats stats,
    required bool hasErrorReport,
    String? errorMessage,
    required DateTime createdAt,
    DateTime? finishedAt,
    required int version,
  }) = _ImportRunInfoImpl;

  factory ImportRunInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return ImportRunInfo(
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      entityType: _incxtnh4.ImportEntityType.fromJson((jsonSerialization['entityType'] as String)),
      status: _iuo8pohf.SyncRunStatus.fromJson((jsonSerialization['status'] as String)),
      fileName: jsonSerialization['fileName'] as String?,
      stats: _inlzmlpe.Protocol().deserialize<_ivcszkn4.ImportStats>(jsonSerialization['stats']),
      hasErrorReport: _isc.BoolJsonExtension.fromJson(jsonSerialization['hasErrorReport']),
      errorMessage: jsonSerialization['errorMessage'] as String?,
      createdAt: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      finishedAt: jsonSerialization['finishedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['finishedAt']),
      version: jsonSerialization['version'] as int,
    );
  }

  _isc.UuidValue id;

  _incxtnh4.ImportEntityType entityType;

  _iuo8pohf.SyncRunStatus status;

  String? fileName;

  _ivcszkn4.ImportStats stats;

  bool hasErrorReport;

  String? errorMessage;

  DateTime createdAt;

  DateTime? finishedAt;

  int version;

  /// Returns a shallow copy of this [ImportRunInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ImportRunInfo copyWith({
    _isc.UuidValue? id,
    _incxtnh4.ImportEntityType? entityType,
    _iuo8pohf.SyncRunStatus? status,
    String? fileName,
    _ivcszkn4.ImportStats? stats,
    bool? hasErrorReport,
    String? errorMessage,
    DateTime? createdAt,
    DateTime? finishedAt = const _isc.$UndefinedDateTime(),
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ImportRunInfo',
      'id': id.toJson(),
      'entityType': entityType.toJson(),
      'status': status.toJson(),
      if (fileName != null) 'fileName': fileName,
      'stats': stats.toJson(),
      'hasErrorReport': hasErrorReport,
      if (errorMessage != null) 'errorMessage': errorMessage,
      'createdAt': createdAt.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ImportRunInfo',
      'id': id.toJson(),
      'entityType': entityType.toJson(),
      'status': status.toJson(),
      if (fileName != null) 'fileName': fileName,
      'stats': stats.toJsonForProtocol(),
      'hasErrorReport': hasErrorReport,
      if (errorMessage != null) 'errorMessage': errorMessage,
      'createdAt': createdAt.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
      'version': version,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ImportRunInfoImpl extends ImportRunInfo {
  _ImportRunInfoImpl({
    required _isc.UuidValue id,
    required _incxtnh4.ImportEntityType entityType,
    required _iuo8pohf.SyncRunStatus status,
    String? fileName,
    required _ivcszkn4.ImportStats stats,
    required bool hasErrorReport,
    String? errorMessage,
    required DateTime createdAt,
    DateTime? finishedAt,
    required int version,
  }) : super._(
         id: id,
         entityType: entityType,
         status: status,
         fileName: fileName,
         stats: stats,
         hasErrorReport: hasErrorReport,
         errorMessage: errorMessage,
         createdAt: createdAt,
         finishedAt: finishedAt,
         version: version,
       );

  /// Returns a shallow copy of this [ImportRunInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ImportRunInfo copyWith({
    _isc.UuidValue? id,
    _incxtnh4.ImportEntityType? entityType,
    _iuo8pohf.SyncRunStatus? status,
    Object? fileName = _Undefined,
    _ivcszkn4.ImportStats? stats,
    bool? hasErrorReport,
    Object? errorMessage = _Undefined,
    DateTime? createdAt,
    DateTime? finishedAt = const _isc.$UndefinedDateTime(),
    int? version,
  }) {
    return ImportRunInfo(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      status: status ?? this.status,
      fileName: fileName is String? ? fileName : this.fileName,
      stats: stats ?? this.stats.copyWith(),
      hasErrorReport: hasErrorReport ?? this.hasErrorReport,
      errorMessage: errorMessage is String? ? errorMessage : this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      finishedAt: finishedAt is _isc.UndefinedSentinel ? this.finishedAt : finishedAt,
      version: version ?? this.version,
    );
  }
}
