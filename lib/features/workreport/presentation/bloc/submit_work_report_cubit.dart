import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';
import 'package:workorder_company_app/features/workreport/domain/usecases/submit_work_report_usecase.dart';
import 'package:workorder_company_app/features/workreport/presentation/bloc/work_report_state.dart';

class SubmitWorkReportCubit extends Cubit<WorkReportSubmitState> {
  final SubmitWorkReportUsecase _submitWorkReportUsecase;

  SubmitWorkReportCubit(this._submitWorkReportUsecase)
      : super(WorkReportSubmitState());

  Future<void> submitWorkReport(
      String workorderId, List<SubmissionEntity> submissions) async {
    emit(state.copyWith(status: WorkReportStateStatus.loading));
    final result = await _submitWorkReportUsecase(workorderId, submissions);
    result.fold(
        (fail) => emit(state.copyWith(
            status: WorkReportStateStatus.error, errorMessage: fail.message)),
        (_) => emit(state.copyWith(status: WorkReportStateStatus.success)));
  }
}
