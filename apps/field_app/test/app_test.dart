import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plataforma_os_field/src/api/gateway.dart';
import 'package:plataforma_os_field/src/app.dart';
import 'package:plataforma_os_field/src/device/device.dart';
import 'package:plataforma_os_field/src/session/session.dart';
import 'package:plataforma_os_field/src/ui/visits/agenda_page.dart';

import 'fake_gateway.dart';

/// "Agora" fixo dos testes: terça, 17/11/2026, 08:00 local.
final now = DateTime(2026, 11, 17, 8);

class FakeDevice implements Device {
  String? qr;
  Object? positionError;
  var positions = 0;

  @override
  Future<DevicePosition> position() async {
    positions++;
    if (positionError case final e?) throw e;
    return (latitude: -30.03, longitude: -51.22, accuracyM: 12.0);
  }

  @override
  Future<String?> scanQr(BuildContext context) async => qr;
}

Future<void> pumpApp(WidgetTester tester, FakeGateway gateway, {FakeDevice? device}) async {
  tester.view.physicalSize = const Size(420, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        gatewayProvider.overrideWithValue(gateway),
        deviceProvider.overrideWithValue(device ?? FakeDevice()),
        clockProvider.overrideWithValue(() => now),
      ],
      child: const FieldApp(),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> login(WidgetTester tester, {String password = 'certa123'}) async {
  await tester.enterText(find.byKey(const Key('email')), 'eduardo@frio-sul.test');
  await tester.enterText(find.byKey(const Key('password')), password);
  await tester.tap(find.byKey(const Key('submit')));
  await tester.pumpAndSettle();
}

void main() {
  group('login', () {
    testWidgets('senha errada mostra a mensagem e fica no login', (tester) async {
      await pumpApp(tester, FakeGateway());
      await login(tester, password: 'errada');
      expect(find.text('E-mail ou senha incorretos.'), findsOneWidget);
      expect(find.text('Minha agenda'), findsNothing);
    });

    testWidgets('com uma empresa só, entra direto na agenda', (tester) async {
      final gateway = FakeGateway()..addVisit(1, DateTime(2026, 11, 17, 9));
      await pumpApp(tester, gateway);
      await login(tester);
      expect(gateway.enteredSlug, 'frio-sul');
      expect(find.text('Minha agenda'), findsOneWidget);
      expect(find.text('Frio Sul'), findsOneWidget);
      expect(find.text('OS 2026-000001'), findsOneWidget);
    });

    testWidgets('acesso sem papel de técnico explica e fica no login', (tester) async {
      final gateway = FakeGateway()
        ..failNext['enterTenant'] = const GatewayException('Sem permissão.', code: 'FORBIDDEN');
      await pumpApp(tester, gateway);
      await login(tester);
      expect(find.textContaining('não é de técnico'), findsOneWidget);
      expect(find.text('Minha agenda'), findsNothing);
    });

    testWidgets('com duas empresas, escolhe e depois troca pelo menu', (tester) async {
      final gateway = FakeGateway(tenants: [FakeGateway.fornoNorte, FakeGateway.frioSul]);
      await pumpApp(tester, gateway);
      await login(tester);
      expect(find.text('Escolha a empresa'), findsOneWidget);
      await tester.tap(find.byKey(const Key('tenant-forno-norte')));
      await tester.pumpAndSettle();
      expect(find.text('Forno Norte'), findsOneWidget);

      await tester.tap(find.byKey(const Key('user-menu')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Trocar de empresa'));
      await tester.pumpAndSettle();
      expect(find.text('Escolha a empresa'), findsOneWidget);
    });

    testWidgets('sessão vencida volta ao login com aviso', (tester) async {
      final gateway = FakeGateway()..failNext['myVisits'] = const SessionLost();
      await pumpApp(tester, gateway);
      await login(tester);
      expect(find.byKey(const Key('login-notice')), findsOneWidget);
      expect(find.text('Sua sessão expirou. Entre de novo.'), findsOneWidget);
    });
  });

  group('agenda', () {
    testWidgets('em andamento, atrasadas e dias, sem canceladas', (tester) async {
      final gateway = FakeGateway()
        ..addVisit(1, DateTime(2026, 11, 17, 14))
        ..addVisit(2, DateTime(2026, 11, 17, 9), status: 'on_site')
        ..addVisit(3, DateTime(2026, 11, 16, 10))
        ..addVisit(4, DateTime(2026, 11, 18, 8), priority: 'urgent')
        ..addVisit(5, DateTime(2026, 11, 19, 8), status: 'cancelled');
      await pumpApp(tester, gateway);
      await login(tester);

      final (from, to) = gateway.lastRange!;
      expect(from, DateTime(2026, 11, 15));
      expect(to, DateTime(2026, 12, 2));

      final titles = ['Em andamento', 'Atrasadas', 'Hoje', 'Amanhã'];
      final ys = [for (final t in titles) tester.getTopLeft(find.text(t)).dy];
      expect(ys, [...ys]..sort());
      expect(find.text('OS 2026-000005'), findsNothing);
      expect(find.text('Urgente'), findsOneWidget);
      expect(find.text('No local'), findsOneWidget);
    });

    testWidgets('acesso sem técnico ligado mostra o aviso', (tester) async {
      await pumpApp(tester, FakeGateway(linkedToTechnician: false));
      await login(tester);
      expect(find.textContaining('não está ligado a um técnico'), findsOneWidget);
    });

    testWidgets('sem visitas mostra a agenda vazia', (tester) async {
      await pumpApp(tester, FakeGateway());
      await login(tester);
      expect(find.text('Nenhuma visita na sua agenda nos próximos dias.'), findsOneWidget);
    });
  });
}
