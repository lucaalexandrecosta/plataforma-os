// Movimentação de bens entre estoque e clientes: instalar, transferir,
// retirar, histórico, OS herdando o cliente e isolamento entre empresas.
//
// Pré-requisitos: os do tenant_isolation_e2e_test.dart.
@Tags(['e2e'])
library;

import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:test/test.dart';

import 'support/e2e_login.dart';

void main() {
  late Client ana; // tenant_admin frio-sul
  late Client davi; // manager frio-sul (só leitura)
  late Client carla; // tenant_admin forno-norte
  late ProductSummary product;
  late Customer paoQuente;
  late CustomerSite lojaCentro;
  var serial = 0;

  setUpAll(() async {
    ana = await tenantClient('ana.admin@frio-sul.test', 'frio-sul');
    davi = await tenantClient('davi.consultor@dev.test', 'frio-sul');
    carla = await tenantClient('carla.admin@forno-norte.test', 'forno-norte');
    product = (await ana.products.list(search: 'FRZ-500')).single;
    paoQuente = (await ana.customers.list(search: 'Pão Quente')).items.single;
    lojaCentro = (await ana.customers.sites(paoQuente.id)).firstWhere((s) => s.name == 'Loja Centro');
  });

  Future<Asset> newAsset() => ana.assets.create(
    AssetInput(
      productId: product.id,
      serialNumber: 'MOV-${DateTime.now().microsecondsSinceEpoch}-${serial++}',
      isActive: true,
    ),
  );

  test('instala, transfere e retira; histórico e status acompanham', () async {
    final asset = await newAsset();
    expect(asset.status, 'in_stock');
    expect(asset.customerId, isNull);

    final installed = await ana.assets.install(
      asset.id,
      asset.version,
      AssetInstallInput(
        customerSiteId: lojaCentro.id,
        sourceDocumentType: 'shipment_invoice',
        sourceDocumentNumber: 'NF 1234',
      ),
    );
    expect(installed.status, 'installed');
    expect(installed.customerName, 'Pão Quente');
    expect(installed.customerSiteName, 'Loja Centro');
    expect(installed.version, greaterThan(asset.version));

    // Mesma unidade de novo: recusa.
    await expectLater(
      ana.assets.install(installed.id, installed.version, AssetInstallInput(customerSiteId: lojaCentro.id)),
      throwsA(isA<ApiException>().having((e) => e.code, 'code', 'ALREADY_AT_SITE')),
    );

    final other = await ana.customers.createSite(
      paoQuente.id,
      CustomerSiteInput(name: 'Filial Praia ${serial++}', isActive: true),
    );
    final moved = await ana.assets.install(
      installed.id,
      installed.version,
      AssetInstallInput(customerSiteId: other.id),
    );
    expect(moved.customerSiteId, other.id);

    final history = await ana.assets.assignments(asset.id);
    expect(history.map((h) => h.customerSiteId), [other.id, lojaCentro.id]);
    expect(history.first.startReason, 'transfer');
    expect(history.last.endReason, 'transfer');
    expect(history.last.sourceDocumentNumber, 'NF 1234');
    expect(history.last.ownershipType, 'tenant_loan');

    final back = await ana.assets.withdraw(
      moved.id,
      moved.version,
      AssetWithdrawInput(reason: 'return_to_stock', notes: 'Cliente encerrou o contrato'),
    );
    expect(back.status, 'in_stock');
    expect(back.customerId, isNull);
    final closed = (await ana.assets.assignments(asset.id)).first;
    expect(closed.endReason, 'return_to_stock');
    expect(closed.notes, 'Cliente encerrou o contrato');

    await expectLater(
      ana.assets.withdraw(back.id, back.version, AssetWithdrawInput(reason: 'withdrawal')),
      throwsA(isA<ApiException>().having((e) => e.code, 'code', 'NOT_INSTALLED')),
    );
  });

  test('lista por cliente e OS aberta no bem herda cliente e unidade', () async {
    final asset = await newAsset();
    final installed = await ana.assets.install(
      asset.id,
      asset.version,
      AssetInstallInput(customerSiteId: lojaCentro.id),
    );
    final atCustomer = await ana.assets.list(customerId: paoQuente.id, limit: 200);
    expect(atCustomer.items.map((a) => a.id), contains(installed.id));

    final type = (await ana.workOrders.types()).first;
    final wo = await ana.workOrders.open(
      WorkOrderInput(workOrderTypeId: type.id, assetId: installed.id, problemDescription: 'Não gela'),
    );
    expect(wo.workOrder.customerId, paoQuente.id);
    expect(wo.workOrder.customerName, 'Pão Quente');
  });

  test('validações: versão, data futura, motivo e unidade de outra empresa', () async {
    final asset = await newAsset();
    await expectLater(
      ana.assets.install(asset.id, asset.version + 5, AssetInstallInput(customerSiteId: lojaCentro.id)),
      throwsA(isA<ApiException>().having((e) => e.code, 'code', 'VERSION_MISMATCH')),
    );
    await expectLater(
      ana.assets.install(
        asset.id,
        asset.version,
        AssetInstallInput(customerSiteId: lojaCentro.id, startedAt: DateTime.now().add(const Duration(days: 2))),
      ),
      throwsA(isA<ApiException>().having((e) => e.fieldErrors!.single.path, 'path', 'startedAt')),
    );
    await expectLater(
      ana.assets.withdraw(asset.id, asset.version, AssetWithdrawInput(reason: 'sumiu')),
      throwsA(isA<ApiException>().having((e) => e.fieldErrors!.single.path, 'path', 'reason')),
    );
    // Unidade da Frio Sul não existe para a Forno Norte, nem o bem.
    final fornoAsset = (await carla.assets.list()).items.first;
    await expectLater(
      carla.assets.install(fornoAsset.id, fornoAsset.version, AssetInstallInput(customerSiteId: lojaCentro.id)),
      throwsA(isA<ApiException>().having((e) => e.fieldErrors!.single.path, 'path', 'customerSiteId')),
    );
    await expectLater(
      carla.assets.assignments(asset.id),
      throwsA(isA<ApiException>().having((e) => e.code, 'code', 'NOT_FOUND')),
    );
    await expectLater(
      davi.assets.install(asset.id, asset.version, AssetInstallInput(customerSiteId: lojaCentro.id)),
      throwsA(isA<ApiException>().having((e) => e.code, 'code', 'FORBIDDEN')),
    );
  });
}
