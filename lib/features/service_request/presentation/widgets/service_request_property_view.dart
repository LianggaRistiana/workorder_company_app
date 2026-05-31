import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/presentation/widgets/service_request_step_card.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';

class ServiceRequestPropertyView extends StatelessWidget {
  final ServiceRequestEntity serviceRequest;

  const ServiceRequestPropertyView({super.key, required this.serviceRequest});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
        margin: const EdgeInsets.only(bottom: AppSpacing.xs),
        child: PropertyDisplay(properties: [
          PropertyItem.text(
              label: "Kode Permintaan",
              value: serviceRequest.code,
              icon: AppIcon.code),
          PropertyItem.text(
              label: "Layanan",
              value: serviceRequest.service.title,
              icon: AppIcon.service),
          if (serviceRequest is RequesterServiceRequestEntity)
            PropertyItem.text(
                label: "Tujuan",
                value: (serviceRequest as RequesterServiceRequestEntity)
                    .company
                    .name,
                icon: AppIcon.company),
          if (serviceRequest is ProviderServiceRequestEntity)
            PropertyItem.widget(
                label: "Diajukan oleh",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(serviceRequest.requestedBy.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall),
                    Text(serviceRequest.requestedBy.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall)
                  ],
                ),
                icon: AppIcon.user),
          if (serviceRequest.approvedBy != null)
            PropertyItem.text(
                label: "Disetujui oleh",
                value: serviceRequest.approvedBy!.name,
                icon: AppIcon.approve),
          PropertyItem.text(
              label: "Diajukan pada",
              value: serviceRequest.statusDate.getCreatedAtString(),
              icon: AppIcon.date),
          PropertyItem.widget(
            label: "Status",
            icon: AppIcon.step,
            child: ServiceRequestStepCard(
                currentStatus: serviceRequest.status,
                statusDate: serviceRequest.statusDate),
          )
        ]));
  }
}
