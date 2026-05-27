import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_radius.dart';
import 'package:workorder_company_app/features/system_integration/domain/entities/external_user_entity.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';
import 'package:workorder_company_app/shared/widgets/dashed_button.dart';

class PairingAccountButton extends StatelessWidget {
  final String companyId;
  final VoidCallback onConnect;

  const PairingAccountButton({
    super.key,
    required this.companyId,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DashedButton(
      borderRadius: AppRadius.large,
      icon: AppIcon.connect,
      height: 52,
      borderColor: theme.colorScheme.primary,
      color: theme.colorScheme.primary,
      title: "Hubungkan Akun",
      onTap: () async {
        final result = await context
            .push<ExternalUserEntity?>(AppRoutes.pairAccount.fillId(companyId));

        if (!context.mounted) return;
        if (result != null) {
          onConnect();
          // context.read<AccountActionCubit>().replaceExternalAccount(result);
        }
      },
    );
  }
}
