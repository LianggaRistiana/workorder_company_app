import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/submissions/domain/draft/submisson_draft.dart';
import 'package:workorder_company_app/features/work_report/domain/entities/work_report_entity.dart';
import 'package:workorder_company_app/features/work_report/domain/usecases/submit_work_report_submission_usecase.dart';
import 'package:workorder_company_app/features/work_report/presentation/state/submit/submit_work_report_submission_state.dart';

class SubmitWorkReportSubmissionCubit
    extends Cubit<SubmitWorkReportSubmissionState> {
  final SubmitWorkReportSubmissionUsecase useCase;

  SubmitWorkReportSubmissionCubit({required this.useCase})
      : super(SubmitWorkReportSubmissionState.initial());

  Future<void> submitWorkReportSubmission(
      WorkReportEntity workReport, SubmissionDraft submission) async {
    emit(state.copyWith(status: SubmitWorkReportSubmissionStatus.loading));
    final result = await useCase(workReport, submission);
    result.fold(
      (failure) => emit(state.copyWith(
        status: SubmitWorkReportSubmissionStatus.error,
        errorMessage: failure.message,
      )),
      (result) => emit(state.copyWith(
        status: SubmitWorkReportSubmissionStatus.success,
        workReport: result,
      )),
    );
  }
}
