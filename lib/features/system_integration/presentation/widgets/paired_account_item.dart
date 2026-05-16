import 'package:flutter/material.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/external_user_entity.dart';
import 'package:intl/intl.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_radius.dart';
import 'package:workorder_company_app/shared/utils/confirm_dialog.dart';
import 'package:workorder_company_app/shared/widgets/clickable_custom_card.dart';
import 'package:workorder_company_app/shared/widgets/icon_box.dart';

class PairedAccountItem extends StatelessWidget {
  final ExternalUserEntity externalUser;
  final VoidCallback onDetach;

  const PairedAccountItem({
    super.key,
    required this.externalUser,
    required this.onDetach,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClickableCustomCard(
      borderRadius: BorderRadius.all(Radius.circular(AppRadius.large)),
      onTap: () {
        showConfirmDialog(
            icon: AppIcon.detach,
            context: context,
            title: "Putuskan Koneksi",
            message:
                "Anda yakin ingin melepaskan koneksi akun anda di perusahaa ${externalUser.company.name}");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconBox.small(icon: AppIcon.connect),
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
