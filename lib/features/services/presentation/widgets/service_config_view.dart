import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/services/domain/entities/base_service_entity.dart';
import 'package:workorder_company_app/shared/widgets/active_status_chip.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';

class ServiceConfigView extends StatelessWidget {
  final BaseServiceEntity service;
  const ServiceConfigView({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.sm),
      child: PropertyDisplay(
        properties: [
          PropertyItem.text(
            label: "Nama Layanan",
            value: service.title,
            icon: Icons.build_circle_outlined,
          ),
          PropertyItem.text(
            label: "Deskripsi",
            value: service.description,
            icon: Icons.info_outline,
          ),
          PropertyItem.text(
            label: "Tipe akses",
            value: service.accessType.displayName,
            icon: Icons.shield_outlined,
          ),
          PropertyItem.widget(
              label: "Status Aktif",
              icon: Icons.verified_outlined,
              child: ActiveStatusChip(
                isActive: service.isActive,
              )),
        ],
      ),
    );
  }
}
