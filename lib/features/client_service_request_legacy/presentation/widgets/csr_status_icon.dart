import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

class CsrStatusIcon extends StatelessWidget {
  final ClientServiceRequestStatus status;
  final double? height;
  final double width;

  const CsrStatusIcon({
    super.key,
    required this.status,
    this.height,
    this.width = 60,
  });

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    final icon = _statusIcon(status);

    return Container(
      width: width, // <-- fix width, semua status akan sama
      height: height,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withAlpha(50),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 28),
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
