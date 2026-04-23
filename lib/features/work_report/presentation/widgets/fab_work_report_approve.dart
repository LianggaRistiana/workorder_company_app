import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/shared/widgets/app_dialog.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';

class FabWorkReportApprove extends StatelessWidget {
  final VoidCallback onPressed;
  const FabWorkReportApprove({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        icon: Icon(AppIcon.approve),
        onPressed: () => _showDialog(context),
        label: Text('Setujui'));
  }

  void _showDialog(BuildContext context) {
    showAppDialog(
      context,
      header: Row(
        children: [
          IconBox.small(icon: AppIcon.approve),
          const SizedBox(width: 8),
          const Text("Setujui Laporan Kerja"),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InformationBlock.info(
              "Menyetujui laporan kerja ini akan membuat laporan menjadi final dan perintah kerja dapat diselesaikan."),
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
            child: const Text("Batal"),
          ),
          FilledButton(
            onPressed: () {
              context.pop();
              onPressed();
            },
            child: const Text("Setujui"),
          ),
        ],
      ),
    );
  }
}
