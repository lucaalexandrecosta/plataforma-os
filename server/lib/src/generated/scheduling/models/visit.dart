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

abstract class Visit implements _is.SerializableModel, _is.ProtocolSerialization {
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
    bool? requirePhotos,
    bool? requireSignature,
    this.signatureAttachmentId,
    this.signerName,
    this.signerRole,
    this.signedAt,
  }) : requireQrCheckIn = requireQrCheckIn ?? false,
       requirePhotos = requirePhotos ?? false,
       requireSignature = requireSignature ?? false;

  factory Visit({
    required _is.UuidValue id,
    required _is.UuidValue workOrderId,
    required String workOrderNumber,
    required String workOrderStatus,
    required String workOrderPriority,
    String? problemDescription,
    String? assetLabel,
    String? productName,
    String? customerName,
    String? branchName,
    required int visitNumber,
    _is.UuidValue? technicianId,
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
    bool? requirePhotos,
    bool? requireSignature,
    _is.UuidValue? signatureAttachmentId,
    String? signerName,
    String? signerRole,
    DateTime? signedAt,
  }) = _VisitImpl;

  factory Visit.fromJson(Map<String, dynamic> jsonSerialization) {
    return Visit(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workOrderId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['workOrderId']),
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
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['technicianId']),
      technicianName: jsonSerialization['technicianName'] as String?,
      status: jsonSerialization['status'] as String,
      outcome: jsonSerialization['outcome'] as String?,
      outcomeNotes: jsonSerialization['outcomeNotes'] as String?,
      scheduledStart: _is.DateTimeJsonExtension.fromJson(jsonSerialization['scheduledStart']),
      scheduledEnd: _is.DateTimeJsonExtension.fromJson(jsonSerialization['scheduledEnd']),
      travelStartedAt: jsonSerialization['travelStartedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['travelStartedAt']),
      checkedInAt: jsonSerialization['checkedInAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['checkedInAt']),
      finishedAt: jsonSerialization['finishedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['finishedAt']),
      cancelledAt: jsonSerialization['cancelledAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['cancelledAt']),
      cancellationReason: jsonSerialization['cancellationReason'] as String?,
      checkInMethod: jsonSerialization['checkInMethod'] as String?,
      checkInDistanceM: (jsonSerialization['checkInDistanceM'] as num?)?.toDouble(),
      checkInOffSite: _is.BoolJsonExtension.fromJson(jsonSerialization['checkInOffSite']),
      checkInJustification: jsonSerialization['checkInJustification'] as String?,
      requireQrCheckIn: jsonSerialization['requireQrCheckIn'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['requireQrCheckIn']),
      version: jsonSerialization['version'] as int,
      requirePhotos: jsonSerialization['requirePhotos'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['requirePhotos']),
      requireSignature: jsonSerialization['requireSignature'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['requireSignature']),
      signatureAttachmentId: jsonSerialization['signatureAttachmentId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['signatureAttachmentId']),
      signerName: jsonSerialization['signerName'] as String?,
      signerRole: jsonSerialization['signerRole'] as String?,
      signedAt: jsonSerialization['signedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['signedAt']),
    );
  }

  _is.UuidValue id;

  _is.UuidValue workOrderId;

  String workOrderNumber;

  String workOrderStatus;

  String workOrderPriority;

  String? problemDescription;

  String? assetLabel;

  String? productName;

  String? customerName;

  String? branchName;

  int visitNumber;

  _is.UuidValue? technicianId;

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

  bool requirePhotos;

  bool requireSignature;

  _is.UuidValue? signatureAttachmentId;

  String? signerName;

  String? signerRole;

  DateTime? signedAt;

  /// Returns a shallow copy of this [Visit]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Visit copyWith({
    _is.UuidValue? id,
    _is.UuidValue? workOrderId,
    String? workOrderNumber,
    String? workOrderStatus,
    String? workOrderPriority,
    String? problemDescription,
    String? assetLabel,
    String? productName,
    String? customerName,
    String? branchName,
    int? visitNumber,
    _is.UuidValue? technicianId = const _is.$UndefinedUuidValue(),
    String? technicianName,
    String? status,
    String? outcome,
    String? outcomeNotes,
    DateTime? scheduledStart,
    DateTime? scheduledEnd,
    DateTime? travelStartedAt = const _is.$UndefinedDateTime(),
    DateTime? checkedInAt = const _is.$UndefinedDateTime(),
    DateTime? finishedAt = const _is.$UndefinedDateTime(),
    DateTime? cancelledAt = const _is.$UndefinedDateTime(),
    String? cancellationReason,
    String? checkInMethod,
    double? checkInDistanceM,
    bool? checkInOffSite,
    String? checkInJustification,
    bool? requireQrCheckIn,
    int? version,
    bool? requirePhotos,
    bool? requireSignature,
    _is.UuidValue? signatureAttachmentId = const _is.$UndefinedUuidValue(),
    String? signerName,
    String? signerRole,
    DateTime? signedAt = const _is.$UndefinedDateTime(),
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
      'requirePhotos': requirePhotos,
      'requireSignature': requireSignature,
      if (signatureAttachmentId != null) 'signatureAttachmentId': signatureAttachmentId?.toJson(),
      if (signerName != null) 'signerName': signerName,
      if (signerRole != null) 'signerRole': signerRole,
      if (signedAt != null) 'signedAt': signedAt?.toJson(),
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
      'requirePhotos': requirePhotos,
      'requireSignature': requireSignature,
      if (signatureAttachmentId != null) 'signatureAttachmentId': signatureAttachmentId?.toJson(),
      if (signerName != null) 'signerName': signerName,
      if (signerRole != null) 'signerRole': signerRole,
      if (signedAt != null) 'signedAt': signedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VisitImpl extends Visit {
  _VisitImpl({
    required _is.UuidValue id,
    required _is.UuidValue workOrderId,
    required String workOrderNumber,
    required String workOrderStatus,
    required String workOrderPriority,
    String? problemDescription,
    String? assetLabel,
    String? productName,
    String? customerName,
    String? branchName,
    required int visitNumber,
    _is.UuidValue? technicianId,
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
    bool? requirePhotos,
    bool? requireSignature,
    _is.UuidValue? signatureAttachmentId,
    String? signerName,
    String? signerRole,
    DateTime? signedAt,
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
         requirePhotos: requirePhotos,
         requireSignature: requireSignature,
         signatureAttachmentId: signatureAttachmentId,
         signerName: signerName,
         signerRole: signerRole,
         signedAt: signedAt,
       );

  /// Returns a shallow copy of this [Visit]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Visit copyWith({
    _is.UuidValue? id,
    _is.UuidValue? workOrderId,
    String? workOrderNumber,
    String? workOrderStatus,
    String? workOrderPriority,
    Object? problemDescription = _Undefined,
    Object? assetLabel = _Undefined,
    Object? productName = _Undefined,
    Object? customerName = _Undefined,
    Object? branchName = _Undefined,
    int? visitNumber,
    _is.UuidValue? technicianId = const _is.$UndefinedUuidValue(),
    Object? technicianName = _Undefined,
    String? status,
    Object? outcome = _Undefined,
    Object? outcomeNotes = _Undefined,
    DateTime? scheduledStart,
    DateTime? scheduledEnd,
    DateTime? travelStartedAt = const _is.$UndefinedDateTime(),
    DateTime? checkedInAt = const _is.$UndefinedDateTime(),
    DateTime? finishedAt = const _is.$UndefinedDateTime(),
    DateTime? cancelledAt = const _is.$UndefinedDateTime(),
    Object? cancellationReason = _Undefined,
    Object? checkInMethod = _Undefined,
    Object? checkInDistanceM = _Undefined,
    bool? checkInOffSite,
    Object? checkInJustification = _Undefined,
    bool? requireQrCheckIn,
    int? version,
    bool? requirePhotos,
    bool? requireSignature,
    _is.UuidValue? signatureAttachmentId = const _is.$UndefinedUuidValue(),
    Object? signerName = _Undefined,
    Object? signerRole = _Undefined,
    DateTime? signedAt = const _is.$UndefinedDateTime(),
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
      technicianId: technicianId is _is.UndefinedSentinel ? this.technicianId : technicianId,
      technicianName: technicianName is String? ? technicianName : this.technicianName,
      status: status ?? this.status,
      outcome: outcome is String? ? outcome : this.outcome,
      outcomeNotes: outcomeNotes is String? ? outcomeNotes : this.outcomeNotes,
      scheduledStart: scheduledStart ?? this.scheduledStart,
      scheduledEnd: scheduledEnd ?? this.scheduledEnd,
      travelStartedAt: travelStartedAt is _is.UndefinedSentinel ? this.travelStartedAt : travelStartedAt,
      checkedInAt: checkedInAt is _is.UndefinedSentinel ? this.checkedInAt : checkedInAt,
      finishedAt: finishedAt is _is.UndefinedSentinel ? this.finishedAt : finishedAt,
      cancelledAt: cancelledAt is _is.UndefinedSentinel ? this.cancelledAt : cancelledAt,
      cancellationReason: cancellationReason is String? ? cancellationReason : this.cancellationReason,
      checkInMethod: checkInMethod is String? ? checkInMethod : this.checkInMethod,
      checkInDistanceM: checkInDistanceM is double? ? checkInDistanceM : this.checkInDistanceM,
      checkInOffSite: checkInOffSite ?? this.checkInOffSite,
      checkInJustification: checkInJustification is String? ? checkInJustification : this.checkInJustification,
      requireQrCheckIn: requireQrCheckIn ?? this.requireQrCheckIn,
      version: version ?? this.version,
      requirePhotos: requirePhotos ?? this.requirePhotos,
      requireSignature: requireSignature ?? this.requireSignature,
      signatureAttachmentId: signatureAttachmentId is _is.UndefinedSentinel
          ? this.signatureAttachmentId
          : signatureAttachmentId,
      signerName: signerName is String? ? signerName : this.signerName,
      signerRole: signerRole is String? ? signerRole : this.signerRole,
      signedAt: signedAt is _is.UndefinedSentinel ? this.signedAt : signedAt,
    );
  }
}
