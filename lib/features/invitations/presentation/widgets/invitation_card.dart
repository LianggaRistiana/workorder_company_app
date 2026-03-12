import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/invitations/domain/entitties/invitation_entity.dart';

class InvitationCard extends StatelessWidget {
  final InvitationEntity invitation;

  const InvitationCard({
    super.key,
    required this.invitation,
  });

  Color _statusColor(BuildContext context) {
    switch (invitation.status) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          /// Email
          Text(
            invitation.toUser.email,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 6),

          /// Role
          Text(
            invitation.role.name,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 6),

          /// Position (optional)
          if (invitation.position != null)
            Text(
              invitation.position!.name,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              /// Status
              Container(
                padding: const EdgeInsets
                    .symmetric(
                        horizontal: 10,
                        vertical: 4),
                decoration: BoxDecoration(
                  color:
                      _statusColor(context)
                          .withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(
                          20),
                ),
                child: Text(
                  invitation.status.name
                      .toUpperCase(),
                  style: TextStyle(
                    color:
                        _statusColor(context),
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),

              /// Created Date
              if (invitation.createdAt != null)
                Text(
                  _formatDate(
                      invitation.createdAt!),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}