import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

class InvitationStatusBadge extends StatelessWidget {
  final InvitationStatus status;
  final bool showIcon;

  const InvitationStatusBadge(
      {super.key, required this.status, required this.showIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
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
            status.displayName,
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

  IconData get icon {
    switch (status) {
      case InvitationStatus.accepted:
        return Icons.check;
      case InvitationStatus.pending:
        return Icons.timelapse;
      case InvitationStatus.rejected:
        return Icons.close;
      case InvitationStatus.cancelled:
        return Icons.close;
    }
  }

  Color get color {
    switch (status) {
      case InvitationStatus.accepted:
        return Colors.green;
      case InvitationStatus.pending:
        return Colors.orange;
      case InvitationStatus.rejected:
        return Colors.red;
      case InvitationStatus.cancelled:
        return Colors.grey;
    }
  }
}
