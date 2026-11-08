import 'package:plataforma_os_core/plataforma_os_core.dart';

import '../../generated/protocol.dart';

/// Campos editáveis de um cliente, já normalizados. Serve à criação, à
/// atualização (atual + patch) e, depois, à importação por planilha: as três
/// passam pelas mesmas regras.
final class CustomerDraft {
  const CustomerDraft({
    required this.name,
    required this.personType,
    required this.documentType,
    required this.kind,
    required this.skipTriage,
    this.code,
    this.tradeName,
    this.documentNumber,
    this.stateRegistration,
    this.email,
    this.phone,
    this.notes,
  });

  factory CustomerDraft.fromInput(CustomerInput i) {
    final personType = i.personType ?? PersonType.company;
    return CustomerDraft(
      code: i.code,
      name: i.name,
      tradeName: i.tradeName,
      personType: personType,
      documentType: i.documentType ?? (personType == PersonType.company ? DocumentType.cnpj : DocumentType.cpf),
      documentNumber: i.documentNumber,
      stateRegistration: i.stateRegistration,
      email: i.email,
      phone: i.phone,
      notes: i.notes,
      kind: i.kind ?? CustomerKind.standard,
      skipTriage: i.skipTriage ?? false,
    );
  }

  factory CustomerDraft.fromCustomer(Customer c) => CustomerDraft(
    code: c.code,
    name: c.name,
    tradeName: c.tradeName,
    personType: c.personType,
    documentType: c.documentType,
    documentNumber: c.documentNumber,
    stateRegistration: c.stateRegistration,
    email: c.email,
    phone: c.phone,
    notes: c.notes,
    kind: c.kind,
    skipTriage: c.skipTriage,
  );

  final String? code;
  final String name;
  final String? tradeName;
  final PersonType personType;
  final DocumentType documentType;
  final String? documentNumber;
  final String? stateRegistration;
  final String? email;
  final String? phone;
  final String? notes;
  final CustomerKind kind;
  final bool skipTriage;

  /// Aplica o patch: campo nulo = sem mudança; `clear` apaga.
  CustomerDraft apply(CustomerPatch p) {
    final clear = p.clear?.toSet() ?? const <CustomerField>{};
    String? pick(CustomerField f, String? patched, String? current) => clear.contains(f) ? null : patched ?? current;
    return CustomerDraft(
      code: pick(CustomerField.code, p.code, code),
      name: p.name ?? name,
      tradeName: pick(CustomerField.tradeName, p.tradeName, tradeName),
      personType: p.personType ?? personType,
      documentType: p.documentType ?? documentType,
      documentNumber: pick(CustomerField.documentNumber, p.documentNumber, documentNumber),
      stateRegistration: pick(CustomerField.stateRegistration, p.stateRegistration, stateRegistration),
      email: pick(CustomerField.email, p.email, email),
      phone: pick(CustomerField.phone, p.phone, phone),
      notes: pick(CustomerField.notes, p.notes, notes),
      kind: p.kind ?? kind,
      skipTriage: p.skipTriage ?? skipTriage,
    );
  }

  /// Nome do campo (como no modelo) → valor, para comparar e montar o UPDATE.
  Map<String, Object?> toFields() => {
    'code': code,
    'name': name,
    'tradeName': tradeName,
    'personType': personType,
    'documentType': documentType,
    'documentNumber': documentNumber,
    'stateRegistration': stateRegistration,
    'email': email,
    'phone': phone,
    'notes': notes,
    'kind': kind,
    'skipTriage': skipTriage,
  };
}

/// Campos que o ERP mantém (espelha `trg_guard_erp_master` em db/schema.sql).
const customerMasterFields = {
  'code',
  'name',
  'tradeName',
  'personType',
  'documentType',
  'documentNumber',
  'stateRegistration',
  'email',
  'phone',
};

/// Resultado da validação: o rascunho normalizado ou os erros por campo.
typedef CustomerValidation = ({CustomerDraft? draft, List<FieldError> errors});

abstract final class CustomerRules {
  static final _code = RegExp(r'^[A-Za-z0-9][A-Za-z0-9._/\-]*$');
  static final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static CustomerValidation validate(CustomerDraft d) {
    final errors = <FieldError>[];
    void err(String path, String code, String message) =>
        errors.add(FieldError(path: path, code: code, message: message));
    String? clean(String? v) {
      final t = v?.trim();
      return (t == null || t.isEmpty) ? null : t;
    }

    final name = clean(d.name);
    if (name == null) {
      err('name', 'required', 'Informe o nome (razão social).');
    } else if (name.length > 200) {
      err('name', 'too_long', 'Até 200 caracteres.');
    }

    final code = clean(d.code);
    if (code != null && (code.length > 40 || !_code.hasMatch(code))) {
      err('code', 'invalid', 'Até 40 caracteres: letras, números, ponto, barra, hífen ou sublinhado.');
    }

    final tradeName = clean(d.tradeName);
    if (tradeName != null && tradeName.length > 200) err('tradeName', 'too_long', 'Até 200 caracteres.');
    final notes = clean(d.notes);
    if (notes != null && notes.length > 4000) err('notes', 'too_long', 'Até 4.000 caracteres.');
    final stateRegistration = clean(d.stateRegistration)?.toUpperCase();
    if (stateRegistration != null && stateRegistration.length > 30) {
      err('stateRegistration', 'too_long', 'Até 30 caracteres.');
    }

    // Tipo de pessoa x documento: empresa não usa CPF; pessoa física não usa CNPJ.
    final allowed = d.personType == PersonType.company
        ? {DocumentType.cnpj, DocumentType.foreign, DocumentType.none}
        : {DocumentType.cpf, DocumentType.foreign, DocumentType.none};
    if (!allowed.contains(d.documentType)) {
      err('documentType', 'incompatible', 'Documento incompatível com o tipo de pessoa.');
    }

    var document = clean(d.documentNumber);
    switch (d.documentType) {
      case DocumentType.cnpj:
        if (document == null) {
          err('documentNumber', 'required', 'Informe o CNPJ.');
        } else if (!BrDocuments.isValidCnpj(document)) {
          err('documentNumber', 'invalid', 'CNPJ inválido.');
        } else {
          document = BrDocuments.normalize(document);
        }
      case DocumentType.cpf:
        if (document == null) {
          err('documentNumber', 'required', 'Informe o CPF.');
        } else if (!BrDocuments.isValidCpf(document)) {
          err('documentNumber', 'invalid', 'CPF inválido.');
        } else {
          document = BrDocuments.normalize(document);
        }
      case DocumentType.foreign:
        if (document == null) {
          err('documentNumber', 'required', 'Informe o documento.');
        } else if (document.length > 40) {
          err('documentNumber', 'too_long', 'Até 40 caracteres.');
        }
      case DocumentType.none:
        if (document != null) err('documentNumber', 'not_allowed', 'Sem documento: deixe o número em branco.');
    }

    final email = clean(d.email)?.toLowerCase();
    if (email != null && (email.length > 254 || !_email.hasMatch(email))) {
      err('email', 'invalid', 'E-mail inválido.');
    }

    final rawPhone = clean(d.phone);
    final phone = rawPhone == null ? null : Phones.toE164(rawPhone);
    if (rawPhone != null && phone == null) err('phone', 'invalid', 'Telefone inválido. Use DDD + número.');

    if (errors.isNotEmpty) return (draft: null, errors: errors);
    return (
      draft: CustomerDraft(
        code: code,
        name: name!,
        tradeName: tradeName,
        personType: d.personType,
        documentType: d.documentType,
        documentNumber: document,
        stateRegistration: stateRegistration,
        email: email,
        phone: phone,
        notes: notes,
        kind: d.kind,
        skipTriage: d.skipTriage,
      ),
      errors: const [],
    );
  }
}
