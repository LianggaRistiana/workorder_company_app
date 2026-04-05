import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/theme/app_icon.dart';
import 'package:workorder_company_app/core/theme/app_spacing.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/draft/submisson_draft.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/form_renderer.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/button_with_loading_state.dart';

class RequesterReviewPage extends StatefulWidget {
  final RequesterServiceRequestEntity request;
  const RequesterReviewPage({super.key, required this.request});

  @override
  State<RequesterReviewPage> createState() => _RequesterReviewPageState();
}

class _RequesterReviewPageState extends State<RequesterReviewPage> {
  late final SubmissionDraft draft;

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
      draft = SubmissionDraft.fromFormEntity(form);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: ButtonWithLoadingState(
            icon: AppIcon.send,
            onPressed: () {},
            isLoading: false,
            label: "Kirim"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: SingleChildScrollView(
            child: Column(children: [
          widget.request.reviewForm?.form != null
              ? FormRenderer(
                  filledForm: widget.request.reviewForm!,
                  onChanged: (formId, order, value) {
                    draft.updateValue(order, value);
                  })
              : const SizedBox(),
          const SizedBox(height: 16),
        ])),
      ),
    );
  }
}
