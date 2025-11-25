import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/workorder/domain/entitties/workorder__entity.dart';
import 'package:workorder_company_app/features/workorder/presentation/widgets/staff_count_chip.dart';
import 'package:workorder_company_app/features/workorder/presentation/widgets/workorder_status_chip.dart';
import 'package:workorder_company_app/features/workorder/presentation/widgets/workorder_status_icon.dart';

class WorkorderItem extends StatelessWidget {
  final WorkorderEntity workorder;
  final VoidCallback? onTap;

  const WorkorderItem({super.key, required this.workorder, this.onTap});

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
          child: Row(
            children: [
              WorkOrderStatusIcon(
                status: workorder.status,
                width: 60,
                height: 70,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(workorder.service.title,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    Row(children: [
                      WorkOrderStatusChip(
                        status: workorder.status,
                        showIcon: false,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      StaffCountChip(
                          staffCount: workorder.assignedStaffs?.length ?? 0),
                      Expanded(
                          child: Text(
                              DateFormat('d MMM yyyy', 'id_ID')
                                  .format(workorder.createdAt),
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.bodySmall))
                    ]),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
