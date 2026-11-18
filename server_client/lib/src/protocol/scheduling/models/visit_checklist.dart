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
import '../../catalog/models/checklist_template.dart' as _i168yfvg;
import '../../scheduling/models/checklist_response.dart' as _i2j91tw1;

abstract class VisitChecklist implements _isc.SerializableModel, _isc.ProtocolSerialization {
  VisitChecklist._({
    required this.visitId,
    required this.visitNumber,
    required this.template,
    this.response,
  });

  factory VisitChecklist({
    required _isc.UuidValue visitId,
    required int visitNumber,
    required _i168yfvg.ChecklistTemplate template,
    _i2j91tw1.ChecklistResponse? response,
  }) = _VisitChecklistImpl;

  factory VisitChecklist.fromJson(Map<String, dynamic> jsonSerialization) {
    return VisitChecklist(
      visitId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['visitId']),
      visitNumber: jsonSerialization['visitNumber'] as int,
      template: _inlzmlpe.Protocol().deserialize<_i168yfvg.ChecklistTemplate>(jsonSerialization['template']),
      response: jsonSerialization['response'] == null
          ? null
          : _inlzmlpe.Protocol().deserialize<_i2j91tw1.ChecklistResponse>(jsonSerialization['response']),
    );
  }

  _isc.UuidValue visitId;

  int visitNumber;

  _i168yfvg.ChecklistTemplate template;

  _i2j91tw1.ChecklistResponse? response;

  /// Returns a shallow copy of this [VisitChecklist]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  VisitChecklist copyWith({
    _isc.UuidValue? visitId,
    int? visitNumber,
    _i168yfvg.ChecklistTemplate? template,
    _i2j91tw1.ChecklistResponse? response = const _UndefinedVisitChecklist$response(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VisitChecklist',
      'visitId': visitId.toJson(),
      'visitNumber': visitNumber,
      'template': template.toJson(),
      if (response != null) 'response': response?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VisitChecklist',
      'visitId': visitId.toJson(),
      'visitNumber': visitNumber,
      'template': template.toJsonForProtocol(),
      if (response != null) 'response': response?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _UndefinedVisitChecklist$response extends _isc.UndefinedSentinel implements _i2j91tw1.ChecklistResponse {
  const _UndefinedVisitChecklist$response();
}

class _VisitChecklistImpl extends VisitChecklist {
  _VisitChecklistImpl({
    required _isc.UuidValue visitId,
    required int visitNumber,
    required _i168yfvg.ChecklistTemplate template,
    _i2j91tw1.ChecklistResponse? response,
  }) : super._(
         visitId: visitId,
         visitNumber: visitNumber,
         template: template,
         response: response,
       );

  /// Returns a shallow copy of this [VisitChecklist]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  VisitChecklist copyWith({
    _isc.UuidValue? visitId,
    int? visitNumber,
    _i168yfvg.ChecklistTemplate? template,
    _i2j91tw1.ChecklistResponse? response = const _UndefinedVisitChecklist$response(),
  }) {
    return VisitChecklist(
      visitId: visitId ?? this.visitId,
      visitNumber: visitNumber ?? this.visitNumber,
      template: template ?? this.template.copyWith(),
      response: response is _isc.UndefinedSentinel ? this.response?.copyWith() : response,
    );
  }
}
