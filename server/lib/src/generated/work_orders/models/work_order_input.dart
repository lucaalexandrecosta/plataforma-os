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

abstract class WorkOrderInput implements _is.SerializableModel, _is.ProtocolSerialization {
  WorkOrderInput._({
    required this.workOrderTypeId,
    this.assetId,
    this.scannedCode,
    this.priority,
    this.problemDescription,
    this.requesterName,
    this.requesterPhone,
  });

  factory WorkOrderInput({
    required _is.UuidValue workOrderTypeId,
    _is.UuidValue? assetId,
    String? scannedCode,
    String? priority,
    String? problemDescription,
    String? requesterName,
    String? requesterPhone,
  }) = _WorkOrderInputImpl;

  factory WorkOrderInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkOrderInput(
      workOrderTypeId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['workOrderTypeId']),
      assetId: jsonSerialization['assetId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['assetId']),
      scannedCode: jsonSerialization['scannedCode'] as String?,
      priority: jsonSerialization['priority'] as String?,
      problemDescription: jsonSerialization['problemDescription'] as String?,
      requesterName: jsonSerialization['requesterName'] as String?,
      requesterPhone: jsonSerialization['requesterPhone'] as String?,
    );
  }

  _is.UuidValue workOrderTypeId;

  _is.UuidValue? assetId;

  String? scannedCode;

  String? priority;

  String? problemDescription;

  String? requesterName;

  String? requesterPhone;

  /// Returns a shallow copy of this [WorkOrderInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  WorkOrderInput copyWith({
    _is.UuidValue? workOrderTypeId,
    _is.UuidValue? assetId = const _is.$UndefinedUuidValue(),
    String? scannedCode,
    String? priority,
    String? problemDescription,
    String? requesterName,
    String? requesterPhone,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WorkOrderInput',
      'workOrderTypeId': workOrderTypeId.toJson(),
      if (assetId != null) 'assetId': assetId?.toJson(),
      if (scannedCode != null) 'scannedCode': scannedCode,
      if (priority != null) 'priority': priority,
      if (problemDescription != null) 'problemDescription': problemDescription,
      if (requesterName != null) 'requesterName': requesterName,
      if (requesterPhone != null) 'requesterPhone': requesterPhone,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WorkOrderInput',
      'workOrderTypeId': workOrderTypeId.toJson(),
      if (assetId != null) 'assetId': assetId?.toJson(),
      if (scannedCode != null) 'scannedCode': scannedCode,
      if (priority != null) 'priority': priority,
      if (problemDescription != null) 'problemDescription': problemDescription,
      if (requesterName != null) 'requesterName': requesterName,
      if (requesterPhone != null) 'requesterPhone': requesterPhone,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorkOrderInputImpl extends WorkOrderInput {
  _WorkOrderInputImpl({
    required _is.UuidValue workOrderTypeId,
    _is.UuidValue? assetId,
    String? scannedCode,
    String? priority,
    String? problemDescription,
    String? requesterName,
    String? requesterPhone,
  }) : super._(
         workOrderTypeId: workOrderTypeId,
         assetId: assetId,
         scannedCode: scannedCode,
         priority: priority,
         problemDescription: problemDescription,
         requesterName: requesterName,
         requesterPhone: requesterPhone,
       );

  /// Returns a shallow copy of this [WorkOrderInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  WorkOrderInput copyWith({
    _is.UuidValue? workOrderTypeId,
    _is.UuidValue? assetId = const _is.$UndefinedUuidValue(),
    Object? scannedCode = _Undefined,
    Object? priority = _Undefined,
    Object? problemDescription = _Undefined,
    Object? requesterName = _Undefined,
    Object? requesterPhone = _Undefined,
  }) {
    return WorkOrderInput(
      workOrderTypeId: workOrderTypeId ?? this.workOrderTypeId,
      assetId: assetId is _is.UndefinedSentinel ? this.assetId : assetId,
      scannedCode: scannedCode is String? ? scannedCode : this.scannedCode,
      priority: priority is String? ? priority : this.priority,
      problemDescription: problemDescription is String? ? problemDescription : this.problemDescription,
      requesterName: requesterName is String? ? requesterName : this.requesterName,
      requesterPhone: requesterPhone is String? ? requesterPhone : this.requesterPhone,
    );
  }
}
