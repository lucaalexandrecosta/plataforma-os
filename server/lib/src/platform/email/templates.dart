import 'email.dart';

/// Textos dos e-mails da plataforma (português; HTML simples, sem imagens).
abstract final class EmailTemplates {
  static String _escape(String s) =>
      s.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;').replaceAll('"', '&quot;');

  static String _html(String title, List<String> paragraphs) =>
      '<!doctype html><html lang="pt-BR"><body style="font-family:Arial,sans-serif;font-size:15px;'
      'color:#1f2328;max-width:520px;margin:24px auto;line-height:1.5">'
      '<h2 style="font-size:18px">${_escape(title)}</h2>'
      '${paragraphs.join()}'
      '<p style="color:#6e7781;font-size:12px;margin-top:32px">Mensagem automática da Plataforma OS. '
      'Se você não esperava este e-mail, pode ignorá-lo.</p></body></html>';

  static String _p(String text) => '<p>${_escape(text)}</p>';

  /// Código de verificação do primeiro acesso ou da troca de senha.
  static EmailMessage verificationCode({required String to, required String code, required bool passwordReset}) {
    final what = passwordReset ? 'trocar a sua senha' : 'criar a sua senha de acesso';
    final subject = passwordReset ? 'Código para trocar a senha' : 'Código de primeiro acesso';
    final intro = 'Use este código para $what na Plataforma OS:';
    const validity = 'O código vale por 15 minutos. Não compartilhe com ninguém.';
    return EmailMessage(
      to: to,
      subject: '$subject: $code',
      text: '$intro\n\n$code\n\n$validity\n',
      html: _html(subject, [
        _p(intro),
        '<p style="font-size:28px;font-weight:bold;letter-spacing:6px">${_escape(code)}</p>',
        _p(validity),
      ]),
    );
  }

  /// Convite para a equipe de uma empresa.
  static EmailMessage invite({
    required String to,
    required String fullName,
    required bool hasLogin,
    required String tenantName,
    required String? invitedBy,
    required String url,
  }) {
    final first = fullName.trim().split(RegExp(r'\s+')).first;
    final line1 = invitedBy == null
        ? 'Você recebeu um convite para a equipe da $tenantName na Plataforma OS.'
        : '$invitedBy convidou você para a equipe da $tenantName na Plataforma OS.';
    final line2 = hasLogin
        ? 'Para entrar, abra $url com o seu e-mail ($to) e a senha de sempre, e escolha a $tenantName.'
        : 'Para entrar, abra $url, escolha "Primeiro acesso" e informe este e-mail ($to). '
              'Vamos mandar um código para você criar a sua senha.';
    final subject = 'Convite: equipe da $tenantName';
    return EmailMessage(
      to: to,
      subject: subject,
      text: 'Olá, $first.\n\n$line1\n\n$line2\n',
      html: _html(subject, [
        _p('Olá, $first.'),
        _p(line1),
        '<p><a href="${_escape(url)}" style="display:inline-block;background:#0b5cad;color:#fff;'
            'padding:10px 18px;border-radius:6px;text-decoration:none">Abrir a Plataforma OS</a></p>',
        _p(line2),
      ]),
    );
  }
}
