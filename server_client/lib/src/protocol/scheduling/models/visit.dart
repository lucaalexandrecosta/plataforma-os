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

abstract class Visit implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Visit._({
    required this.id,
    required this.workOrderId,
    required this.workOrderNumber,
    required this.workOrderStatus,
    required this.workOrderPriority,
    this.problemDescription,
    this.assetLabel,
    this.productName,
    this.customerName,
    this.branchName,
    required this.visitNumber,
    this.technicianId,
    this.technicianName,
    required this.status,
    this.outcome,
    this.outcomeNotes,
    required this.scheduledStart,
    required this.scheduledEnd,
    this.travelStartedAt,
    this.checkedInAt,
    this.finishedAt,
    this.cancelledAt,
    this.cancellationReason,
    this.checkInMethod,
    this.checkInDistanceM,
    required this.checkInOffSite,
    this.checkInJustification,
    bool? requireQrCheckIn,
    required this.version,
  }) : requireQrCheckIn = requireQrCheckIn ?? false;

  factory Visit({
    required _isc.UuidValue id,
    required _isc.UuidValue workOrderId,
    required String workOrderNumber,
    required String workOrderStatus,
    required String workOrderPriority,
    String? problemDescription,
    String? assetLabel,
    String? productName,
    String? customerName,
    String? branchName,
    required int visitNumber,
    _isc.UuidValue? technicianId,
    String? technicianName,
    required String status,
    String? outcome,
    String? outcomeNotes,
    required DateTime scheduledStart,
    required DateTime scheduledEnd,
    DateTime? travelStartedAt,
    DateTime? checkedInAt,
    DateTime? finishedAt,
    DateTime? cancelledAt,
    String? cancellationReason,
    String? checkInMethod,
    double? checkInDistanceM,
    required bool checkInOffSite,
    String? checkInJustification,
    bool? requireQrCheckIn,
    required int version,
  }) = _VisitImpl;

  factory Visit.fromJson(Map<String, dynamic> jsonSerialization) {
    return Visit(
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workOrderId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['workOrderId']),
      workOrderNumber: jsonSerialization['workOrderNumber'] as String,
      workOrderStatus: jsonSerialization['workOrderStatus'] as String,
      workOrderPriority: jsonSerialization['workOrderPriority'] as String,
      problemDescription: jsonSerialization['problemDescription'] as String?,
      assetLabel: jsonSerialization['assetLabel'] as String?,
      productName: jsonSerialization['productName'] as String?,
      customerName: jsonSerialization['customerName'] as String?,
      branchName: jsonSerialization['branchName'] as String?,
      visitNumber: jsonSerialization['visitNumber'] as int,
      technicianId: jsonSerialization['technicianId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['technicianId']),
      technicianName: jsonSerialization['technicianName'] as String?,
      status: jsonSerialization['status'] as String,
      outcome: jsonSerialization['outcome'] as String?,
      outcomeNotes: jsonSerialization['outcomeNotes'] as String?,
      scheduledStart: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['scheduledStart']),
      scheduledEnd: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['scheduledEnd']),
      travelStartedAt: jsonSerialization['travelStartedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['travelStartedAt']),
      checkedInAt: jsonSerialization['checkedInAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['checkedInAt']),
      finishedAt: jsonSerialization['finishedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['finishedAt']),
      cancelledAt: jsonSerialization['cancelledAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['cancelledAt']),
      cancellationReason: jsonSerialization['cancellationReason'] as String?,
      checkInMethod: jsonSerialization['checkInMethod'] as String?,
      checkInDistanceM: (jsonSerialization['checkInDistanceM'] as num?)?.toDouble(),
      checkInOffSite: _isc.BoolJsonExtension.fromJson(jsonSerialization['checkInOffSite']),
      checkInJustification: jsonSerialization['checkInJustification'] as String?,
      requireQrCheckIn: jsonSerialization['requireQrCheckIn'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['requireQrCheckIn']),
      version: jsonSerialization['version'] as int,
    );
  }

  _isc.UuidValue id;

  _isc.UuidValue workOrderId;

  String workOrderNumber;

  String workOrderStatus;

  String workOrderPriority;

  String? problemDescription;

  String? assetLabel;

  String? productName;

  String? customerName;

  String? branchName;

  int visitNumber;

  _isc.UuidValue? technicianId;

  String? technicianName;

  String status;

  String? outcome;

  String? outcomeNotes;

  DateTime scheduledStart;

  DateTime scheduledEnd;

  DateTime? travelStartedAt;

  DateTime? checkedInAt;

  DateTime? finishedAt;

  DateTime? cancelledAt;

  String? cancellationReason;

  String? checkInMethod;

  double? checkInDistanceM;

  bool checkInOffSite;

  String? checkInJustification;

  bool requireQrCheckIn;

  int version;

  /// Returns a shallow copy of this [Visit]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Visit copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? workOrderId,
    String? workOrderNumber,
    String? workOrderStatus,
    String? workOrderPriority,
    String? problemDescription,
    String? assetLabel,
    String? productName,
    String? customerName,
    String? branchName,
    int? visitNumber,
    _isc.UuidValue? technicianId = const _isc.$UndefinedUuidValue(),
    String? technicianName,
    String? status,
    String? outcome,
    String? outcomeNotes,
    DateTime? scheduledStart,
    DateTime? scheduledEnd,
    DateTime? travelStartedAt = const _isc.$UndefinedDateTime(),
    DateTime? checkedInAt = const _isc.$UndefinedDateTime(),
    DateTime? finishedAt = const _isc.$UndefinedDateTime(),
    DateTime? cancelledAt = const _isc.$UndefinedDateTime(),
    String? cancellationReason,
    String? checkInMethod,
    double? checkInDistanceM,
    bool? checkInOffSite,
    String? checkInJustification,
    bool? requireQrCheckIn,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Visit',
      'id': id.toJson(),
      'workOrderId': workOrderId.toJson(),
      'workOrderNumber': workOrderNumber,
      'workOrderStatus': workOrderStatus,
      'workOrderPriority': workOrderPriority,
      if (problemDescription != null) 'problemDescription': problemDescription,
      if (assetLabel != null) 'assetLabel': assetLabel,
      if (productName != null) 'productName': productName,
      if (customerName != null) 'customerName': customerName,
      if (branchName != null) 'branchName': branchName,
      'visitNumber': visitNumber,
      if (technicianId != null) 'technicianId': technicianId?.toJson(),
      if (technicianName != null) 'technicianName': technicianName,
      'status': status,
      if (outcome != null) 'outcome': outcome,
      if (outcomeNotes != null) 'outcomeNotes': outcomeNotes,
      'scheduledStart': scheduledStart.toJson(),
      'scheduledEnd': scheduledEnd.toJson(),
      if (travelStartedAt != null) 'travelStartedAt': travelStartedAt?.toJson(),
      if (checkedInAt != null) 'checkedInAt': checkedInAt?.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
      if (cancelledAt != null) 'cancelledAt': cancelledAt?.toJson(),
      if (cancellationReason != null) 'cancellationReason': cancellationReason,
      if (checkInMethod != null) 'checkInMethod': checkInMethod,
      if (checkInDistanceM != null) 'checkInDistanceM': checkInDistanceM,
      'checkInOffSite': checkInOffSite,
      if (checkInJustification != null) 'checkInJustification': checkInJustification,
      'requireQrCheckIn': requireQrCheckIn,
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Visit',
      'id': id.toJson(),
      'workOrderId': workOrderId.toJson(),
      'workOrderNumber': workOrderNumber,
      'workOrderStatus': workOrderStatus,
      'workOrderPriority': workOrderPriority,
      if (problemDescription != null) 'problemDescription': problemDescription,
      if (assetLabel != null) 'assetLabel': assetLabel,
      if (productName != null) 'productName': productName,
      if (customerName != null) 'customerName': customerName,
      if (branchName != null) 'branchName': branchName,
      'visitNumber': visitNumber,
      if (technicianId != null) 'technicianId': technicianId?.toJson(),
      if (technicianName != null) 'technicianName': technicianName,
      'status': status,
      if (outcome != null) 'outcome': outcome,
      if (outcomeNotes != null) 'outcomeNotes': outcomeNotes,
      'scheduledStart': scheduledStart.toJson(),
      'scheduledEnd': scheduledEnd.toJson(),
      if (travelStartedAt != null) 'travelStartedAt': travelStartedAt?.toJson(),
      if (checkedInAt != null) 'checkedInAt': checkedInAt?.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
      if (cancelledAt != null) 'cancelledAt': cancelledAt?.toJson(),
      if (cancellationReason != null) 'cancellationReason': cancellationReason,
      if (checkInMethod != null) 'checkInMethod': checkInMethod,
      if (checkInDistanceM != null) 'checkInDistanceM': checkInDistanceM,
      'checkInOffSite': checkInOffSite,
      if (checkInJustification != null) 'checkInJustification': checkInJustification,
      'requireQrCheckIn': requireQrCheckIn,
      'version': version,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VisitImpl extends Visit {
  _VisitImpl({
    required _isc.UuidValue id,
    required _isc.UuidValue workOrderId,
    required String workOrderNumber,
    required String workOrderStatus,
    required String workOrderPriority,
    String? problemDescription,
    String? assetLabel,
    String? productName,
    String? customerName,
    String? branchName,
    required int visitNumber,
    _isc.UuidValue? technicianId,
    String? technicianName,
    required String status,
    String? outcome,
    String? outcomeNotes,
    required DateTime scheduledStart,
    required DateTime scheduledEnd,
    DateTime? travelStartedAt,
    DateTime? checkedInAt,
    DateTime? finishedAt,
    DateTime? cancelledAt,
    String? cancellationReason,
    String? checkInMethod,
    double? checkInDistanceM,
    required bool checkInOffSite,
    String? checkInJustification,
    bool? requireQrCheckIn,
    required int version,
  }) : super._(
         id: id,
         workOrderId: workOrderId,
         workOrderNumber: workOrderNumber,
         workOrderStatus: workOrderStatus,
         workOrderPriority: workOrderPriority,
         problemDescription: problemDescription,
         assetLabel: assetLabel,
         productName: productName,
         customerName: customerName,
         branchName: branchName,
         visitNumber: visitNumber,
         technicianId: technicianId,
         technicianName: technicianName,
         status: status,
         outcome: outcome,
         outcomeNotes: outcomeNotes,
         scheduledStart: scheduledStart,
         scheduledEnd: scheduledEnd,
         travelStartedAt: travelStartedAt,
         checkedInAt: checkedInAt,
         finishedAt: finishedAt,
         cancelledAt: cancelledAt,
         cancellationReason: cancellationReason,
         checkInMethod: checkInMethod,
         checkInDistanceM: checkInDistanceM,
         checkInOffSite: checkInOffSite,
         checkInJustification: checkInJustification,
         requireQrCheckIn: requireQrCheckIn,
         version: version,
       );

  /// Returns a shallow copy of this [Visit]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Visit copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? workOrderId,
    String? workOrderNumber,
    String? workOrderStatus,
    String? workOrderPriority,
    Object? problemDescription = _Undefined,
    Object? assetLabel = _Undefined,
    Object? productName = _Undefined,
    Object? customerName = _Undefined,
    Object? branchName = _Undefined,
    int? visitNumber,
    _isc.UuidValue? technicianId = const _isc.$UndefinedUuidValue(),
    Object? technicianName = _Undefined,
    String? status,
    Object? outcome = _Undefined,
    Object? outcomeNotes = _Undefined,
    DateTime? scheduledStart,
    DateTime? scheduledEnd,
    DateTime? travelStartedAt = const _isc.$UndefinedDateTime(),
    DateTime? checkedInAt = const _isc.$UndefinedDateTime(),
    DateTime? finishedAt = const _isc.$UndefinedDateTime(),
    DateTime? cancelledAt = const _isc.$UndefinedDateTime(),
    Object? cancellationReason = _Undefined,
    Object? checkInMethod = _Undefined,
    Object? checkInDistanceM = _Undefined,
    bool? checkInOffSite,
    Object? checkInJustification = _Undefined,
    bool? requireQrCheckIn,
    int? version,
  }) {
    return Visit(
      id: id ?? this.id,
      workOrderId: workOrderId ?? this.workOrderId,
      workOrderNumber: workOrderNumber ?? this.workOrderNumber,
      workOrderStatus: workOrderStatus ?? this.workOrderStatus,
      workOrderPriority: workOrderPriority ?? this.workOrderPriority,
      problemDescription: problemDescription is String? ? problemDescription : this.problemDescription,
      assetLabel: assetLabel is String? ? assetLabel : this.assetLabel,
      productName: productName is String? ? productName : this.productName,
      customerName: customerName is String? ? customerName : this.customerName,
      branchName: branchName is String? ? branchName : this.branchName,
      visitNumber: visitNumber ?? this.visitNumber,
      technicianId: technicianId is _isc.UndefinedSentinel ? this.technicianId : technicianId,
      technicianName: technicianName is String? ? technicianName : this.technicianName,
      status: status ?? this.status,
      outcome: outcome is String? ? outcome : this.outcome,
      outcomeNotes: outcomeNotes is String? ? outcomeNotes : this.outcomeNotes,
      scheduledStart: scheduledStart ?? this.scheduledStart,
      scheduledEnd: scheduledEnd ?? this.scheduledEnd,
      travelStartedAt: travelStartedAt is _isc.UndefinedSentinel ? this.travelStartedAt : travelStartedAt,
      checkedInAt: checkedInAt is _isc.UndefinedSentinel ? this.checkedInAt : checkedInAt,
      finishedAt: finishedAt is _isc.UndefinedSentinel ? this.finishedAt : finishedAt,
      cancelledAt: cancelledAt is _isc.UndefinedSentinel ? this.cancelledAt : cancelledAt,
      cancellationReason: cancellationReason is String? ? cancellationReason : this.cancellationReason,
      checkInMethod: checkInMethod is String? ? checkInMethod : this.checkInMethod,
      checkInDistanceM: checkInDistanceM is double? ? checkInDistanceM : this.checkInDistanceM,
      checkInOffSite: checkInOffSite ?? this.checkInOffSite,
      checkInJustification: checkInJustification is String? ? checkInJustification : this.checkInJustification,
      requireQrCheckIn: requireQrCheckIn ?? this.requireQrCheckIn,
      version: version ?? this.version,
    );
  }
}
