import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';

class InvitationStatusIcon extends StatelessWidget {
  final InvitationStatus status;
  final double? height;
  final double width;

  const InvitationStatusIcon(
      {super.key, required this.status, this.height, this.width = 20});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: width,
      // height: height,
      // padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      backgroundColor: color.withAlpha(20),
      // decoration: BoxDecoration(
      //   color: color.withAlpha(20),
      //   borderRadius: BorderRadius.circular(18),
      // ),
      child: Icon(icon, color: color, size: 24),
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
