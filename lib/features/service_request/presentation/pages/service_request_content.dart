import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/presentation/widgets/service_request_step_card.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';
import 'package:workorder_company_app/shared/widgets/custom_card.dart';
import 'package:workorder_company_app/shared/widgets/error_body.dart';
import 'package:workorder_company_app/shared/widgets/filled_form_view.dart';
import 'package:workorder_company_app/shared/widgets/property_display.dart';

class ServiceRequestContent extends StatelessWidget {
  final bool isLoading;
  final ServiceRequestEntity? serviceRequest;
  final VoidCallback? onRefresh;

  const ServiceRequestContent({
    super.key,
    required this.isLoading,
    this.serviceRequest,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
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

    return RefreshIndicator(
        onRefresh: () async {
          if (onRefresh != null) {
            onRefresh!();
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HeaderOfPage(title: serviceRequest!.code, icon: AppIcon.service),
              // const SizedBox(height: 8),
              CustomCard(
                  child: PropertyDisplay(properties: [
                PropertyItem.text(
                    label: "Kode Permintaan",
                    value: serviceRequest!.code,
                    icon: AppIcon.code),
                PropertyItem.text(
                    label: "Layanan",
                    value: serviceRequest!.service.title,
                    icon: AppIcon.service),
                if (serviceRequest is RequesterServiceRequestEntity)
                  PropertyItem.text(
                      label: "Tujuan",
                      value: (serviceRequest as RequesterServiceRequestEntity)
                          .company
                          .name,
                      icon: AppIcon.company),
                if (serviceRequest is ProviderServiceRequestEntity)
                  PropertyItem.text(
                      label: "Diajukan oleh",
                      value: serviceRequest!.requestedBy.name,
                      icon: AppIcon.user),
                if (serviceRequest!.approvedBy != null)
                  PropertyItem.text(
                      label: "Disetujui oleh",
                      value: serviceRequest!.approvedBy!.name,
                      icon: AppIcon.user),
                PropertyItem.text(
                    label: "Diajukan pada",
                    value: DateFormat('d MMMM yyyy', 'id_ID')
                        .format(serviceRequest!.createdAt),
                    icon: AppIcon.dateField)
              ])),
              ServiceRequestStepCard(currentStatus: serviceRequest!.status),

              if (serviceRequest!.intakeForm != null) ...[
                const SizedBox(
                  height: AppSpacing.md,
                ),
                FilledFormView(filledForm: serviceRequest!.intakeForm!)
              ]
            ],
          ),
        ));
  }
}
