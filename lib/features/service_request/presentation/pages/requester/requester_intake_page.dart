import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/forms/domain/entities/filled_form_entity.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/get_intake_form/requester_get_intake_form_cubit.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/get_intake_form/requester_get_intake_form_state.dart';
import 'package:workorder_company_app/features/services/domain/entities/base_service_entity.dart';
import 'package:workorder_company_app/features/services/presentation/widgets/service_summary_property_view.dart';
import 'package:workorder_company_app/features/submissions/domain/draft/submisson_draft.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/form_renderer.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/app_loading.dart';
import 'package:workorder_company_app/shared/widgets/button_with_loading_state.dart';

class RequesterIntakePage extends StatefulWidget {
  final BaseServiceEntity baseService;

  const RequesterIntakePage({super.key, required this.baseService});

  @override
  State<RequesterIntakePage> createState() => _RequesterIntakePageState();
}

class _RequesterIntakePageState extends State<RequesterIntakePage> {
  late final SubmissionDraft draft;

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
            draft = SubmissionDraft.fromFormEntity(state.form!);
          }
        },
        builder: (context, state) => Scaffold(
          appBar: AppBar(),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child:
                // Provide Intake state here
                ButtonWithLoadingState(
              icon: Icons.send,
              isLoading: false,
              onPressed: () {},
              label: "Kirim",
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ServiceSummaryPropertyView(service: widget.baseService),
                  if (state.status == RequesterGetIntakeFormStatus.loading) ...[
                    const SizedBox(height: 16),
                    AppLoading()
                  ],
                  if (state.status == RequesterGetIntakeFormStatus.loaded &&
                      state.form != null) ...[
                    FormRenderer(
                        filledForm: FilledFormEntity(form: state.form!),
                        onChanged: (formId, order, value) {
                          draft.updateValue(order, value);
                        }),
                    const SizedBox(height: 16)
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
