import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';
import 'package:workorder_company_app/features_legacy/workreport_legacy/data/model/work_report_model.dart';

abstract class WorkReportRemoteDatasource {
  Future<ApiResponse<WorkReportModel>> getWorkReportByWorkorderId(String id);
  Future<ApiResponse<WorkReportModel>> submitWorkReportByWorkorderId(
      String id, List<SubmissionsModel> submissions);
}

class WorkReportRemoteDatasourceImpl implements WorkReportRemoteDatasource {
  final ApiClient _apiClient;

  WorkReportRemoteDatasourceImpl(this._apiClient);

  @override
  Future<ApiResponse<WorkReportModel>> getWorkReportByWorkorderId(
      String id) async {
    throw UnimplementedError();

    // final response = await _apiClient.get(Endpoints.workorderReport(id));
    // return ApiResponse.fromJson(
    //   response,
    //   (json) => WorkReportModel.fromJson(json),
    // );
  }

  @override
  Future<ApiResponse<WorkReportModel>> submitWorkReportByWorkorderId(
      String id, List<SubmissionsModel> submissions) async {
    throw UnimplementedError();

    // final response = await _apiClient.put(
    //     Endpoints.workorderReportSubmissions(id),
    //     data: {"submissions": submissions});
    // return ApiResponse.fromJson(
    //   response,
    //   (json) => WorkReportModel.fromJson(json),
    // );
  }
}
