import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:workorder_company_app/core/constants/app_config.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/notification/presentation/widgets/notification_toggle.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_switch.dart';

class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const NotificationToggle(),
        HorizontalSwitch(
          margin: EdgeInsets.only(bottom: AppSpacing.xs),
          title: "Petunjuk",
          leadingIcon: Icons.info_outline,
          description: "Tampilkan petunjuk penggunaan aplikasi Anda",
          value: false,
          onChanged: (_) {},
        ),
        HorizontalButton(
          margin: EdgeInsets.only(bottom: AppSpacing.xs),
          title: "Coba versi website",
          leadingIcon: LucideIcons.globe2,
          description: "Versi website disarankan untuk penggunaan desktop",
          onTap: () async {
            final canLaunch = await canLaunchUrlString(AppConfig.websiteUrl);

            if (!canLaunch) {
              if (!context.mounted) return;

              context.showError(
                "Tidak dapat membuka halaman web",
              );
            }

            await launchUrlString(
              AppConfig.websiteUrl,
              mode: LaunchMode.externalApplication,
            );
          },
        ),
      ],
    );
  }
}
