import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/features/workreport/data/model/work_report_model.dart';

abstract class WorkReportRemoteDatasource {
  Future<ApiResponse<WorkReportModel>> getWorkReportByWorkorderId(String id);
  Future<ApiResponse<WorkReportModel>> submitWorkReportByWorkorderId(String id);
}

class WorkReportRemoteDatasourceImpl implements WorkReportRemoteDatasource {
  final ApiClient _apiClient;

  WorkReportRemoteDatasourceImpl(this._apiClient);

  @override
  Future<ApiResponse<WorkReportModel>> getWorkReportByWorkorderId(
      String id) async {
    final response = await _apiClient.get(Endpoints.workorderReport(id));
    return ApiResponse.fromJson(
      response,
      (json) => WorkReportModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<WorkReportModel>> submitWorkReportByWorkorderId(
      String id) {
    // TODO: implement submitWorkreportByWorkorderId
    throw UnimplementedError();
  }
}
