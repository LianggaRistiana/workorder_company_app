import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_radius.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/home/presentation/widget/user_chip.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/member_entity.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';

class MemberItemCard extends StatelessWidget {
  final MemberEntity member;
  const MemberItemCard({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return ClickableCustomCard(
      borderRadius: const BorderRadius.all(Radius.circular(AppRadius.large)),
      onTap: () {},
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          UserChip(user: member.client),
          const SizedBox(height: 4),
          Text(member.membershipCode,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}
