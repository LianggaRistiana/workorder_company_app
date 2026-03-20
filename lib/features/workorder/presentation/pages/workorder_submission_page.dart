import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/forms/domain/entities/ordered_form_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/field_data_entity.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';
import 'package:workorder_company_app/features/submissions/presentation/widgets/form_renderer.dart';
import 'package:workorder_company_app/features/workorder/presentation/bloc/workorder_submissions_forms_cubit.dart';
import 'package:workorder_company_app/features/workorder/presentation/bloc/workorder_bloc.dart';
import 'package:workorder_company_app/features/workorder/presentation/bloc/workorder_detail_cubit.dart';
import 'package:workorder_company_app/shared/utils/context_snackbar.dart';

class WorkorderSubmissionPage extends StatefulWidget {
  const WorkorderSubmissionPage({super.key});

  @override
  State<WorkorderSubmissionPage> createState() =>
      _WorkorderSubmissionPageState();
}

class _WorkorderSubmissionPageState extends State<WorkorderSubmissionPage> {
  final _formKey = GlobalKey<FormState>();
  List<SubmissionEntity> submissions = [];
  bool initialized = false;

  void _onFieldChanged(String formId, String order, dynamic value) {
    final updated = List<SubmissionEntity>.from(submissions);
    final index = updated.indexWhere((s) => s.formId == formId);
    if (index == -1) return;

    final submission = updated[index];
    final updatedFields =
        List<FieldDataEntity>.from(submission.fieldsData ?? []);
    final fieldIndex = updatedFields.indexWhere((f) => f.order == order);

    if (fieldIndex != -1) {
      updatedFields[fieldIndex] = FieldDataEntity(order: order, value: value);
    } else {
      updatedFields.add(FieldDataEntity(order: order, value: value));
    }

    updated[index] = submission.copyWith(fieldsData: updatedFields);
    setState(() => submissions = updated);
  }

  List<SubmissionEntity> _initialize(
    List<OrderedFormEntity> orderedForms,
    List<SubmissionEntity> initial,
  ) {
    if (initial.isNotEmpty) return initial;

    return orderedForms
        .map(
          (e) => SubmissionEntity(
            id: '',
            formId: e.form.id,
            submissionType: FormType.workOrder,
            fieldsData: [],
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final workorder = context.watch<WorkorderDetailCubit>().state.workorder;

    if (workorder == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final orderedForms = workorder.workorderForms
            ?.map((e) => OrderedFormEntity(
                  form: e.form,
                  order: e.order ?? 0,
                ))
            .toList() ??
        [];

    final initialSubs = workorder.workorderForms
            ?.map((e) => e.submission)
            .whereType<SubmissionEntity>()
            .toList() ??
        [];

    /// ⭐ INITIALIZE SUBMISSIONS ONCE — tanpa setState
    if (!initialized) {
      submissions = _initialize(orderedForms, initialSubs);
      initialized = true;
    }

    return BlocConsumer<WorkorderSubmissionsFormsCubit,
        WorkorderSubmissionsState>(
      listener: (context, state) {
        if (state.status == WorkorderStateStatus.success) {
          context.showSuccess('Berhasil menyimpan formulir tugas kerja');
          context.pop(true);
        }

        if (state.status == WorkorderStateStatus.error) {
          context.showError(state.errorMessage ?? 'Terjadi kesalahan');
        }
      },
      builder: (context, state) {
        final isLoading = state.status == WorkorderStateStatus.loading;

        return Scaffold(
          appBar: AppBar(),
          floatingActionButton: FloatingActionButton(
            onPressed: isLoading
                ? null
                : () {
                    if (_formKey.currentState?.validate() ?? false) {
                      context
                          .read<WorkorderSubmissionsFormsCubit>()
                          .submitSubmissions(workorder.id, submissions);
                    }
                  },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: isLoading
                  ? const SizedBox(
                      key: ValueKey("fab_loading"),
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save, key: ValueKey("fab_icon")),
            ),
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: FormRenderer(
                orderedForms: orderedForms,
                submissions: submissions,
                onChanged: _onFieldChanged,
              ),
            ),
          ),
        );
      },
    );
  }
}
