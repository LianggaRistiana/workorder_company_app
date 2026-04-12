import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

class WorkOrderStatusIcon extends StatelessWidget {
  final WorkOrderStatus status;
  const WorkOrderStatusIcon({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    final icon = _statusIcon(status);

    return Container(
      width: 60,
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withAlpha(50),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }

  Color _statusColor(WorkOrderStatus status) {
    switch (status) {
      case WorkOrderStatus.drafted:
        return Colors.grey.shade500;

      case WorkOrderStatus.sent:
        return Colors.blue.shade600;

      case WorkOrderStatus.approved:
        return Colors.teal.shade600;

      case WorkOrderStatus.onProgress:
        return Colors.amber.shade700;

      case WorkOrderStatus.completed:
        return Colors.green.shade600;

      case WorkOrderStatus.rejected:
        return Colors.red.shade600;

      case WorkOrderStatus.cancelled:
        return Colors.red.shade400;

      case WorkOrderStatus.failed:
        return Colors.red.shade800;
    }
  }

  IconData _statusIcon(WorkOrderStatus status) {
    switch (status) {
      case WorkOrderStatus.drafted:
        return Icons.edit_note; // draft state

      case WorkOrderStatus.sent:
        return Icons.send; // already sent

      case WorkOrderStatus.approved:
        return Icons.verified; // approved / validated

      case WorkOrderStatus.onProgress:
        return LucideIcons.loader; // process ongoing

      case WorkOrderStatus.completed:
        return Icons.check_circle; // success

      case WorkOrderStatus.rejected:
        return Icons.cancel; // rejected

      case WorkOrderStatus.cancelled:
        return LucideIcons.xCircle; // cancelled by user

      case WorkOrderStatus.failed:
        return Icons.error; // system failure
    }
  }
}
