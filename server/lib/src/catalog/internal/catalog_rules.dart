import 'package:plataforma_os_core/plataforma_os_core.dart';
import 'package:serverpod/serverpod.dart' show UuidValue;

import '../../generated/protocol.dart';

/// Regras do catálogo, comuns às telas e à importação por planilha.

String? _clean(String? v) {
  final t = v?.trim();
  return (t == null || t.isEmpty) ? null : t;
}

final _code = RegExp(r'^[A-Za-z0-9][A-Za-z0-9._/\-]*$');
final _unit = RegExp(r'^[A-Z0-9]{1,6}$');

/// Maior preço aceito: R$ 100 milhões (cabe com folga no `int` do Flutter Web).
const maxPriceCents = 10000000000;

typedef _Err = void Function(String path, String code, String message);

String? _checkCode(String? raw, _Err err) {
  final code = _clean(raw);
  if (code == null) {
    err('code', 'required', 'Informe o código.');
  } else if (code.length > 40 || !_code.hasMatch(code)) {
    err('code', 'invalid', 'Até 40 caracteres: letras, números, ponto, barra, hífen ou sublinhado.');
  }
  return code;
}

String? _checkName(String? raw, _Err err) {
  final name = _clean(raw);
  if (name == null) {
    err('name', 'required', 'Informe o nome.');
  } else if (name.length > 200) {
    err('name', 'too_long', 'Até 200 caracteres.');
  }
  return name;
}

String? _checkText(String path, String? raw, int max, _Err err) {
  final v = _clean(raw);
  if (v != null && v.length > max) err(path, 'too_long', 'Até $max caracteres.');
  return v;
}

String? _checkUnit(String? raw, _Err err) {
  final unit = _clean(raw)?.toUpperCase();
  if (unit == null) {
    err('unitCode', 'required', 'Informe a unidade.');
  } else if (!_unit.hasMatch(unit)) {
    err('unitCode', 'invalid', 'Unidade: até 6 letras ou números (UN, H, KG, M).');
  }
  return unit;
}

void _checkPrice(String path, int? cents, _Err err) {
  if (cents != null && (cents < 0 || cents > maxPriceCents)) {
    err(path, 'out_of_range', 'Preço entre R\$ 0,00 e ${Money.formatBrl(maxPriceCents)}.');
  }
}

// ---------------------------------------------------------------------------
// Famílias
// ---------------------------------------------------------------------------

final class FamilyDraft {
  const FamilyDraft({required this.code, required this.name, this.parentId});

  factory FamilyDraft.fromInput(ProductFamilyInput i) => FamilyDraft(code: i.code, name: i.name, parentId: i.parentId);
  factory FamilyDraft.fromFamily(ProductFamily f) => FamilyDraft(code: f.code, name: f.name, parentId: f.parentId);

  final String code;
  final String name;
  final UuidValue? parentId;

  FamilyDraft apply(ProductFamilyPatch p) => FamilyDraft(
    code: p.code ?? code,
    name: p.name ?? name,
    parentId: (p.clearParent ?? false) ? null : p.parentId ?? parentId,
  );

  Map<String, Object?> toFields() => {'code': code, 'name': name, 'parentId': parentId};
}

typedef FamilyValidation = ({FamilyDraft? draft, List<FieldError> errors});

/// Profundidade máxima da árvore (raiz = 1). Mais que isso vira labirinto nos
/// filtros de sintoma e no app do técnico.
const maxFamilyDepth = 5;

abstract final class FamilyRules {
  static FamilyValidation validate(FamilyDraft d) {
    final errors = <FieldError>[];
    void err(String path, String code, String message) =>
        errors.add(FieldError(path: path, code: code, message: message));
    final code = _checkCode(d.code, err);
    final name = _checkName(d.name, err);
    if (errors.isNotEmpty) return (draft: null, errors: errors);
    return (draft: FamilyDraft(code: code!, name: name!, parentId: d.parentId), errors: const []);
  }
}

/// Campos que o ERP mantém numa família (sem trigger no banco: a família do
/// ERP só muda pela integração, por coerência com produtos e serviços).
const familyMasterFields = {'code', 'name', 'parentId'};

// ---------------------------------------------------------------------------
// Produtos
// ---------------------------------------------------------------------------

final class ProductDraft {
  const ProductDraft({
    required this.code,
    required this.name,
    required this.productKind,
    required this.unitCode,
    required this.isSerialized,
    required this.tracksAssets,
    this.description,
    this.productFamilyId,
    this.gtin,
    this.defaultWarrantyMonths,
    this.referencePrice,
    this.labelPositionInstructions,
  });

  /// Equipamento controla ativos e tem série por padrão; peça e consumível não.
  factory ProductDraft.fromInput(ProductInput i) {
    final kind = i.productKind ?? ProductKind.equipment;
    final tracks = i.tracksAssets ?? kind == ProductKind.equipment;
    return ProductDraft(
      code: i.code,
      name: i.name,
      description: i.description,
      productFamilyId: i.productFamilyId,
      productKind: kind,
      unitCode: i.unitCode ?? 'UN',
      gtin: i.gtin,
      isSerialized: i.isSerialized ?? tracks,
      tracksAssets: tracks,
      defaultWarrantyMonths: i.defaultWarrantyMonths,
      referencePrice: i.referencePrice,
      labelPositionInstructions: i.labelPositionInstructions,
    );
  }

  factory ProductDraft.fromProduct(Product p) => ProductDraft(
    code: p.code,
    name: p.name,
    description: p.description,
    productFamilyId: p.productFamilyId,
    productKind: p.productKind,
    unitCode: p.unitCode,
    gtin: p.gtin,
    isSerialized: p.isSerialized,
    tracksAssets: p.tracksAssets,
    defaultWarrantyMonths: p.defaultWarrantyMonths,
    referencePrice: p.referencePrice,
    labelPositionInstructions: p.labelPositionInstructions,
  );

  final String code;
  final String name;
  final String? description;
  final UuidValue? productFamilyId;
  final ProductKind productKind;
  final String unitCode;
  final String? gtin;
  final bool isSerialized;
  final bool tracksAssets;
  final int? defaultWarrantyMonths;
  final int? referencePrice;
  final String? labelPositionInstructions;

  ProductDraft apply(ProductPatch p) {
    final clear = p.clear?.toSet() ?? const <ProductField>{};
    T? pick<T>(ProductField f, T? patched, T? current) => clear.contains(f) ? null : patched ?? current;
    return ProductDraft(
      code: p.code ?? code,
      name: p.name ?? name,
      description: pick(ProductField.description, p.description, description),
      productFamilyId: pick(ProductField.productFamilyId, p.productFamilyId, productFamilyId),
      productKind: p.productKind ?? productKind,
      unitCode: p.unitCode ?? unitCode,
      gtin: pick(ProductField.gtin, p.gtin, gtin),
      isSerialized: p.isSerialized ?? isSerialized,
      tracksAssets: p.tracksAssets ?? tracksAssets,
      defaultWarrantyMonths: pick(ProductField.defaultWarrantyMonths, p.defaultWarrantyMonths, defaultWarrantyMonths),
      referencePrice: pick(ProductField.referencePrice, p.referencePrice, referencePrice),
      labelPositionInstructions: pick(
        ProductField.labelPositionInstructions,
        p.labelPositionInstructions,
        labelPositionInstructions,
      ),
    );
  }

  Map<String, Object?> toFields() => {
    'code': code,
    'name': name,
    'description': description,
    'productFamilyId': productFamilyId,
    'productKind': productKind,
    'unitCode': unitCode,
    'gtin': gtin,
    'isSerialized': isSerialized,
    'tracksAssets': tracksAssets,
    'defaultWarrantyMonths': defaultWarrantyMonths,
    'referencePrice': referencePrice,
    'labelPositionInstructions': labelPositionInstructions,
  };
}

/// Espelha `trg_guard_erp_master` de `app.products` (db/schema.sql §20.9).
const productMasterFields = {'code', 'name', 'description', 'unitCode', 'gtin', 'referencePrice'};

typedef ProductValidation = ({ProductDraft? draft, List<FieldError> errors});

abstract final class ProductRules {
  static ProductValidation validate(ProductDraft d) {
    final errors = <FieldError>[];
    void err(String path, String code, String message) =>
        errors.add(FieldError(path: path, code: code, message: message));

    final code = _checkCode(d.code, err);
    final name = _checkName(d.name, err);
    final description = _checkText('description', d.description, 4000, err);
    final unit = _checkUnit(d.unitCode, err);
    final instructions = _checkText('labelPositionInstructions', d.labelPositionInstructions, 1000, err);

    var gtin = _clean(d.gtin);
    if (gtin != null) {
      if (Gtin.isValid(gtin)) {
        gtin = Gtin.normalize(gtin);
      } else {
        err('gtin', 'invalid', 'GTIN/EAN inválido: 8, 12, 13 ou 14 dígitos com o verificador.');
      }
    }
    final warranty = d.defaultWarrantyMonths;
    if (warranty != null && (warranty < 0 || warranty > 240)) {
      err('defaultWarrantyMonths', 'out_of_range', 'Garantia entre 0 e 240 meses.');
    }
    _checkPrice('referencePrice', d.referencePrice, err);
    if (d.tracksAssets && d.productKind == ProductKind.consumable) {
      err('tracksAssets', 'incompatible', 'Consumível não vira ativo.');
    }
    if (d.isSerialized && !d.tracksAssets) {
      err('isSerialized', 'incompatible', 'Número de série só vale para produtos que geram ativos.');
    }

    if (errors.isNotEmpty) return (draft: null, errors: errors);
    return (
      draft: ProductDraft(
        code: code!,
        name: name!,
        description: description,
        productFamilyId: d.productFamilyId,
        productKind: d.productKind,
        unitCode: unit!,
        gtin: gtin,
        isSerialized: d.isSerialized,
        tracksAssets: d.tracksAssets,
        defaultWarrantyMonths: warranty,
        referencePrice: d.referencePrice,
        labelPositionInstructions: instructions,
      ),
      errors: const [],
    );
  }
}

// ---------------------------------------------------------------------------
// Serviços
// ---------------------------------------------------------------------------

final class ServiceDraft {
  const ServiceDraft({
    required this.code,
    required this.name,
    required this.unitCode,
    required this.serviceKind,
    this.description,
    this.defaultPrice,
    this.estimatedMinutes,
  });

  factory ServiceDraft.fromInput(CatalogServiceInput i) => ServiceDraft(
    code: i.code,
    name: i.name,
    description: i.description,
    unitCode: i.unitCode ?? 'H',
    defaultPrice: i.defaultPrice,
    estimatedMinutes: i.estimatedMinutes,
    serviceKind: i.serviceKind ?? ServiceKind.other,
  );

  factory ServiceDraft.fromService(CatalogService s) => ServiceDraft(
    code: s.code,
    name: s.name,
    description: s.description,
    unitCode: s.unitCode,
    defaultPrice: s.defaultPrice,
    estimatedMinutes: s.estimatedMinutes,
    serviceKind: s.serviceKind,
  );

  final String code;
  final String name;
  final String? description;
  final String unitCode;
  final int? defaultPrice;
  final int? estimatedMinutes;
  final ServiceKind serviceKind;

  ServiceDraft apply(CatalogServicePatch p) {
    final clear = p.clear?.toSet() ?? const <CatalogServiceField>{};
    T? pick<T>(CatalogServiceField f, T? patched, T? current) => clear.contains(f) ? null : patched ?? current;
    return ServiceDraft(
      code: p.code ?? code,
      name: p.name ?? name,
      description: pick(CatalogServiceField.description, p.description, description),
      unitCode: p.unitCode ?? unitCode,
      defaultPrice: pick(CatalogServiceField.defaultPrice, p.defaultPrice, defaultPrice),
      estimatedMinutes: pick(CatalogServiceField.estimatedMinutes, p.estimatedMinutes, estimatedMinutes),
      serviceKind: p.serviceKind ?? serviceKind,
    );
  }

  Map<String, Object?> toFields() => {
    'code': code,
    'name': name,
    'description': description,
    'unitCode': unitCode,
    'defaultPrice': defaultPrice,
    'estimatedMinutes': estimatedMinutes,
    'serviceKind': serviceKind,
  };
}

/// Espelha `trg_guard_erp_master` de `app.services`.
const serviceMasterFields = {'code', 'name', 'description', 'unitCode', 'defaultPrice'};

typedef ServiceValidation = ({ServiceDraft? draft, List<FieldError> errors});

abstract final class ServiceRules {
  static ServiceValidation validate(ServiceDraft d) {
    final errors = <FieldError>[];
    void err(String path, String code, String message) =>
        errors.add(FieldError(path: path, code: code, message: message));

    final code = _checkCode(d.code, err);
    final name = _checkName(d.name, err);
    final description = _checkText('description', d.description, 4000, err);
    final unit = _checkUnit(d.unitCode, err);
    _checkPrice('defaultPrice', d.defaultPrice, err);
    final minutes = d.estimatedMinutes;
    if (minutes != null && (minutes < 1 || minutes > 14400)) {
      err('estimatedMinutes', 'out_of_range', 'Tempo estimado entre 1 minuto e 240 horas.');
    }

    if (errors.isNotEmpty) return (draft: null, errors: errors);
    return (
      draft: ServiceDraft(
        code: code!,
        name: name!,
        description: description,
        unitCode: unit!,
        defaultPrice: d.defaultPrice,
        estimatedMinutes: minutes,
        serviceKind: d.serviceKind,
      ),
      errors: const [],
    );
  }
}
