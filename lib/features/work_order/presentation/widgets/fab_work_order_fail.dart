import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/utils/validators.dart';
import 'package:workorder_company_app/shared/widgets/app_dialog.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';

class FabWorkOrderFail extends StatelessWidget {
  final void Function(String issue) onSubmit;

  const FabWorkOrderFail({
    super.key,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
      foregroundColor: Theme.of(context).colorScheme.error,
      onPressed: () {
        _showDialog(context);
      },
      child: Icon(AppIcon.fail),
    );
  }

  void _showDialog(BuildContext context) {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showAppDialog(
      context,
      header: Row(
        children: [
          IconBox.small(
            icon: AppIcon.fail,
            iconColor: Theme.of(context).colorScheme.error,
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
          ),
          const SizedBox(width: 8),
          const Text("Gagalkan perintah kerja"),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InformationBlock.warning(
              "Status gagal bersifat final dan akan menghentikan alur pekerjaan. Pastikan keputusan sudah benar sebelum melanjutkan."),
          const SizedBox(height: 12),
          Form(
            key: formKey,
            child: CustomInputField(
              label: "Alasan",
              controller: controller,
              maxLines: 3,
              validator: (value) {
                return ValidatorUtils.single(
                  value,
                  fieldName: "Alasan",
                  ValidatorType.required,
                );
              },
            ),
          ),
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
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              final isValid = formKey.currentState?.validate() ?? false;

              if (!isValid) return;

              final text = controller.text.trim();

              context.pop();
              onSubmit(text);
            },
            child: const Text("Gagalkan"),
          ),
        ],
      ),
    );
  }
}
