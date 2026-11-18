import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:serverpod_client/serverpod_client.dart' show UuidValue;

import '../../api/gateway.dart';
import '../../labels.dart';
import '../../local/providers.dart';
import '../common/errors.dart';

/// Converte o quadro da assinatura em PNG. Os testes de widget trocam por
/// uma imagem fixa (a renderização real só termina fora do relógio falso).
final signatureImageProvider = Provider<Future<Uint8List> Function(RenderRepaintBoundary)>(
  (ref) => (boundary) async {
    final image = await boundary.toImage(pixelRatio: 2);
    try {
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      return data!.buffer.asUint8List();
    } finally {
      image.dispose();
    }
  },
);

/// Assinatura de quem recebeu o atendimento (docs/06 §5.13): nome, papel,
/// documento opcional e o traço no quadro, convertido em PNG. Fica no
/// aparelho e vai com o sync, como o resto da visita.
class SignaturePage extends ConsumerStatefulWidget {
  const SignaturePage({super.key, required this.visitId});

  final UuidValue visitId;

  @override
  ConsumerState<SignaturePage> createState() => _SignaturePageState();
}

class _SignaturePageState extends ConsumerState<SignaturePage> {
  final _name = TextEditingController();
  final _document = TextEditingController();
  final _padKey = GlobalKey();
  final _strokes = <List<Offset>>[];
  var _role = 'site_manager';
  var _busy = false;
  String? _nameError;

  @override
  void dispose() {
    _name.dispose();
    _document.dispose();
    super.dispose();
  }

  bool get _signed => _strokes.any((s) => s.length > 1);

  Future<void> _save(Visit visit) async {
    final store = ref.read(storeProvider);
    if (store == null) return;
    if (_name.text.trim().isEmpty) {
      setState(() => _nameError = 'Informe o nome.');
      return;
    }
    if (!_signed) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Peça para a pessoa assinar no quadro.')));
      return;
    }
    setState(() => _busy = true);
    try {
      final boundary = _padKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final png = await ref.read(signatureImageProvider)(boundary);
      await store.captureSignature(
        visit,
        png,
        signerName: _name.text,
        signerDocument: _document.text,
        signerRole: _role,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Assinatura registrada.')));
      Navigator.of(context).pop();
    } on GatewayException catch (e) {
      if (mounted) reportError(context, ref, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = ref.watch(storeProvider);
    if (store == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final theme = Theme.of(context);
    return StreamBuilder<Visit?>(
      stream: store.watchVisit(widget.visitId),
      builder: (context, snap) {
        final visit = snap.data;
        return Scaffold(
          appBar: AppBar(title: const Text('Assinatura do cliente')),
          body: visit == null
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    Text(
                      'OS ${visit.workOrderNumber} · ${visit.customerName ?? ''}',
                      style: theme.textTheme.titleSmall,
                    ),
                    if (visit.outcomeNotes case final notes?) Text(notes, style: theme.textTheme.bodySmall),
                    const SizedBox(height: 12),
                    TextField(
                      key: const Key('signer-name'),
                      controller: _name,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: 'Nome de quem assina',
                        border: const OutlineInputBorder(),
                        errorText: _nameError,
                      ),
                      onChanged: (_) => _nameError == null ? null : setState(() => _nameError = null),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (final MapEntry(:key, :value) in signerRoleLabels.entries)
                          ChoiceChip(
                            key: Key('signer-role-$key'),
                            label: Text(value),
                            selected: _role == key,
                            onSelected: (_) => setState(() => _role = key),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      key: const Key('signer-document'),
                      controller: _document,
                      decoration: const InputDecoration(
                        labelText: 'Documento (opcional)',
                        helperText: 'CPF, RG ou matrícula. Fica só no servidor.',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: Text('Assine abaixo', style: theme.textTheme.labelLarge)),
                        TextButton.icon(
                          key: const Key('signature-clear'),
                          onPressed: _strokes.isEmpty ? null : () => setState(_strokes.clear),
                          icon: const Icon(Icons.restart_alt),
                          label: const Text('Limpar'),
                        ),
                      ],
                    ),
                    RepaintBoundary(
                      key: _padKey,
                      child: Container(
                        key: const Key('signature-pad'),
                        height: 220,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: theme.colorScheme.outline),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: GestureDetector(
                          onPanStart: (d) => setState(() => _strokes.add([d.localPosition])),
                          onPanUpdate: (d) => setState(() => _strokes.last.add(d.localPosition)),
                          child: CustomPaint(painter: _SignaturePainter(_strokes), size: Size.infinite),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ao assinar, a pessoa confirma o atendimento desta visita.',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
          bottomNavigationBar: visit == null
              ? null
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: FilledButton.icon(
                      key: const Key('signature-save'),
                      style: ButtonStyle(minimumSize: WidgetStateProperty.all(const Size.fromHeight(52))),
                      icon: const Icon(Icons.draw),
                      label: const Text('Confirmar assinatura'),
                      onPressed: _busy ? null : () => _save(visit),
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class _SignaturePainter extends CustomPainter {
  _SignaturePainter(this.strokes);

  final List<List<Offset>> strokes;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    for (final s in strokes) {
      if (s.length < 2) continue;
      final path = Path()..moveTo(s.first.dx, s.first.dy);
      for (final p in s.skip(1)) {
        path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_SignaturePainter old) => true;
}
