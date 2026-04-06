import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/policies/requester_service_request_policy.dart';
import 'package:workorder_company_app/features/service_request/presentation/pages/service_request_content.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/service_request_detail/requester_service_request_detail_cubit.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/service_request_detail/requester_service_request_detail_state.dart';
import 'package:workorder_company_app/features/service_request/presentation/widgets/service_request_cancel.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';

class RequesterServiceRequestDetailPage extends StatelessWidget {
  final String id;

  const RequesterServiceRequestDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<RequesterServiceRequestDetailCubit>()..getServiceRequestDetail(id),
      child: BlocConsumer<RequesterServiceRequestDetailCubit,
          RequesterServiceRequestDetailState>(listener: (context, state) {
        if (state.status == RequesterServiceRequestDetailStatus.error) {
          context.showError(state.errorMessage ?? "Terjadi Kesalahan");
        }
      }, builder: (context, state) {
        final isLoading =
            state.status == RequesterServiceRequestDetailStatus.loading;
        final serviceRequest = state.request;

        return Scaffold(
          appBar: AppBar(),
          bottomNavigationBar: serviceRequest != null
              ? _actionWidget(context, serviceRequest)
              : null,
          body: ServiceRequestContent(
            isLoading: isLoading,
            serviceRequest: state.request,
          ),
        );
      }),
    );
  }

  Widget _actionWidget(
      BuildContext context, RequesterServiceRequestEntity request) {
    switch (request.status) {
      case ServiceRequestStatus.received:
        return ServiceRequestCancel(
          serviceRequestId: request.id,
        ).require(RequesterServiceRequestPolicy(request: request).cancelRule);

      case ServiceRequestStatus.completed:
        return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: FilledButton.icon(
              onPressed: () {
                context.push(AppRoutes.serviceRequestReview, extra: request);
              },
              label: Text("Isi Ulasan"),
              icon: Icon(AppIcon.review),
            )).require(
          RequesterServiceRequestPolicy(request: request).fillReviewRule,
        );
      default:
        return SizedBox.shrink();
    }
  }
}
