import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
// import 'package:workorder_company_app/core/constants/app_enums.dart';
// import 'package:workorder_company_app/features/forms/domain/entities/ordered_form_entity.dart';
// import 'package:workorder_company_app/features/submissions/domain/entitties/field_data_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';
// import 'package:workorder_company_app/features/submissions/presentation/widgets/form_renderer_legacy.dart';
import 'package:workorder_company_app/features_legacy/workreport_legacy/presentation/bloc/get_work_report_cubit.dart';
import 'package:workorder_company_app/features_legacy/workreport_legacy/presentation/bloc/submit_work_report_cubit.dart';
import 'package:workorder_company_app/features_legacy/workreport_legacy/presentation/bloc/work_report_state.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';
import 'package:workorder_company_app/shared/widgets/empty_state_widget.dart';

class WorkReportSubmissionPage extends StatefulWidget {
  final String workorderId;
  const WorkReportSubmissionPage({super.key, required this.workorderId});

  @override
  State<WorkReportSubmissionPage> createState() =>
      _WorkreportSubmissionStatePage();
}

class _WorkreportSubmissionStatePage extends State<WorkReportSubmissionPage> {
  final _formKey = GlobalKey<FormState>();
  List<SubmissionEntity> submissions = [];
  bool initialized = false;

  // void _onFieldChanged(String formId, String order, dynamic value) {
  //   final updated = List<SubmissionEntity>.from(submissions);
  //   final index = updated.indexWhere((s) => s.formId == formId);
  //   if (index == -1) return;

  //   final submission = updated[index];
  //   final updatedFields =
  //       List<FieldDataEntity>.from(submission.fieldsData ?? []);
  //   final fieldIndex = updatedFields.indexWhere((f) => f.order == order);

  //   if (fieldIndex != -1) {
  //     updatedFields[fieldIndex] = FieldDataEntity(order: order, value: value);
  //   } else {
  //     updatedFields.add(FieldDataEntity(order: order, value: value));
  //   }

  //   updated[index] = submission.copyWith(fieldsData: updatedFields);
  //   setState(() => submissions = updated);
  // }

  // List<SubmissionEntity> _initialize(
  //   List<OrderedFormEntity> orderedForms,
  //   List<SubmissionEntity> initial,
  // ) {
  //   if (initial.isNotEmpty) return initial;

  //   return orderedForms
  //       .map(
  //         (e) => SubmissionEntity(
  //           id: '',
  //           formId: e.form.id,
  //           submissionType: FormType.report,
  //           fieldsData: [],
  //         ),
  //       )
  //       .toList();
  // }

  @override
  Widget build(BuildContext context) {
    final workReport = context.watch<GetWorkReportCubit>().state.workReport;

    if (workReport == null) {
      return const Scaffold(
        body: Center(child: EmptyStateWidget()),
      );
    }

    // final orderedForms = workReport.reportForms
    //         ?.map((e) => OrderedFormEntity(
    //               form: e.form,
    //               // order: e.order ?? 0,
    //             ))
    //         .toList() ??
    //     [];

    // final initialSubs = workReport.reportForms
    //         ?.map((e) => e.submission)
    //         .whereType<SubmissionEntity>()
    //         .toList() ??
    //     [];

    // /// ⭐ INITIALIZE SUBMISSIONS ONCE — tanpa setState
    // if (!initialized) {
    //   submissions = _initialize(orderedForms, initialSubs);
    //   initialized = true;
    // }

    return BlocConsumer<SubmitWorkReportCubit, WorkReportSubmitState>(
      listener: (context, state) {
        if (state.status == WorkReportStateStatus.success) {
          context.showSuccess('Berhasil menyimpan formulir laporan');
          context.pop(true);
        }

        if (state.status == WorkReportStateStatus.error) {
          context.showError(state.errorMessage ?? 'Terjadi kesalahan');
        }
      },
      builder: (context, state) {
        final isLoading = state.status == WorkReportStateStatus.loading;

        return Scaffold(
          appBar: AppBar(),
          bottomNavigationBar: FilledButton.icon(
            label: const Text("Simpan"),
            onPressed: isLoading
                ? null
                : () {
                    if (_formKey.currentState?.validate() ?? false) {
                      context
                          .read<SubmitWorkReportCubit>()
                          .submitWorkReport(widget.workorderId, submissions);
                    }
                  },
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.save),
          ),
          // body: Form(
          //   key: _formKey,
          //   child: SingleChildScrollView(
          //     padding: const EdgeInsets.all(16),
          //     child: FormRenderer(
          //       orderedForms: orderedForms,
          //       submissions: submissions,
          //       onChanged: _onFieldChanged,
          //     ),
          //   ),
          // )
        );
      },
    );
  }
}
