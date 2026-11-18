import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:plataforma_os_server/src/platform/email/email.dart';
import 'package:plataforma_os_server/src/platform/email/templates.dart';
import 'package:test/test.dart';

/// Servidor SMTP mínimo, sem TLS e sem autenticação: guarda o envelope e o
/// conteúdo de cada mensagem.
class FakeSmtp {
  FakeSmtp._(this._server);

  final ServerSocket _server;
  final messages = <({String from, List<String> to, String data})>[];

  int get port => _server.port;

  static Future<FakeSmtp> start() async {
    final smtp = FakeSmtp._(await ServerSocket.bind(InternetAddress.loopbackIPv4, 0));
    smtp._server.listen(smtp._handle);
    return smtp;
  }

  Future<void> close() => _server.close();

  void _handle(Socket socket) {
    var from = '';
    var to = <String>[];
    StringBuffer? data;
    void reply(String line) => socket.write('$line\r\n');
    reply('220 fake.smtp ESMTP');
    utf8.decoder.bind(socket).transform(const LineSplitter()).listen((line) {
      if (data != null) {
        if (line == '.') {
          messages.add((from: from, to: to, data: data.toString()));
          data = null;
          reply('250 OK queued');
        } else {
          data!.writeln(line.startsWith('..') ? line.substring(1) : line);
        }
        return;
      }
      final cmd = line.toUpperCase();
      if (cmd.startsWith('EHLO') || cmd.startsWith('HELO')) {
        reply('250-fake.smtp');
        reply('250 8BITMIME');
      } else if (cmd.startsWith('MAIL FROM:')) {
        from = line.substring(10).trim();
        to = [];
        reply('250 OK');
      } else if (cmd.startsWith('RCPT TO:')) {
        to.add(line.substring(8).trim());
        reply('250 OK');
      } else if (cmd == 'DATA') {
        data = StringBuffer();
        reply('354 End data with <CR><LF>.<CR><LF>');
      } else if (cmd == 'QUIT') {
        reply('221 Bye');
        socket.close();
      } else {
        reply('250 OK');
      }
    }, onError: (_) {});
  }
}

/// Partes base64 da mensagem MIME, decodificadas.
List<String> _decodedParts(String data) => [
  for (final part in data.split(RegExp(r'--mailer-[^\n]*\n')))
    if (part.contains('content-transfer-encoding: base64'))
      utf8.decode(base64.decode(part.split('\n\n').skip(1).join().replaceAll(RegExp(r'\s'), ''))),
];

void main() {
  group('SMTP', () {
    late FakeSmtp smtp;
    setUp(() async => smtp = await FakeSmtp.start());
    tearDown(() => smtp.close());

    test('entrega texto e HTML com remetente e destinatário', () async {
      final sender = SmtpEmailSender(
        host: '127.0.0.1',
        port: smtp.port,
        allowInsecure: true,
        from: 'nao-responda@plataforma.test',
      );
      await sender.deliver(
        EmailTemplates.verificationCode(to: 'ana@frio-sul.test', code: '482913', passwordReset: false),
      );
      final m = smtp.messages.single;
      expect(m.from, contains('nao-responda@plataforma.test'));
      expect(m.to.single, contains('ana@frio-sul.test'));
      expect(m.data, contains('text/html'));
      final text = _decodedParts(m.data).join('\n');
      expect(text, contains('482913'));
      expect(text, contains('criar a sua senha'));
    });

    test('sem TLS no servidor e sem allowInsecure, recusa', () async {
      final sender = SmtpEmailSender(host: '127.0.0.1', port: smtp.port, from: 'x@plataforma.test');
      await expectLater(
        sender.deliver(const EmailMessage(to: 'a@b.test', subject: 'oi', text: 'oi')),
        throwsA(anything),
      );
      expect(smtp.messages, isEmpty);
    });
  });

  group('modelos', () {
    test('código de primeiro acesso e de troca de senha', () {
      final first = EmailTemplates.verificationCode(to: 'a@b.test', code: '123456', passwordReset: false);
      expect(first.subject, 'Código de primeiro acesso: 123456');
      expect(first.text, contains('criar a sua senha'));
      final reset = EmailTemplates.verificationCode(to: 'a@b.test', code: '654321', passwordReset: true);
      expect(reset.subject, 'Código para trocar a senha: 654321');
      expect(reset.html, contains('654321'));
    });

    test('convite: primeiro acesso ou quem já tem senha; HTML escapado', () {
      final novo = EmailTemplates.invite(
        to: 'eva@frio-sul.test',
        fullName: 'Eva Lima',
        hasLogin: false,
        tenantName: 'Frio Sul <Refrigeração>',
        invitedBy: 'Ana Admin',
        url: 'https://app.plataforma.test',
      );
      expect(novo.subject, 'Convite: equipe da Frio Sul <Refrigeração>');
      expect(novo.text, startsWith('Olá, Eva.'));
      expect(novo.text, contains('Ana Admin convidou você'));
      expect(novo.text, contains('"Primeiro acesso"'));
      expect(novo.html, contains('Frio Sul &lt;Refrigeração&gt;'));
      expect(novo.html, contains('href="https://app.plataforma.test"'));

      final antigo = EmailTemplates.invite(
        to: 'eva@frio-sul.test',
        fullName: 'Eva',
        hasLogin: true,
        tenantName: 'Frio Sul',
        invitedBy: null,
        url: 'https://app.plataforma.test',
      );
      expect(antigo.text, contains('a senha de sempre'));
      expect(antigo.text, contains('Você recebeu um convite'));
    });
  });
}
