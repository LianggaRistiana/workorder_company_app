import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/submit_review_form/requester_submit_review_form_cubit.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/submit_review_form/requester_submit_review_form_state.dart';
import 'package:workorder_company_app/features/service_request/presentation/widgets/service_request_property_view.dart';
import 'package:workorder_company_app/features/submissions/presentation/coordinator/form_renderer_coordinator.dart';
import 'package:workorder_company_app/features/submissions/presentation/cubit/file_upload_progress_cubit.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/form_renderer.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/adaptive_split_column.dart';
import 'package:workorder_company_app/shared/widgets/button_with_loading_state.dart';

class RequesterReviewPage extends StatefulWidget {
  final RequesterServiceRequestEntity request;
  const RequesterReviewPage({super.key, required this.request});

  @override
  State<RequesterReviewPage> createState() => _RequesterReviewPageState();
}

class _RequesterReviewPageState extends State<RequesterReviewPage> {
  late final FormRendererCoordinator coordinator;

  @override
  void initState() {
    super.initState();

    final form = widget.request.reviewForm?.form;
    if (form == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.pop();
        context.showError("Formulir tidak tersedia");
      });
    } else {
      coordinator = FormRendererCoordinator.form(form);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RequesterSubmitReviewFormCubit>(),
      child: BlocConsumer<RequesterSubmitReviewFormCubit,
          RequesterSubmitReviewFormState>(
        listener: (context, state) {
          if (state.status == RequesterSubmitReviewFormStatus.success) {
            context.showSuccess("Berhasil mengirim review");
            context.pop();
          }
          if (state.status == RequesterSubmitReviewFormStatus.error) {
            context.showError(state.errorMessage ?? "Terjadi kesalahan");
          }
        },
        builder: (context, state) => Scaffold(
          appBar: AppBar(),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: _buildSubmitButton(context,
                    state.status == RequesterSubmitReviewFormStatus.loading)
                .hideOnLargeScreen(),
          ),
          body: SafeArea(
            child: AdaptiveSplitColumn(leftChildren: [
              ServiceRequestPropertyView(serviceRequest: widget.request),
              const SizedBox(height: 16),
            ], rightChildren: [
              if (widget.request.reviewForm?.form != null) ...[
                FormRenderer(
                  coordinator: coordinator,
                ),
                const SizedBox(height: 16),
                _buildSubmitButton(context,
                        state.status == RequesterSubmitReviewFormStatus.loading)
                    .hideOnSmallScreen()
              ] else ...[
                const SizedBox.shrink(),
              ],
              const SizedBox(height: 16),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, bool isLoading) {
    return ButtonWithLoadingState(
        icon: AppIcon.send,
        progress: context.watch<FileUploadProgressCubit>().state.totalProgress,
        loadingLabel:
            context.watch<FileUploadProgressCubit>().state.buttonMessage ??
                "Menyimpan...",
        onPressed: () {
          context
              .read<RequesterSubmitReviewFormCubit>()
              .submitReviewForm(widget.request.id, coordinator.draft);
        },
        isLoading: isLoading,
        label: "Kirim");
  }
}
