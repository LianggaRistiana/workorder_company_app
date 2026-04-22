import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/provider/action_service_request/provider_action_service_request_cubit.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/provider/action_service_request/provider_action_service_request_state.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/loading_state_inline.dart';

// OPTIMIZE : convert this into FAB. follow work order for pattern
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
          if (state.status == ProviderActionServiceRequestStatus.error) {
            context.showError(state.errorMessage ?? "Terjadi Kesalahan");
          } else if (state.status ==
              ProviderActionServiceRequestStatus.approved) {
            // TODO[High] : if success update sr detail here
            context.showSuccess("Permintaan diterima");
            context.pop();
          } else if (state.status ==
              ProviderActionServiceRequestStatus.rejected) {
            // TODO[High] : if success update sr detail here
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
              IconButton.filled(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.errorContainer,
                  ),
                  foregroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.error,
                  ),
                ),
                onPressed: () {
                  context
                      .read<ProviderActionServiceRequestCubit>()
                      .rejectServiceRequest(request);
                },
                icon: Icon(AppIcon.reject,
                    color: Theme.of(context).colorScheme.error),
              ),
              const SizedBox(width: AppSpacing.md),
              FilledButton.icon(
                onPressed: () {
                  context
                      .read<ProviderActionServiceRequestCubit>()
                      .approveServiceRequest(request);
                },
                label: Text("Terima Permintaan"),
                icon: Icon(AppIcon.approve),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
