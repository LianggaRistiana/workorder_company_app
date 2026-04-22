import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_summary_entity.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/service_config_view.dart';
import 'package:workorder_company_app/shared/widgets/app_dialog.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';

void showWorkOrderCreateConfirmDialog(
  BuildContext context,
  ServiceSummaryEntity serviceSelected,
) {
  showAppDialog(
    context,
    header: Row(
      children: [
        IconBox.small(icon: AppIcon.workOrder),
        const SizedBox(width: 8),
        const Text("Buat Perintah Kerja"),
      ],
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Anda akan membuat perintah kerja untuk layanan berikut"),
        ServiceConfigView(service: serviceSelected),
        InformationBlock.info(
            "Perintah kerja akan dibuat tanpa adanya permintaan layanan")
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
            context.pop(serviceSelected);
          },
          child: const Text("Buat"),
        ),
      ],
    ),
  );
}
