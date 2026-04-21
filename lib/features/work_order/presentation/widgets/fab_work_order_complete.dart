import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/shared/widgets/app_dialog.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';

class FabWorkOrderComplete extends StatelessWidget {
  final void Function(String issue) onSubmit;
  const FabWorkOrderComplete({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        icon: Icon(AppIcon.complete),
        onPressed: () {
          _showIssueDialog(context);
        },
        label: Text('Selesaikan'));
  }

  void _showIssueDialog(BuildContext context) {
    final controller = TextEditingController();

    showAppDialog(
      context,
      header: Row(
        children: [
          IconBox.small(icon: AppIcon.complete),
          const SizedBox(width: 8),
          const Text("Selesaikan perintah kerja"),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InformationBlock.warning(
              "Setelah diselesaikan, status tidak dapat diubah kembali.\n\nDengan mengisi kendala, perintah kerja akan menjadi selesai dengan isu"),
          const SizedBox(height: 12),
          CustomInputField(
            label: "Catatan Kendala",
            controller: controller,
            maxLines: 3,
          ),
          const SizedBox(height: 12),
        ],
      ),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text("Batal"),
          ),
          FilledButton(
            onPressed: () {
              final text = controller.text.trim();

              context.pop();
              onSubmit(text);
            },
            child: const Text("Kirim"),
          ),
        ],
      ),
    );
  }
}
