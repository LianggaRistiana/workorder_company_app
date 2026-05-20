import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/constants/app_config.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/shared/widgets/section_title.dart';
import 'package:workorder_company_app/shared/widgets/version_text.dart';

class AboutAppSection extends StatelessWidget {
  const AboutAppSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle("Tentang Aplikasi"),
        Divider(),
        const SizedBox(height: AppSpacing.sm),
        VersionText(),
        const SizedBox(height: AppSpacing.sm),
        Divider(),
        const SizedBox(height: AppSpacing.sm),
        Text(
          "Server Code Name\n${AppConfig.serverCodeName}",
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        Divider(),
        const SizedBox(height: AppSpacing.sm),
        Text(
          "Developed by Workorder SaaS Team\n© 2026",
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
