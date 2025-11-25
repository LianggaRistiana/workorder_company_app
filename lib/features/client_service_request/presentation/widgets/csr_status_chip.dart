import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

class CsrStatusChip extends StatelessWidget {
  final ClientServiceRequestStatus status;
  final bool showIcon;

  const CsrStatusChip(
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

Color _statusColor(ClientServiceRequestStatus status) {
  switch (status) {
    case ClientServiceRequestStatus.received:
      return Colors.orange;
    case ClientServiceRequestStatus.approved:
      return Colors.blue;
    case ClientServiceRequestStatus.workOrderCreated:
      return Colors.blue;
    case ClientServiceRequestStatus.completed:
      return Colors.green;
    case ClientServiceRequestStatus.cancelled:
      return Colors.red;
    case ClientServiceRequestStatus.rejected:
      return Colors.red;
  }
}

IconData _statusIcon(ClientServiceRequestStatus status) {
  switch (status) {
    case ClientServiceRequestStatus.received:
      return Icons.inbox;

    case ClientServiceRequestStatus.approved:
      return Icons.check_circle;

    case ClientServiceRequestStatus.workOrderCreated:
      return Icons.article; // atau Icons.playlist_add_check

    case ClientServiceRequestStatus.completed:
      return Icons.done_all;

    case ClientServiceRequestStatus.cancelled:
      return Icons.cancel;

    case ClientServiceRequestStatus.rejected:
      return Icons.block;
  }
}
