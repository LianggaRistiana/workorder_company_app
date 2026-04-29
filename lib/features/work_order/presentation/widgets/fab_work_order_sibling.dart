import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/work_order/domain/meta/work_order_meta.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/work_order_status_icon.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/shared/widgets/custom_list.dart';
import 'package:workorder_company_app/shared/widgets/app_bottom_sheet.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';

class FabWorkOrderSibling extends StatelessWidget {
  final WorkOrderSiblings siblings;
  final String currentWorkOrderId;
  const FabWorkOrderSibling(
      {super.key, required this.siblings, required this.currentWorkOrderId});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: null,
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
      onPressed: () => _openBottomSheet(context),
      child: Icon(AppIcon.branch),
    );
  }

  void _openBottomSheet(BuildContext context) {
    showAppBottomSheet(
      context,
      header: Row(
        children: [
          Expanded(
              child: PropertyTitle(
                  icon: AppIcon.branch, label: "Perintah Kerja terkait")),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: () => context.pop(),
            tooltip: "Tutup",
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).disabledColor.withAlpha(80),
              foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            icon: const Icon(Icons.close),
          )
        ],
      ),
      content: SingleChildScrollView(
        child: CustomList(
            items: siblings.siblings,
            separatorHeight: AppSpacing.sm,
            itemBuilder: (item, _) => InkWell(
                  onTap: () {
                    context.pop();
                    context
                        .pop(); // HACK : Observe this, if any bug occur during switch work order, remove this double pop
                    context.push(AppRoutes.workOrdersDetail.fillId(item.id));
                  },
                  child: Row(
                    children: [
                      WorkOrderStatusIcon(status: item.status),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          child: Text(
                        item.code,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.titleSmall,
                      )),
                      if (item.id == currentWorkOrderId)
                        Icon(
                          color: Theme.of(context).colorScheme.primary,
                          AppIcon.selected,
                        )
                    ],
                  ),
                )),
      ),
    );
  }
}
