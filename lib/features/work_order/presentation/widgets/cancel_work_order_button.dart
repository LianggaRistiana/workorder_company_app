import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/meta/work_order_meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/work_order/domain/authorization/work_order_authorizer.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/cancel/cancel_work_order_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/cancel/cancel_work_order_state.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/work_order_status_chip.dart';
import 'package:workorder_company_app/shared/widgets/app_dialog.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';
import 'package:workorder_company_app/shared/widgets/loading_state_inline.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';

class CancelWorkOrderButton extends StatelessWidget {
  final WorkOrderEntity workOrder;
  final WorkOrderCapabilities? capabilities;
  final WorkOrderSiblings? siblings;

  const CancelWorkOrderButton(
      {super.key, required this.workOrder, this.capabilities, this.siblings});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CancelWorkOrderCubit, CancelWorkOrderState>(
        builder: (context, state) {
      return HorizontalButton(
              onTap: () {
                _showDialog(context);
              },
              isDanger: true,
              title: "Batalkan Perintah Kerja",
              description:
                  "Saat Perintah Kerja dibatalkan, semua perintah kerja terkait akan ikut dibatalkan",
              leadingIcon: AppIcon.cancel)
          .withInlineLoading(state.isLoading, isEndAlign: false);
    }).require(
        WorkOrderAuthorizer(workOrder: workOrder, capabilities: capabilities)
            .cancelWorkOrder);
  }

  void _showDialog(BuildContext context) {
    final siblingList =
        siblings?.siblings.where((e) => e.id != workOrder.id).toList() ?? [];

    showAppDialog(
      context,
      header: Row(
        children: [
          IconBox.small(
            icon: AppIcon.cancel,
            iconColor: Theme.of(context).colorScheme.error,
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
          ),
          const SizedBox(width: 8),
          const Text("Batalkan perintah kerja"),
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          InformationBlock.warning(
            siblings?.hasMultipleSiblings ?? false
                ? "Perintah kerja ini memiliki pekerjaan terkait. Membatalkan akan membatalkan seluruh pekerjaan yang saling terhubung."
                : "Perintah kerja ini akan dibatalkan dan tidak dapat dilanjutkan kembali.",
          ),
          if (siblings?.hasMultipleSiblings ?? false) ...[
            const SizedBox(height: AppSpacing.md),
            PropertyTitle(
              label: "Perintah Kerja Terkait",
              icon: AppIcon.workOrder,
            ),
            const SizedBox(height: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: siblingList
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(item.code,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleSmall),
                          ),
                          Spacer(),
                          WorkOrderStatusChip(status: item.status),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.md),
          ]
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
              context.pop();
              context.read<CancelWorkOrderCubit>().cancelWorkOrder(workOrder);
            },
            child: const Text("Batalkan Perintah Kerja"),
          ),
        ],
      ),
    );
  }
}
