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
import 'package:plataforma_os_server/src/generated/protocol.dart' as _isma42go;
import 'package:serverpod/serverpod.dart' as _is;
import '../../scheduling/models/checklist_answer.dart' as _iytyfjrh;

abstract class ChecklistResponse implements _is.SerializableModel, _is.ProtocolSerialization {
  ChecklistResponse._({
    required this.id,
    required this.workOrderId,
    required this.visitId,
    required this.checklistTemplateId,
    required this.templateVersion,
    required this.status,
    required this.answers,
    this.submittedAt,
    this.submittedByName,
    required this.version,
  });

  factory ChecklistResponse({
    required _is.UuidValue id,
    required _is.UuidValue workOrderId,
    required _is.UuidValue visitId,
    required _is.UuidValue checklistTemplateId,
    required int templateVersion,
    required String status,
    required List<_iytyfjrh.ChecklistAnswer> answers,
    DateTime? submittedAt,
    String? submittedByName,
    required int version,
  }) = _ChecklistResponseImpl;

  factory ChecklistResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChecklistResponse(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workOrderId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['workOrderId']),
      visitId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['visitId']),
      checklistTemplateId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['checklistTemplateId']),
      templateVersion: jsonSerialization['templateVersion'] as int,
      status: jsonSerialization['status'] as String,
      answers: _isma42go.Protocol().deserialize<List<_iytyfjrh.ChecklistAnswer>>(jsonSerialization['answers']),
      submittedAt: jsonSerialization['submittedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['submittedAt']),
      submittedByName: jsonSerialization['submittedByName'] as String?,
      version: jsonSerialization['version'] as int,
    );
  }

  _is.UuidValue id;

  _is.UuidValue workOrderId;

  _is.UuidValue visitId;

  _is.UuidValue checklistTemplateId;

  int templateVersion;

  String status;

  List<_iytyfjrh.ChecklistAnswer> answers;

  DateTime? submittedAt;

  String? submittedByName;

  int version;

  /// Returns a shallow copy of this [ChecklistResponse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ChecklistResponse copyWith({
    _is.UuidValue? id,
    _is.UuidValue? workOrderId,
    _is.UuidValue? visitId,
    _is.UuidValue? checklistTemplateId,
    int? templateVersion,
    String? status,
    List<_iytyfjrh.ChecklistAnswer>? answers,
    DateTime? submittedAt = const _is.$UndefinedDateTime(),
    String? submittedByName,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChecklistResponse',
      'id': id.toJson(),
      'workOrderId': workOrderId.toJson(),
      'visitId': visitId.toJson(),
      'checklistTemplateId': checklistTemplateId.toJson(),
      'templateVersion': templateVersion,
      'status': status,
      'answers': answers.toJson(valueToJson: (v) => v.toJson()),
      if (submittedAt != null) 'submittedAt': submittedAt?.toJson(),
      if (submittedByName != null) 'submittedByName': submittedByName,
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChecklistResponse',
      'id': id.toJson(),
      'workOrderId': workOrderId.toJson(),
      'visitId': visitId.toJson(),
      'checklistTemplateId': checklistTemplateId.toJson(),
      'templateVersion': templateVersion,
      'status': status,
      'answers': answers.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (submittedAt != null) 'submittedAt': submittedAt?.toJson(),
      if (submittedByName != null) 'submittedByName': submittedByName,
      'version': version,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChecklistResponseImpl extends ChecklistResponse {
  _ChecklistResponseImpl({
    required _is.UuidValue id,
    required _is.UuidValue workOrderId,
    required _is.UuidValue visitId,
    required _is.UuidValue checklistTemplateId,
    required int templateVersion,
    required String status,
    required List<_iytyfjrh.ChecklistAnswer> answers,
    DateTime? submittedAt,
    String? submittedByName,
    required int version,
  }) : super._(
         id: id,
         workOrderId: workOrderId,
         visitId: visitId,
         checklistTemplateId: checklistTemplateId,
         templateVersion: templateVersion,
         status: status,
         answers: answers,
         submittedAt: submittedAt,
         submittedByName: submittedByName,
         version: version,
       );

  /// Returns a shallow copy of this [ChecklistResponse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ChecklistResponse copyWith({
    _is.UuidValue? id,
    _is.UuidValue? workOrderId,
    _is.UuidValue? visitId,
    _is.UuidValue? checklistTemplateId,
    int? templateVersion,
    String? status,
    List<_iytyfjrh.ChecklistAnswer>? answers,
    DateTime? submittedAt = const _is.$UndefinedDateTime(),
    Object? submittedByName = _Undefined,
    int? version,
  }) {
    return ChecklistResponse(
      id: id ?? this.id,
      workOrderId: workOrderId ?? this.workOrderId,
      visitId: visitId ?? this.visitId,
      checklistTemplateId: checklistTemplateId ?? this.checklistTemplateId,
      templateVersion: templateVersion ?? this.templateVersion,
      status: status ?? this.status,
      answers: answers ?? this.answers.map((e0) => e0.copyWith()).toList(),
      submittedAt: submittedAt is _is.UndefinedSentinel ? this.submittedAt : submittedAt,
      submittedByName: submittedByName is String? ? submittedByName : this.submittedByName,
      version: version ?? this.version,
    );
  }
}
