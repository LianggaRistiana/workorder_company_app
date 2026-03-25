import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_request_config_entity.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';
import 'package:workorder_company_app/shared/widgets/section_title.dart';

class ServiceRequestTabView extends StatelessWidget {
  final ServiceRequestConfigEntity config;
  const ServiceRequestTabView({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CustomCard(
                child: PropertyDisplay(properties: [
              PropertyItem.text(
                label: "Hak Persetujuan",
                value: config.serviceRequestApprovalAccessType.displayName,
                icon: Icons.admin_panel_settings,
              ),
              PropertyItem.text(
                label: "Kebutuhan Review",
                value: config.reviewNeed ? "Ya" : "Tidak",
                icon: Icons.reviews_outlined,
              ),
            ])),
            SectionTitle("Formulir Permintaan"),
            HorizontalButton(
              leadingIcon: Icons.inbox_outlined,
              title: config.intakeForm.title,
              onTap: () {},
            ),
            SectionTitle("Formulir Review"),
            HorizontalButton(
              leadingIcon: Icons.reviews_outlined,
              title: config.reviewForm.title,
              onTap: () {},
            ),
          ])),
    );
  }
}
