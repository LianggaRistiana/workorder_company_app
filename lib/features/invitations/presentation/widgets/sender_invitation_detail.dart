import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workorder_company_app/features/invitations/domain/entities/invitation_entity.dart';
import 'package:workorder_company_app/features/invitations/presentation/widgets/invitation_status_badge.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';

class SenderInvitationDetail extends StatelessWidget {
  final InvitationEntity invitation;

  const SenderInvitationDetail({super.key, required this.invitation});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: PropertyDisplay(properties: [
        PropertyItem.text(
          icon: Icons.work_outline,
          label: "Posisi ditawarkan",
          value: invitation.role.displayName,
        ),
        PropertyItem.text(
          icon: Icons.badge_outlined,
          label: "Departemen",
          value: invitation.position?.name ?? "-",
        ),
        PropertyItem.widget(
            icon: Icons.check_circle_outline,
            label: "Status",
            child: InvitationStatusBadge(
                status: invitation.status, showIcon: true)),
        PropertyItem.text(
          icon: Icons.date_range_outlined,
          label: "Berlaku hingga",
          value: invitation.expiresAt != null
              ? DateFormat('d MMM yyyy', 'id_ID').format(invitation.expiresAt!)
              : "-",
        ),
        PropertyItem.text(
          icon: Icons.calendar_month_outlined,
          label: "Tanggal dikirim",
          value: invitation.createdAt != null
              ? DateFormat('d MMM yyyy', 'id_ID').format(invitation.createdAt!)
              : "-",
        ),
      ]),
    );
  }
}
