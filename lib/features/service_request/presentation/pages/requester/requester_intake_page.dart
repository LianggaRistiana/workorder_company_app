import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/get_intake_form/requester_get_intake_form_cubit.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/get_intake_form/requester_get_intake_form_state.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/submit_intake_form/requester_submit_intake_form_cubit.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/submit_intake_form/requester_submit_intake_form_state.dart';
import 'package:workorder_company_app/features/services/domain/entities/base_service_entity.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/service_summary_property_view.dart';
import 'package:workorder_company_app/features/submissions/domain/draft/submisson_draft.dart';
import 'package:workorder_company_app/features/submissions/presentation/coordinator/form_renderer_coordinator.dart';
import 'package:workorder_company_app/features/submissions/presentation/cubit/file_upload_progress_cubit.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/form_renderer.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/adaptive_split_column.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';
import 'package:workorder_company_app/shared/widgets/button_with_loading_state.dart';

class RequesterIntakePage extends StatefulWidget {
  final BaseServiceEntity baseService;

  const RequesterIntakePage({super.key, required this.baseService});

  @override
  State<RequesterIntakePage> createState() => _RequesterIntakePageState();
}

class _RequesterIntakePageState extends State<RequesterIntakePage> {
  late final FormRendererCoordinator coordinator;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RequesterGetIntakeFormCubit>()
        ..getIntakeForm(widget.baseService.id),
      child: BlocConsumer<RequesterGetIntakeFormCubit,
          RequesterGetIntakeFormState>(
        listener: (context, state) {
          if (state.status == RequesterGetIntakeFormStatus.error) {
            context.showError(state.errorMessage ?? "Terjadi Kesalahan");
            context.pop();
          }
          if (state.status == RequesterGetIntakeFormStatus.loaded) {
            coordinator = FormRendererCoordinator.form(state.form!);
          }
        },
        builder: (context, state) => Scaffold(
            appBar: AppBar(),
            bottomNavigationBar: state.status ==
                        RequesterGetIntakeFormStatus.loaded &&
                    state.form != null
                ? SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: _buildSubmitButton(
                          context, coordinator.draft, widget.baseService.id),
                    ).hideOnLargeScreen(),
                  )
                : null,
            body: SafeArea(
              child: AdaptiveSplitColumn(
                leftChildren: [
                  ServiceSummaryPropertyView(service: widget.baseService),
                  const SizedBox(height: 16),
                ],
                rightChildren: [
                  if (state.status == RequesterGetIntakeFormStatus.loading) ...[
                    const SizedBox(height: 16),
                    AppLoading()
                  ],
                  if (state.status == RequesterGetIntakeFormStatus.loaded &&
                      state.form != null) ...[
                    FormRenderer(
                      coordinator: coordinator,
                    ),
                    const SizedBox(height: 16),
                    _buildSubmitButton(
                            context, coordinator.draft, widget.baseService.id)
                        .hideOnSmallScreen(),
                  ]
                ],
              ),
            )),
      ),
    );
  }

  Widget _buildSubmitButton(
      BuildContext context, SubmissionDraft draft, String serviceId) {
    return BlocProvider(
      create: (_) => sl<RequesterSubmitIntakeFormCubit>(),
      child: BlocConsumer<RequesterSubmitIntakeFormCubit,
              RequesterSubmitIntakeFormState>(
          listener: (context, state) {
            if (state.status == RequesterSubmitIntakeFormStatus.error) {
              context.showError(state.errorMessage ?? "Terjadi Kesalahan");
            }
            if (state.status == RequesterSubmitIntakeFormStatus.success) {
              context.showSuccess("Berhasil mengirim formulir");
              context.pop();
              context.push(AppRoutes.serviceRequestSent);
            }
          },
          builder: (context, state) => ButtonWithLoadingState(
                icon: Icons.send,
                loadingLabel: context
                        .watch<FileUploadProgressCubit>()
                        .state
                        .bottonMessage ??
                    "Mengunggah",
                isLoading:
                    state.status == RequesterSubmitIntakeFormStatus.loading,
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  context
                      .read<RequesterSubmitIntakeFormCubit>()
                      .submitIntakeForm(serviceId, draft);
                },
                label: "Kirim",
              )),
    );
  }
}
