import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/cancel_service_request/requester_cancel_service_request_cubit.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/cancel_service_request/requester_cancel_service_request_state.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/loading_state_inline.dart';

class ServiceRequestCancel extends StatelessWidget {
  final String serviceRequestId;
  const ServiceRequestCancel({super.key, required this.serviceRequestId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RequesterCancelServiceRequestCubit>(),
      child: BlocConsumer<RequesterCancelServiceRequestCubit,
          RequesterCancelServiceRequestState>(
        listener: (context, state) {
          if (state.status == RequesterCancelServiceRequestStatus.error) {
            context.showError(state.errorMessage ?? "Terjadi Kesalahan");
          }

          if (state.status == RequesterCancelServiceRequestStatus.success) {
            // TODO[High] : if success update sr detail here
            context.showSuccess("Permintaan dibatalkan");
            context.pop();
          }
        },
        builder: (context, state) => Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              state.status == RequesterCancelServiceRequestStatus.loading
                  ? const LoadingStateInline()
                  : FilledButton.icon(
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
                            .read<RequesterCancelServiceRequestCubit>()
                            .cancelServiceRequest(serviceRequestId);
                      },
                      label: Text("Batalkan Permintaan"),
                      icon: Icon(AppIcon.cancel,
                          color: Theme.of(context).colorScheme.error),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
