import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/invitations/domain/entities/invitation_entity.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';

class ReceiverInvitationCard extends StatelessWidget {
  final InvitationEntity invitation;
  final VoidCallback? onTap;

  const ReceiverInvitationCard(
      {super.key, required this.invitation, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClickableCustomCard(
      borderRadius: BorderRadius.circular(24),
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconBox(icon: Icons.home_work_outlined),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                  child: Text(
                invitation.company?.name ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              )),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Spacer(),
              if (invitation.createdAt != null)
                Text(
                    DateFormat('d MMM yyyy', 'id_ID')
                        .format(invitation.createdAt!),
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.bodySmall),
            ],
          )
        ],
      ),
    );
  }
}
