// Ficha patrimonial e depreciação gerencial de ponta a ponta: ficha do bem,
// memória de cálculo do motor, posição mensal com totais por centro de custo,
// fechamento em ordem (fotografia que não muda com a ficha), reabertura,
// permissões e isolamento.
//
// Pré-requisitos: os do tenant_isolation_e2e_test.dart.
@Tags(['e2e'])
library;

import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:test/test.dart';

import 'support/e2e_login.dart';

void main() {
  late Client ana; // tenant_admin frio-sul (ler, manter e fechar)
  late Client bruno; // dispatcher frio-sul (sem depreciação)
  late Client davi; // manager frio-sul (só leitura)
  late Client carla; // tenant_admin forno-norte
  late Asset asset;
  late Asset noCost;
  late CostCenter producao;
  late DepreciationProfile profile;

  DepreciationProfileInput straightLine({String rate = '20', String? notes}) => DepreciationProfileInput(
    method: 'straight_line',
    annualRate: rate,
    startDate: DateTime.utc(2026, 1, 10),
    residualValue: 200000,
    notes: notes,
  );

  setUpAll(() async {
    ana = await tenantClient('ana.admin@frio-sul.test', 'frio-sul');
    bruno = await tenantClient('bruno.despacho@frio-sul.test', 'frio-sul');
    davi = await tenantClient('davi.consultor@dev.test', 'frio-sul');
    carla = await tenantClient('carla.admin@forno-norte.test', 'forno-norte');
    final matriz = (await ana.branches.list()).singleWhere((b) => b.code == 'MATRIZ');
    producao = (await ana.costCenters.list()).singleWhere((c) => c.code == '1.01');
    final product = (await ana.products.list()).first;
    final stamp = DateTime.now().microsecondsSinceEpoch;
    asset = await ana.assets.create(
      AssetInput(
        productId: product.id,
        assetTag: 'PAT-DEP-$stamp',
        branchId: matriz.id,
        costCenterId: producao.id,
        acquisitionCost: 1200000,
        isActive: true,
      ),
    );
    noCost = await ana.assets.create(AssetInput(productId: product.id, assetTag: 'PAT-DEP2-$stamp', isActive: true));
  });

  test('ficha: permissões, validações e criação com a base do bem', () async {
    expect(await davi.depreciation.profile(asset.id), isNull);
    await expectLater(bruno.depreciation.profile(asset.id), throwsApiError('FORBIDDEN'));
    await expectLater(davi.depreciation.saveProfile(asset.id, null, straightLine()), throwsApiError('FORBIDDEN'));
    await expectLater(
      ana.depreciation.saveProfile(asset.id, null, straightLine(rate: '0')),
      throwsApiError('VALIDATION_FAILED'),
    );
    await expectLater(
      ana.depreciation.saveProfile(asset.id, null, straightLine(rate: '10,12345')),
      throwsApiError('VALIDATION_FAILED'),
    );
    await expectLater(
      ana.depreciation.saveProfile(asset.id, null, straightLine()..residualValue = 1300000),
      throwsApiError('VALIDATION_FAILED'),
    );
    await expectLater(
      ana.depreciation.saveProfile(noCost.id, null, straightLine()),
      throwsApiError('VALIDATION_FAILED'),
    );

    profile = await ana.depreciation.saveProfile(asset.id, null, straightLine());
    expect(profile.annualRate, '20');
    expect(profile.startRule, 'pro_rata_days');
    expect(profile.depreciableCost, isNull);
    expect(profile.effectiveCost, 1200000);
    await expectLater(ana.depreciation.saveProfile(asset.id, null, straightLine()), throwsApiError('PROFILE_EXISTS'));

    final updated = await ana.depreciation.saveProfile(asset.id, profile.version, straightLine(notes: 'Linha 2'));
    expect(updated.notes, 'Linha 2');
    await expectLater(
      ana.depreciation.saveProfile(asset.id, profile.version, straightLine()),
      throwsApiError('VERSION_MISMATCH'),
    );
    profile = updated;
  });

  test('memória de cálculo: pró-rata no primeiro mês e residual no fim', () async {
    final schedule = await davi.depreciation.schedule(asset.id);
    expect(schedule.cost, 1200000);
    final lines = schedule.lines;
    expect((lines.first.year, lines.first.month, lines.first.amount), (2026, 1, 11828));
    expect((lines[1].amount, lines[1].accumulated, lines[1].netBookValue), (16667, 28495, 1171505));
    expect(lines.last.accumulated, 1000000);
    expect(lines.last.netBookValue, 200000);
    expect(lines.fold<int>(0, (s, l) => s + l.amount), 1000000);
  });

  test('unidades produzidas: capacidade e produção com casas decimais', () async {
    final units = await ana.depreciation.saveProfile(
      noCost.id,
      null,
      DepreciationProfileInput(
        method: 'units_of_production',
        annualRate: '0',
        startDate: DateTime.utc(2026, 1, 1),
        depreciableCost: 100000,
        totalCapacity: '100,5',
        monthlyProduction: '10,05',
      ),
    );
    expect(units.totalCapacity, '100.5');
    final lines = (await ana.depreciation.schedule(noCost.id)).lines;
    expect(lines.first.amount, 10000);
    expect(lines, hasLength(10));
  });

  test('posição: bem, centro de custo e filial; antes do início o bem não aparece', () async {
    final feb = await davi.depreciation.position(2026, 2);
    expect(feb.closed, isFalse);
    final item = feb.items.singleWhere((i) => i.assetId == asset.id);
    expect((item.monthlyAmount, item.accumulated, item.netBookValue), (16667, 28495, 1171505));
    expect(item.costCenterId, producao.id);
    final cc = feb.byCostCenter.singleWhere((g) => g.id == producao.id);
    expect(cc.assetCount, greaterThanOrEqualTo(1));
    expect(feb.total.monthlyAmount, feb.items.fold<int>(0, (s, i) => s + i.monthlyAmount));
    final onlyCc = await davi.depreciation.position(2026, 2, costCenterId: producao.id);
    expect(onlyCc.items.every((i) => i.costCenterId == producao.id), isTrue);
    expect((await davi.depreciation.position(2025, 12)).items.map((i) => i.assetId), isNot(contains(asset.id)));
    await expectLater(davi.depreciation.position(2026, 13), throwsApiError('VALIDATION_FAILED'));
  });

  test('fechamento em ordem guarda a fotografia; reabrir só a última', () async {
    await expectLater(davi.depreciation.close(2026, 1), throwsApiError('FORBIDDEN'));
    await expectLater(ana.depreciation.close(2100, 1), throwsApiError('PERIOD_IN_FUTURE'));
    final jan = await ana.depreciation.close(2026, 1);
    expect(jan.status, 'closed');
    expect(jan.closedByName, 'Ana Admin');
    await expectLater(ana.depreciation.close(2026, 1), throwsApiError('ALREADY_CLOSED'));
    await expectLater(ana.depreciation.close(2026, 3), throwsApiError('PERIOD_OUT_OF_ORDER'));
    await ana.depreciation.close(2026, 2);

    // Mudar a taxa não mexe no que já foi fechado.
    profile = await ana.depreciation.saveProfile(asset.id, profile.version, straightLine(rate: '50'));
    final closedJan = await davi.depreciation.position(2026, 1);
    expect(closedJan.closed, isTrue);
    expect(closedJan.items.singleWhere((i) => i.assetId == asset.id).monthlyAmount, 11828);
    final liveMar = await davi.depreciation.position(2026, 3);
    expect(liveMar.items.singleWhere((i) => i.assetId == asset.id).monthlyAmount, 41667);

    await expectLater(ana.depreciation.reopen(2026, 1, 'Taxa'), throwsApiError('NOT_LATEST_CLOSING'));
    await expectLater(ana.depreciation.reopen(2026, 2, ' '), throwsApiError('VALIDATION_FAILED'));
    final reopened = await ana.depreciation.reopen(2026, 2, 'Taxa revisada');
    expect(reopened.status, 'reopened');
    expect((await davi.depreciation.position(2026, 2)).closed, isFalse);
    await expectLater(ana.depreciation.reopen(2026, 2, 'de novo'), throwsApiError('NOT_CLOSED'));
    final again = await ana.depreciation.close(2026, 2);
    expect(again.status, 'closed');
    final history = await davi.depreciation.closings();
    expect(
      history.where((c) => c.year == 2026 && c.month == 2).map((c) => c.status),
      containsAll(['closed', 'reopened']),
    );
  });

  test('isolamento: outra empresa não vê a ficha nem a posição do bem', () async {
    await expectLater(carla.depreciation.profile(asset.id), throwsApiError('NOT_FOUND'));
    await expectLater(carla.depreciation.schedule(asset.id), throwsApiError('NOT_FOUND'));
    expect((await carla.depreciation.position(2026, 2)).items.map((i) => i.assetId), isNot(contains(asset.id)));
    expect((await carla.depreciation.closings()).where((c) => c.year == 2026 && c.month == 1), isEmpty);
  });
}
