// Unidades e contatos do cliente de ponta a ponta: padrão de cadastro,
// isolamento, unidade sempre do mesmo cliente, ações do contato
// (aprovar, bloquear, desbloquear) e eventos no outbox.
@Tags(['e2e'])
library;

import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:postgres/postgres.dart' as pg;
import 'package:test/test.dart';

import 'support.dart';

void main() {
  late Client asAna;
  late Client asCarla;
  late Client asDavi;
  late pg.Connection db;
  final run = DateTime.now().toUtc().millisecondsSinceEpoch.toRadixString(36).toUpperCase();

  setUpAll(() async {
    final tokens = loadTestTokens();
    asAna = clientAs(tokens, ana);
    asCarla = clientAs(tokens, carla);
    asDavi = clientAs(tokens, daviA);
    db = await openTestDb();
  });
  tearDownAll(() => db.close());

  Matcher apiError(String code) => throwsA(isA<ApiException>().having((e) => e.code, 'code', code));
  Matcher fieldErrors(String code, List<String> paths) => throwsA(
    isA<ApiException>()
        .having((e) => e.code, 'code', code)
        .having((e) => e.fieldErrors?.map((f) => f.path).toSet(), 'paths', containsAll(paths)),
  );

  Future<Customer> customer(String suffix) => asAna.customers.create(
    CustomerInput(name: 'E2E $run $suffix', documentType: DocumentType.none),
  );

  group('unidades', () {
    test('cria normalizando CEP, UF e telefone; lista por cliente', () async {
      final c = await customer('sites');
      final s = await asAna.customerSites.create(
        CustomerSiteInput(
          customerId: c.id,
          name: ' Loja Centro ',
          street: 'Rua dos Andradas',
          streetNumber: '1001',
          district: 'Centro Histórico',
          city: 'Porto Alegre',
          state: 'rs',
          postalCode: '90020-007',
          latitude: -30.0277,
          longitude: -51.2287,
          phone: '(51) 3333-4444',
          accessNotes: 'Entrada pela doca, falar com o vigia',
        ),
      );
      expect(s.name, 'Loja Centro');
      expect(s.state, 'RS');
      expect(s.postalCode, '90020007');
      expect(s.countryCode, 'BR');
      expect(s.phone, '+555133334444');
      expect(s.latitude, closeTo(-30.0277, 1e-9));
      expect(s.tenantId, tenantA);

      await asAna.customerSites.create(CustomerSiteInput(customerId: c.id, name: 'Depósito'));
      final page = await asAna.customerSites.list(CustomerSiteFilter(customerId: c.id), null);
      expect(page.items.map((x) => x.name), ['Depósito', 'Loja Centro']);
    });

    test('validação: UF, CEP, coordenada incompleta e nome', () async {
      final c = await customer('sites-val');
      await expectLater(
        asAna.customerSites.create(
          CustomerSiteInput(customerId: c.id, name: ' ', state: 'XX', postalCode: '123', latitude: -30),
        ),
        fieldErrors('VALIDATION_FAILED', ['name', 'state', 'postalCode', 'latitude']),
      );
    });

    test('cliente inativo não recebe unidade; cliente de outro tenant é NOT_FOUND', () async {
      final c = await customer('sites-inativo');
      await asAna.customers.deactivate(c.id, 'teste', c.version);
      await expectLater(
        asAna.customerSites.create(CustomerSiteInput(customerId: c.id, name: 'X')),
        apiError('BUSINESS_RULE_VIOLATION'),
      );
      final other = await customer('sites-isolado');
      await expectLater(
        asCarla.customerSites.create(CustomerSiteInput(customerId: other.id, name: 'Invasão')),
        apiError('NOT_FOUND'),
      );
    });

    test('update com versão, clear da localização, inativar e reativar; outbox', () async {
      final c = await customer('sites-upd');
      final s = await asAna.customerSites.create(
        CustomerSiteInput(customerId: c.id, name: 'Filial', latitude: -29.9, longitude: -51.1),
      );
      final v2 = await asAna.customerSites.update(s.id, CustomerSitePatch(clear: [CustomerSiteField.location]), 1);
      expect(v2.latitude, isNull);
      expect(v2.longitude, isNull);
      expect(v2.version, 2);
      await expectLater(
        asAna.customerSites.update(s.id, CustomerSitePatch(name: 'X'), 1),
        apiError('VERSION_MISMATCH'),
      );
      await expectLater(asCarla.customerSites.get(s.id), apiError('NOT_FOUND'));
      await expectLater(asDavi.customerSites.update(s.id, CustomerSitePatch(name: 'X'), 2), apiError('FORBIDDEN'));
      final off = await asAna.customerSites.deactivate(s.id, 'Fechou', 2);
      expect(off.isActive, isFalse);
      final on = await asAna.customerSites.reactivate(s.id, off.version);
      expect(on.isActive, isTrue);
      final events = await db.execute(
        pg.Sql.named(
          'SELECT event_type FROM app.outbox_messages WHERE aggregate_id = @id::uuid ORDER BY aggregate_version',
        ),
        parameters: {'id': s.id.uuid},
      );
      expect(events.map((r) => r[0]), [
        'customer_site.created',
        'customer_site.updated',
        'customer_site.deactivated',
        'customer_site.updated',
      ]);
    });
  });

  group('contatos', () {
    test('cria com celular normalizado; precisa de celular ou e-mail', () async {
      final c = await customer('contatos');
      final ct = await asAna.customerContacts.create(
        CustomerContactInput(
          customerId: c.id,
          name: 'Maria Gerente',
          phone: '(51) 98888-7777',
          email: 'Maria@Loja.TEST',
          jobTitle: 'Gerente',
          preferredChannel: NotificationChannel.whatsapp,
        ),
      );
      expect(ct.phoneE164, '+5551988887777');
      expect(ct.email, 'maria@loja.test');
      expect(ct.status, ContactStatus.active);
      expect(ct.origin, ContactOrigin.backoffice);
      expect(ct.contactRole, ContactRole.customer_contact);
      expect(ct.whatsappOptInAt, isNull, reason: 'consentimento é do próprio contato');
      await expectLater(
        asAna.customerContacts.create(CustomerContactInput(customerId: c.id, name: 'Sem canal')),
        fieldErrors('VALIDATION_FAILED', ['phone']),
      );
      await expectLater(
        asAna.customerContacts.create(
          CustomerContactInput(
            customerId: c.id,
            name: 'Só e-mail',
            email: 'a@b.test',
            preferredChannel: NotificationChannel.sms,
          ),
        ),
        fieldErrors('VALIDATION_FAILED', ['preferredChannel']),
      );
    });

    test('unidade do contato precisa ser do mesmo cliente', () async {
      final c1 = await customer('ct-site-1');
      final c2 = await customer('ct-site-2');
      final siteOfC2 = await asAna.customerSites.create(CustomerSiteInput(customerId: c2.id, name: 'Unidade do outro'));
      await expectLater(
        asAna.customerContacts.create(
          CustomerContactInput(customerId: c1.id, customerSiteId: siteOfC2.id, name: 'X', email: 'x@y.test'),
        ),
        fieldErrors('VALIDATION_FAILED', ['customerSiteId']),
      );
      final siteOfC1 = await asAna.customerSites.create(CustomerSiteInput(customerId: c1.id, name: 'Unidade certa'));
      final ok = await asAna.customerContacts.create(
        CustomerContactInput(customerId: c1.id, customerSiteId: siteOfC1.id, name: 'Y', email: 'y@y.test'),
      );
      expect(ok.customerSiteId, siteOfC1.id);
      final bySite = await asAna.customerContacts.list(CustomerContactFilter(customerSiteId: siteOfC1.id), null);
      expect(bySite.items.map((x) => x.id), [ok.id]);
    });

    test('bloquear exige motivo; desbloquear; aprovar só pendente; eventos do catálogo', () async {
      final c = await customer('ct-acoes');
      final ct = await asAna.customerContacts.create(
        CustomerContactInput(customerId: c.id, name: 'João', phone: '51988880000'),
      );
      await expectLater(asAna.customerContacts.approve(ct.id, 1), apiError('INVALID_TRANSITION'));
      await expectLater(asAna.customerContacts.block(ct.id, ' ', 1), fieldErrors('VALIDATION_FAILED', ['reason']));
      final blocked = await asAna.customerContacts.block(ct.id, 'Abriu chamados falsos', 1);
      expect(blocked.status, ContactStatus.blocked);
      expect(blocked.blockedReason, 'Abriu chamados falsos');
      final active = await asAna.customerContacts.unblock(ct.id, blocked.version);
      expect(active.status, ContactStatus.active);
      expect(active.blockedReason, isNull);

      // Autocadastro pelo QR (simulado direto no banco): nasce pending_approval.
      final pendingId = const Uuid().v7obj();
      await db.execute(
        pg.Sql.named(
          'INSERT INTO app.customer_contacts (id, tenant_id, customer_id, name, phone_e164, status, origin) '
          "VALUES (@id::uuid, @t::uuid, @c::uuid, 'Autocadastro', '+5551977776666', 'pending_approval', 'qr_self_service')",
        ),
        parameters: {'id': pendingId.uuid, 't': tenantA.uuid, 'c': c.id.uuid},
      );
      final pending = await asAna.customerContacts.get(pendingId);
      expect(pending.status, ContactStatus.pending_approval);
      final approved = await asAna.customerContacts.approve(pendingId, pending.version);
      expect(approved.status, ContactStatus.active);
      expect(approved.approvedAt, isNotNull);
      expect(approved.approvedBy, ana.user, reason: 'aprovado pela Ana, num update só');
      expect(approved.version, pending.version + 1);

      final events = await db.execute(
        pg.Sql.named(
          'SELECT event_type FROM app.outbox_messages WHERE aggregate_id = @id::uuid ORDER BY aggregate_version',
        ),
        parameters: {'id': ct.id.uuid},
      );
      expect(events.map((r) => r[0]), [
        'customer_contact.created',
        'customer_contact.blocked',
        'customer_contact.updated',
      ]);
    });

    test('isolamento e permissões', () async {
      final c = await customer('ct-iso');
      final ct = await asAna.customerContacts.create(
        CustomerContactInput(customerId: c.id, name: 'Z', email: 'z@z.test'),
      );
      await expectLater(asCarla.customerContacts.get(ct.id), apiError('NOT_FOUND'));
      await expectLater(asCarla.customerContacts.block(ct.id, 'x', 1), apiError('NOT_FOUND'));
      expect((await asCarla.customerContacts.list(CustomerContactFilter(customerId: c.id), null)).items, isEmpty);
      expect((await asDavi.customerContacts.get(ct.id)).id, ct.id);
      await expectLater(asDavi.customerContacts.block(ct.id, 'x', 1), apiError('FORBIDDEN'));
    });
  });
}
