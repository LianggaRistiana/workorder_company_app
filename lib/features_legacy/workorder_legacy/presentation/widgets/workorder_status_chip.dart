// import 'package:flutter/material.dart';
// import 'package:workorder_company_app/core/constants/app_enums.dart';

// class WorkOrderStatusChip extends StatelessWidget {
//   final WorkOrderStatus status;
//   final bool showIcon;

//   const WorkOrderStatusChip({
//     super.key,
//     required this.status,
//     this.showIcon = true, // default ada icon
//   });

//   @override
//   Widget build(BuildContext context) {
//     final color = _statusColor(status);
//     final icon = _statusIcon(status);
//     final label = status.displayName;

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withAlpha(50),
//         borderRadius: BorderRadius.circular(20), // chip style
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (showIcon) ...[
//             Icon(
//               icon,
//               color: color,
//               size: 18,
//             ),
//             const SizedBox(width: 6),
//           ],
//           Text(
//             label,
//             style: TextStyle(
//               color: color,
//               fontWeight: FontWeight.w600,
//               fontSize: 13,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ------------------------
//   // Helper styling
//   // ------------------------

//   Color _statusColor(WorkOrderStatus status) {
//     switch (status) {
//       case WorkOrderStatus.drafted:
//         return Colors.grey;
//       case WorkOrderStatus.ready:
//         return Colors.blue;
//       case WorkOrderStatus.inProgress:
//         return Colors.orange;
//       case WorkOrderStatus.completed:
//         return Colors.green;
//       case WorkOrderStatus.cancelled:
//         return Colors.red;
//     }
//   }

//   IconData _statusIcon(WorkOrderStatus status) {
//     switch (status) {
//       case WorkOrderStatus.drafted:
//         return Icons.edit_note;
//       case WorkOrderStatus.ready:
//         return Icons.check_circle;
//       case WorkOrderStatus.inProgress:
//         return Icons.timelapse;
//       case WorkOrderStatus.completed:
//         return Icons.done_all;
//       case WorkOrderStatus.cancelled:
//         return Icons.cancel;
//     }
//   }
// }
