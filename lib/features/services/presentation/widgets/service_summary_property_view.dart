import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/features/services/domain/entities/base_service_entity.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';

class ServiceSummaryPropertyView extends StatelessWidget {
  final BaseServiceEntity service;
  const ServiceSummaryPropertyView({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: PropertyDisplay(properties: [
        PropertyItem.text(
            icon: AppIcon.service, label: "Layanan", value: service.title),
        PropertyItem.text(
            icon: AppIcon.desc, label: "Deskripsi", value: service.description),
        PropertyItem.text(
            icon: AppIcon.type,
            label: "Akses Layanan",
            value: service.accessType.displayName)
      ]),
    );
  }
}
