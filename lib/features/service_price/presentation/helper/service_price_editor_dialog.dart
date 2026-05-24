import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_summary_entity.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/service_config_view.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/app_dialog.dart';
import 'package:workorder_company_app/shared/widgets/custom_input_field.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';

void servicePriceEditorDialog(
  BuildContext context,
  ServiceSummaryEntity serviceSelected,
  int? price,
  void Function(int price, ServiceSummaryEntity service) onSubmit,
) {
  final controller = TextEditingController(
    text: price != null ? price.toString() : '',
  );

  final isEdit = price != null;

  showAppDialog(
    context,
    header: Row(
      children: [
        IconBox.small(icon: AppIcon.workOrder),
        const SizedBox(width: 8),
        Text(
          isEdit ? "Edit Harga Layanan" : "Tambah Harga Layanan",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InformationBlock.info(
          "Harga akan digunakan sebagai acuan biaya layanan pada permintaan layanan.",
        ),
        const SizedBox(height: 16),
        CustomInputField(
          controller: controller,
          label: "Harga Layanan",
          keyboardType: TextInputType.number,
        ),
        ServiceConfigView(service: serviceSelected),
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
        const SizedBox(width: 8),
        FilledButton(
          onPressed: () {
            final value = int.tryParse(controller.text);

            if (value == null || value <= 0) {
              context.showError("Harga tidak valid");
              return;
            }

            context.pop();
            onSubmit(value, serviceSelected);
          },
          child: Text(
            isEdit ? "Simpan" : "Tambah",
          ),
        ),
      ],
    ),
  );
}
