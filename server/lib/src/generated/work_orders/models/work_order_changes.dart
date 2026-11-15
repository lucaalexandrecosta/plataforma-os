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

abstract class WorkOrderChanges implements _is.SerializableModel, _is.ProtocolSerialization {
  WorkOrderChanges._({
    required this.workOrderTypeId,
    required this.priority,
    this.problemDescription,
    this.requesterName,
    this.requesterPhone,
  });

  factory WorkOrderChanges({
    required _is.UuidValue workOrderTypeId,
    required String priority,
    String? problemDescription,
    String? requesterName,
    String? requesterPhone,
  }) = _WorkOrderChangesImpl;

  factory WorkOrderChanges.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkOrderChanges(
      workOrderTypeId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['workOrderTypeId']),
      priority: jsonSerialization['priority'] as String,
      problemDescription: jsonSerialization['problemDescription'] as String?,
      requesterName: jsonSerialization['requesterName'] as String?,
      requesterPhone: jsonSerialization['requesterPhone'] as String?,
    );
  }

  _is.UuidValue workOrderTypeId;

  String priority;

  String? problemDescription;

  String? requesterName;

  String? requesterPhone;

  /// Returns a shallow copy of this [WorkOrderChanges]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  WorkOrderChanges copyWith({
    _is.UuidValue? workOrderTypeId,
    String? priority,
    String? problemDescription,
    String? requesterName,
    String? requesterPhone,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WorkOrderChanges',
      'workOrderTypeId': workOrderTypeId.toJson(),
      'priority': priority,
      if (problemDescription != null) 'problemDescription': problemDescription,
      if (requesterName != null) 'requesterName': requesterName,
      if (requesterPhone != null) 'requesterPhone': requesterPhone,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WorkOrderChanges',
      'workOrderTypeId': workOrderTypeId.toJson(),
      'priority': priority,
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

class _WorkOrderChangesImpl extends WorkOrderChanges {
  _WorkOrderChangesImpl({
    required _is.UuidValue workOrderTypeId,
    required String priority,
    String? problemDescription,
    String? requesterName,
    String? requesterPhone,
  }) : super._(
         workOrderTypeId: workOrderTypeId,
         priority: priority,
         problemDescription: problemDescription,
         requesterName: requesterName,
         requesterPhone: requesterPhone,
       );

  /// Returns a shallow copy of this [WorkOrderChanges]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  WorkOrderChanges copyWith({
    _is.UuidValue? workOrderTypeId,
    String? priority,
    Object? problemDescription = _Undefined,
    Object? requesterName = _Undefined,
    Object? requesterPhone = _Undefined,
  }) {
    return WorkOrderChanges(
      workOrderTypeId: workOrderTypeId ?? this.workOrderTypeId,
      priority: priority ?? this.priority,
      problemDescription: problemDescription is String? ? problemDescription : this.problemDescription,
      requesterName: requesterName is String? ? requesterName : this.requesterName,
      requesterPhone: requesterPhone is String? ? requesterPhone : this.requesterPhone,
    );
  }
}
