import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../identity_access/identity_access.dart';
import '../../platform/db/sql_values.dart';
import '../../platform/errors/api_errors.dart';
import 'customer_contacts.dart';
import 'customers.dart';

/// Importação de clientes, unidades e contatos por planilha (RF-16).
///
/// Tudo ou nada: valida todas as linhas e só grava se nenhuma tiver erro.
/// Reimportar a mesma planilha não duplica: o cliente é reconhecido pelo
/// código, depois pelo documento e, sem nenhum dos dois, pelo nome; unidade e contato pelo
/// nome dentro do cliente. Cadastros que já existem não são alterados.
abstract final class CustomerImport {
  static const maxRows = 2000;

  /// Colunas do modelo, na ordem do arquivo; o backoffice usa os mesmos nomes.
  static const columns = {
    'code': 'codigo',
    'name': 'nome',
    'tradeName': 'nome_fantasia',
    'personType': 'tipo',
    'documentNumber': 'documento',
    'stateRegistration': 'inscricao_estadual',
    'email': 'email',
    'phone': 'telefone',
    'notes': 'observacoes',
    'siteName': 'unidade',
    'siteCode': 'unidade_codigo',
    'postalCode': 'cep',
    'street': 'rua',
    'streetNumber': 'numero',
    'complement': 'complemento',
    'district': 'bairro',
    'city': 'cidade',
    'state': 'uf',
    'sitePhone': 'unidade_telefone',
    'accessNotes': 'como_chegar',
    'contactName': 'contato',
    'contactPhone': 'contato_telefone',
    'contactEmail': 'contato_email',
    'contactJobTitle': 'contato_cargo',
  };

  static const _customerColumns = {
    'name': 'nome',
    'code': 'codigo',
    'personType': 'tipo',
    'documentNumber': 'documento',
    'email': 'email',
  };
  static const _siteColumns = {
    'name': 'unidade',
    'state': 'uf',
    'postalCode': 'cep',
    'latitude': 'unidade',
    'longitude': 'unidade',
  };
  static const _contactColumns = {
    'name': 'contato',
    'phone': 'contato_telefone',
    'email': 'contato_email',
    'preferredChannel': 'contato',
    'contactRole': 'contato',
  };

  static Future<CustomerImportReport> importRows(
    Session session,
    List<CustomerImportRow> rows, {
    required bool dryRun,
  }) async {
    await Authorization.require(session, Customers.managePermission);
    if (rows.isEmpty) {
      throw ApiErrors.fieldError(session, 'rows', 'REQUIRED', 'A planilha não tem linhas de dados.');
    }
    if (rows.length > maxRows) {
      throw ApiErrors.fieldError(session, 'rows', 'TOO_MANY', 'Importe até $maxRows linhas por vez.');
    }
    final existing = await _Existing.load(session);
    final errors = <CustomerImportError>[];
    final customers = <String, _Planned>{}; // chave → cliente (novo ou existente)
    final sites = <String, _Planned>{}; // chave do cliente + nome
    final contacts = <String, _Planned>{};

    for (final row in rows) {
      void fail(String column, String message) =>
          errors.add(CustomerImportError(line: row.line, column: column, message: message));

      // ---------------------------------------------------------- cliente
      final name = cleanText(row.name);
      final code = cleanText(row.code);
      final digits = row.documentNumber?.replaceAll(RegExp(r'\D'), '');
      final document = digits == null || digits.isEmpty ? null : digits;
      final key = code != null
          ? 'c:${code.toLowerCase()}'
          : document != null
          ? 'd:$document'
          : name != null
          ? 'n:${name.toLowerCase()}'
          : null;
      if (key == null) {
        fail('nome', 'Informe o código, o documento ou o nome do cliente.');
        continue;
      }
      var customer = customers[key];
      if (customer == null) {
        final found = existing.customer(code: code, document: document, name: name);
        if (found != null) {
          customer = _Planned(found, created: false);
        } else {
          final personType = _personType(row.personType, document);
          if (personType == null) {
            fail('tipo', 'Use PJ ou PF.');
            continue;
          }
          final (params, fieldErrors) = Customers.checkCustomer(
            CustomerInput(
              code: code,
              name: name ?? '',
              tradeName: row.tradeName,
              personType: personType,
              documentNumber: document,
              stateRegistration: row.stateRegistration,
              email: row.email,
              phone: row.phone,
              notes: row.notes,
              isActive: true,
            ),
          );
          for (final e in fieldErrors) {
            fail(_customerColumns[e.path] ?? 'nome', e.message);
          }
          if (fieldErrors.isNotEmpty) continue;
          customer = _Planned(const Uuid().v7obj(), created: true, params: params);
        }
        customers[key] = customer;
      }

      // ---------------------------------------------------------- unidade
      _Planned? site;
      final siteName = cleanText(row.siteName);
      if (siteName != null) {
        final siteKey = '$key|${siteName.toLowerCase()}';
        site = sites[siteKey];
        if (site == null) {
          final found = customer.created ? null : existing.site(customer.id, siteName);
          if (found != null) {
            site = _Planned(found, created: false);
          } else {
            final (params, fieldErrors) = Customers.checkSite(
              CustomerSiteInput(
                code: row.siteCode,
                name: siteName,
                street: row.street,
                streetNumber: row.streetNumber,
                complement: row.complement,
                district: row.district,
                city: row.city,
                state: row.state,
                postalCode: row.postalCode,
                phone: row.sitePhone,
                accessNotes: row.accessNotes,
                isActive: true,
              ),
            );
            for (final e in fieldErrors) {
              fail(_siteColumns[e.path] ?? 'unidade', e.message);
            }
            if (fieldErrors.isNotEmpty) continue;
            site = _Planned(const Uuid().v7obj(), created: true, params: params, parent: customer.id);
          }
          sites[siteKey] = site;
        }
      }

      // ---------------------------------------------------------- contato
      final contactName = cleanText(row.contactName);
      if (contactName != null) {
        final contactKey = '$key|${contactName.toLowerCase()}';
        if (contacts.containsKey(contactKey)) continue;
        final found = customer.created ? null : existing.contact(customer.id, contactName);
        if (found != null) {
          contacts[contactKey] = _Planned(found, created: false);
          continue;
        }
        final (params, fieldErrors) = CustomerContacts.check(
          CustomerContactInput(
            name: contactName,
            phone: row.contactPhone,
            email: row.contactEmail,
            jobTitle: row.contactJobTitle,
            contactRole: 'customer_contact',
            canOpenRequests: true,
            isActive: true,
          ),
        );
        for (final e in fieldErrors) {
          fail(_contactColumns[e.path] ?? 'contato', e.message);
        }
        if (fieldErrors.isNotEmpty) continue;
        contacts[contactKey] = _Planned(
          const Uuid().v7obj(),
          created: true,
          params: {...params, 'siteId': site?.id.uuid},
          parent: customer.id,
        );
      }
    }

    final apply = errors.isEmpty && !dryRun;
    if (apply) {
      await session.db.transaction((tx) async {
        for (final c in customers.values.where((c) => c.created)) {
          await Customers.insertCustomer(session, c.id, c.params!, transaction: tx);
        }
        for (final s in sites.values.where((s) => s.created)) {
          await Customers.insertSite(session, s.id, s.parent!, s.params!, transaction: tx);
        }
        for (final c in contacts.values.where((c) => c.created)) {
          await CustomerContacts.insert(session, c.id, c.parent!, c.params!, transaction: tx);
        }
      });
    }
    int created(Map<String, _Planned> m) => m.values.where((p) => p.created).length;
    return CustomerImportReport(
      dryRun: dryRun,
      applied: apply,
      rows: rows.length,
      customersCreated: created(customers),
      customersExisting: customers.length - created(customers),
      sitesCreated: created(sites),
      sitesExisting: sites.length - created(sites),
      contactsCreated: created(contacts),
      contactsExisting: contacts.length - created(contacts),
      errors: errors,
    );
  }

  static String? _personType(String? raw, String? document) {
    final t = cleanText(raw)?.toLowerCase();
    if (t == null) return document?.length == 11 ? 'individual' : 'company';
    if (const {'pj', 'empresa', 'juridica', 'jurídica', 'pessoa jurídica', 'pessoa juridica'}.contains(t)) {
      return 'company';
    }
    if (const {'pf', 'fisica', 'física', 'pessoa física', 'pessoa fisica'}.contains(t)) return 'individual';
    return null;
  }
}

class _Planned {
  _Planned(this.id, {required this.created, this.params, this.parent});

  final UuidValue id;
  final bool created;
  final Map<String, Object?>? params;
  final UuidValue? parent;
}

/// Cadastros que já existem no tenant, para reconhecer a mesma linha.
class _Existing {
  _Existing._(this._byCode, this._byDocument, this._byName, this._sites, this._contacts);

  final Map<String, UuidValue> _byCode;
  final Map<String, UuidValue> _byDocument;
  final Map<String, UuidValue> _byName;
  final Map<String, UuidValue> _sites;
  final Map<String, UuidValue> _contacts;

  static Future<_Existing> load(Session session) async {
    final byCode = <String, UuidValue>{};
    final byDocument = <String, UuidValue>{};
    final byName = <String, UuidValue>{};
    for (final r in await session.db.unsafeQuery('SELECT id, code, document_number, name FROM app.customers')) {
      final id = sqlUuid(r[0]);
      if (r[1] != null) byCode[(r[1] as String).toLowerCase()] = id;
      if (r[2] != null) byDocument[r[2] as String] = id;
      byName.putIfAbsent((r[3] as String).toLowerCase(), () => id);
    }
    Future<Map<String, UuidValue>> named(String table) async => {
      for (final r in await session.db.unsafeQuery('SELECT id, customer_id, name FROM app.$table'))
        '${sqlUuid(r[1]).uuid}|${(r[2] as String).toLowerCase()}': sqlUuid(r[0]),
    };
    return _Existing._(byCode, byDocument, byName, await named('customer_sites'), await named('customer_contacts'));
  }

  UuidValue? customer({String? code, String? document, String? name}) {
    final byCode = code == null ? null : _byCode[code.toLowerCase()];
    if (byCode != null) return byCode;
    final byDocument = document == null ? null : _byDocument[document];
    if (byDocument != null) return byDocument;
    if (code != null || document != null) return null;
    return name == null ? null : _byName[name.toLowerCase()];
  }

  UuidValue? site(UuidValue customerId, String name) => _sites['${customerId.uuid}|${name.toLowerCase()}'];

  UuidValue? contact(UuidValue customerId, String name) => _contacts['${customerId.uuid}|${name.toLowerCase()}'];
}
