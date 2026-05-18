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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FormRendererCoordinator? coordinator;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<RequesterGetIntakeFormCubit>()
            ..getIntakeForm(widget.baseService.id),
        ),
        BlocProvider(
          create: (_) => sl<RequesterSubmitIntakeFormCubit>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<RequesterGetIntakeFormCubit,
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
          ),
          BlocListener<RequesterSubmitIntakeFormCubit,
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
          ),
        ],
        child: Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: BlocBuilder<RequesterGetIntakeFormCubit,
                RequesterGetIntakeFormState>(
              builder: (context, state) {
                return AdaptiveSplitColumn(
                  leftChildren: [
                    ServiceSummaryPropertyView(service: widget.baseService),
                    const SizedBox(height: 16),
                  ],
                  rightChildren: [
                    if (state.status ==
                        RequesterGetIntakeFormStatus.loading) ...[
                      const SizedBox(height: 16),
                      AppLoading(),
                    ],
                    if (state.status == RequesterGetIntakeFormStatus.loaded &&
                        coordinator != null) ...[
                      Form(
                        key: _formKey,
                        child: FormRenderer(
                          coordinator: coordinator!,
                        ),
                      ), // TODO : Test For giving Form here
                      const SizedBox(height: 16),
                      _SubmitButton(
                        formKey: _formKey,
                        draft: coordinator!.draft,
                        serviceId: widget.baseService.id,
                      ).hideOnSmallScreen(),
                    ],
                  ],
                );
              },
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: BlocBuilder<RequesterGetIntakeFormCubit,
                  RequesterGetIntakeFormState>(
                builder: (context, state) {
                  if (state.status == RequesterGetIntakeFormStatus.loaded &&
                      coordinator != null) {
                    return _SubmitButton(
                      formKey: _formKey,
                      draft: coordinator!.draft,
                      serviceId: widget.baseService.id,
                    ).hideOnLargeScreen();
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final SubmissionDraft draft;
  final String serviceId;

  const _SubmitButton({
    required this.formKey,
    required this.draft,
    required this.serviceId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequesterSubmitIntakeFormCubit,
        RequesterSubmitIntakeFormState>(
      builder: (context, state) {
        final uploadState = context.watch<FileUploadProgressCubit>().state;

        return ButtonWithLoadingState(
          icon: Icons.send,
          progress: uploadState.totalProgress,
          loadingLabel: uploadState.buttonMessage ?? "Menyimpan...",
          isLoading: state.status == RequesterSubmitIntakeFormStatus.loading,
          onPressed: () {
            FocusScope.of(context).unfocus();
            if (!formKey.currentState!.validate()) return;

            context
                .read<RequesterSubmitIntakeFormCubit>()
                .submitIntakeForm(serviceId, draft);
          },
          label: "Kirim",
        );
      },
    );
  }
}
