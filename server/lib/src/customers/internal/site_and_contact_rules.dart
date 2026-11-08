import 'package:plataforma_os_core/plataforma_os_core.dart';
import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';

/// Regras puras de unidades e contatos (mesmo papel de `CustomerRules`):
/// normalizam e devolvem todos os erros por campo de uma vez. Também servem à
/// importação por planilha.

typedef Validated<T> = ({T? value, List<FieldError> errors});

String? _clean(String? v) {
  final t = v?.trim();
  return (t == null || t.isEmpty) ? null : t;
}

// ---------------------------------------------------------------------------
// Unidade
// ---------------------------------------------------------------------------

final class SiteDraft {
  const SiteDraft({
    required this.name,
    required this.countryCode,
    this.code,
    this.street,
    this.streetNumber,
    this.complement,
    this.district,
    this.city,
    this.state,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.phone,
    this.accessNotes,
  });

  factory SiteDraft.fromInput(CustomerSiteInput i) => SiteDraft(
    code: i.code,
    name: i.name,
    street: i.street,
    streetNumber: i.streetNumber,
    complement: i.complement,
    district: i.district,
    city: i.city,
    state: i.state,
    postalCode: i.postalCode,
    countryCode: i.countryCode ?? 'BR',
    latitude: i.latitude,
    longitude: i.longitude,
    phone: i.phone,
    accessNotes: i.accessNotes,
  );

  factory SiteDraft.fromSite(CustomerSite s) => SiteDraft(
    code: s.code,
    name: s.name,
    street: s.street,
    streetNumber: s.streetNumber,
    complement: s.complement,
    district: s.district,
    city: s.city,
    state: s.state,
    postalCode: s.postalCode,
    countryCode: s.countryCode,
    latitude: s.latitude,
    longitude: s.longitude,
    phone: s.phone,
    accessNotes: s.accessNotes,
  );

  final String? code;
  final String name;
  final String? street;
  final String? streetNumber;
  final String? complement;
  final String? district;
  final String? city;
  final String? state;
  final String? postalCode;
  final String countryCode;
  final double? latitude;
  final double? longitude;
  final String? phone;
  final String? accessNotes;

  SiteDraft apply(CustomerSitePatch p) {
    final clear = p.clear?.toSet() ?? const <CustomerSiteField>{};
    String? pick(CustomerSiteField f, String? patched, String? current) =>
        clear.contains(f) ? null : patched ?? current;
    final clearLocation = clear.contains(CustomerSiteField.location);
    return SiteDraft(
      code: pick(CustomerSiteField.code, p.code, code),
      name: p.name ?? name,
      street: pick(CustomerSiteField.street, p.street, street),
      streetNumber: pick(CustomerSiteField.streetNumber, p.streetNumber, streetNumber),
      complement: pick(CustomerSiteField.complement, p.complement, complement),
      district: pick(CustomerSiteField.district, p.district, district),
      city: pick(CustomerSiteField.city, p.city, city),
      state: pick(CustomerSiteField.state, p.state, state),
      postalCode: pick(CustomerSiteField.postalCode, p.postalCode, postalCode),
      countryCode: p.countryCode ?? countryCode,
      latitude: clearLocation ? null : p.latitude ?? latitude,
      longitude: clearLocation ? null : p.longitude ?? longitude,
      phone: pick(CustomerSiteField.phone, p.phone, phone),
      accessNotes: pick(CustomerSiteField.accessNotes, p.accessNotes, accessNotes),
    );
  }

  Map<String, Object?> toFields() => {
    'code': code,
    'name': name,
    'street': street,
    'streetNumber': streetNumber,
    'complement': complement,
    'district': district,
    'city': city,
    'state': state,
    'postalCode': postalCode,
    'countryCode': countryCode,
    'latitude': latitude,
    'longitude': longitude,
    'phone': phone,
    'accessNotes': accessNotes,
  };
}

/// Campos que o ERP mantém (espelha `trg_guard_erp_master` de customer_sites).
const siteMasterFields = {
  'code',
  'name',
  'street',
  'streetNumber',
  'complement',
  'district',
  'city',
  'state',
  'postalCode',
  'countryCode',
};

/// Unidades da federação (IBGE).
const brazilianStates = {
  'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA', //
  'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO',
};

abstract final class SiteRules {
  static Validated<SiteDraft> validate(SiteDraft d) {
    final errors = <FieldError>[];
    void err(String path, String code, String message) =>
        errors.add(FieldError(path: path, code: code, message: message));
    String? limited(String path, String? v, int max) {
      final c = _clean(v);
      if (c != null && c.length > max) err(path, 'too_long', 'Até $max caracteres.');
      return c;
    }

    final name = limited('name', d.name, 200);
    if (name == null) err('name', 'required', 'Informe o nome da unidade.');
    final code = limited('code', d.code, 40);
    final street = limited('street', d.street, 200);
    final streetNumber = limited('streetNumber', d.streetNumber, 20);
    final complement = limited('complement', d.complement, 100);
    final district = limited('district', d.district, 100);
    final city = limited('city', d.city, 100);
    final accessNotes = limited('accessNotes', d.accessNotes, 2000);

    final country = d.countryCode.trim().toUpperCase();
    if (!RegExp(r'^[A-Z]{2}$').hasMatch(country)) err('countryCode', 'invalid', 'País inválido (2 letras, ex.: BR).');

    var state = _clean(d.state)?.toUpperCase();
    var postalCode = _clean(d.postalCode);
    if (country == 'BR') {
      if (state != null && !brazilianStates.contains(state)) err('state', 'invalid', 'UF inválida.');
      if (postalCode != null) {
        final digits = postalCode.replaceAll(RegExp(r'[\s.\-]'), '');
        if (!RegExp(r'^\d{8}$').hasMatch(digits)) {
          err('postalCode', 'invalid', 'CEP inválido (8 dígitos).');
        } else {
          postalCode = digits;
        }
      }
    } else {
      if (state != null && state.length > 40) err('state', 'too_long', 'Até 40 caracteres.');
      if (postalCode != null && postalCode.length > 20) err('postalCode', 'too_long', 'Até 20 caracteres.');
      state = state == null ? null : _clean(d.state);
    }

    final lat = d.latitude;
    final lng = d.longitude;
    if ((lat == null) != (lng == null)) {
      err('latitude', 'incomplete', 'Informe latitude e longitude juntas.');
    } else if (lat != null && lng != null) {
      if (lat < -90 || lat > 90 || lat.isNaN) err('latitude', 'out_of_range', 'Latitude entre -90 e 90.');
      if (lng < -180 || lng > 180 || lng.isNaN) err('longitude', 'out_of_range', 'Longitude entre -180 e 180.');
    }

    final rawPhone = _clean(d.phone);
    final phone = rawPhone == null ? null : Phones.toE164(rawPhone);
    if (rawPhone != null && phone == null) err('phone', 'invalid', 'Telefone inválido. Use DDD + número.');

    if (errors.isNotEmpty) return (value: null, errors: errors);
    return (
      value: SiteDraft(
        code: code,
        name: name!,
        street: street,
        streetNumber: streetNumber,
        complement: complement,
        district: district,
        city: city,
        state: state,
        postalCode: postalCode,
        countryCode: country,
        latitude: lat,
        longitude: lng,
        phone: phone,
        accessNotes: accessNotes,
      ),
      errors: const [],
    );
  }
}

// ---------------------------------------------------------------------------
// Contato
// ---------------------------------------------------------------------------

final class ContactDraft {
  const ContactDraft({
    required this.name,
    required this.contactRole,
    required this.canOpenRequests,
    this.customerSiteId,
    this.email,
    this.phone,
    this.jobTitle,
    this.preferredChannel,
  });

  factory ContactDraft.fromInput(CustomerContactInput i) => ContactDraft(
    customerSiteId: i.customerSiteId,
    name: i.name,
    email: i.email,
    phone: i.phone,
    jobTitle: i.jobTitle,
    contactRole: i.contactRole ?? ContactRole.customer_contact,
    canOpenRequests: i.canOpenRequests ?? true,
    preferredChannel: i.preferredChannel,
  );

  factory ContactDraft.fromContact(CustomerContact c) => ContactDraft(
    customerSiteId: c.customerSiteId,
    name: c.name,
    email: c.email,
    phone: c.phoneE164,
    jobTitle: c.jobTitle,
    contactRole: c.contactRole,
    canOpenRequests: c.canOpenRequests,
    preferredChannel: c.preferredChannel,
  );

  final UuidValue? customerSiteId;
  final String name;
  final String? email;
  final String? phone;
  final String? jobTitle;
  final ContactRole contactRole;
  final bool canOpenRequests;
  final NotificationChannel? preferredChannel;

  ContactDraft apply(CustomerContactPatch p) {
    final clear = p.clear?.toSet() ?? const <CustomerContactField>{};
    T? pick<T>(CustomerContactField f, T? patched, T? current) => clear.contains(f) ? null : patched ?? current;
    return ContactDraft(
      customerSiteId: pick(CustomerContactField.customerSiteId, p.customerSiteId, customerSiteId),
      name: p.name ?? name,
      email: pick(CustomerContactField.email, p.email, email),
      phone: pick(CustomerContactField.phone, p.phone, phone),
      jobTitle: pick(CustomerContactField.jobTitle, p.jobTitle, jobTitle),
      contactRole: p.contactRole ?? contactRole,
      canOpenRequests: p.canOpenRequests ?? canOpenRequests,
      preferredChannel: pick(CustomerContactField.preferredChannel, p.preferredChannel, preferredChannel),
    );
  }

  Map<String, Object?> toFields() => {
    'customerSiteId': customerSiteId,
    'name': name,
    'email': email,
    'phoneE164': phone,
    'jobTitle': jobTitle,
    'contactRole': contactRole,
    'canOpenRequests': canOpenRequests,
    'preferredChannel': preferredChannel,
  };
}

/// Espelha `trg_guard_erp_master` de customer_contacts.
const contactMasterFields = {'name', 'email', 'phoneE164', 'jobTitle'};

abstract final class ContactRules {
  static final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static Validated<ContactDraft> validate(ContactDraft d) {
    final errors = <FieldError>[];
    void err(String path, String code, String message) =>
        errors.add(FieldError(path: path, code: code, message: message));

    final name = _clean(d.name);
    if (name == null) {
      err('name', 'required', 'Informe o nome.');
    } else if (name.length > 200) {
      err('name', 'too_long', 'Até 200 caracteres.');
    }
    final jobTitle = _clean(d.jobTitle);
    if (jobTitle != null && jobTitle.length > 100) err('jobTitle', 'too_long', 'Até 100 caracteres.');

    final email = _clean(d.email)?.toLowerCase();
    if (email != null && (email.length > 254 || !_email.hasMatch(email))) err('email', 'invalid', 'E-mail inválido.');
    final rawPhone = _clean(d.phone);
    final phone = rawPhone == null ? null : Phones.toE164(rawPhone);
    if (rawPhone != null && phone == null) err('phone', 'invalid', 'Celular inválido. Use DDD + número.');

    // O contato entra no app por OTP: precisa de pelo menos um canal.
    if (rawPhone == null && email == null) {
      err('phone', 'required', 'Informe o celular ou o e-mail.');
    }
    switch (d.preferredChannel) {
      case NotificationChannel.whatsapp || NotificationChannel.sms when rawPhone == null:
        err('preferredChannel', 'needs_phone', 'Para WhatsApp ou SMS, informe o celular.');
      case NotificationChannel.email when email == null:
        err('preferredChannel', 'needs_email', 'Para e-mail, informe o e-mail.');
      default:
        break;
    }

    if (errors.isNotEmpty) return (value: null, errors: errors);
    return (
      value: ContactDraft(
        customerSiteId: d.customerSiteId,
        name: name!,
        email: email,
        phone: phone,
        jobTitle: jobTitle,
        contactRole: d.contactRole,
        canOpenRequests: d.canOpenRequests,
        preferredChannel: d.preferredChannel,
      ),
      errors: const [],
    );
  }
}
