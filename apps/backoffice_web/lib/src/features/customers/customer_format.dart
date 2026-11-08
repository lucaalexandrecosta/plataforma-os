import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:plataforma_os_core/plataforma_os_core.dart';

/// Rótulos e máscaras do cadastro de clientes, em um lugar só.
abstract final class CustomerFormat {
  static String document(Customer c) {
    final n = c.documentNumber;
    if (n == null) return '—';
    return switch (c.documentType) {
      DocumentType.cnpj || DocumentType.cpf => BrDocuments.format(n),
      _ => n,
    };
  }

  static String documentLabel(DocumentType t) => switch (t) {
    DocumentType.cnpj => 'CNPJ',
    DocumentType.cpf => 'CPF',
    DocumentType.foreign => 'Documento estrangeiro',
    DocumentType.none => 'Sem documento',
  };

  static String personLabel(PersonType t) => switch (t) {
    PersonType.company => 'Empresa',
    PersonType.individual => 'Pessoa física',
  };

  /// `+5551999990001` → `(51) 99999-0001`; estrangeiro fica como está.
  static String phone(String? e164) {
    if (e164 == null) return '—';
    final m = RegExp(r'^\+55(\d{2})(\d{4,5})(\d{4})$').firstMatch(e164);
    if (m == null) return e164;
    return '(${m[1]}) ${m[2]}-${m[3]}';
  }
}
