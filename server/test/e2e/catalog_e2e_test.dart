// Catálogo de ponta a ponta: famílias (árvore, ciclo, inativação), produtos
// e serviços (padrão de cadastro, ERP, eventos), permissões, isolamento e
// importação por planilha.
@Tags(['e2e'])
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:postgres/postgres.dart' as pg;
import 'package:test/test.dart';

import 'support.dart';

ByteData csv(String text) => ByteData.sublistView(Uint8List.fromList(utf8.encode(text)));

void main() {
  late Client asAna;
  late Client asBruno;
  late Client asCarla;
  late Client asDavi;
  late pg.Connection db;
  final run = DateTime.now().toUtc().millisecondsSinceEpoch.toRadixString(36).toUpperCase();

  setUpAll(() async {
    final tokens = loadTestTokens();
    asAna = clientAs(tokens, ana);
    asBruno = clientAs(tokens, bruno);
    asCarla = clientAs(tokens, carla);
    asDavi = clientAs(tokens, daviA);
    db = await openTestDb();
  });
  tearDownAll(() => db.close());

  Matcher apiError(String code, {String? path}) => throwsA(
    isA<ApiException>()
        .having((e) => e.code, 'code', code)
        .having((e) => path == null || (e.fieldErrors ?? []).any((f) => f.path == path), 'fieldErrors[$path]', true),
  );

  Future<int> outboxCount(String type, UuidValue id) async {
    final r = await db.execute(
      pg.Sql.named('SELECT count(*) FROM app.outbox_messages WHERE event_type = @t AND aggregate_id = @id::uuid'),
      parameters: {'t': type, 'id': id.uuid},
    );
    return r.single[0]! as int;
  }

  test('famílias: árvore, ciclo, profundidade e inativação', () async {
    final root = await asAna.productFamilies.create(ProductFamilyInput(code: 'REF-$run', name: 'Refrigeração $run'));
    final child = await asAna.productFamilies.create(
      ProductFamilyInput(code: 'FRZ-$run', name: 'Freezers $run', parentId: root.id),
    );
    expect(child.parentId, root.id);

    final children = await asAna.productFamilies.list(ProductFamilyFilter(parentId: root.id), null);
    expect(children.items.map((f) => f.id), [child.id]);

    await expectLater(
      asAna.productFamilies.update(root.id, ProductFamilyPatch(parentId: child.id), root.version),
      apiError('VALIDATION_FAILED', path: 'parentId'),
    );
    await expectLater(
      asAna.productFamilies.create(ProductFamilyInput(code: 'REF-$run', name: 'Outra')),
      apiError('DUPLICATE', path: 'code'),
    );

    // Cinco níveis no máximo.
    var parent = child;
    for (var level = 3; level <= 5; level++) {
      parent = await asAna.productFamilies.create(
        ProductFamilyInput(code: 'L$level-$run', name: 'Nível $level', parentId: parent.id),
      );
    }
    await expectLater(
      asAna.productFamilies.create(ProductFamilyInput(code: 'L6-$run', name: 'Nível 6', parentId: parent.id)),
      apiError('VALIDATION_FAILED', path: 'parentId'),
    );

    await expectLater(
      asAna.productFamilies.deactivate(root.id, 'teste', root.version),
      apiError('BUSINESS_RULE_VIOLATION'),
    );
    final leaf = await asAna.productFamilies.deactivate(parent.id, 'teste', parent.version);
    expect(leaf.isActive, isFalse);
    await expectLater(
      asAna.productFamilies.create(ProductFamilyInput(code: 'X-$run', name: 'X', parentId: leaf.id)),
      apiError('VALIDATION_FAILED', path: 'parentId'),
    );
    expect((await asAna.productFamilies.reactivate(leaf.id, leaf.version)).isActive, isTrue);
  });

  test('produtos: cadastro, filtro por família com subfamílias, patch, versão e eventos', () async {
    final root = await asAna.productFamilies.create(ProductFamilyInput(code: 'EQ-$run', name: 'Equipamentos'));
    final sub = await asAna.productFamilies.create(
      ProductFamilyInput(code: 'EXP-$run', name: 'Expositores', parentId: root.id),
    );
    final p = await asAna.products.create(
      ProductInput(
        id: const Uuid().v7obj(),
        code: 'PRD-$run',
        name: 'Expositor 3 portas',
        productFamilyId: sub.id,
        gtin: '7891000315507',
        referencePrice: 459000,
        defaultWarrantyMonths: 12,
      ),
    );
    expect(p.productKind, ProductKind.equipment);
    expect(p.tracksAssets, isTrue);
    expect(p.isSerialized, isTrue);
    expect(p.unitCode, 'UN');
    expect(await outboxCount('product.created', p.id), 1);

    final byRoot = await asAna.products.list(ProductFilter(productFamilyId: root.id), null);
    expect(byRoot.items.map((x) => x.id), [p.id], reason: 'a família raiz inclui as subfamílias');
    final byQuery = await asAna.products.list(ProductFilter(q: '7891000315507'), null);
    expect(byQuery.items.map((x) => x.id), contains(p.id));

    await expectLater(
      asAna.products.create(ProductInput(code: 'PRD-$run', name: 'Duplicado')),
      apiError('DUPLICATE', path: 'code'),
    );
    await expectLater(
      asAna.products.create(ProductInput(code: 'BAD-$run', name: 'X', gtin: '123')),
      apiError('VALIDATION_FAILED', path: 'gtin'),
    );
    await expectLater(
      asAna.products.create(
        ProductInput(code: 'NF-$run', name: 'X', productFamilyId: const Uuid().v7obj()),
      ),
      apiError('VALIDATION_FAILED', path: 'productFamilyId'),
    );

    final u = await asAna.products.update(
      p.id,
      ProductPatch(name: 'Expositor 3 portas inox', clear: [ProductField.gtin]),
      p.version,
    );
    expect(u.name, 'Expositor 3 portas inox');
    expect(u.gtin, isNull);
    expect(u.referencePrice, 459000);
    expect(u.version, p.version + 1);
    await expectLater(
      asAna.products.update(p.id, ProductPatch(name: 'Velho'), p.version),
      apiError('VERSION_MISMATCH'),
    );

    final off = await asAna.products.deactivate(u.id, 'Fora de linha', u.version);
    expect(off.isActive, isFalse);
    final on = await asAna.products.reactivate(off.id, off.version);
    expect(on.isActive, isTrue);
    expect(await outboxCount('product.updated', p.id), 3);
  });

  test('produto do ERP: só as extensões locais mudam', () async {
    final id = const Uuid().v7obj();
    await db.execute(
      pg.Sql.named(
        'INSERT INTO app.products (id, tenant_id, code, name, source, external_system, external_id) '
        "VALUES (@id::uuid, @t::uuid, @code, 'Do ERP', 'erp', 'senior', @code)",
      ),
      parameters: {'id': id.uuid, 't': ana.tenant.uuid, 'code': 'ERP-$run'},
    );
    final p = await asAna.products.get(id);
    expect(p.source, RecordSource.erp);
    await expectLater(
      asAna.products.update(id, ProductPatch(name: 'Outro nome'), p.version),
      apiError('MASTER_FIELD_READ_ONLY', path: 'name'),
    );
    await expectLater(asAna.products.deactivate(id, 'x', p.version), apiError('MASTER_FIELD_READ_ONLY'));
    final local = await asAna.products.update(
      id,
      ProductPatch(labelPositionInstructions: 'Atrás, embaixo', defaultWarrantyMonths: 24),
      p.version,
    );
    expect(local.labelPositionInstructions, 'Atrás, embaixo');
  });

  test('serviços: cadastro, filtro por tipo e atualização', () async {
    final s = await asAna.services.create(
      CatalogServiceInput(
        code: 'HT-$run',
        name: 'Hora técnica $run',
        serviceKind: ServiceKind.labour,
        defaultPrice: 18000,
        estimatedMinutes: 60,
      ),
    );
    expect(s.unitCode, 'H');
    expect(await outboxCount('service.created', s.id), 1);
    final labour = await asAna.services.list(CatalogServiceFilter(serviceKind: ServiceKind.labour, q: run), null);
    expect(labour.items.map((x) => x.id), [s.id]);
    final travel = await asAna.services.list(CatalogServiceFilter(serviceKind: ServiceKind.travel, q: run), null);
    expect(travel.items, isEmpty);
    final u = await asAna.services.update(
      s.id,
      CatalogServicePatch(defaultPrice: 19500, clear: [CatalogServiceField.estimatedMinutes]),
      s.version,
    );
    expect(u.defaultPrice, 19500);
    expect(u.estimatedMinutes, isNull);
    await expectLater(
      asAna.services.create(CatalogServiceInput(code: 'HT2-$run', name: 'X', unitCode: 'hora técnica')),
      apiError('VALIDATION_FAILED', path: 'unitCode'),
    );
  });

  test('permissões e isolamento', () async {
    final p = await asAna.products.create(ProductInput(code: 'ISO-$run', name: 'Isolado'));
    // Despacho e gestor leem, mas não escrevem (catalog.manage é do administrador).
    expect((await asBruno.products.get(p.id)).id, p.id);
    expect((await asDavi.products.get(p.id)).id, p.id);
    await expectLater(asBruno.products.create(ProductInput(code: 'B-$run', name: 'X')), apiError('FORBIDDEN'));
    await expectLater(asBruno.services.create(CatalogServiceInput(code: 'B-$run', name: 'X')), apiError('FORBIDDEN'));
    await expectLater(
      asBruno.productFamilies.create(ProductFamilyInput(code: 'B-$run', name: 'X')),
      apiError('FORBIDDEN'),
    );
    // Outro tenant: não existe.
    await expectLater(asCarla.products.get(p.id), apiError('NOT_FOUND'));
    await expectLater(asCarla.products.update(p.id, ProductPatch(name: 'X'), p.version), apiError('NOT_FOUND'));
    final mine = await asCarla.products.list(ProductFilter(q: 'ISO-$run'), null);
    expect(mine.items, isEmpty);
  });

  test('importação: produtos com família pelo código e serviços', () async {
    expect(
      await asAna.imports.available(),
      containsAll([ImportEntityType.products, ImportEntityType.services, ImportEntityType.customers]),
    );
    expect(await asBruno.imports.available(), isEmpty, reason: 'despacho não tem imports.run');

    final fam = await asAna.productFamilies.create(ProductFamilyInput(code: 'IMPF-$run', name: 'Família importada'));
    final file =
        'Código;Nome;Família (código);Tipo;GTIN;Preço de referência (R\$);Garantia (meses)\n'
        'IP-$run-1;Freezer 400 L;${fam.code};equipamento;7891000315507;3.990,00;12\n'
        'IP-$run-2;Compressor 1/3 HP;;peça;;289,90;\n'
        'IP-$run-3;Sem família;NAO-EXISTE;;;;\n'
        'IP-$run-4;Tipo errado;;cadeira;;;\n'
        'IP-$run-5;Preço errado;;;;12,345;\n';
    final pv = await asAna.imports.preview(ImportEntityType.products, 'produtos.csv', csv(file));
    expect(pv.unknownColumns, isEmpty);
    expect(pv.run.stats.toCreate, 2);
    expect(pv.errors.map((e) => e.rowNumber), [4, 5, 6]);
    expect(pv.errors[0].messages.single, contains('não encontrada'));
    expect(pv.errors[1].messages.single, contains('Tipo'));
    expect(pv.errors[2].messages.single, contains('Preço'));
    final done = await asAna.imports.confirm(pv.run.id, pv.run.version);
    expect(done.stats.created, 2);

    final created = await asAna.products.list(ProductFilter(q: 'IP-$run'), PageRequest(sort: 'code'));
    expect(created.items.map((p) => p.code), ['IP-$run-1', 'IP-$run-2']);
    final freezer = created.items.first;
    expect(freezer.productFamilyId, fam.id);
    expect(freezer.referencePrice, 399000);
    expect(freezer.tracksAssets, isTrue);
    final part = created.items.last;
    expect(part.productKind, ProductKind.spare_part);
    expect(part.tracksAssets, isFalse);
    expect(part.referencePrice, 28990);

    // Reenvio: sem mudança; e uma atualização de preço.
    final again = await asAna.imports.preview(
      ImportEntityType.products,
      'p.csv',
      csv('codigo;nome;preco_referencia\nIP-$run-1;Freezer 400 L;3.990,00\nIP-$run-2;;300\n'),
    );
    expect(again.run.stats.unchanged, 1);
    expect(again.run.stats.toUpdate, 1);
    await asAna.imports.confirm(again.run.id, again.run.version);
    expect((await asAna.products.get(part.id)).referencePrice, 30000);

    final sv = await asAna.imports.preview(
      ImportEntityType.services,
      'servicos.csv',
      csv(
        'codigo;nome;tipo;unidade;preco;minutos_estimados\n'
        'IS-$run-1;Visita técnica;visita;VIS;150,00;\n'
        'IS-$run-2;Deslocamento;deslocamento;KM;2,50;\n'
        'IS-$run-3;Tempo errado;;;;0\n',
      ),
    );
    expect(sv.run.stats.toCreate, 2);
    expect(sv.errors.single.rowNumber, 4);
    await asAna.imports.confirm(sv.run.id, sv.run.version);
    final services = await asAna.services.list(CatalogServiceFilter(q: 'IS-$run'), PageRequest(sort: 'code'));
    expect(services.items.map((s) => (s.serviceKind, s.unitCode, s.defaultPrice)), [
      (ServiceKind.visit, 'VIS', 15000),
      (ServiceKind.travel, 'KM', 250),
    ]);
  });
}
