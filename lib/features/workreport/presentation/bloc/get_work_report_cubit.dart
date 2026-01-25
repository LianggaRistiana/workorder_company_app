import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/workreport/domain/usecases/get_work_report_usecase.dart';
import 'package:workorder_company_app/features/workreport/presentation/bloc/work_report_state.dart';

class GetWorkReportCubit extends Cubit<WorkReportState> {
  final GetWorkReportUsecase _getWorkReportUsecase;

  GetWorkReportCubit(this._getWorkReportUsecase) : super(WorkReportState());

  Future<void> getWorkReport(String id) async {
    emit(state.copyWith(status: WorkReportStateStatus.loading));
    final result = await _getWorkReportUsecase(id);
    result.fold(
      (fail) => emit(state.copyWith(
          status: WorkReportStateStatus.error, errorMessage: fail.message)),
      (workReport) => emit(state.copyWith(
          status: WorkReportStateStatus.loaded, workReport: workReport)),
    );
  }
}
