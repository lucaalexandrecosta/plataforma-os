import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Peças de layout dos formulários de cadastro.

/// Cartão com título e campos que quebram linha conforme a largura.
class FormSection extends StatelessWidget {
  const FormSection({super.key, required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Wrap(spacing: 16, runSpacing: 8, children: children),
          ],
        ),
      ),
    ),
  );
}

/// Campo com largura preferida; encolhe em telas estreitas.
class FieldBox extends StatelessWidget {
  const FieldBox({super.key, required this.width, required this.child});
  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: BoxConstraints(maxWidth: width, minWidth: width < 300 ? width : 280),
    child: SizedBox(width: width, child: child),
  );
}

/// Aviso informativo no topo do formulário (somente leitura, ERP).
class InfoBanner extends StatelessWidget {
  const InfoBanner({super.key, required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: scheme.secondaryContainer, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Icon(icon, color: scheme.onSecondaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: TextStyle(color: scheme.onSecondaryContainer)),
          ),
        ],
      ),
    );
  }
}

/// Cabeçalho das telas de cadastro: voltar, título, inativar/reativar,
/// salvar e os selos (situação, ERP, versão, última alteração).
class RecordHeader extends StatelessWidget {
  const RecordHeader({
    required this.title,
    required this.isNew,
    required this.canManage,
    required this.saving,
    required this.backPath,
    required this.onSave,
    this.isActive,
    this.fromErp = false,
    this.version,
    this.updatedAt,
    this.onToggleActive,
    this.readOnlyMessage,
    this.erpMessage,
    super.key,
  });

  final String title;
  final bool isNew;
  final bool canManage;
  final bool saving;
  final String backPath;
  final VoidCallback onSave;
  final bool? isActive;
  final bool fromErp;
  final int? version;
  final DateTime? updatedAt;

  /// `null` = sem botão (ex.: registro do ERP).
  final VoidCallback? onToggleActive;
  final String? readOnlyMessage;
  final String? erpMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconButton(
              tooltip: 'Voltar',
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.canPop() ? context.pop() : context.go(backPath),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(title, style: theme.textTheme.headlineSmall)),
            if (!isNew && canManage && isActive != null)
              OutlinedButton.icon(
                onPressed: saving ? null : onToggleActive,
                icon: Icon(isActive! ? Icons.block : Icons.restart_alt),
                label: Text(isActive! ? 'Inativar' : 'Reativar'),
              ),
            const SizedBox(width: 12),
            if (canManage)
              FilledButton.icon(
                onPressed: saving ? null : onSave,
                icon: saving
                    ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.save_outlined),
                label: Text(isNew ? 'Cadastrar' : 'Salvar'),
              ),
          ],
        ),
        if (!isNew) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 56),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (isActive != null) Chip(label: Text(isActive! ? 'Ativo' : 'Inativo')),
                if (fromErp) const Chip(avatar: Icon(Icons.sync, size: 16), label: Text('Vem do ERP')),
                if (version != null) Chip(label: Text('Versão $version')),
                if (updatedAt != null)
                  Chip(
                    label: Text(
                      'Atualizado em ${DateFormat("dd/MM/yyyy 'às' HH:mm", 'pt_BR').format(updatedAt!.toLocal())}',
                    ),
                  ),
              ],
            ),
          ),
        ],
        if (!canManage && readOnlyMessage != null) ...[
          const SizedBox(height: 12),
          InfoBanner(icon: Icons.visibility_outlined, text: readOnlyMessage!),
        ],
        if (fromErp && erpMessage != null) ...[
          const SizedBox(height: 12),
          InfoBanner(icon: Icons.sync, text: erpMessage!),
        ],
      ],
    );
  }
}
