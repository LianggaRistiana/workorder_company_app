import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/work_report/domain/entities/work_report_entity.dart';
import 'package:workorder_company_app/features/work_report/domain/usecases/send_work_report_usecase.dart';
import 'package:workorder_company_app/features/work_report/presentation/state/send/send_work_report_state.dart';

class SendWorkReportCubit extends Cubit<SendWorkReportState> {
  final SendWorkReportUsecase useCase;

  SendWorkReportCubit({required this.useCase})
      : super(SendWorkReportState.initial());

  Future<void> sendWorkReport(WorkReportEntity workReport) async {
    emit(state.copyWith(status: SendWorkReportStatus.loading));
    final result = await useCase(workReport);
    result.fold(
      (failure) => emit(state.copyWith(
        status: SendWorkReportStatus.error,
        errorMessage: failure.message,
      )),
      (result) => emit(state.copyWith(
        status: SendWorkReportStatus.success,
        workReport: result,
      )),
    );
  }
}
