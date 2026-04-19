import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/work_order/presentation/ui_mappers/work_order_status_color_mapper.dart';
import 'package:workorder_company_app/features/work_order/presentation/ui_mappers/work_order_status_icon_mapper.dart';

class WorkOrderStatusIcon extends StatelessWidget {
  final WorkOrderStatus status;
  const WorkOrderStatusIcon({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: status.color.withAlpha(50),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(status.icon, color: status.color, size: 28),
    );
  }
}
