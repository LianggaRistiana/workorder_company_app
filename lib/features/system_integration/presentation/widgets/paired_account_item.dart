import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_enums/system_integration_enum.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/external_user_entity.dart';
import 'package:intl/intl.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_radius.dart';
import 'package:workorder_company_app/shared/utils/confirm_dialog.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';
import 'package:workorder_company_app/shared/widgets/shimmer_placeholder.dart';
import 'package:workorder_company_app/shared/widgets/smart_shimmer.dart';

class PairedAccountItem extends StatelessWidget {
  final ExternalUserEntity externalUser;
  final VoidCallback onDetach;
  final bool isLoading;

  const PairedAccountItem(
      {super.key,
      required this.externalUser,
      required this.onDetach,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return SmartShimmer(
        key: const ValueKey('loading'),
        placeholders: [
          ShimmerPlaceholder(
              height: 60, width: double.infinity, borderRadius: 50),
        ],
      );
    }

    return ClickableCustomCard(
      borderRadius: BorderRadius.all(Radius.circular(AppRadius.large)),
      onTap: () async {
        if (externalUser.integrationType != IntegrationType.externalSystem) {
          return;
        }
        final result = await showConfirmDialog(
            icon: AppIcon.detach,
            context: context,
            title: "Putuskan Koneksi",
            message:
                "Anda yakin ingin melepaskan koneksi akun anda di perusahaan ${externalUser.company.name}");
        if (result == true) {
          onDetach();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconBox.small(
                icon: externalUser.integrationType == IntegrationType.claimCode
                    ? AppIcon.memberCode
                    : AppIcon.connect,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      externalUser.externalName,
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      externalUser.externalEmail,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Terhubung pada ${DateFormat('d MMM yyyy', 'id_ID').format(externalUser.pairedAt.toLocal())}",
                style: theme.textTheme.labelSmall,
              ))
        ],
      ),
    );
  }
}
