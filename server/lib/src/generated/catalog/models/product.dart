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
import 'dart:async' as _ida;
import 'package:serverpod/serverpod.dart' as _is;
import '../../catalog/models/product_kind.dart' as _ithievlp;
import '../../platform/models/record_source.dart' as _i1c87mer;

abstract class Product implements _is.TableRow<_is.UuidValue>, _is.ProtocolSerialization {
  Product._({
    _is.UuidValue? id,
    required this.tenantId,
    required this.code,
    required this.name,
    this.description,
    this.productFamilyId,
    required this.productKind,
    required this.unitCode,
    this.gtin,
    required this.isSerialized,
    required this.tracksAssets,
    this.defaultWarrantyMonths,
    this.referencePrice,
    this.labelPositionInstructions,
    this.labelPositionAttachmentId,
    required this.isActive,
    required this.source,
    this.externalSystem,
    this.externalId,
    this.missingSince,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  }) : id = id ?? const _is.Uuid().v7obj();

  factory Product({
    _is.UuidValue? id,
    required _is.UuidValue tenantId,
    required String code,
    required String name,
    String? description,
    _is.UuidValue? productFamilyId,
    required _ithievlp.ProductKind productKind,
    required String unitCode,
    String? gtin,
    required bool isSerialized,
    required bool tracksAssets,
    int? defaultWarrantyMonths,
    int? referencePrice,
    String? labelPositionInstructions,
    _is.UuidValue? labelPositionAttachmentId,
    required bool isActive,
    required _i1c87mer.RecordSource source,
    String? externalSystem,
    String? externalId,
    DateTime? missingSince,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
  }) = _ProductImpl;

  factory Product.fromJson(Map<String, dynamic> jsonSerialization) {
    return Product(
      id: jsonSerialization['id'] == null ? null : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      tenantId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['tenantId']),
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      productFamilyId: jsonSerialization['productFamilyId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['productFamilyId']),
      productKind: _ithievlp.ProductKind.fromJson((jsonSerialization['productKind'] as String)),
      unitCode: jsonSerialization['unitCode'] as String,
      gtin: jsonSerialization['gtin'] as String?,
      isSerialized: _is.BoolJsonExtension.fromJson(jsonSerialization['isSerialized']),
      tracksAssets: _is.BoolJsonExtension.fromJson(jsonSerialization['tracksAssets']),
      defaultWarrantyMonths: jsonSerialization['defaultWarrantyMonths'] as int?,
      referencePrice: jsonSerialization['referencePrice'] as int?,
      labelPositionInstructions: jsonSerialization['labelPositionInstructions'] as String?,
      labelPositionAttachmentId: jsonSerialization['labelPositionAttachmentId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['labelPositionAttachmentId']),
      isActive: _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      source: _i1c87mer.RecordSource.fromJson((jsonSerialization['source'] as String)),
      externalSystem: jsonSerialization['externalSystem'] as String?,
      externalId: jsonSerialization['externalId'] as String?,
      missingSince: jsonSerialization['missingSince'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['missingSince']),
      createdAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      version: jsonSerialization['version'] as int,
    );
  }

  static final t = ProductTable();

  static const db = ProductRepository._();

  @override
  _is.UuidValue id;

  _is.UuidValue tenantId;

  String code;

  String name;

  String? description;

  _is.UuidValue? productFamilyId;

  _ithievlp.ProductKind productKind;

  String unitCode;

  String? gtin;

  bool isSerialized;

  bool tracksAssets;

  int? defaultWarrantyMonths;

  int? referencePrice;

  String? labelPositionInstructions;

  _is.UuidValue? labelPositionAttachmentId;

  bool isActive;

  _i1c87mer.RecordSource source;

  String? externalSystem;

  String? externalId;

  DateTime? missingSince;

  DateTime createdAt;

  DateTime updatedAt;

  int version;

  @override
  _is.Table<_is.UuidValue> get table => t;

  /// Returns a shallow copy of this [Product]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Product copyWith({
    _is.UuidValue? id,
    _is.UuidValue? tenantId,
    String? code,
    String? name,
    String? description,
    _is.UuidValue? productFamilyId = const _is.$UndefinedUuidValue(),
    _ithievlp.ProductKind? productKind,
    String? unitCode,
    String? gtin,
    bool? isSerialized,
    bool? tracksAssets,
    int? defaultWarrantyMonths,
    int? referencePrice,
    String? labelPositionInstructions,
    _is.UuidValue? labelPositionAttachmentId = const _is.$UndefinedUuidValue(),
    bool? isActive,
    _i1c87mer.RecordSource? source,
    String? externalSystem,
    String? externalId,
    DateTime? missingSince = const _is.$UndefinedDateTime(),
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Product',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      'code': code,
      'name': name,
      if (description != null) 'description': description,
      if (productFamilyId != null) 'productFamilyId': productFamilyId?.toJson(),
      'productKind': productKind.toJson(),
      'unitCode': unitCode,
      if (gtin != null) 'gtin': gtin,
      'isSerialized': isSerialized,
      'tracksAssets': tracksAssets,
      if (defaultWarrantyMonths != null) 'defaultWarrantyMonths': defaultWarrantyMonths,
      if (referencePrice != null) 'referencePrice': referencePrice,
      if (labelPositionInstructions != null) 'labelPositionInstructions': labelPositionInstructions,
      if (labelPositionAttachmentId != null) 'labelPositionAttachmentId': labelPositionAttachmentId?.toJson(),
      'isActive': isActive,
      'source': source.toJson(),
      if (externalSystem != null) 'externalSystem': externalSystem,
      if (externalId != null) 'externalId': externalId,
      if (missingSince != null) 'missingSince': missingSince?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Product',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      'code': code,
      'name': name,
      if (description != null) 'description': description,
      if (productFamilyId != null) 'productFamilyId': productFamilyId?.toJson(),
      'productKind': productKind.toJson(),
      'unitCode': unitCode,
      if (gtin != null) 'gtin': gtin,
      'isSerialized': isSerialized,
      'tracksAssets': tracksAssets,
      if (defaultWarrantyMonths != null) 'defaultWarrantyMonths': defaultWarrantyMonths,
      if (referencePrice != null) 'referencePrice': referencePrice,
      if (labelPositionInstructions != null) 'labelPositionInstructions': labelPositionInstructions,
      if (labelPositionAttachmentId != null) 'labelPositionAttachmentId': labelPositionAttachmentId?.toJson(),
      'isActive': isActive,
      'source': source.toJson(),
      if (externalSystem != null) 'externalSystem': externalSystem,
      if (externalId != null) 'externalId': externalId,
      if (missingSince != null) 'missingSince': missingSince?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  static ProductInclude include() {
    return ProductInclude._();
  }

  static ProductIncludeList includeList({
    _is.WhereExpressionBuilder<ProductTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProductTable>? orderBy,
    _is.OrderByListBuilder<ProductTable>? orderByList,
    ProductInclude? include,
  }) {
    return ProductIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Product.t),
      orderByList: orderByList?.call(Product.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProductImpl extends Product {
  _ProductImpl({
    _is.UuidValue? id,
    required _is.UuidValue tenantId,
    required String code,
    required String name,
    String? description,
    _is.UuidValue? productFamilyId,
    required _ithievlp.ProductKind productKind,
    required String unitCode,
    String? gtin,
    required bool isSerialized,
    required bool tracksAssets,
    int? defaultWarrantyMonths,
    int? referencePrice,
    String? labelPositionInstructions,
    _is.UuidValue? labelPositionAttachmentId,
    required bool isActive,
    required _i1c87mer.RecordSource source,
    String? externalSystem,
    String? externalId,
    DateTime? missingSince,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
  }) : super._(
         id: id,
         tenantId: tenantId,
         code: code,
         name: name,
         description: description,
         productFamilyId: productFamilyId,
         productKind: productKind,
         unitCode: unitCode,
         gtin: gtin,
         isSerialized: isSerialized,
         tracksAssets: tracksAssets,
         defaultWarrantyMonths: defaultWarrantyMonths,
         referencePrice: referencePrice,
         labelPositionInstructions: labelPositionInstructions,
         labelPositionAttachmentId: labelPositionAttachmentId,
         isActive: isActive,
         source: source,
         externalSystem: externalSystem,
         externalId: externalId,
         missingSince: missingSince,
         createdAt: createdAt,
         updatedAt: updatedAt,
         version: version,
       );

  /// Returns a shallow copy of this [Product]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Product copyWith({
    _is.UuidValue? id,
    _is.UuidValue? tenantId,
    String? code,
    String? name,
    Object? description = _Undefined,
    _is.UuidValue? productFamilyId = const _is.$UndefinedUuidValue(),
    _ithievlp.ProductKind? productKind,
    String? unitCode,
    Object? gtin = _Undefined,
    bool? isSerialized,
    bool? tracksAssets,
    Object? defaultWarrantyMonths = _Undefined,
    Object? referencePrice = _Undefined,
    Object? labelPositionInstructions = _Undefined,
    _is.UuidValue? labelPositionAttachmentId = const _is.$UndefinedUuidValue(),
    bool? isActive,
    _i1c87mer.RecordSource? source,
    Object? externalSystem = _Undefined,
    Object? externalId = _Undefined,
    DateTime? missingSince = const _is.$UndefinedDateTime(),
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return Product(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      productFamilyId: productFamilyId is _is.UndefinedSentinel ? this.productFamilyId : productFamilyId,
      productKind: productKind ?? this.productKind,
      unitCode: unitCode ?? this.unitCode,
      gtin: gtin is String? ? gtin : this.gtin,
      isSerialized: isSerialized ?? this.isSerialized,
      tracksAssets: tracksAssets ?? this.tracksAssets,
      defaultWarrantyMonths: defaultWarrantyMonths is int? ? defaultWarrantyMonths : this.defaultWarrantyMonths,
      referencePrice: referencePrice is int? ? referencePrice : this.referencePrice,
      labelPositionInstructions: labelPositionInstructions is String?
          ? labelPositionInstructions
          : this.labelPositionInstructions,
      labelPositionAttachmentId: labelPositionAttachmentId is _is.UndefinedSentinel
          ? this.labelPositionAttachmentId
          : labelPositionAttachmentId,
      isActive: isActive ?? this.isActive,
      source: source ?? this.source,
      externalSystem: externalSystem is String? ? externalSystem : this.externalSystem,
      externalId: externalId is String? ? externalId : this.externalId,
      missingSince: missingSince is _is.UndefinedSentinel ? this.missingSince : missingSince,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }
}

class ProductUpdateTable extends _is.UpdateTable<ProductTable> {
  ProductUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> tenantId(_is.UuidValue value) => _is.ColumnValue(
    table.tenantId,
    value,
  );

  _is.ColumnValue<String, String> code(String value) => _is.ColumnValue(
    table.code,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> description(String? value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> productFamilyId(_is.UuidValue? value) => _is.ColumnValue(
    table.productFamilyId,
    value,
  );

  _is.ColumnValue<_ithievlp.ProductKind, _ithievlp.ProductKind> productKind(_ithievlp.ProductKind value) =>
      _is.ColumnValue(
        table.productKind,
        value,
      );

  _is.ColumnValue<String, String> unitCode(String value) => _is.ColumnValue(
    table.unitCode,
    value,
  );

  _is.ColumnValue<String, String> gtin(String? value) => _is.ColumnValue(
    table.gtin,
    value,
  );

  _is.ColumnValue<bool, bool> isSerialized(bool value) => _is.ColumnValue(
    table.isSerialized,
    value,
  );

  _is.ColumnValue<bool, bool> tracksAssets(bool value) => _is.ColumnValue(
    table.tracksAssets,
    value,
  );

  _is.ColumnValue<int, int> defaultWarrantyMonths(int? value) => _is.ColumnValue(
    table.defaultWarrantyMonths,
    value,
  );

  _is.ColumnValue<int, int> referencePrice(int? value) => _is.ColumnValue(
    table.referencePrice,
    value,
  );

  _is.ColumnValue<String, String> labelPositionInstructions(String? value) => _is.ColumnValue(
    table.labelPositionInstructions,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> labelPositionAttachmentId(_is.UuidValue? value) => _is.ColumnValue(
    table.labelPositionAttachmentId,
    value,
  );

  _is.ColumnValue<bool, bool> isActive(bool value) => _is.ColumnValue(
    table.isActive,
    value,
  );

  _is.ColumnValue<_i1c87mer.RecordSource, _i1c87mer.RecordSource> source(_i1c87mer.RecordSource value) =>
      _is.ColumnValue(
        table.source,
        value,
      );

  _is.ColumnValue<String, String> externalSystem(String? value) => _is.ColumnValue(
    table.externalSystem,
    value,
  );

  _is.ColumnValue<String, String> externalId(String? value) => _is.ColumnValue(
    table.externalId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> missingSince(DateTime? value) => _is.ColumnValue(
    table.missingSince,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) => _is.ColumnValue(
    table.createdAt,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) => _is.ColumnValue(
    table.updatedAt,
    value,
  );

  _is.ColumnValue<int, int> version(int value) => _is.ColumnValue(
    table.version,
    value,
  );
}

class ProductTable extends _is.Table<_is.UuidValue> {
  ProductTable({super.tableRelation}) : super(tableName: 'products') {
    updateTable = ProductUpdateTable(this);
    tenantId = _is.ColumnUuid(
      'tenant_id',
      this,
      fieldName: 'tenantId',
    );
    code = _is.ColumnString(
      'code',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    productFamilyId = _is.ColumnUuid(
      'product_family_id',
      this,
      fieldName: 'productFamilyId',
    );
    productKind = _is.ColumnEnum(
      'product_kind',
      this,
      _is.EnumSerialization.byName,
      fieldName: 'productKind',
    );
    unitCode = _is.ColumnString(
      'unit_code',
      this,
      fieldName: 'unitCode',
    );
    gtin = _is.ColumnString(
      'gtin',
      this,
    );
    isSerialized = _is.ColumnBool(
      'is_serialized',
      this,
      fieldName: 'isSerialized',
    );
    tracksAssets = _is.ColumnBool(
      'tracks_assets',
      this,
      fieldName: 'tracksAssets',
    );
    defaultWarrantyMonths = _is.ColumnInt(
      'default_warranty_months',
      this,
      fieldName: 'defaultWarrantyMonths',
    );
    referencePrice = _is.ColumnInt(
      'reference_price',
      this,
      fieldName: 'referencePrice',
    );
    labelPositionInstructions = _is.ColumnString(
      'label_position_instructions',
      this,
      fieldName: 'labelPositionInstructions',
    );
    labelPositionAttachmentId = _is.ColumnUuid(
      'label_position_attachment_id',
      this,
      fieldName: 'labelPositionAttachmentId',
    );
    isActive = _is.ColumnBool(
      'is_active',
      this,
      fieldName: 'isActive',
    );
    source = _is.ColumnEnum(
      'source',
      this,
      _is.EnumSerialization.byName,
    );
    externalSystem = _is.ColumnString(
      'external_system',
      this,
      fieldName: 'externalSystem',
    );
    externalId = _is.ColumnString(
      'external_id',
      this,
      fieldName: 'externalId',
    );
    missingSince = _is.ColumnDateTime(
      'missing_since',
      this,
      fieldName: 'missingSince',
    );
    createdAt = _is.ColumnDateTime(
      'created_at',
      this,
      fieldName: 'createdAt',
    );
    updatedAt = _is.ColumnDateTime(
      'updated_at',
      this,
      fieldName: 'updatedAt',
    );
    version = _is.ColumnInt(
      'version',
      this,
    );
  }

  late final ProductUpdateTable updateTable;

  late final _is.ColumnUuid tenantId;

  late final _is.ColumnString code;

  late final _is.ColumnString name;

  late final _is.ColumnString description;

  late final _is.ColumnUuid productFamilyId;

  late final _is.ColumnEnum<_ithievlp.ProductKind> productKind;

  late final _is.ColumnString unitCode;

  late final _is.ColumnString gtin;

  late final _is.ColumnBool isSerialized;

  late final _is.ColumnBool tracksAssets;

  late final _is.ColumnInt defaultWarrantyMonths;

  late final _is.ColumnInt referencePrice;

  late final _is.ColumnString labelPositionInstructions;

  late final _is.ColumnUuid labelPositionAttachmentId;

  late final _is.ColumnBool isActive;

  late final _is.ColumnEnum<_i1c87mer.RecordSource> source;

  late final _is.ColumnString externalSystem;

  late final _is.ColumnString externalId;

  late final _is.ColumnDateTime missingSince;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  late final _is.ColumnInt version;

  @override
  List<_is.Column> get columns => [
    id,
    tenantId,
    code,
    name,
    description,
    productFamilyId,
    productKind,
    unitCode,
    gtin,
    isSerialized,
    tracksAssets,
    defaultWarrantyMonths,
    referencePrice,
    labelPositionInstructions,
    labelPositionAttachmentId,
    isActive,
    source,
    externalSystem,
    externalId,
    missingSince,
    createdAt,
    updatedAt,
    version,
  ];
}

class ProductInclude extends _is.IncludeObject {
  ProductInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue> get table => Product.t;
}

class ProductIncludeList extends _is.IncludeList {
  ProductIncludeList._({
    _is.WhereExpressionBuilder<ProductTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Product.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue> get table => Product.t;
}

class ProductRepository {
  const ProductRepository._();

  /// Returns a list of [Product]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Product>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProductTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProductTable>? orderBy,
    _is.OrderByListBuilder<ProductTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Product>(
      where: where?.call(Product.t),
      orderBy: orderBy?.call(Product.t),
      orderByList: orderByList?.call(Product.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [Product]s matching the given query parameters every time the
  /// source tables are modified.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// Use [throttle] to specify the minimum interval between queries. It can
  /// also be set to `null`, in which case the stream will only be throttled
  /// when its subscription is paused.
  ///
  /// Source tables are collected from the queried table, [where], [orderBy],
  /// [orderByList], and the [include] graph. [alsoTriggerOnTables] is added
  /// to that set. Pass [Table] instances such as `Product.t`.
  ///
  /// Raw [Expression] SQL is not inspected. Tables referenced only in raw
  /// SQL must be passed via [alsoTriggerOnTables].
  ///
  /// The stream always reads committed state and never joins an ambient
  /// [Transaction]. Emissions for a write fire after that write commits.
  ///
  /// Currently only supported on SQLite. Calling this method on PostgreSQL
  /// throws an [UnsupportedError].
  ///
  /// ```dart
  /// var subscription = Persons.db.watch(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// ).listen((persons) {
  ///   // Handle the latest matching rows.
  /// });
  /// ```
  _ida.Stream<List<Product>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProductTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProductTable>? orderBy,
    _is.OrderByListBuilder<ProductTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<Product>(
      where: where?.call(Product.t),
      orderBy: orderBy?.call(Product.t),
      orderByList: orderByList?.call(Product.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [Product] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Product?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProductTable>? where,
    int? offset,
    _is.OrderByBuilder<ProductTable>? orderBy,
    _is.OrderByListBuilder<ProductTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Product>(
      where: where?.call(Product.t),
      orderBy: orderBy?.call(Product.t),
      orderByList: orderByList?.call(Product.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Product] by its [id] or null if no such row exists.
  Future<Product?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Product>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Product]s in the list and returns the inserted rows.
  ///
  /// The returned [Product]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Product>> insert(
    _is.DatabaseSession session,
    List<Product> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Product>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Product] and returns the inserted row.
  ///
  /// The returned [Product] will have its `id` field set.
  Future<Product> insertRow(
    _is.DatabaseSession session,
    Product row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Product>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Product]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [Product]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Product>> upsert(
    _is.DatabaseSession session,
    List<Product> rows, {
    required _is.ColumnSelections<ProductTable> conflictColumns,
    _is.ColumnSelections<ProductTable>? updateColumns,
    _is.WhereExpressionBuilder<ProductTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Product>(
      rows,
      conflictColumns: conflictColumns(Product.t),
      updateColumns: updateColumns?.call(Product.t),
      updateWhere: updateWhere?.call(Product.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Product] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [Product] will have its `id` field set.
  Future<Product?> upsertRow(
    _is.DatabaseSession session,
    Product row, {
    required _is.ColumnSelections<ProductTable> conflictColumns,
    _is.ColumnSelections<ProductTable>? updateColumns,
    _is.WhereExpressionBuilder<ProductTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Product>(
      row,
      conflictColumns: conflictColumns(Product.t),
      updateColumns: updateColumns?.call(Product.t),
      updateWhere: updateWhere?.call(Product.t),
      transaction: transaction,
    );
  }

  /// Updates all [Product]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Product>> update(
    _is.DatabaseSession session,
    List<Product> rows, {
    _is.ColumnSelections<ProductTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Product>(
      rows,
      columns: columns?.call(Product.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Product]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Product> updateRow(
    _is.DatabaseSession session,
    Product row, {
    _is.ColumnSelections<ProductTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Product>(
      row,
      columns: columns?.call(Product.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Product] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Product?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ProductUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Product>(
      id,
      columnValues: columnValues(Product.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Product]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Product>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ProductUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ProductTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProductTable>? orderBy,
    _is.OrderByListBuilder<ProductTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Product>(
      columnValues: columnValues(Product.t.updateTable),
      where: where(Product.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Product.t),
      orderByList: orderByList?.call(Product.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Product]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Product>> delete(
    _is.DatabaseSession session,
    List<Product> rows, {
    _is.OrderByBuilder<ProductTable>? orderBy,
    _is.OrderByListBuilder<ProductTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Product>(
      rows,
      orderBy: orderBy?.call(Product.t),
      orderByList: orderByList?.call(Product.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Product].
  Future<Product> deleteRow(
    _is.DatabaseSession session,
    Product row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Product>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Product>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProductTable> where,
    _is.OrderByBuilder<ProductTable>? orderBy,
    _is.OrderByListBuilder<ProductTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Product>(
      where: where(Product.t),
      orderBy: orderBy?.call(Product.t),
      orderByList: orderByList?.call(Product.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProductTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Product>(
      where: where?.call(Product.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Product] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProductTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Product>(
      where: where(Product.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
