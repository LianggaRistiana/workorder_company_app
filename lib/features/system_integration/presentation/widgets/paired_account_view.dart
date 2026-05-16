import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_radius.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/external_user_entity.dart';
import 'package:workorder_company_app/features/system_integration/presentation/widgets/paired_account_item.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';
import 'package:workorder_company_app/shared/widgets/information_block.dart';

/// Use context.push((AppRoutes.pairAccount.fillId(companyId))) to connect
class PairedAccountView extends StatelessWidget {
  final bool isPaired;
  final String companyId;
  final ExternalUserEntity? externalUser;
  final VoidCallback onDetach;
  final VoidCallback? onConnect;

  const PairedAccountView({
    super.key,
    required this.companyId,
    required this.isPaired,
    this.externalUser,
    required this.onDetach,
    this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final externalAccount = externalUser;

    if (!isPaired) {
      return DashedButton(
        borderRadius: AppRadius.large,
        icon: AppIcon.connect,
        height: 52,
        borderColor: theme.colorScheme.primary,
        color: theme.colorScheme.primary,
        title: "Hubungkan Akun",
        onTap: onConnect,
      );
    }

    if (externalAccount == null) {
      return InformationBlock.error(
        "Akun terhubung tetapi data akun eksternal tidak dapat dimuat.",
      );
    }

    return PairedAccountItem(externalUser: externalAccount, onDetach: onDetach);
  }
}
