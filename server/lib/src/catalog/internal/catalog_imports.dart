import 'package:plataforma_os_core/plataforma_os_core.dart';
import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/imports/import_spec.dart';
import 'catalog_common.dart';
import 'catalog_rules.dart';
import 'catalog_service_service.dart';
import 'product_service.dart';

/// Importações por planilha do catálogo. As linhas passam pelas mesmas
/// regras das telas (`ProductRules`, `ServiceRules`); a chave é o código.

final class _Create<D> {
  const _Create(this.draft);
  final D draft;
}

final class _Update<R> {
  const _Update(this.current, this.changed);
  final R current;
  final Map<String, Object?> changed;
}

int? _money(String? v) {
  if (v == null) return null;
  try {
    return Money.parseToCents(v);
  } on FormatException {
    throw const FormatException('valor inválido (use 1234,56)');
  }
}

ImportRowPlan _error(ImportRecord r, String? key, List<String> messages) =>
    ImportRowPlan(rowNumber: r.rowNumber, key: key, action: ImportAction.error, messages: messages);

/// Etapas comuns: código obrigatório e único na planilha; o resto por linha.
Future<List<ImportRowPlan>> _planByCode<R>(
  List<ImportRecord> records, {
  required Future<Map<String, R>> Function(List<String> codes) existing,
  required ImportRowPlan Function(ImportRecord r, String code, R? current) row,
}) async {
  final codes = [
    for (final r in records)
      if (r['codigo'] != null) r['codigo']!,
  ];
  final current = await existing(codes);
  final seen = <String>{};
  return [
    for (final r in records)
      switch (r['codigo']) {
        null => _error(r, null, const ['Código: obrigatório (é a chave da importação).']),
        final code when !seen.add(code) => _error(r, code, const ['Código repetido na planilha.']),
        final code => _guard(r, code, () => row(r, code, current[code])),
      },
  ];
}

ImportRowPlan _guard(ImportRecord r, String code, ImportRowPlan Function() body) {
  try {
    return body();
  } on FormatException catch (e) {
    return _error(r, code, [e.message]);
  }
}

// ---------------------------------------------------------------------------
// Produtos
// ---------------------------------------------------------------------------

final class ProductsImport extends ImportSpec {
  @override
  ImportEntityType get entity => ImportEntityType.products;
  @override
  String get title => 'Produtos';
  @override
  String get managePermission => CatalogCommon.managePermission;
  @override
  String get description =>
      'Cria ou atualiza produtos (equipamentos, peças, consumíveis) pelo código. Células vazias não apagam o que já '
      'está cadastrado. A família é indicada pelo código dela.';

  static const _code = ImportColumn(
    'codigo',
    'Código',
    isRequired: true,
    help: 'Chave da importação: único na empresa.',
    example: 'FRZ-500',
    aliases: ['cod', 'code', 'sku', 'codigo_produto'],
  );
  static const _name = ImportColumn(
    'nome',
    'Nome',
    isRequired: true,
    help: 'Nome do modelo.',
    example: 'Freezer horizontal 500 L',
    aliases: ['name', 'produto', 'descricao_curta'],
  );
  static const _description = ImportColumn(
    'descricao',
    'Descrição',
    help: 'Opcional.',
    example: 'Duas tampas, 220 V',
    aliases: ['description', 'detalhes'],
  );
  static const _family = ImportColumn(
    'familia',
    'Família (código)',
    help: 'Código de uma família ativa já cadastrada.',
    example: 'REFRIG',
    aliases: ['codigo_familia', 'family', 'categoria'],
  );
  static const _kind = ImportColumn(
    'tipo',
    'Tipo',
    help: 'equipamento, peça, consumível ou outro. Vazio: equipamento (ao criar).',
    example: 'equipamento',
    aliases: ['tipo_produto', 'kind'],
  );
  static const _unit = ImportColumn(
    'unidade',
    'Unidade',
    help: 'UN, PC, KG, M… Vazio: UN (ao criar).',
    example: 'UN',
    aliases: ['un', 'unit', 'unidade_medida'],
  );
  static const _gtin = ImportColumn(
    'gtin',
    'GTIN / EAN',
    help: 'Código de barras, com o dígito verificador.',
    example: '7891000315507',
    aliases: ['ean', 'codigo_barras', 'codigo_de_barras'],
  );
  static const _tracks = ImportColumn(
    'gera_ativo',
    'Gera ativo',
    help: 'sim ou não: cada unidade vira um ativo com QR. Vazio: sim para equipamento (ao criar).',
    example: 'sim',
    aliases: ['controla_ativo', 'ativo_fisico'],
  );
  static const _serial = ImportColumn(
    'numero_serie',
    'Tem número de série',
    help: 'sim ou não. Vazio: igual a "Gera ativo" (ao criar).',
    example: 'sim',
    aliases: ['serializado', 'serie'],
  );
  static const _warranty = ImportColumn(
    'garantia_meses',
    'Garantia (meses)',
    help: 'Garantia padrão, de 0 a 240.',
    example: '12',
    aliases: ['garantia'],
  );
  static const _price = ImportColumn(
    'preco_referencia',
    'Preço de referência (R\$)',
    help: 'Com vírgula decimal.',
    example: '4.590,00',
    aliases: ['preco', 'valor', 'price'],
  );
  static const _label = ImportColumn(
    'instrucoes_etiqueta',
    'Onde colar a etiqueta QR',
    help: 'Orientação para o técnico.',
    example: 'Lateral direita, acima da placa',
    aliases: ['etiqueta', 'posicao_etiqueta'],
  );

  @override
  final List<ImportColumn> columns = const [
    _code,
    _name,
    _description,
    _family,
    _kind,
    _unit,
    _gtin,
    _tracks,
    _serial,
    _warranty,
    _price,
    _label,
  ];

  static const _pathToColumn = {
    'code': 'codigo',
    'name': 'nome',
    'description': 'descricao',
    'productFamilyId': 'familia',
    'productKind': 'tipo',
    'unitCode': 'unidade',
    'gtin': 'gtin',
    'tracksAssets': 'gera_ativo',
    'isSerialized': 'numero_serie',
    'defaultWarrantyMonths': 'garantia_meses',
    'referencePrice': 'preco_referencia',
    'labelPositionInstructions': 'instrucoes_etiqueta',
  };

  static ProductKind? _kindOf(String? v) {
    if (v == null) return null;
    return switch (ImportCells.normalizeHeader(v)) {
      'equipamento' || 'equipment' || 'eq' => ProductKind.equipment,
      'peca' || 'pecas' || 'spare_part' || 'part' || 'pc' => ProductKind.spare_part,
      'consumivel' || 'consumable' || 'material' => ProductKind.consumable,
      'outro' || 'outros' || 'other' => ProductKind.other,
      _ => throw const FormatException('use equipamento, peça, consumível ou outro'),
    };
  }

  @override
  Future<List<ImportRowPlan>> plan(Session session, List<ImportRecord> records, {Transaction? transaction}) async {
    final familyCodes = {
      for (final r in records)
        if (r['familia'] != null) r['familia']!,
    }.toList();
    final families = {
      for (final f in await ImportHelpers.findInChunks(
        familyCodes,
        (chunk) => ProductFamily.db.find(session, where: (t) => t.code.inSet(chunk), transaction: transaction),
      ))
        f.code: f,
    };

    return _planByCode<Product>(
      records,
      existing: (codes) async => {
        for (final p in await ImportHelpers.findInChunks(
          codes,
          (chunk) => Product.db.find(session, where: (t) => t.code.inSet(chunk), transaction: transaction),
        ))
          p.code: p,
      },
      row: (r, code, current) {
        UuidValue? familyId;
        final familyCode = r['familia'];
        if (familyCode != null) {
          final family = families[familyCode];
          if (family == null) return _error(r, code, ['${_family.label}: "$familyCode" não encontrada.']);
          if (!family.isActive) return _error(r, code, ['${_family.label}: "$familyCode" está inativa.']);
          familyId = family.id;
        }
        final kind = ImportHelpers.cell(r, _kind, _kindOf);
        final tracks = ImportHelpers.cell(r, _tracks, ImportCells.boolean);
        final serial = ImportHelpers.cell(r, _serial, ImportCells.boolean);
        final warranty = ImportHelpers.cell(r, _warranty, ImportCells.integer);
        final price = ImportHelpers.cell(r, _price, _money);

        final ProductDraft draft;
        if (current == null) {
          draft = ProductDraft.fromInput(
            ProductInput(
              code: code,
              name: r['nome'] ?? '',
              description: r['descricao'],
              productFamilyId: familyId,
              productKind: kind,
              unitCode: r['unidade'],
              gtin: r['gtin'],
              tracksAssets: tracks,
              isSerialized: serial,
              defaultWarrantyMonths: warranty,
              referencePrice: price,
              labelPositionInstructions: r['instrucoes_etiqueta'],
            ),
          );
        } else {
          draft = ProductDraft.fromProduct(current).apply(
            ProductPatch(
              name: r['nome'],
              description: r['descricao'],
              productFamilyId: familyId,
              productKind: kind,
              unitCode: r['unidade'],
              gtin: r['gtin'],
              tracksAssets: tracks,
              isSerialized: serial,
              defaultWarrantyMonths: warranty,
              referencePrice: price,
              labelPositionInstructions: r['instrucoes_etiqueta'],
            ),
          );
        }
        final v = ProductRules.validate(draft);
        if (v.errors.isNotEmpty) return _error(r, code, ImportHelpers.messages(v.errors, columns, _pathToColumn));
        if (current == null) {
          return ImportRowPlan(
            rowNumber: r.rowNumber,
            key: code,
            action: ImportAction.create,
            payload: _Create(v.draft!),
          );
        }
        final changed = CatalogCommon.changed(ProductDraft.fromProduct(current).toFields(), v.draft!.toFields());
        if (changed.isEmpty) return ImportRowPlan(rowNumber: r.rowNumber, key: code, action: ImportAction.unchanged);
        if (current.source == RecordSource.erp && changed.keys.any(productMasterFields.contains)) {
          return _error(r, code, const [
            'Produto vem do ERP: código, nome, descrição, unidade, GTIN e preço só mudam por lá.',
          ]);
        }
        return ImportRowPlan(
          rowNumber: r.rowNumber,
          key: code,
          action: ImportAction.update,
          payload: _Update(current, changed),
        );
      },
    );
  }

  @override
  Future<({int created, int updated})> apply(
    Session session,
    Transaction transaction,
    List<ImportRowPlan> plan, {
    required UuidValue runId,
  }) async {
    final origin = {'origin': 'file_import', 'import_run_id': runId.uuid};
    final toInsert = [
      for (final p in plan)
        if (p.payload case _Create<ProductDraft>(:final draft)) ProductService.newProduct(session, draft),
    ];
    var created = 0;
    for (var i = 0; i < toInsert.length; i += 500) {
      final rows = await Product.db.insert(
        session,
        toInsert.sublist(i, i + 500 > toInsert.length ? toInsert.length : i + 500),
        transaction: transaction,
      );
      for (final p in rows) {
        await ProductService.event(session, transaction, 'product.created', p, extra: origin);
      }
      created += rows.length;
    }
    var updated = 0;
    for (final p in plan) {
      if (p.payload case _Update<Product>(:final current, :final changed)) {
        final rows = await Product.db.updateWhere(
          session,
          columnValues: (t) => [for (final e in changed.entries) ProductService.columnValue(t, e.key, e.value)],
          where: (t) => t.id.equals(current.id) & t.version.equals(current.version),
          transaction: transaction,
        );
        if (rows.isEmpty) throw StateError('Produto ${current.code} mudou durante a importação.');
        await ProductService.event(
          session,
          transaction,
          'product.updated',
          rows.single,
          extra: {...origin, 'changed_fields': changed.keys.toList()..sort()},
        );
        updated++;
      }
    }
    return (created: created, updated: updated);
  }
}

// ---------------------------------------------------------------------------
// Serviços
// ---------------------------------------------------------------------------

final class ServicesImport extends ImportSpec {
  @override
  ImportEntityType get entity => ImportEntityType.services;
  @override
  String get title => 'Serviços';
  @override
  String get managePermission => CatalogCommon.managePermission;
  @override
  String get description =>
      'Cria ou atualiza serviços (hora técnica, visita, deslocamento) pelo código. Células vazias não apagam o que já '
      'está cadastrado.';

  static const _kind = ImportColumn(
    'tipo',
    'Tipo',
    help: 'mão de obra, deslocamento, visita ou outro. Vazio: outro (ao criar).',
    example: 'mão de obra',
    aliases: ['tipo_servico', 'kind'],
  );
  static const _price = ImportColumn(
    'preco',
    'Preço por unidade (R\$)',
    help: 'Com vírgula decimal.',
    example: '180,00',
    aliases: ['preco_padrao', 'valor', 'price'],
  );
  static const _minutes = ImportColumn(
    'minutos_estimados',
    'Tempo estimado (minutos)',
    help: 'Duração típica, em minutos.',
    example: '60',
    aliases: ['tempo_estimado', 'minutos', 'duracao'],
  );

  @override
  final List<ImportColumn> columns = const [
    ImportColumn(
      'codigo',
      'Código',
      isRequired: true,
      help: 'Chave da importação: único na empresa.',
      example: 'HT-NORMAL',
      aliases: ['cod', 'code', 'codigo_servico'],
    ),
    ImportColumn(
      'nome',
      'Nome',
      isRequired: true,
      help: 'Como aparece na OS e no relatório.',
      example: 'Hora técnica (horário comercial)',
      aliases: ['name', 'servico'],
    ),
    ImportColumn('descricao', 'Descrição', help: 'Opcional.', example: '', aliases: ['description']),
    _kind,
    ImportColumn(
      'unidade',
      'Unidade',
      help: 'H, VIS, KM… Vazio: H (ao criar).',
      example: 'H',
      aliases: ['un', 'unit'],
    ),
    _price,
    _minutes,
  ];

  static const _pathToColumn = {
    'code': 'codigo',
    'name': 'nome',
    'description': 'descricao',
    'serviceKind': 'tipo',
    'unitCode': 'unidade',
    'defaultPrice': 'preco',
    'estimatedMinutes': 'minutos_estimados',
  };

  static ServiceKind? _kindOf(String? v) {
    if (v == null) return null;
    return switch (ImportCells.normalizeHeader(v)) {
      'mao_de_obra' || 'mao_obra' || 'labour' || 'labor' || 'hora_tecnica' => ServiceKind.labour,
      'deslocamento' || 'travel' || 'km' => ServiceKind.travel,
      'visita' || 'visit' || 'taxa_de_visita' => ServiceKind.visit,
      'outro' || 'outros' || 'other' => ServiceKind.other,
      _ => throw const FormatException('use mão de obra, deslocamento, visita ou outro'),
    };
  }

  @override
  Future<List<ImportRowPlan>> plan(Session session, List<ImportRecord> records, {Transaction? transaction}) =>
      _planByCode<CatalogService>(
        records,
        existing: (codes) async => {
          for (final s in await ImportHelpers.findInChunks(
            codes,
            (chunk) => CatalogService.db.find(session, where: (t) => t.code.inSet(chunk), transaction: transaction),
          ))
            s.code: s,
        },
        row: (r, code, current) {
          final kind = ImportHelpers.cell(r, _kind, _kindOf);
          final price = ImportHelpers.cell(r, _price, _money);
          final minutes = ImportHelpers.cell(r, _minutes, ImportCells.integer);
          final draft = current == null
              ? ServiceDraft.fromInput(
                  CatalogServiceInput(
                    code: code,
                    name: r['nome'] ?? '',
                    description: r['descricao'],
                    unitCode: r['unidade'],
                    defaultPrice: price,
                    estimatedMinutes: minutes,
                    serviceKind: kind,
                  ),
                )
              : ServiceDraft.fromService(current).apply(
                  CatalogServicePatch(
                    name: r['nome'],
                    description: r['descricao'],
                    unitCode: r['unidade'],
                    defaultPrice: price,
                    estimatedMinutes: minutes,
                    serviceKind: kind,
                  ),
                );
          final v = ServiceRules.validate(draft);
          if (v.errors.isNotEmpty) return _error(r, code, ImportHelpers.messages(v.errors, columns, _pathToColumn));
          if (current == null) {
            return ImportRowPlan(
              rowNumber: r.rowNumber,
              key: code,
              action: ImportAction.create,
              payload: _Create(v.draft!),
            );
          }
          final changed = CatalogCommon.changed(ServiceDraft.fromService(current).toFields(), v.draft!.toFields());
          if (changed.isEmpty) return ImportRowPlan(rowNumber: r.rowNumber, key: code, action: ImportAction.unchanged);
          if (current.source == RecordSource.erp && changed.keys.any(serviceMasterFields.contains)) {
            return _error(r, code, const [
              'Serviço vem do ERP: código, nome, descrição, unidade e preço só mudam por lá.',
            ]);
          }
          return ImportRowPlan(
            rowNumber: r.rowNumber,
            key: code,
            action: ImportAction.update,
            payload: _Update(current, changed),
          );
        },
      );

  @override
  Future<({int created, int updated})> apply(
    Session session,
    Transaction transaction,
    List<ImportRowPlan> plan, {
    required UuidValue runId,
  }) async {
    final origin = {'origin': 'file_import', 'import_run_id': runId.uuid};
    final toInsert = [
      for (final p in plan)
        if (p.payload case _Create<ServiceDraft>(:final draft)) CatalogServices.newService(session, draft),
    ];
    var created = 0;
    for (var i = 0; i < toInsert.length; i += 500) {
      final rows = await CatalogService.db.insert(
        session,
        toInsert.sublist(i, i + 500 > toInsert.length ? toInsert.length : i + 500),
        transaction: transaction,
      );
      for (final s in rows) {
        await CatalogServices.event(session, transaction, 'service.created', s, extra: origin);
      }
      created += rows.length;
    }
    var updated = 0;
    for (final p in plan) {
      if (p.payload case _Update<CatalogService>(:final current, :final changed)) {
        final rows = await CatalogService.db.updateWhere(
          session,
          columnValues: (t) => [for (final e in changed.entries) CatalogServices.columnValue(t, e.key, e.value)],
          where: (t) => t.id.equals(current.id) & t.version.equals(current.version),
          transaction: transaction,
        );
        if (rows.isEmpty) throw StateError('Serviço ${current.code} mudou durante a importação.');
        await CatalogServices.event(
          session,
          transaction,
          'service.updated',
          rows.single,
          extra: {...origin, 'changed_fields': changed.keys.toList()..sort()},
        );
        updated++;
      }
    }
    return (created: created, updated: updated);
  }
}
