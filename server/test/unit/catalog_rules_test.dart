import 'package:plataforma_os_server/src/catalog/internal/catalog_rules.dart';
import 'package:plataforma_os_server/src/generated/protocol.dart';
import 'package:test/test.dart';

List<String> _paths(List<FieldError> errors) => errors.map((e) => e.path).toList();

void main() {
  group('produtos', () {
    test('padrões: equipamento gera ativo com série; unidade UN; normaliza GTIN e unidade', () {
      final v = ProductRules.validate(
        ProductDraft.fromInput(ProductInput(code: ' FRZ-500 ', name: 'Freezer', gtin: '789-1000-31550-7')),
      );
      expect(v.errors, isEmpty);
      final d = v.draft!;
      expect(d.code, 'FRZ-500');
      expect(d.productKind, ProductKind.equipment);
      expect((d.tracksAssets, d.isSerialized), (true, true));
      expect(d.unitCode, 'UN');
      expect(d.gtin, '7891000315507');

      final part = ProductDraft.fromInput(
        ProductInput(code: 'P1', name: 'Compressor', productKind: ProductKind.spare_part, unitCode: 'pc'),
      );
      expect((part.tracksAssets, part.isSerialized), (false, false));
      expect(ProductRules.validate(part).draft!.unitCode, 'PC');
    });

    test('erros por campo', () {
      final v = ProductRules.validate(
        ProductDraft.fromInput(
          ProductInput(
            code: 'com espaço',
            name: ' ',
            gtin: '7891000315508',
            unitCode: 'UNIDADES',
            defaultWarrantyMonths: 300,
            referencePrice: -1,
          ),
        ),
      );
      expect(
        _paths(v.errors),
        containsAll(['code', 'name', 'gtin', 'unitCode', 'defaultWarrantyMonths', 'referencePrice']),
      );
    });

    test('consumível não gera ativo; série exige ativo', () {
      final consumable = ProductRules.validate(
        ProductDraft.fromInput(
          ProductInput(code: 'C1', name: 'Gás', productKind: ProductKind.consumable, tracksAssets: true),
        ),
      );
      expect(_paths(consumable.errors), contains('tracksAssets'));
      final serial = ProductRules.validate(
        ProductDraft.fromInput(ProductInput(code: 'C2', name: 'X', tracksAssets: false, isSerialized: true)),
      );
      expect(_paths(serial.errors), ['isSerialized']);
    });

    test('patch: nulo não mexe; clear apaga', () {
      final base = ProductDraft.fromInput(
        ProductInput(code: 'A', name: 'A', gtin: '7891000315507', referencePrice: 100, description: 'd'),
      );
      final after = base.apply(ProductPatch(name: 'B', clear: [ProductField.gtin, ProductField.referencePrice]));
      expect(after.name, 'B');
      expect(after.description, 'd');
      expect(after.gtin, isNull);
      expect(after.referencePrice, isNull);
    });
  });

  group('serviços', () {
    test('padrões e validação', () {
      final ok = ServiceRules.validate(ServiceDraft.fromInput(CatalogServiceInput(code: 'HT', name: 'Hora técnica')));
      expect(ok.draft!.unitCode, 'H');
      expect(ok.draft!.serviceKind, ServiceKind.other);
      final bad = ServiceRules.validate(
        ServiceDraft.fromInput(
          CatalogServiceInput(code: '', name: 'X', estimatedMinutes: 0, defaultPrice: maxPriceCents + 1),
        ),
      );
      expect(_paths(bad.errors), containsAll(['code', 'estimatedMinutes', 'defaultPrice']));
    });
  });

  test('família: código e nome obrigatórios', () {
    expect(_paths(FamilyRules.validate(const FamilyDraft(code: '', name: '')).errors), ['code', 'name']);
  });
}
