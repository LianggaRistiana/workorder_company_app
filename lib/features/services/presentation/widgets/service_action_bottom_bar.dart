import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/shared/utils/confirm_dialog.dart';

class ServiceActionBottomBar extends StatelessWidget {
  final VoidCallback? onRemove;
  final bool isActive;
  final VoidCallback? onToggleActive;
  const ServiceActionBottomBar(
      {super.key, this.onRemove, this.onToggleActive, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      IconButton(
          onPressed: () async {
            final confirm = await showConfirmDialog(
              context: context,
              title: "Hapus Layanan",
              message: "Apakah Anda yakin ingin menghapus Layanan ini?",
              icon: AppIcon.delete,
              confirmText: "Ya, Hapus",
              type: ConfirmDialogType.danger,
            );

            if (confirm != true) return;
            if (!context.mounted) return;
            onRemove?.call();
          },
          icon: Icon(
            AppIcon.delete,
            size: 18,
            color: Theme.of(context).colorScheme.error,
          )),
      const SizedBox(width: 8),
      FilledButton.icon(
          onPressed: onToggleActive,
          label: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(isActive ? AppIcon.inactiveState : AppIcon.activeState),
            const SizedBox(width: 8),
            Text(isActive ? "Nonaktifkan Layanan" : "Aktifkan Layanan")
          ]))
    ]);
  }
}
