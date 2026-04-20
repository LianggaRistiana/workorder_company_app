import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/work_report/domain/entities/work_report_entity.dart';
import 'package:workorder_company_app/features/work_report/domain/usecases/approve_work_report_usecase.dart';
import 'package:workorder_company_app/features/work_report/domain/usecases/reject_work_report_usecase.dart';
import 'package:workorder_company_app/features/work_report/presentation/state/approval/approval_work_report_state.dart';

class ApprovalWorkReportCubit extends Cubit<ApprovalWorkReportState> {
  final ApproveWorkReportUsecase approveUseCase;
  final RejectWorkReportUsecase rejectUseCase;

  ApprovalWorkReportCubit({
    required this.approveUseCase,
    required this.rejectUseCase,
  }) : super(ApprovalWorkReportState.initial());

  Future<void> approveWorkReport(WorkReportEntity workReport) async {
    emit(state.copyWith(status: ApprovalWorkReportStatus.loading));
    final result = await approveUseCase(workReport);
    result.fold(
      (failure) => emit(state.copyWith(
        status: ApprovalWorkReportStatus.error,
        errorMessage: failure.message,
      )),
      (report) => emit(state.copyWith(
        status: ApprovalWorkReportStatus.approved,
        workReport: report,
      )),
    );
  }

  Future<void> rejectWorkReport(WorkReportEntity workReport) async {
    emit(state.copyWith(status: ApprovalWorkReportStatus.loading));
    final result = await rejectUseCase(workReport);
    result.fold(
      (failure) => emit(state.copyWith(
        status: ApprovalWorkReportStatus.error,
        errorMessage: failure.message,
      )),
      (report) => emit(state.copyWith(
        status: ApprovalWorkReportStatus.rejected,
        workReport: report,
      )),
    );
  }
}
