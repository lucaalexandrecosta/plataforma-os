// Cadastros base de ponta a ponta: filiais, centros de custo, modelos de
// equipamento e bens, com permissões, validação, concorrência otimista e
// isolamento entre empresas.
//
// Pré-requisitos: os do tenant_isolation_e2e_test.dart.
@Tags(['e2e'])
library;

import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:test/test.dart';

import 'support/e2e_login.dart';

void main() {
  late Client ana; // tenant_admin frio-sul
  late Client davi; // manager frio-sul (só leitura de OS)
  late Client carla; // tenant_admin forno-norte

  setUpAll(() async {
    ana = await tenantClient('ana.admin@frio-sul.test', 'frio-sul');
    davi = await tenantClient('davi.consultor@dev.test', 'frio-sul');
    carla = await tenantClient('carla.admin@forno-norte.test', 'forno-norte');
  });

  BranchInput branchInput(Branch b, {String? tradeName, bool? isDefault}) => BranchInput(
    code: b.code,
    legalName: b.legalName,
    tradeName: tradeName ?? b.tradeName,
    documentNumber: b.documentNumber,
    city: b.city,
    state: b.state,
    erpBranchCode: b.erpBranchCode,
    isDefault: isDefault ?? b.isDefault,
    isActive: b.isActive,
  );

  group('filiais', () {
    test('lista, cria e troca a filial padrão', () async {
      final initial = await ana.branches.list();
      expect(initial.map((b) => b.code), ['MATRIZ']);
      expect(initial.single.isDefault, isTrue);

      final created = await ana.branches.create(
        BranchInput(
          code: 'CXS',
          legalName: 'Frio Sul Refrigeração Ltda - Caxias',
          documentNumber: '11.222.333/0002-62',
          city: 'Caxias do Sul',
          state: 'rs',
          isDefault: false,
          isActive: true,
        ),
      );
      expect(created.documentNumber, '11222333000262');
      expect(created.state, 'RS');

      // Marcar a nova como padrão desmarca a anterior.
      final promoted = await ana.branches.update(created.id, created.version, branchInput(created, isDefault: true));
      expect(promoted.isDefault, isTrue);
      final matriz = (await ana.branches.list()).singleWhere((b) => b.code == 'MATRIZ');
      expect(matriz.isDefault, isFalse);
      await expectLater(
        ana.branches.update(promoted.id, promoted.version, branchInput(promoted, isDefault: false)),
        throwsApiError('DEFAULT_BRANCH_REQUIRED'),
      );
      await ana.branches.update(matriz.id, matriz.version, branchInput(matriz, isDefault: true));
    });

    test('validação, código repetido e versão desatualizada', () async {
      await expectLater(
        ana.branches.create(
          BranchInput(code: '', legalName: 'X', documentNumber: '123', isDefault: false, isActive: true),
        ),
        throwsApiError('VALIDATION_FAILED'),
      );
      await expectLater(
        ana.branches.create(BranchInput(code: 'MATRIZ', legalName: 'Outra', isDefault: false, isActive: true)),
        throwsApiError('VALIDATION_FAILED'),
      );
      final matriz = (await ana.branches.list()).singleWhere((b) => b.code == 'MATRIZ');
      final updated = await ana.branches.update(
        matriz.id,
        matriz.version,
        branchInput(matriz, tradeName: 'Frio Sul Matriz'),
      );
      expect(updated.version, matriz.version + 1);
      await expectLater(
        ana.branches.update(matriz.id, matriz.version, branchInput(matriz, tradeName: 'Velha')),
        throwsA(isA<ApiException>().having((e) => e.currentVersion, 'currentVersion', updated.version)),
      );
    });

    test('gestor lê mas não altera; outra empresa não enxerga', () async {
      expect(await davi.branches.list(), isNotEmpty);
      await expectLater(
        davi.branches.create(BranchInput(code: 'X', legalName: 'X', isDefault: false, isActive: true)),
        throwsApiError('FORBIDDEN'),
      );
      final frioSul = (await ana.branches.list()).first;
      expect((await carla.branches.list()).map((b) => b.id), isNot(contains(frioSul.id)));
      await expectLater(
        carla.branches.update(frioSul.id, frioSul.version, branchInput(frioSul)),
        throwsApiError('NOT_FOUND'),
      );
    });
  });

  group('centros de custo', () {
    test('cria, filtra pela filial e recusa filial de outra empresa', () async {
      final branches = await ana.branches.list();
      final matriz = branches.singleWhere((b) => b.code == 'MATRIZ');
      final cxs = branches.singleWhere((b) => b.code == 'CXS');
      final manut = await ana.costCenters.create(
        CostCenterInput(code: '1.02', name: 'Manutenção Caxias', branchId: cxs.id, isActive: true),
      );
      expect(manut.branchId, cxs.id);

      final ofMatriz = [for (final c in await ana.costCenters.list(branchId: matriz.id)) c.code];
      expect(ofMatriz, containsAll(['1.01', '2.01']));
      expect(ofMatriz, isNot(contains('1.02')));

      await expectLater(
        ana.costCenters.create(CostCenterInput(code: '1.01', name: 'Repetido', isActive: true)),
        throwsApiError('VALIDATION_FAILED'),
      );
      final carlaBranch = (await carla.branches.list()).first;
      await expectLater(
        ana.costCenters.create(CostCenterInput(code: '9.99', name: 'X', branchId: carlaBranch.id, isActive: true)),
        throwsApiError('VALIDATION_FAILED'),
      );
      expect(await carla.costCenters.list(), isEmpty);
    });
  });

  group('bens', () {
    test('cadastra um bem interno com filial, centro de custo e aquisição', () async {
      final product = await ana.products.create(ProductInput(code: 'CMP-01', name: 'Compressor de ar 50 L'));
      expect([for (final p in await ana.products.list(search: 'compressor')) p.id], [product.id]);

      final matriz = (await ana.branches.list()).singleWhere((b) => b.code == 'MATRIZ');
      final producao = (await ana.costCenters.list()).singleWhere((c) => c.code == '1.01');
      final asset = await ana.assets.create(
        AssetInput(
          productId: product.id,
          assetTag: 'PAT-000123',
          serialNumber: 'SN-777',
          branchId: matriz.id,
          costCenterId: producao.id,
          acquisitionDate: DateTime.utc(2025, 3, 10),
          acquisitionCost: 1250000,
          supplierName: 'Compressores Sul',
          acquisitionDocument: 'NF 4521',
          isActive: true,
        ),
      );
      expect(asset.productName, 'Compressor de ar 50 L');
      expect(asset.status, 'in_stock');
      expect(asset.source, 'local');
      expect(asset.acquisitionCost, 1250000);
      expect(asset.acquisitionDate, DateTime.utc(2025, 3, 10));

      final page = await ana.assets.list(costCenterId: producao.id);
      expect(page.items.map((a) => a.assetTag), contains('PAT-000123'));
      expect((await davi.assets.get(asset.id)).assetTag, 'PAT-000123');

      final moved = await ana.assets.update(
        asset.id,
        asset.version,
        AssetInput(
          productId: product.id,
          assetTag: 'PAT-000123',
          serialNumber: 'SN-777',
          branchId: matriz.id,
          costCenterId: producao.id,
          locationNote: 'Galpão 2',
          acquisitionDate: asset.acquisitionDate,
          acquisitionCost: asset.acquisitionCost,
          isActive: true,
        ),
      );
      expect(moved.locationNote, 'Galpão 2');
      expect(moved.version, asset.version + 1);
    });

    test('validação: patrimônio repetido, sem identificação e centro de custo de outra filial', () async {
      final product = (await ana.products.list(search: 'CMP-01')).single;
      await expectLater(
        ana.assets.create(AssetInput(productId: product.id, assetTag: 'PAT-000123', isActive: true)),
        throwsApiError('VALIDATION_FAILED'),
      );
      await expectLater(
        ana.assets.create(AssetInput(productId: product.id, isActive: true)),
        throwsApiError('VALIDATION_FAILED'),
      );
      final matriz = (await ana.branches.list()).singleWhere((b) => b.code == 'MATRIZ');
      final caxiasCc = (await ana.costCenters.list()).singleWhere((c) => c.code == '1.02');
      await expectLater(
        ana.assets.create(
          AssetInput(
            productId: product.id,
            assetTag: 'PAT-9',
            branchId: matriz.id,
            costCenterId: caxiasCc.id,
            isActive: true,
          ),
        ),
        throwsApiError('VALIDATION_FAILED'),
      );
    });

    test('gestor não altera; outra empresa não vê nem altera', () async {
      final asset = (await ana.assets.list(search: 'PAT-000123')).items.single;
      await expectLater(
        davi.assets.create(AssetInput(productId: asset.productId, assetTag: 'PAT-X', isActive: true)),
        throwsApiError('FORBIDDEN'),
      );
      await expectLater(carla.assets.get(asset.id), throwsApiError('NOT_FOUND'));
      expect((await carla.assets.list(search: 'PAT-000123')).total, 0);
      await expectLater(
        carla.assets.create(AssetInput(productId: asset.productId, assetTag: 'PAT-Y', isActive: true)),
        throwsApiError('VALIDATION_FAILED'),
      );
    });
  });
}
