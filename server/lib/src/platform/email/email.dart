import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server.dart' as mailer;
import 'package:serverpod/serverpod.dart';

/// Um e-mail para uma pessoa: texto simples e, se houver, HTML.
class EmailMessage {
  const EmailMessage({required this.to, required this.subject, required this.text, this.html});

  final String to;
  final String subject;
  final String text;
  final String? html;
}

/// Quem entrega os e-mails da plataforma.
abstract interface class EmailSender {
  Future<void> send(Session session, EmailMessage message);
}

/// Desenvolvimento e teste: escreve o e-mail no log em vez de enviar.
class LogEmailSender implements EmailSender {
  const LogEmailSender();

  @override
  Future<void> send(Session session, EmailMessage message) async =>
      session.log('E-mail para ${message.to} · ${message.subject}\n${message.text}', level: LogLevel.info);
}

/// Envio por SMTP (Amazon SES, ou qualquer provedor com SMTP). Usa STARTTLS
/// quando o servidor oferece; sem TLS só se [allowInsecure] (servidor local).
class SmtpEmailSender implements EmailSender {
  SmtpEmailSender({
    required String host,
    required this.from,
    this.fromName = 'Plataforma OS',
    int port = 587,
    bool ssl = false,
    bool allowInsecure = false,
    String? username,
    String? password,
    this.timeout = const Duration(seconds: 20),
  }) : _server = mailer.SmtpServer(
         host,
         port: port,
         ssl: ssl,
         allowInsecure: allowInsecure,
         username: username,
         password: password,
       );

  final String from;
  final String fromName;
  final Duration timeout;
  final mailer.SmtpServer _server;

  @override
  Future<void> send(Session session, EmailMessage message) => deliver(message);

  /// Envia sem precisar de sessão (o envio SMTP não usa o banco).
  Future<void> deliver(EmailMessage message) async {
    final mail = mailer.Message()
      ..from = mailer.Address(from, fromName)
      ..recipients = [message.to]
      ..subject = message.subject
      ..text = message.text
      ..html = message.html;
    await mailer.send(mail, _server, timeout: timeout);
  }
}

/// Configuração do e-mail, lida na subida do servidor.
///
/// Segredos (config/passwords.yaml em dev; variáveis
/// `SERVERPOD_PASSWORD_<chave>` no cofre em homologação e produção):
/// `smtpHost`, `smtpPort` (587), `smtpUsername`, `smtpPassword`, `emailFrom`
/// (remetente verificado), `smtpAllowInsecure` (`true` só para servidor
/// local de teste) e `backofficeUrl` (link dos convites).
///
/// Sem `smtpHost`: em desenvolvimento e teste os e-mails vão para o log; nos
/// outros modos o envio falha, para não engolir um código de acesso.
abstract final class Email {
  static EmailSender? _sender;
  static String _backofficeUrl = 'http://localhost:8082';

  static EmailSender? get sender => _sender;

  /// Endereço do backoffice usado nos links dos e-mails.
  static String get backofficeUrl => _backofficeUrl;

  static void configure(Serverpod pod) {
    final url = pod.getPassword('backofficeUrl');
    if (url != null && url.isNotEmpty) _backofficeUrl = url.replaceAll(RegExp(r'/+$'), '');
    final host = pod.getPassword('smtpHost');
    if (host != null && host.isNotEmpty) {
      final from = pod.getPassword('emailFrom') ?? (throw StateError('Segredo "emailFrom" ausente para o SMTP.'));
      _sender = SmtpEmailSender(
        host: host,
        port: int.tryParse(pod.getPassword('smtpPort') ?? '') ?? 587,
        // Vazio = sem autenticação (ex.: o Mailpit do infra/staging).
        username: switch (pod.getPassword('smtpUsername')) {
          final u? when u.isNotEmpty => u,
          _ => null,
        },
        password: pod.getPassword('smtpPassword'),
        allowInsecure: pod.getPassword('smtpAllowInsecure') == 'true',
        from: from,
      );
    } else if (pod.runMode == ServerpodRunMode.development || pod.runMode == ServerpodRunMode.test) {
      _sender = const LogEmailSender();
    } else {
      _sender = null;
    }
  }

  /// Troca o remetente (testes).
  static void useSender(EmailSender? sender) => _sender = sender;

  /// Envia agora. Lança [StateError] se o envio não estiver configurado e
  /// repassa a falha do provedor.
  static Future<void> send(Session session, EmailMessage message) async {
    final sender = _sender ?? (throw StateError('Envio de e-mail não configurado (smtpHost).'));
    await sender.send(session, message);
  }
}
