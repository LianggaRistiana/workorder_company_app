import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/core/utils/safe_mapper.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';
import 'package:workorder_company_app/features/workorder/data/model/workorder_model.dart';

abstract class WorkorderRemoteDatasource {
  Future<ApiResponse<List<WorkorderModel>>> getWorkorders();
  Future<ApiResponse<WorkorderModel>> setAssignedStaffs(
      List<String> staffEmail, String workorderId);
  Future<ApiResponse<WorkorderModel>> getWorkorderById(String id);
  Future<ApiResponse<WorkorderModel>> setSubmissions(
      String id, List<SubmissionsModel> submissions);
  Future<ApiResponse<WorkorderModel>> setToReady(String id);
  Future<ApiResponse<WorkorderModel>> setToStart(String id);
  Future<ApiResponse<WorkorderModel>> setToCancel(String id);
  Future<ApiResponse<WorkorderModel>> setToComplete(String id);
}

class WorkorderRemoteDatasourceImpl implements WorkorderRemoteDatasource {
  final ApiClient _apiClient;

  WorkorderRemoteDatasourceImpl(this._apiClient);

  @override
  Future<ApiResponse<WorkorderModel>> getWorkorderById(String id) async {
    final response = await _apiClient.get(Endpoints.workorder.byId(id));
    return ApiResponse.fromJson(
      response,
      (json) => WorkorderModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<List<WorkorderModel>>> getWorkorders() async {
    final response = await _apiClient.get(Endpoints.workorder);
    return ApiResponse.fromJson(
      response,
      (data) => SafeMapper.mapList(
        data,
        (json) => WorkorderModel.fromJson(json),
      ),
    );
  }

  @override
  Future<ApiResponse<WorkorderModel>> setAssignedStaffs(
      List<String> staffEmail, String workorderId) async {
    final response = await _apiClient.put(
        Endpoints.workorderSetAssignedStaff(workorderId),
        data: {"staffEmail": staffEmail});
    return ApiResponse.fromJson(
      response,
      (json) => WorkorderModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<WorkorderModel>> setSubmissions(
      String id, List<SubmissionsModel> submissions) async {
    final response = await _apiClient.put(Endpoints.workorderSetSubmissions(id),
        data: {"submissions": submissions});
    return ApiResponse.fromJson(
      response,
      (json) => WorkorderModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<WorkorderModel>> setToCancel(String id) {
    // TODO: implement setToCancel
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<WorkorderModel>> setToComplete(String id) {
    // TODO: implement setToComplete
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<WorkorderModel>> setToReady(String id) async {
    final response = await _apiClient.put(Endpoints.workorderSetToReady(id));
    return ApiResponse.fromJson(
      response,
      (json) => WorkorderModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<WorkorderModel>> setToStart(String id) async {
    final response = await _apiClient.put(Endpoints.workorderStart(id));
    return ApiResponse.fromJson(
      response,
      (json) => WorkorderModel.fromJson(json),
    );
  }
}
