import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/presentation/widgets/work_order_status_icon.dart';

class WorkOrderItemCard extends StatelessWidget {
  final VoidCallback? onTap;
  final WorkOrderEntity workOrder;

  const WorkOrderItemCard({
    super.key,
    this.onTap,
    required this.workOrder,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.only(
            top: AppSpacing.sm,
            bottom: AppSpacing.sm,
            left: AppSpacing.md,
            right: AppSpacing.lg,
          ),
          child: Row(children: [
            WorkOrderStatusIcon(status: workOrder.status),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workOrder.code,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Text(
                        workOrder.service.title,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      const Spacer(),
                      if (workOrder.statusDate.createdAt != null) ...[
                        Text(
                          DateFormat('d MMM yyyy', 'id_ID')
                              .format(workOrder.statusDate.createdAt!),
                          textAlign: TextAlign.end,
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      ],
                    ],
                  )
                ],
              ),
            ),
          ])),
    );
  }
}
