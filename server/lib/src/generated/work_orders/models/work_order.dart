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

abstract class WorkOrder implements _is.SerializableModel, _is.ProtocolSerialization {
  WorkOrder._({
    required this.id,
    required this.number,
    required this.workOrderTypeId,
    required this.workOrderTypeName,
    required this.status,
    required this.priority,
    required this.origin,
    required this.entryMethod,
    this.assetId,
    this.assetLabel,
    this.productName,
    this.branchId,
    this.branchName,
    this.costCenterId,
    this.costCenterName,
    this.customerId,
    this.customerName,
    this.problemDescription,
    this.requesterName,
    this.requesterPhone,
    this.holdReason,
    this.statusReason,
    this.resolutionNotes,
    this.cancellationReason,
    this.cancellationNote,
    required this.reopenedCount,
    required this.createdAt,
    required this.statusChangedAt,
    this.startedAt,
    this.completedAt,
    this.closedAt,
    this.cancelledAt,
    required this.version,
  });

  factory WorkOrder({
    required _is.UuidValue id,
    required String number,
    required _is.UuidValue workOrderTypeId,
    required String workOrderTypeName,
    required String status,
    required String priority,
    required String origin,
    required String entryMethod,
    _is.UuidValue? assetId,
    String? assetLabel,
    String? productName,
    _is.UuidValue? branchId,
    String? branchName,
    _is.UuidValue? costCenterId,
    String? costCenterName,
    _is.UuidValue? customerId,
    String? customerName,
    String? problemDescription,
    String? requesterName,
    String? requesterPhone,
    String? holdReason,
    String? statusReason,
    String? resolutionNotes,
    String? cancellationReason,
    String? cancellationNote,
    required int reopenedCount,
    required DateTime createdAt,
    required DateTime statusChangedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? closedAt,
    DateTime? cancelledAt,
    required int version,
  }) = _WorkOrderImpl;

  factory WorkOrder.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkOrder(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      number: jsonSerialization['number'] as String,
      workOrderTypeId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['workOrderTypeId']),
      workOrderTypeName: jsonSerialization['workOrderTypeName'] as String,
      status: jsonSerialization['status'] as String,
      priority: jsonSerialization['priority'] as String,
      origin: jsonSerialization['origin'] as String,
      entryMethod: jsonSerialization['entryMethod'] as String,
      assetId: jsonSerialization['assetId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['assetId']),
      assetLabel: jsonSerialization['assetLabel'] as String?,
      productName: jsonSerialization['productName'] as String?,
      branchId: jsonSerialization['branchId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['branchId']),
      branchName: jsonSerialization['branchName'] as String?,
      costCenterId: jsonSerialization['costCenterId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['costCenterId']),
      costCenterName: jsonSerialization['costCenterName'] as String?,
      customerId: jsonSerialization['customerId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['customerId']),
      customerName: jsonSerialization['customerName'] as String?,
      problemDescription: jsonSerialization['problemDescription'] as String?,
      requesterName: jsonSerialization['requesterName'] as String?,
      requesterPhone: jsonSerialization['requesterPhone'] as String?,
      holdReason: jsonSerialization['holdReason'] as String?,
      statusReason: jsonSerialization['statusReason'] as String?,
      resolutionNotes: jsonSerialization['resolutionNotes'] as String?,
      cancellationReason: jsonSerialization['cancellationReason'] as String?,
      cancellationNote: jsonSerialization['cancellationNote'] as String?,
      reopenedCount: jsonSerialization['reopenedCount'] as int,
      createdAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      statusChangedAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['statusChangedAt']),
      startedAt: jsonSerialization['startedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['startedAt']),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['completedAt']),
      closedAt: jsonSerialization['closedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['closedAt']),
      cancelledAt: jsonSerialization['cancelledAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['cancelledAt']),
      version: jsonSerialization['version'] as int,
    );
  }

  _is.UuidValue id;

  String number;

  _is.UuidValue workOrderTypeId;

  String workOrderTypeName;

  String status;

  String priority;

  String origin;

  String entryMethod;

  _is.UuidValue? assetId;

  String? assetLabel;

  String? productName;

  _is.UuidValue? branchId;

  String? branchName;

  _is.UuidValue? costCenterId;

  String? costCenterName;

  _is.UuidValue? customerId;

  String? customerName;

  String? problemDescription;

  String? requesterName;

  String? requesterPhone;

  String? holdReason;

  String? statusReason;

  String? resolutionNotes;

  String? cancellationReason;

  String? cancellationNote;

  int reopenedCount;

  DateTime createdAt;

  DateTime statusChangedAt;

  DateTime? startedAt;

  DateTime? completedAt;

  DateTime? closedAt;

  DateTime? cancelledAt;

  int version;

  /// Returns a shallow copy of this [WorkOrder]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  WorkOrder copyWith({
    _is.UuidValue? id,
    String? number,
    _is.UuidValue? workOrderTypeId,
    String? workOrderTypeName,
    String? status,
    String? priority,
    String? origin,
    String? entryMethod,
    _is.UuidValue? assetId = const _is.$UndefinedUuidValue(),
    String? assetLabel,
    String? productName,
    _is.UuidValue? branchId = const _is.$UndefinedUuidValue(),
    String? branchName,
    _is.UuidValue? costCenterId = const _is.$UndefinedUuidValue(),
    String? costCenterName,
    _is.UuidValue? customerId = const _is.$UndefinedUuidValue(),
    String? customerName,
    String? problemDescription,
    String? requesterName,
    String? requesterPhone,
    String? holdReason,
    String? statusReason,
    String? resolutionNotes,
    String? cancellationReason,
    String? cancellationNote,
    int? reopenedCount,
    DateTime? createdAt,
    DateTime? statusChangedAt,
    DateTime? startedAt = const _is.$UndefinedDateTime(),
    DateTime? completedAt = const _is.$UndefinedDateTime(),
    DateTime? closedAt = const _is.$UndefinedDateTime(),
    DateTime? cancelledAt = const _is.$UndefinedDateTime(),
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WorkOrder',
      'id': id.toJson(),
      'number': number,
      'workOrderTypeId': workOrderTypeId.toJson(),
      'workOrderTypeName': workOrderTypeName,
      'status': status,
      'priority': priority,
      'origin': origin,
      'entryMethod': entryMethod,
      if (assetId != null) 'assetId': assetId?.toJson(),
      if (assetLabel != null) 'assetLabel': assetLabel,
      if (productName != null) 'productName': productName,
      if (branchId != null) 'branchId': branchId?.toJson(),
      if (branchName != null) 'branchName': branchName,
      if (costCenterId != null) 'costCenterId': costCenterId?.toJson(),
      if (costCenterName != null) 'costCenterName': costCenterName,
      if (customerId != null) 'customerId': customerId?.toJson(),
      if (customerName != null) 'customerName': customerName,
      if (problemDescription != null) 'problemDescription': problemDescription,
      if (requesterName != null) 'requesterName': requesterName,
      if (requesterPhone != null) 'requesterPhone': requesterPhone,
      if (holdReason != null) 'holdReason': holdReason,
      if (statusReason != null) 'statusReason': statusReason,
      if (resolutionNotes != null) 'resolutionNotes': resolutionNotes,
      if (cancellationReason != null) 'cancellationReason': cancellationReason,
      if (cancellationNote != null) 'cancellationNote': cancellationNote,
      'reopenedCount': reopenedCount,
      'createdAt': createdAt.toJson(),
      'statusChangedAt': statusChangedAt.toJson(),
      if (startedAt != null) 'startedAt': startedAt?.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      if (closedAt != null) 'closedAt': closedAt?.toJson(),
      if (cancelledAt != null) 'cancelledAt': cancelledAt?.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WorkOrder',
      'id': id.toJson(),
      'number': number,
      'workOrderTypeId': workOrderTypeId.toJson(),
      'workOrderTypeName': workOrderTypeName,
      'status': status,
      'priority': priority,
      'origin': origin,
      'entryMethod': entryMethod,
      if (assetId != null) 'assetId': assetId?.toJson(),
      if (assetLabel != null) 'assetLabel': assetLabel,
      if (productName != null) 'productName': productName,
      if (branchId != null) 'branchId': branchId?.toJson(),
      if (branchName != null) 'branchName': branchName,
      if (costCenterId != null) 'costCenterId': costCenterId?.toJson(),
      if (costCenterName != null) 'costCenterName': costCenterName,
      if (customerId != null) 'customerId': customerId?.toJson(),
      if (customerName != null) 'customerName': customerName,
      if (problemDescription != null) 'problemDescription': problemDescription,
      if (requesterName != null) 'requesterName': requesterName,
      if (requesterPhone != null) 'requesterPhone': requesterPhone,
      if (holdReason != null) 'holdReason': holdReason,
      if (statusReason != null) 'statusReason': statusReason,
      if (resolutionNotes != null) 'resolutionNotes': resolutionNotes,
      if (cancellationReason != null) 'cancellationReason': cancellationReason,
      if (cancellationNote != null) 'cancellationNote': cancellationNote,
      'reopenedCount': reopenedCount,
      'createdAt': createdAt.toJson(),
      'statusChangedAt': statusChangedAt.toJson(),
      if (startedAt != null) 'startedAt': startedAt?.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      if (closedAt != null) 'closedAt': closedAt?.toJson(),
      if (cancelledAt != null) 'cancelledAt': cancelledAt?.toJson(),
      'version': version,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorkOrderImpl extends WorkOrder {
  _WorkOrderImpl({
    required _is.UuidValue id,
    required String number,
    required _is.UuidValue workOrderTypeId,
    required String workOrderTypeName,
    required String status,
    required String priority,
    required String origin,
    required String entryMethod,
    _is.UuidValue? assetId,
    String? assetLabel,
    String? productName,
    _is.UuidValue? branchId,
    String? branchName,
    _is.UuidValue? costCenterId,
    String? costCenterName,
    _is.UuidValue? customerId,
    String? customerName,
    String? problemDescription,
    String? requesterName,
    String? requesterPhone,
    String? holdReason,
    String? statusReason,
    String? resolutionNotes,
    String? cancellationReason,
    String? cancellationNote,
    required int reopenedCount,
    required DateTime createdAt,
    required DateTime statusChangedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? closedAt,
    DateTime? cancelledAt,
    required int version,
  }) : super._(
         id: id,
         number: number,
         workOrderTypeId: workOrderTypeId,
         workOrderTypeName: workOrderTypeName,
         status: status,
         priority: priority,
         origin: origin,
         entryMethod: entryMethod,
         assetId: assetId,
         assetLabel: assetLabel,
         productName: productName,
         branchId: branchId,
         branchName: branchName,
         costCenterId: costCenterId,
         costCenterName: costCenterName,
         customerId: customerId,
         customerName: customerName,
         problemDescription: problemDescription,
         requesterName: requesterName,
         requesterPhone: requesterPhone,
         holdReason: holdReason,
         statusReason: statusReason,
         resolutionNotes: resolutionNotes,
         cancellationReason: cancellationReason,
         cancellationNote: cancellationNote,
         reopenedCount: reopenedCount,
         createdAt: createdAt,
         statusChangedAt: statusChangedAt,
         startedAt: startedAt,
         completedAt: completedAt,
         closedAt: closedAt,
         cancelledAt: cancelledAt,
         version: version,
       );

  /// Returns a shallow copy of this [WorkOrder]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  WorkOrder copyWith({
    _is.UuidValue? id,
    String? number,
    _is.UuidValue? workOrderTypeId,
    String? workOrderTypeName,
    String? status,
    String? priority,
    String? origin,
    String? entryMethod,
    _is.UuidValue? assetId = const _is.$UndefinedUuidValue(),
    Object? assetLabel = _Undefined,
    Object? productName = _Undefined,
    _is.UuidValue? branchId = const _is.$UndefinedUuidValue(),
    Object? branchName = _Undefined,
    _is.UuidValue? costCenterId = const _is.$UndefinedUuidValue(),
    Object? costCenterName = _Undefined,
    _is.UuidValue? customerId = const _is.$UndefinedUuidValue(),
    Object? customerName = _Undefined,
    Object? problemDescription = _Undefined,
    Object? requesterName = _Undefined,
    Object? requesterPhone = _Undefined,
    Object? holdReason = _Undefined,
    Object? statusReason = _Undefined,
    Object? resolutionNotes = _Undefined,
    Object? cancellationReason = _Undefined,
    Object? cancellationNote = _Undefined,
    int? reopenedCount,
    DateTime? createdAt,
    DateTime? statusChangedAt,
    DateTime? startedAt = const _is.$UndefinedDateTime(),
    DateTime? completedAt = const _is.$UndefinedDateTime(),
    DateTime? closedAt = const _is.$UndefinedDateTime(),
    DateTime? cancelledAt = const _is.$UndefinedDateTime(),
    int? version,
  }) {
    return WorkOrder(
      id: id ?? this.id,
      number: number ?? this.number,
      workOrderTypeId: workOrderTypeId ?? this.workOrderTypeId,
      workOrderTypeName: workOrderTypeName ?? this.workOrderTypeName,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      origin: origin ?? this.origin,
      entryMethod: entryMethod ?? this.entryMethod,
      assetId: assetId is _is.UndefinedSentinel ? this.assetId : assetId,
      assetLabel: assetLabel is String? ? assetLabel : this.assetLabel,
      productName: productName is String? ? productName : this.productName,
      branchId: branchId is _is.UndefinedSentinel ? this.branchId : branchId,
      branchName: branchName is String? ? branchName : this.branchName,
      costCenterId: costCenterId is _is.UndefinedSentinel ? this.costCenterId : costCenterId,
      costCenterName: costCenterName is String? ? costCenterName : this.costCenterName,
      customerId: customerId is _is.UndefinedSentinel ? this.customerId : customerId,
      customerName: customerName is String? ? customerName : this.customerName,
      problemDescription: problemDescription is String? ? problemDescription : this.problemDescription,
      requesterName: requesterName is String? ? requesterName : this.requesterName,
      requesterPhone: requesterPhone is String? ? requesterPhone : this.requesterPhone,
      holdReason: holdReason is String? ? holdReason : this.holdReason,
      statusReason: statusReason is String? ? statusReason : this.statusReason,
      resolutionNotes: resolutionNotes is String? ? resolutionNotes : this.resolutionNotes,
      cancellationReason: cancellationReason is String? ? cancellationReason : this.cancellationReason,
      cancellationNote: cancellationNote is String? ? cancellationNote : this.cancellationNote,
      reopenedCount: reopenedCount ?? this.reopenedCount,
      createdAt: createdAt ?? this.createdAt,
      statusChangedAt: statusChangedAt ?? this.statusChangedAt,
      startedAt: startedAt is _is.UndefinedSentinel ? this.startedAt : startedAt,
      completedAt: completedAt is _is.UndefinedSentinel ? this.completedAt : completedAt,
      closedAt: closedAt is _is.UndefinedSentinel ? this.closedAt : closedAt,
      cancelledAt: cancelledAt is _is.UndefinedSentinel ? this.cancelledAt : cancelledAt,
      version: version ?? this.version,
    );
  }
}
