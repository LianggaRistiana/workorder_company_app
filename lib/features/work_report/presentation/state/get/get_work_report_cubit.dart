import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_report/domain/entities/work_report_entity.dart';
import 'package:workorder_company_app/features/work_report/domain/usecases/get_work_report_usecase.dart';
import 'package:workorder_company_app/features/work_report/presentation/state/get/get_work_report_state.dart';

class GetWorkReportCubit extends Cubit<GetWorkReportState> {
  final GetWorkReportUsecase getWorkReportUseCase;

  GetWorkReportCubit({required this.getWorkReportUseCase})
      : super(GetWorkReportState.initial());

  Future<void> getWorkReport(WorkOrderEntity workOrder) async {
    emit(state.copyWith(status: GetWorkReportStatus.loading));

    final result = await getWorkReportUseCase(workOrder);

    result.fold(
      (failure) => emit(state.copyWith(
        status: GetWorkReportStatus.error,
        errorMessage: failure.message,
      )),
      (report) => emit(state.copyWith(
        status: GetWorkReportStatus.loaded,
        workReport: report,
      )),
    );
  }

  Future<void> updateResult(WorkReportEntity result) async {
    emit(state.copyWith(
      workReport: result,
      shouldRefreshWorkOrder: true,
    ));
  }
}
