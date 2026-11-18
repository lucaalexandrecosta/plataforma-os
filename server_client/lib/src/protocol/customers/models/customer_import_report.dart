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
import '../../customers/models/customer_import_error.dart' as _iygsfkhs;

abstract class CustomerImportReport implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CustomerImportReport._({
    required this.dryRun,
    required this.applied,
    required this.rows,
    required this.customersCreated,
    required this.customersExisting,
    required this.sitesCreated,
    required this.sitesExisting,
    required this.contactsCreated,
    required this.contactsExisting,
    required this.errors,
  });

  factory CustomerImportReport({
    required bool dryRun,
    required bool applied,
    required int rows,
    required int customersCreated,
    required int customersExisting,
    required int sitesCreated,
    required int sitesExisting,
    required int contactsCreated,
    required int contactsExisting,
    required List<_iygsfkhs.CustomerImportError> errors,
  }) = _CustomerImportReportImpl;

  factory CustomerImportReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return CustomerImportReport(
      dryRun: _isc.BoolJsonExtension.fromJson(jsonSerialization['dryRun']),
      applied: _isc.BoolJsonExtension.fromJson(jsonSerialization['applied']),
      rows: jsonSerialization['rows'] as int,
      customersCreated: jsonSerialization['customersCreated'] as int,
      customersExisting: jsonSerialization['customersExisting'] as int,
      sitesCreated: jsonSerialization['sitesCreated'] as int,
      sitesExisting: jsonSerialization['sitesExisting'] as int,
      contactsCreated: jsonSerialization['contactsCreated'] as int,
      contactsExisting: jsonSerialization['contactsExisting'] as int,
      errors: _inlzmlpe.Protocol().deserialize<List<_iygsfkhs.CustomerImportError>>(jsonSerialization['errors']),
    );
  }

  bool dryRun;

  bool applied;

  int rows;

  int customersCreated;

  int customersExisting;

  int sitesCreated;

  int sitesExisting;

  int contactsCreated;

  int contactsExisting;

  List<_iygsfkhs.CustomerImportError> errors;

  /// Returns a shallow copy of this [CustomerImportReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CustomerImportReport copyWith({
    bool? dryRun,
    bool? applied,
    int? rows,
    int? customersCreated,
    int? customersExisting,
    int? sitesCreated,
    int? sitesExisting,
    int? contactsCreated,
    int? contactsExisting,
    List<_iygsfkhs.CustomerImportError>? errors,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CustomerImportReport',
      'dryRun': dryRun,
      'applied': applied,
      'rows': rows,
      'customersCreated': customersCreated,
      'customersExisting': customersExisting,
      'sitesCreated': sitesCreated,
      'sitesExisting': sitesExisting,
      'contactsCreated': contactsCreated,
      'contactsExisting': contactsExisting,
      'errors': errors.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CustomerImportReport',
      'dryRun': dryRun,
      'applied': applied,
      'rows': rows,
      'customersCreated': customersCreated,
      'customersExisting': customersExisting,
      'sitesCreated': sitesCreated,
      'sitesExisting': sitesExisting,
      'contactsCreated': contactsCreated,
      'contactsExisting': contactsExisting,
      'errors': errors.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _CustomerImportReportImpl extends CustomerImportReport {
  _CustomerImportReportImpl({
    required bool dryRun,
    required bool applied,
    required int rows,
    required int customersCreated,
    required int customersExisting,
    required int sitesCreated,
    required int sitesExisting,
    required int contactsCreated,
    required int contactsExisting,
    required List<_iygsfkhs.CustomerImportError> errors,
  }) : super._(
         dryRun: dryRun,
         applied: applied,
         rows: rows,
         customersCreated: customersCreated,
         customersExisting: customersExisting,
         sitesCreated: sitesCreated,
         sitesExisting: sitesExisting,
         contactsCreated: contactsCreated,
         contactsExisting: contactsExisting,
         errors: errors,
       );

  /// Returns a shallow copy of this [CustomerImportReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CustomerImportReport copyWith({
    bool? dryRun,
    bool? applied,
    int? rows,
    int? customersCreated,
    int? customersExisting,
    int? sitesCreated,
    int? sitesExisting,
    int? contactsCreated,
    int? contactsExisting,
    List<_iygsfkhs.CustomerImportError>? errors,
  }) {
    return CustomerImportReport(
      dryRun: dryRun ?? this.dryRun,
      applied: applied ?? this.applied,
      rows: rows ?? this.rows,
      customersCreated: customersCreated ?? this.customersCreated,
      customersExisting: customersExisting ?? this.customersExisting,
      sitesCreated: sitesCreated ?? this.sitesCreated,
      sitesExisting: sitesExisting ?? this.sitesExisting,
      contactsCreated: contactsCreated ?? this.contactsCreated,
      contactsExisting: contactsExisting ?? this.contactsExisting,
      errors: errors ?? this.errors.map((e0) => e0.copyWith()).toList(),
    );
  }
}
