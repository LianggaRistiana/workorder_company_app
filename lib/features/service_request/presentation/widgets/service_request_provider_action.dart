import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/provider/action_service_request/provider_action_service_request_cubit.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/provider/action_service_request/provider_action_service_request_state.dart';
import 'package:workorder_company_app/features/work_order/domain/params/work_order_temp_local_params.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/loading_state_inline.dart';

// OPTIMIZE : convert this into FAB. follow work order UI pattern
class ServiceRequestProviderAction extends StatelessWidget {
  final ProviderServiceRequestEntity request;
  const ServiceRequestProviderAction({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProviderActionServiceRequestCubit>(),
      child: BlocConsumer<ProviderActionServiceRequestCubit,
          ProviderActionServiceRequestState>(
        listener: (context, state) {
          final requestResult = state.request;

          if (state.status == ProviderActionServiceRequestStatus.error) {
            context.showError(state.errorMessage ?? "Terjadi Kesalahan");
          } else if (state.status ==
                  ProviderActionServiceRequestStatus.approved &&
              requestResult != null) {
            context.showSuccess("Permintaan diterima");
            context.pop();
            context.push(Endpoints.workorders,
                extra: WorkOrderTempLocalParams.fromServiceRequest(
                    byServiceRequestId: requestResult.id));
          } else if (state.status ==
              ProviderActionServiceRequestStatus.rejected) {
            context.showSuccess("Permintaan ditolak");
            context.pop();
          }
        },
        builder: (context, state) => Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (state.status == ProviderActionServiceRequestStatus.loading)
              const LoadingStateInline()
            else ...[
              FloatingActionButton.small(
                heroTag: null,
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                onPressed: () {
                  context
                      .read<ProviderActionServiceRequestCubit>()
                      .rejectServiceRequest(request);
                },
                child: Icon(AppIcon.reject,
                    color: Theme.of(context).colorScheme.error),
              ),
              // IconButton.filled(
              //   style: ButtonStyle(
              //     backgroundColor: WidgetStatePropertyAll(
              //       Theme.of(context).colorScheme.errorContainer,
              //     ),
              //     foregroundColor: WidgetStatePropertyAll(
              //       Theme.of(context).colorScheme.error,
              //     ),
              //   ),
              //   onPressed: () {
              //     context
              //         .read<ProviderActionServiceRequestCubit>()
              //         .rejectServiceRequest(request);
              //   },
              //   icon: Icon(AppIcon.reject,
              //       color: Theme.of(context).colorScheme.error),
              // ),
              const SizedBox(width: AppSpacing.sm),
              FloatingActionButton.extended(
                heroTag: null,
                onPressed: () {
                  context
                      .read<ProviderActionServiceRequestCubit>()
                      .approveServiceRequest(request);
                },
                icon: const Icon(AppIcon.approve),
                label: const Text("Terima Permintaan"),
              )
              // FilledButton.icon(
              //   onPressed: () {
              //     context
              //         .read<ProviderActionServiceRequestCubit>()
              //         .approveServiceRequest(request);
              //   },
              //   label: Text("Terima Permintaan"),
              //   icon: Icon(AppIcon.approve),
              // ),
            ]
          ],
        ),
      ),
    );
  }
}
