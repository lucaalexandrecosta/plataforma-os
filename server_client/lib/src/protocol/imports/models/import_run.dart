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
import '../../imports/models/import_entity_type.dart' as _incxtnh4;
import '../../imports/models/sync_run_mode.dart' as _ihge5bzx;
import '../../imports/models/sync_run_status.dart' as _iuo8pohf;
import '../../imports/models/sync_run_trigger.dart' as _igklebcn;

abstract class ImportRun implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ImportRun._({
    _isc.UuidValue? id,
    required this.tenantId,
    required this.entityType,
    required this.mode,
    required this.trigger,
    required this.dryRun,
    required this.status,
    this.fileStorageKey,
    this.fileName,
    this.fileSha256,
    this.reportStorageKey,
    this.errorMessage,
    this.startedAt,
    this.finishedAt,
    this.requestedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  }) : id = id ?? const _isc.Uuid().v7obj();

  factory ImportRun({
    _isc.UuidValue? id,
    required _isc.UuidValue tenantId,
    required _incxtnh4.ImportEntityType entityType,
    required _ihge5bzx.SyncRunMode mode,
    required _igklebcn.SyncRunTrigger trigger,
    required bool dryRun,
    required _iuo8pohf.SyncRunStatus status,
    String? fileStorageKey,
    String? fileName,
    String? fileSha256,
    String? reportStorageKey,
    String? errorMessage,
    DateTime? startedAt,
    DateTime? finishedAt,
    _isc.UuidValue? requestedBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
  }) = _ImportRunImpl;

  factory ImportRun.fromJson(Map<String, dynamic> jsonSerialization) {
    return ImportRun(
      id: jsonSerialization['id'] == null ? null : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      tenantId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['tenantId']),
      entityType: _incxtnh4.ImportEntityType.fromJson((jsonSerialization['entityType'] as String)),
      mode: _ihge5bzx.SyncRunMode.fromJson((jsonSerialization['mode'] as String)),
      trigger: _igklebcn.SyncRunTrigger.fromJson((jsonSerialization['trigger'] as String)),
      dryRun: _isc.BoolJsonExtension.fromJson(jsonSerialization['dryRun']),
      status: _iuo8pohf.SyncRunStatus.fromJson((jsonSerialization['status'] as String)),
      fileStorageKey: jsonSerialization['fileStorageKey'] as String?,
      fileName: jsonSerialization['fileName'] as String?,
      fileSha256: jsonSerialization['fileSha256'] as String?,
      reportStorageKey: jsonSerialization['reportStorageKey'] as String?,
      errorMessage: jsonSerialization['errorMessage'] as String?,
      startedAt: jsonSerialization['startedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['startedAt']),
      finishedAt: jsonSerialization['finishedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['finishedAt']),
      requestedBy: jsonSerialization['requestedBy'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['requestedBy']),
      createdAt: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      version: jsonSerialization['version'] as int,
    );
  }

  /// The id of the object.
  _isc.UuidValue id;

  _isc.UuidValue tenantId;

  _incxtnh4.ImportEntityType entityType;

  _ihge5bzx.SyncRunMode mode;

  _igklebcn.SyncRunTrigger trigger;

  bool dryRun;

  _iuo8pohf.SyncRunStatus status;

  String? fileStorageKey;

  String? fileName;

  String? fileSha256;

  String? reportStorageKey;

  String? errorMessage;

  DateTime? startedAt;

  DateTime? finishedAt;

  _isc.UuidValue? requestedBy;

  DateTime createdAt;

  DateTime updatedAt;

  int version;

  /// Returns a shallow copy of this [ImportRun]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ImportRun copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? tenantId,
    _incxtnh4.ImportEntityType? entityType,
    _ihge5bzx.SyncRunMode? mode,
    _igklebcn.SyncRunTrigger? trigger,
    bool? dryRun,
    _iuo8pohf.SyncRunStatus? status,
    String? fileStorageKey,
    String? fileName,
    String? fileSha256,
    String? reportStorageKey,
    String? errorMessage,
    DateTime? startedAt = const _isc.$UndefinedDateTime(),
    DateTime? finishedAt = const _isc.$UndefinedDateTime(),
    _isc.UuidValue? requestedBy = const _isc.$UndefinedUuidValue(),
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ImportRun',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      'entityType': entityType.toJson(),
      'mode': mode.toJson(),
      'trigger': trigger.toJson(),
      'dryRun': dryRun,
      'status': status.toJson(),
      if (fileStorageKey != null) 'fileStorageKey': fileStorageKey,
      if (fileName != null) 'fileName': fileName,
      if (fileSha256 != null) 'fileSha256': fileSha256,
      if (reportStorageKey != null) 'reportStorageKey': reportStorageKey,
      if (errorMessage != null) 'errorMessage': errorMessage,
      if (startedAt != null) 'startedAt': startedAt?.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
      if (requestedBy != null) 'requestedBy': requestedBy?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ImportRun',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      'entityType': entityType.toJson(),
      'mode': mode.toJson(),
      'trigger': trigger.toJson(),
      'dryRun': dryRun,
      'status': status.toJson(),
      if (fileStorageKey != null) 'fileStorageKey': fileStorageKey,
      if (fileName != null) 'fileName': fileName,
      if (fileSha256 != null) 'fileSha256': fileSha256,
      if (reportStorageKey != null) 'reportStorageKey': reportStorageKey,
      if (errorMessage != null) 'errorMessage': errorMessage,
      if (startedAt != null) 'startedAt': startedAt?.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
      if (requestedBy != null) 'requestedBy': requestedBy?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ImportRunImpl extends ImportRun {
  _ImportRunImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue tenantId,
    required _incxtnh4.ImportEntityType entityType,
    required _ihge5bzx.SyncRunMode mode,
    required _igklebcn.SyncRunTrigger trigger,
    required bool dryRun,
    required _iuo8pohf.SyncRunStatus status,
    String? fileStorageKey,
    String? fileName,
    String? fileSha256,
    String? reportStorageKey,
    String? errorMessage,
    DateTime? startedAt,
    DateTime? finishedAt,
    _isc.UuidValue? requestedBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
  }) : super._(
         id: id,
         tenantId: tenantId,
         entityType: entityType,
         mode: mode,
         trigger: trigger,
         dryRun: dryRun,
         status: status,
         fileStorageKey: fileStorageKey,
         fileName: fileName,
         fileSha256: fileSha256,
         reportStorageKey: reportStorageKey,
         errorMessage: errorMessage,
         startedAt: startedAt,
         finishedAt: finishedAt,
         requestedBy: requestedBy,
         createdAt: createdAt,
         updatedAt: updatedAt,
         version: version,
       );

  /// Returns a shallow copy of this [ImportRun]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ImportRun copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? tenantId,
    _incxtnh4.ImportEntityType? entityType,
    _ihge5bzx.SyncRunMode? mode,
    _igklebcn.SyncRunTrigger? trigger,
    bool? dryRun,
    _iuo8pohf.SyncRunStatus? status,
    Object? fileStorageKey = _Undefined,
    Object? fileName = _Undefined,
    Object? fileSha256 = _Undefined,
    Object? reportStorageKey = _Undefined,
    Object? errorMessage = _Undefined,
    DateTime? startedAt = const _isc.$UndefinedDateTime(),
    DateTime? finishedAt = const _isc.$UndefinedDateTime(),
    _isc.UuidValue? requestedBy = const _isc.$UndefinedUuidValue(),
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return ImportRun(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      entityType: entityType ?? this.entityType,
      mode: mode ?? this.mode,
      trigger: trigger ?? this.trigger,
      dryRun: dryRun ?? this.dryRun,
      status: status ?? this.status,
      fileStorageKey: fileStorageKey is String? ? fileStorageKey : this.fileStorageKey,
      fileName: fileName is String? ? fileName : this.fileName,
      fileSha256: fileSha256 is String? ? fileSha256 : this.fileSha256,
      reportStorageKey: reportStorageKey is String? ? reportStorageKey : this.reportStorageKey,
      errorMessage: errorMessage is String? ? errorMessage : this.errorMessage,
      startedAt: startedAt is _isc.UndefinedSentinel ? this.startedAt : startedAt,
      finishedAt: finishedAt is _isc.UndefinedSentinel ? this.finishedAt : finishedAt,
      requestedBy: requestedBy is _isc.UndefinedSentinel ? this.requestedBy : requestedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }
}
