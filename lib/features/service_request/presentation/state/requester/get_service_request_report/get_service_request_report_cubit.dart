import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/forms/domain/entities/work_reports_filled_form_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/usecases/requester/requester_get_service_request_report_usecase.dart';
import 'package:workorder_company_app/features/service_request/presentation/state/requester/get_service_request_report/get_service_request_report_state.dart';

class GetServiceRequestReportCubit extends Cubit<GetServiceRequestReportState> {
  final RequesterGetServiceRequestReportUsecase _getServiceRequestReportUsecase;

  GetServiceRequestReportCubit({
    required RequesterGetServiceRequestReportUsecase
        getServiceRequestReportUsecase,
  })  : _getServiceRequestReportUsecase = getServiceRequestReportUsecase,
        super(const GetServiceRequestReportState(
          status: GetServiceRequestReportStatus.initial,
          reports: WorkReportsFilledFormEntity(filledForms: []),
          errorMessage: null,
        ));

  Future<void> getReport(String id) async {
    emit(GetServiceRequestReportState(
      status: GetServiceRequestReportStatus.loading,
      reports: state.reports,
      errorMessage: null,
    ));

    final result = await _getServiceRequestReportUsecase.call(id);

    result.fold(
      (failure) => emit(GetServiceRequestReportState(
        status: GetServiceRequestReportStatus.error,
        reports: state.reports,
        errorMessage: failure.message,
      )),
      (reports) => emit(GetServiceRequestReportState(
        status: GetServiceRequestReportStatus.success,
        reports: reports,
        errorMessage: null,
      )),
    );
  }
}
