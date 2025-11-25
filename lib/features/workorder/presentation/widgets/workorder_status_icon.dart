import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

class WorkOrderStatusIcon extends StatelessWidget {
  final WorkOrderStatus status;
  final double? height;
  final double width;

  const WorkOrderStatusIcon({
    super.key,
    required this.status,
    this.height,
    this.width = 60,
  });

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    final icon = _statusIcon(status);
    // final label = status.displayName;

    return Container(
      width: width, // <-- fix width, semua status akan sama
      height: height,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withAlpha(50),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 28),
      // child: Column(
      //   mainAxisSize: MainAxisSize.min,
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
      //     Icon(icon, color: color, size: 28),
      //     const SizedBox(height: 8),
      //     Text(
      //       label,
      //       textAlign: TextAlign.center, // biar rapi
      //       style: TextStyle(
      //         color: color,
      //         fontWeight: FontWeight.w600,
      //         fontSize: 14,
      //       ),
      //       maxLines: 1,
      //       overflow: TextOverflow.ellipsis, // jaga2 kalau displayname panjang
      //     ),
      //   ],
      // ),
    );
  }

  // ------------------------
  // Helper styling
  // ------------------------

  Color _statusColor(WorkOrderStatus status) {
    switch (status) {
      case WorkOrderStatus.drafted:
        return Colors.grey;
      case WorkOrderStatus.ready:
        return Colors.blue;
      case WorkOrderStatus.inProgress:
        return Colors.orange;
      case WorkOrderStatus.completed:
        return Colors.green;
      case WorkOrderStatus.cancelled:
        return Colors.red;
    }
  }

  IconData _statusIcon(WorkOrderStatus status) {
    switch (status) {
      case WorkOrderStatus.drafted:
        return Icons.edit_note_outlined;
      case WorkOrderStatus.ready:
        return Icons.check_circle;
      case WorkOrderStatus.inProgress:
        return Icons.timelapse;
      case WorkOrderStatus.completed:
        return Icons.done_all;
      case WorkOrderStatus.cancelled:
        return Icons.cancel;
    }
  }
}
