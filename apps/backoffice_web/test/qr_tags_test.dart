import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plataforma_os_backoffice/src/api/gateway.dart';
import 'package:plataforma_os_backoffice/src/app.dart';
import 'package:plataforma_os_backoffice/src/session/session.dart';
import 'package:plataforma_os_backoffice/src/ui/common/save_file.dart';
import 'package:plataforma_os_backoffice/src/ui/qr_tags/label_sheet.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import 'app_test.dart' show login;
import 'fake_gateway.dart';

final saved = <(String, String, Uint8List)>[];

Future<void> pump(WidgetTester tester, FakeGateway gateway) async {
  saved.clear();
  tester.view.physicalSize = const Size(1400, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        gatewayProvider.overrideWithValue(gateway),
        saveFileProvider.overrideWithValue((name, type, bytes) async => saved.add((name, type, bytes))),
      ],
      child: const BackofficeApp(),
    ),
  );
  await tester.pumpAndSettle();
  await login(tester);
}

Future<void> tapKey(WidgetTester tester, String key) async {
  await tester.tap(find.byKey(Key(key)));
  await tester.pumpAndSettle();
}

Future<void> openAsset(WidgetTester tester) async {
  await tester.tap(find.text('Bens'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('PAT-001'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('gerar lote, baixar o PDF e o lote fica impresso', (tester) async {
    final gateway = FakeGateway();
    await pump(tester, gateway);
    await tester.tap(find.text('Etiquetas QR'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Nenhum lote ainda'), findsOneWidget);

    await tapKey(tester, 'qr-generate');
    await tester.enterText(find.byKey(const Key('qr-quantity')), '600');
    await tapKey(tester, 'qr-generate-ok');
    expect(find.text('Informe de 1 a 500.'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('qr-quantity')), '3');
    await tapKey(tester, 'qr-generate-ok');

    expect(find.text('Lote LOTE-0001'), findsOneWidget);
    expect(find.text('3 etiquetas, ainda não impressas.'), findsOneWidget);
    await tester.runAsync(() async {
      await tester.tap(find.byKey(const Key('qr-print')));
      for (var i = 0; i < 100 && gateway.printedBatches == 0; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
      await Future<void>.delayed(const Duration(milliseconds: 20));
      await tester.pump();
      await Future<void>.delayed(const Duration(milliseconds: 20));
    });
    await tester.pumpAndSettle();
    expect(saved.single.$1, 'etiquetas-LOTE-0001.pdf');
    expect(String.fromCharCodes(saved.single.$3.take(4)), '%PDF');
    expect(gateway.printedBatches, 1);
    expect(find.textContaining('3 etiquetas. Impresso em'), findsOneWidget);
    expect(find.text('Impressa'), findsNWidgets(3));

    await tapKey(tester, 'qr-revoke-Q002-0001');
    await tester.tap(find.byKey(const Key('reason')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Danificada').last);
    await tester.pumpAndSettle();
    await tapKey(tester, 'reason-confirm');
    expect(find.text('Revogada · Danificada'), findsOneWidget);
    expect(find.byKey(const Key('qr-revoke-Q002-0001')), findsNothing);
  });

  testWidgets('vincular etiqueta na ficha do bem, desvincular e revogar', (tester) async {
    final gateway = FakeGateway();
    await gateway.generateQrBatch(2);
    gateway.currentAsset = Asset.fromJson(FakeGateway.asset1.toJson()..remove('qrShortCode'));
    await pump(tester, gateway);
    await openAsset(tester);
    expect(find.byKey(const Key('tag-unbind')), findsNothing);

    await tapKey(tester, 'tag-bind');
    await tester.enterText(find.byKey(const Key('tag-code')), 'q001-0001');
    await tapKey(tester, 'tag-bind-ok');
    expect(find.text('Q001-0001'), findsOneWidget);
    expect(gateway.tagList.first.status, 'bound');

    await tapKey(tester, 'tag-unbind');
    await tapKey(tester, 'confirm-unbind');
    expect(find.text('Q001-0001'), findsNothing);
    expect(gateway.tagList.first.status, 'printed');

    await tapKey(tester, 'tag-bind');
    await tester.enterText(find.byKey(const Key('tag-code')), 'Q002-0001');
    await tapKey(tester, 'tag-bind-ok');
    await tapKey(tester, 'tag-revoke');
    await tester.tap(find.byKey(const Key('reason')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Perdida').last);
    await tester.pumpAndSettle();
    await tapKey(tester, 'reason-confirm');
    expect(gateway.tagList[1].status, 'revoked');
    expect(find.byKey(const Key('tag-bind')), findsOneWidget);
  });

  testWidgets('etiqueta já usada mostra o erro do servidor', (tester) async {
    final gateway = FakeGateway()
      ..failNext['bindQrTag'] = const GatewayException(
        'Esta etiqueta já está em outro bem.',
        code: 'TAG_ALREADY_BOUND',
      );
    gateway.currentAsset = Asset.fromJson(FakeGateway.asset1.toJson()..remove('qrShortCode'));
    await pump(tester, gateway);
    await openAsset(tester);
    await tapKey(tester, 'tag-bind');
    await tester.enterText(find.byKey(const Key('tag-code')), 'X');
    await tapKey(tester, 'tag-bind-ok');
    expect(find.text('Esta etiqueta já está em outro bem.'), findsOneWidget);
  });

  testWidgets('sem qr_tags.manage: sem menu nem botões na ficha', (tester) async {
    final gateway = FakeGateway(permissions: const ['work_orders.read', 'assets.manage']);
    gateway.currentAsset = Asset.fromJson(FakeGateway.asset1.toJson()..remove('qrShortCode'));
    await pump(tester, gateway);
    expect(find.text('Etiquetas QR'), findsNothing);
    await openAsset(tester);
    expect(find.byKey(const Key('tag-bind')), findsNothing);
  });

  test('folha de etiquetas: uma página a cada 24', () async {
    final gateway = FakeGateway();
    final batch = await gateway.generateQrBatch(25);
    final bytes = await buildLabelSheet(batch, gateway.tagList);
    final pdf = String.fromCharCodes(bytes);
    expect(pdf, startsWith('%PDF'));
    expect(RegExp(r'/Type\s*/Page\b').allMatches(pdf).length, 2);
  });
}
