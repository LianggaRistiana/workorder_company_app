import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums/service_request_enum.dart';

class ServiceRequestStatusChip extends StatelessWidget {
  final ServiceRequestStatus status;
  final bool showIcon;

  const ServiceRequestStatusChip(
      {super.key, required this.status, required this.showIcon});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    final icon = _statusIcon(status);
    final label = status.displayName;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(50),
        borderRadius: BorderRadius.circular(20), // chip style
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              icon,
              color: color,
              size: 18,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

Color _statusColor(ServiceRequestStatus status) {
  // TODO[Low] : fix color of this color
  switch (status) {
    case ServiceRequestStatus.received:
      return Colors.orange;
    case ServiceRequestStatus.approved:
      return Colors.blue;
    case ServiceRequestStatus.onProgress:
      return Colors.amber;
    case ServiceRequestStatus.closed:
      return Colors.blue;
    case ServiceRequestStatus.completed:
      return Colors.green;
    case ServiceRequestStatus.cancelled:
      return Colors.red;
    case ServiceRequestStatus.rejected:
      return Colors.red;
  }
}

IconData _statusIcon(ServiceRequestStatus status) {
  switch (status) {
    case ServiceRequestStatus.received:
      return Icons.inbox;

    case ServiceRequestStatus.approved:
      return Icons.check_circle;
    case ServiceRequestStatus.closed:
      return Icons.check_circle;
    case ServiceRequestStatus.onProgress:
      return Icons.scale;

    case ServiceRequestStatus.completed:
      return Icons.done_all;

    case ServiceRequestStatus.cancelled:
      return Icons.cancel;

    case ServiceRequestStatus.rejected:
      return Icons.block;
  }
}
