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
import '../../imports/models/import_row_error.dart' as _i4p7im5b;
import '../../imports/models/import_run_info.dart' as _i2kryhup;

abstract class ImportPreview implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ImportPreview._({
    required this.run,
    required this.recognizedColumns,
    required this.unknownColumns,
    required this.missingColumns,
    required this.errors,
  });

  factory ImportPreview({
    required _i2kryhup.ImportRunInfo run,
    required List<String> recognizedColumns,
    required List<String> unknownColumns,
    required List<String> missingColumns,
    required List<_i4p7im5b.ImportRowError> errors,
  }) = _ImportPreviewImpl;

  factory ImportPreview.fromJson(Map<String, dynamic> jsonSerialization) {
    return ImportPreview(
      run: _inlzmlpe.Protocol().deserialize<_i2kryhup.ImportRunInfo>(jsonSerialization['run']),
      recognizedColumns: _inlzmlpe.Protocol().deserialize<List<String>>(jsonSerialization['recognizedColumns']),
      unknownColumns: _inlzmlpe.Protocol().deserialize<List<String>>(jsonSerialization['unknownColumns']),
      missingColumns: _inlzmlpe.Protocol().deserialize<List<String>>(jsonSerialization['missingColumns']),
      errors: _inlzmlpe.Protocol().deserialize<List<_i4p7im5b.ImportRowError>>(jsonSerialization['errors']),
    );
  }

  _i2kryhup.ImportRunInfo run;

  List<String> recognizedColumns;

  List<String> unknownColumns;

  List<String> missingColumns;

  List<_i4p7im5b.ImportRowError> errors;

  /// Returns a shallow copy of this [ImportPreview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ImportPreview copyWith({
    _i2kryhup.ImportRunInfo? run,
    List<String>? recognizedColumns,
    List<String>? unknownColumns,
    List<String>? missingColumns,
    List<_i4p7im5b.ImportRowError>? errors,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ImportPreview',
      'run': run.toJson(),
      'recognizedColumns': recognizedColumns.toJson(),
      'unknownColumns': unknownColumns.toJson(),
      'missingColumns': missingColumns.toJson(),
      'errors': errors.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ImportPreview',
      'run': run.toJsonForProtocol(),
      'recognizedColumns': recognizedColumns.toJson(),
      'unknownColumns': unknownColumns.toJson(),
      'missingColumns': missingColumns.toJson(),
      'errors': errors.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ImportPreviewImpl extends ImportPreview {
  _ImportPreviewImpl({
    required _i2kryhup.ImportRunInfo run,
    required List<String> recognizedColumns,
    required List<String> unknownColumns,
    required List<String> missingColumns,
    required List<_i4p7im5b.ImportRowError> errors,
  }) : super._(
         run: run,
         recognizedColumns: recognizedColumns,
         unknownColumns: unknownColumns,
         missingColumns: missingColumns,
         errors: errors,
       );

  /// Returns a shallow copy of this [ImportPreview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ImportPreview copyWith({
    _i2kryhup.ImportRunInfo? run,
    List<String>? recognizedColumns,
    List<String>? unknownColumns,
    List<String>? missingColumns,
    List<_i4p7im5b.ImportRowError>? errors,
  }) {
    return ImportPreview(
      run: run ?? this.run.copyWith(),
      recognizedColumns: recognizedColumns ?? this.recognizedColumns.map((e0) => e0).toList(),
      unknownColumns: unknownColumns ?? this.unknownColumns.map((e0) => e0).toList(),
      missingColumns: missingColumns ?? this.missingColumns.map((e0) => e0).toList(),
      errors: errors ?? this.errors.map((e0) => e0.copyWith()).toList(),
    );
  }
}
