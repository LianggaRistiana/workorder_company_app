import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/core/authorization/util/access_gate_on_widget.dart';
import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/notification/presentation/bloc/notification_log_cubit.dart';
import 'package:workorder_company_app/features/service_request/domain/authorization/provider_service_request_authorizer.dart';
import 'package:workorder_company_app/features/service_request/presentation/pages/service_request_content.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/provider/service_request_detail/provider_service_request_detail_cubit.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/provider/service_request_detail/provider_service_request_detail_state.dart';
import 'package:workorder_company_app/features/service_request/presentation/widgets/service_request_provider_action.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';

class ProviderServiceRequestDetailPage extends StatelessWidget {
  final String id;

  const ProviderServiceRequestDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ProviderServiceRequestDetailCubit>()..getServiceRequestDetail(id),
      child: BlocConsumer<ProviderServiceRequestDetailCubit,
          ProviderServiceRequestDetailState>(listener: (context, state) {
        if (state.status == ProviderServiceRequestDetailStatus.error) {
          context.showError(state.errorMessage ?? "Terjadi Kesalahan");
        }
        if (state.status == ProviderServiceRequestDetailStatus.loaded &&
            state.request != null) {
          context.read<NotificationLogCubit>().markAsRead(
                state.request?.id,
                ResourceType.serviceRequest,
              );
        }
      }, builder: (context, state) {
        final isLoading =
            state.status == ProviderServiceRequestDetailStatus.loading;
        final serviceRequest = state.request;

        return Scaffold(
          appBar: AppBar(),
          bottomNavigationBar: serviceRequest != null
              ? Padding(
                  padding: const EdgeInsets.all(
                    AppSpacing.md,
                  ),
                  child: ServiceRequestProviderAction(request: serviceRequest),
                ).require(
                  ProviderServiceRequestAuthorizer(serviceRequest).actionRule)
              : null,
          body: ServiceRequestContent(
            onRefresh: () async {
              await context
                  .read<ProviderServiceRequestDetailCubit>()
                  .getServiceRequestDetail(id);
            },
            isLoading: isLoading,
            serviceRequest: serviceRequest,
          ),
        );
      }),
    );
  }
}
