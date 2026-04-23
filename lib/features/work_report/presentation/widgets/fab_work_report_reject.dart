import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/shared/widgets/app_dialog.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';

class FabWorkReportReject extends StatelessWidget {
  final VoidCallback onPressed;

  const FabWorkReportReject({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
      foregroundColor: Theme.of(context).colorScheme.error,
      onPressed: () => _showDialog(context),
      child: Icon(AppIcon.reject),
    );
  }

  void _showDialog(BuildContext context) {
    showAppDialog(
      context,
      header: Row(
        children: [
          IconBox.small(
            icon: AppIcon.reject,
            iconColor: Theme.of(context).colorScheme.error,
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
          ),
          const SizedBox(width: 8),
          const Text("Tolak Laporan Kerja"),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InformationBlock.warning(
              "Jika ditolak, laporan kerja akan dikembalikan kepada pegawai untuk dilakukan pengisian kembali."),
        ],
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () => context.pop(),
            child: const Text("Tolak"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              context.pop();
              onPressed();
            },
            child: const Text("Tolak"),
          ),
        ],
      ),
    );
  }
}
