import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/work_order/presentation/ui_mappers/work_order_status_color_mapper.dart';
import 'package:workorder_company_app/features/work_order/presentation/ui_mappers/work_order_status_icon_mapper.dart';

class WorkOrderStatusChip extends StatelessWidget {
  final WorkOrderStatus status;

  const WorkOrderStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status.color.withAlpha(15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: status.color.withAlpha(3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, color: status.color, size: 16),
          const SizedBox(width: 6),
          Text(
            status.displayName,
            style: TextStyle(
              color: status.color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
