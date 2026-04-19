import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';
import 'package:workorder_company_app/features/work_report/data/model/work_report_model.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';

abstract class WorkReportRemoteDatasource {
  ApiFuture<WorkReportModel> getWorkReport(String workOrderId);
  ApiFuture<WorkReportModel> submitWorkReportSubmission(
    String workReportId,
    SubmissionsModel submission,
  );
  ApiFuture<WorkReportModel> sendWorkReport(String workReportId);
  ApiFuture<WorkReportModel> approveWorkReport(String workReportId);
  ApiFuture<WorkReportModel> rejectWorkReport(String workReportId);
}

class WorkReportRemoteDatasourceImpl implements WorkReportRemoteDatasource {
  final ApiClient _apiClient;

  WorkReportRemoteDatasourceImpl(this._apiClient);

  @override
  ApiFuture<WorkReportModel> approveWorkReport(String workReportId) async {
    final response = await _apiClient
        .patch(Endpoints.workReportApprove.fillId(workReportId));
    return ApiResponse.fromJson(
      response,
      (json) => WorkReportModel.fromJson(json),
    );
  }

  @override
  ApiFuture<WorkReportModel> getWorkReport(String workOrderId) async {
    final response =
        await _apiClient.get(Endpoints.workReportDetail.fillId(workOrderId));
    return ApiResponse.fromJson(
      response,
      (json) => WorkReportModel.fromJson(json),
    );
  }

  @override
  ApiFuture<WorkReportModel> rejectWorkReport(String workReportId) async {
    final response =
        await _apiClient.patch(Endpoints.workReportReject.fillId(workReportId));
    return ApiResponse.fromJson(
      response,
      (json) => WorkReportModel.fromJson(json),
    );
  }

  @override
  ApiFuture<WorkReportModel> sendWorkReport(String workReportId) async {
    final response =
        await _apiClient.patch(Endpoints.workReportSent.fillId(workReportId));
    return ApiResponse.fromJson(
      response,
      (json) => WorkReportModel.fromJson(json),
    );
  }

  @override
  ApiFuture<WorkReportModel> submitWorkReportSubmission(
    String workReportId,
    SubmissionsModel submission,
  ) async {
    final response = await _apiClient
        .post(Endpoints.workReportSetSubmissions.fillId(workReportId));
    return ApiResponse.fromJson(
      response,
      (json) => WorkReportModel.fromJson(json),
    );
  }
}
