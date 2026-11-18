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

abstract class ChecklistSubmitPayload implements _is.SerializableModel, _is.ProtocolSerialization {
  ChecklistSubmitPayload._({
    required this.checklistTemplateId,
    required this.answers,
  });

  factory ChecklistSubmitPayload({
    required _is.UuidValue checklistTemplateId,
    required List<_iytyfjrh.ChecklistAnswer> answers,
  }) = _ChecklistSubmitPayloadImpl;

  factory ChecklistSubmitPayload.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChecklistSubmitPayload(
      checklistTemplateId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['checklistTemplateId']),
      answers: _isma42go.Protocol().deserialize<List<_iytyfjrh.ChecklistAnswer>>(jsonSerialization['answers']),
    );
  }

  _is.UuidValue checklistTemplateId;

  List<_iytyfjrh.ChecklistAnswer> answers;

  /// Returns a shallow copy of this [ChecklistSubmitPayload]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ChecklistSubmitPayload copyWith({
    _is.UuidValue? checklistTemplateId,
    List<_iytyfjrh.ChecklistAnswer>? answers,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChecklistSubmitPayload',
      'checklistTemplateId': checklistTemplateId.toJson(),
      'answers': answers.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChecklistSubmitPayload',
      'checklistTemplateId': checklistTemplateId.toJson(),
      'answers': answers.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ChecklistSubmitPayloadImpl extends ChecklistSubmitPayload {
  _ChecklistSubmitPayloadImpl({
    required _is.UuidValue checklistTemplateId,
    required List<_iytyfjrh.ChecklistAnswer> answers,
  }) : super._(
         checklistTemplateId: checklistTemplateId,
         answers: answers,
       );

  /// Returns a shallow copy of this [ChecklistSubmitPayload]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ChecklistSubmitPayload copyWith({
    _is.UuidValue? checklistTemplateId,
    List<_iytyfjrh.ChecklistAnswer>? answers,
  }) {
    return ChecklistSubmitPayload(
      checklistTemplateId: checklistTemplateId ?? this.checklistTemplateId,
      answers: answers ?? this.answers.map((e0) => e0.copyWith()).toList(),
    );
  }
}
