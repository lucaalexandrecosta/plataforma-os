import 'package:plataforma_os_server/src/customers/internal/site_and_contact_rules.dart';
import 'package:plataforma_os_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

List<String> paths(List<FieldError> errors) => [for (final e in errors) e.path];

void main() {
  final customerId = UuidValue.withValidation('0197f000-0001-7300-8000-000000000001');

  group('SiteRules', () {
    test('normaliza CEP, UF, país e telefone', () {
      final r = SiteRules.validate(
        SiteDraft.fromInput(
          CustomerSiteInput(
            customerId: customerId,
            name: ' Loja ',
            state: 'sp',
            postalCode: '01310-100',
            phone: '11 3333-4444',
          ),
        ),
      );
      expect(r.errors, isEmpty);
      expect(r.value!.name, 'Loja');
      expect(r.value!.state, 'SP');
      expect(r.value!.postalCode, '01310100');
      expect(r.value!.countryCode, 'BR');
      expect(r.value!.phone, '+551133334444');
    });

    test('fora do Brasil: UF e CEP livres', () {
      final r = SiteRules.validate(
        SiteDraft.fromInput(
          CustomerSiteInput(
            customerId: customerId,
            name: 'Filial',
            countryCode: 'ar',
            state: 'Córdoba',
            postalCode: 'X5000',
          ),
        ),
      );
      expect(r.errors, isEmpty);
      expect(r.value!.countryCode, 'AR');
      expect(r.value!.state, 'Córdoba');
    });

    test('coordenada: as duas juntas e dentro dos limites', () {
      SiteDraft d({double? lat, double? lng}) =>
          SiteDraft.fromInput(CustomerSiteInput(customerId: customerId, name: 'X', latitude: lat, longitude: lng));
      expect(paths(SiteRules.validate(d(lat: -30)).errors), ['latitude']);
      expect(paths(SiteRules.validate(d(lat: -91, lng: 0)).errors), ['latitude']);
      expect(paths(SiteRules.validate(d(lat: 0, lng: 181)).errors), ['longitude']);
      expect(SiteRules.validate(d(lat: -30.0277, lng: -51.2287)).errors, isEmpty);
    });

    test('patch: clear da localização apaga as duas', () {
      final base = SiteDraft.fromInput(CustomerSiteInput(customerId: customerId, name: 'X', latitude: 1, longitude: 2));
      final next = base.apply(CustomerSitePatch(clear: [CustomerSiteField.location]));
      expect(next.latitude, isNull);
      expect(next.longitude, isNull);
    });
  });

  group('ContactRules', () {
    ContactDraft d({String? phone, String? email, NotificationChannel? channel}) => ContactDraft.fromInput(
      CustomerContactInput(customerId: customerId, name: 'Ana', phone: phone, email: email, preferredChannel: channel),
    );

    test('precisa de celular ou e-mail', () {
      expect(paths(ContactRules.validate(d()).errors), ['phone']);
      expect(ContactRules.validate(d(email: 'a@b.test')).errors, isEmpty);
      expect(ContactRules.validate(d(phone: '51988887777')).value!.phone, '+5551988887777');
    });

    test('canal preferido precisa do dado correspondente', () {
      expect(paths(ContactRules.validate(d(email: 'a@b.test', channel: NotificationChannel.whatsapp)).errors), [
        'preferredChannel',
      ]);
      expect(paths(ContactRules.validate(d(phone: '51988887777', channel: NotificationChannel.email)).errors), [
        'preferredChannel',
      ]);
      expect(ContactRules.validate(d(phone: '51988887777', channel: NotificationChannel.sms)).errors, isEmpty);
    });

    test('padrões: contato comum que pode abrir chamados', () {
      final v = ContactRules.validate(d(email: 'A@B.TEST')).value!;
      expect(v.contactRole, ContactRole.customer_contact);
      expect(v.canOpenRequests, isTrue);
      expect(v.email, 'a@b.test');
    });

    test('campos mestres do ERP espelham o trigger', () {
      expect(contactMasterFields, {'name', 'email', 'phoneE164', 'jobTitle'});
      expect(siteMasterFields, isNot(contains('latitude')));
      expect(siteMasterFields, isNot(contains('accessNotes')));
    });
  });
}
