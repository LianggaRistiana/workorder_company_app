import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/constants/app_enums/service_request_enum.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/service_request/domain/authorization/provider_service_request_authorizer.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/presentation/pages/service_request_report.dart';
import 'package:workorder_company_app/features/service_request/presentation/widgets/service_request_property_view.dart';
import 'package:workorder_company_app/features/work_order/domain/params/work_order_params.dart';
import 'package:workorder_company_app/shared/widgets/adaptive_split_column.dart';
import 'package:workorder_company_app/shared/widgets/app_bottom_sheet.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';
import 'package:workorder_company_app/shared/widgets/error_body.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/filled_form_view.dart';
import 'package:workorder_company_app/shared/widgets/horizontal_button.dart';
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
              leftChildren: _serviceRequestMetaData(context, serviceRequest!),
              rightChildren: _serviceRequestFilledForm(serviceRequest!))),
    );
  }

  List<Widget> _serviceRequestMetaData(
      BuildContext context, ServiceRequestEntity serviceRequest) {
    return [
      ServiceRequestPropertyView(serviceRequest: serviceRequest),
      if (serviceRequest is ProviderServiceRequestEntity)
        HorizontalButton(
                margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                title: "Lihat Perintah Kerja",
                description:
                    "Lihat perintah kerja yang terkait dengan permintaan ini",
                onTap: () {
                  context.push(Endpoints.workorders,
                      extra: WorkOrderParams(serviceRequest: serviceRequest));
                },
                leadingIcon: AppIcon.workOrder)
            .require(ProviderServiceRequestAuthorizer(serviceRequest)
                .workOrderAccessRule),
      if (serviceRequest.status.isReviewAvailable) ...[
        HorizontalButton(
            leadingIcon: AppIcon.review,
            description: "Lihat ulasan yang terkait dengan permintaan ini",
            onTap: () {
              final reviewForm = serviceRequest.reviewForm;
              showAppBottomSheet(
                context,
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      PropertyTitle(
                        icon: AppIcon.review,
                        label: "Ulasan",
                      ),
                      const SizedBox(
                        height: AppSpacing.sm,
                      ),
                      if (reviewForm != null)
                        FilledFormView(filledForm: reviewForm),
                    ],
                  ),
                ),
              );
            },
            title: "Lihat Ulasan")
      ],
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
      ],
      if (serviceRequest.status.isReportAvailable) ...[
        ServiceRequestReport(serviceRequestId: serviceRequest.id)
      ],
      const SizedBox(
        height: AppSpacing.lg,
      ),
    ];
  }
}
