import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

class ServiceRequestStatusIcon extends StatelessWidget {
  final ServiceRequestStatus status;

  const ServiceRequestStatusIcon({super.key, required this.status});

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

  Color _statusColor(ServiceRequestStatus status) {
    switch (status) {
      case ServiceRequestStatus.received:
        return Colors.orange;
      case ServiceRequestStatus.approved:
        return Colors.blue;
      case ServiceRequestStatus.workOrderCreated:
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

      case ServiceRequestStatus.workOrderCreated:
        return Icons.article;

      case ServiceRequestStatus.completed:
        return Icons.done_all;

      case ServiceRequestStatus.cancelled:
        return Icons.cancel;

      case ServiceRequestStatus.rejected:
        return Icons.block;
    }
  }
}
