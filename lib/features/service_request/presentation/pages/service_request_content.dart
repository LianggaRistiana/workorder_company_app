import 'package:flutter/material.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/presentation/widgets/service_request_step_card.dart';
import 'package:workorder_company_app/shared/widgets/adaptive_split_column.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/error_body.dart';
import 'package:workorder_company_app/shared/widgets/filled_form_view.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';

class ServiceRequestContent extends StatelessWidget {
  final bool isLoading;
  final ServiceRequestEntity? serviceRequest;
  final Future<void> Function()? onRefresh;

  const ServiceRequestContent({
    super.key,
    required this.isLoading,
    this.serviceRequest,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && serviceRequest == null) {
      return const Center(child: AppLoading());
    }

    if (serviceRequest == null) {
      return Center(
        child: ErrorBody(
          errorMessage: 'Tidak ditemukan',
          onRetry: onRefresh,
        ),
      );
    }

    return SafeArea(
      child: RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          onRefresh: () async {
            if (onRefresh != null) {
              await onRefresh!();
            }
          },
          child: AdaptiveSplitColumn(
              leftChildren: _serviceRequestMetaData(serviceRequest!),
              rightChildren: _serviceRequestFilledForm(serviceRequest!))),
    );
  }

  List<Widget> _serviceRequestMetaData(ServiceRequestEntity serviceRequest) {
    return [
      CustomCard(
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
                  value: serviceRequest.company.name,
                  icon: AppIcon.company),
            if (serviceRequest is ProviderServiceRequestEntity)
              PropertyItem.text(
                  label: "Diajukan oleh",
                  value: serviceRequest.requestedBy.name,
                  icon: AppIcon.user),
            if (serviceRequest.approvedBy != null)
              PropertyItem.text(
                  label: "Disetujui oleh",
                  value: serviceRequest.approvedBy!.name,
                  icon: AppIcon.approve),
            PropertyItem.text(
                label: "Diajukan pada",
                value: serviceRequest.statusDate.getCreatedAtString(),
                icon: AppIcon.dateField)
          ])),
      ServiceRequestStepCard(currentStatus: serviceRequest.status),
      const SizedBox(
        height: AppSpacing.md,
      ),
    ];
  }

  List<Widget> _serviceRequestFilledForm(ServiceRequestEntity serviceRequest) {
    return [
      if (serviceRequest.intakeForm != null) ...[
        FilledFormView(filledForm: serviceRequest.intakeForm!),
        const SizedBox(
          height: AppSpacing.lg,
        ),
      ]
    ];
  }
}
