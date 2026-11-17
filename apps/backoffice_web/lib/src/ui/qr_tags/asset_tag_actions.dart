import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import '../../api/gateway.dart';
import '../../labels.dart';
import '../../session/session.dart';
import '../common/errors.dart';
import '../work_orders/reason_dialog.dart';

/// Etiqueta do bem na ficha: vincular uma etiqueta impressa (código curto),
/// desvincular (`qr_tags.unbind`) ou revogar a etiqueta atual
/// (`qr_tags.manage`). [onChanged] recarrega a ficha.
class AssetTagActions extends ConsumerStatefulWidget {
  const AssetTagActions({super.key, required this.asset, required this.onChanged});

  final Asset asset;
  final VoidCallback onChanged;

  @override
  ConsumerState<AssetTagActions> createState() => _AssetTagActionsState();
}

class _AssetTagActionsState extends ConsumerState<AssetTagActions> {
  var _busy = false;

  Future<void> _run(Future<void> Function(Gateway g) action, String done) async {
    setState(() => _busy = true);
    try {
      await action(ref.read(gatewayProvider));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(done)));
      widget.onChanged();
    } on GatewayException catch (e) {
      if (mounted) reportError(context, ref, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _bind() async {
    final code = await showDialog<String>(context: context, builder: (_) => const _BindDialog());
    if (code == null) return;
    await _run((g) => g.bindQrTag(code, widget.asset.id), 'Etiqueta vinculada ao bem.');
  }

  Future<void> _unbind() async {
    final sure = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Desvincular a etiqueta?'),
        content: Text(
          'A etiqueta ${widget.asset.qrShortCode} deixa de apontar para este bem e pode ser usada em outro. '
          'A mudança fica registrada.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Voltar')),
          FilledButton(
            key: const Key('confirm-unbind'),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Desvincular'),
          ),
        ],
      ),
    );
    if (sure != true) return;
    await _run((g) async => g.unbindQrTag(await g.resolveQrTag(widget.asset.qrShortCode!)), 'Etiqueta desvinculada.');
  }

  Future<void> _revoke() async {
    final result = await showDialog<ReasonResult>(
      context: context,
      builder: (_) => ReasonDialog(
        title: 'Revogar a etiqueta ${widget.asset.qrShortCode}?',
        confirmLabel: 'Revogar',
        reasons: qrRevokeReasonLabels,
        noteLabel: 'Observação',
        destructive: true,
      ),
    );
    if (result == null) return;
    await _run(
      (g) async => g.revokeQrTag(await g.resolveQrTag(widget.asset.qrShortCode!), result.reason!, note: result.note),
      'Etiqueta revogada. Vincule uma nova ao bem.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final canManage = session is SignedIn && session.can('qr_tags.manage');
    final canUnbind = session is SignedIn && session.can('qr_tags.unbind');
    final a = widget.asset;
    final tagged = a.qrShortCode != null;
    return Wrap(
      spacing: 8,
      children: [
        if (!tagged && canManage && a.isActive && a.status != 'retired')
          OutlinedButton.icon(
            key: const Key('tag-bind'),
            onPressed: _busy ? null : _bind,
            icon: const Icon(Icons.qr_code),
            label: const Text('Vincular etiqueta'),
          ),
        if (tagged && canUnbind)
          OutlinedButton(
            key: const Key('tag-unbind'),
            onPressed: _busy ? null : _unbind,
            child: const Text('Desvincular'),
          ),
        if (tagged && canManage)
          OutlinedButton(key: const Key('tag-revoke'), onPressed: _busy ? null : _revoke, child: const Text('Revogar')),
      ],
    );
  }
}

class _BindDialog extends StatefulWidget {
  const _BindDialog();

  @override
  State<_BindDialog> createState() => _BindDialogState();
}

class _BindDialogState extends State<_BindDialog> {
  final _form = GlobalKey<FormState>();
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  void _submit() {
    if (_form.currentState!.validate()) Navigator.of(context).pop(_code.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Vincular etiqueta'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _form,
          child: TextFormField(
            key: const Key('tag-code'),
            controller: _code,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Código da etiqueta',
              hintText: 'ABCD-2345',
              helperText: 'O código impresso embaixo do QR (ou a URL lida).',
              border: OutlineInputBorder(),
            ),
            validator: (v) => v == null || v.trim().isEmpty ? 'Informe o código.' : null,
            onFieldSubmitted: (_) => _submit(),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
        FilledButton(key: const Key('tag-bind-ok'), onPressed: _submit, child: const Text('Vincular')),
      ],
    );
  }
}
