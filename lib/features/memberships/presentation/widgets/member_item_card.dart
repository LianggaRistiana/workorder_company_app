import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_radius.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/home/presentation/widget/user_chip.dart';
import 'package:workorder_company_app/features/memberships/domain/entitties/member_entity.dart';
import 'package:workorder_company_app/shared/widgets/app_bottom_sheet.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';

class MemberItemCard extends StatelessWidget {
  final MemberEntity member;
  const MemberItemCard({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return ClickableCustomCard(
      borderRadius: const BorderRadius.all(Radius.circular(AppRadius.large)),
      onTap: () {
        showAppBottomSheet(context,
            content: SingleChildScrollView(
              child: Column(
                children: [
                  UserChip(user: member.client),
                  const SizedBox(height: AppSpacing.lg),
                  PropertyTitle(label: "Informasi Kustomer (External)"),
                  const SizedBox(height: AppSpacing.sm),
                  CustomCard(
                    child: PropertyDisplay(properties: [
                      PropertyItem.text(
                        label: "External Username",
                        value: member.externalUser.externalName,
                      ),
                      PropertyItem.text(
                        label: "External Email",
                        value: member.externalUser.externalEmail,
                      ),
                      PropertyItem.widget(
                          label: "Terhubung melalui",
                          child: member.externalUser.integrationType ==
                                  IntegrationType.claimCode
                              ? const _ViaCode()
                              : const _ViaExternalSystem()),
                      PropertyItem.text(
                        label: "Terhubung pada",
                        value: DateFormat('d MMM yyyy', 'id_ID')
                            .format(member.externalUser.pairedAt.toLocal()),
                      ),
                    ]),
                  )
                ],
              ),
            ));
      },
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          UserChip(user: member.client),
          const SizedBox(height: 4),
          Text(member.externalUser.externalEmail,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _ViaCode extends StatelessWidget {
  const _ViaCode();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(
          AppIcon.memberCode,
          color: Theme.of(context).colorScheme.primary,
          size: 12,
        ),
        const SizedBox(width: 10),
        Text(
          "Via Kode Anggota",
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontFamily: "Monospace"),
        )
      ]),
    );
  }
}

class _ViaExternalSystem extends StatelessWidget {
  const _ViaExternalSystem();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(
          AppIcon.connect,
          color: Theme.of(context).colorScheme.primary,
          size: 12,
        ),
        const SizedBox(width: 10),
        Text(
          "Via Eksternal System",
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontFamily: "Monospace"),
        )
      ]),
    );
  }
}
