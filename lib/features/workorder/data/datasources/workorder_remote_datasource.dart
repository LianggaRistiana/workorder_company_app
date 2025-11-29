import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/core/utils/safe_mapper.dart';
import 'package:workorder_company_app/features/workorder/data/model/workorder_model.dart';

abstract class WorkorderRemoteDatasource {
  Future<ApiResponse<List<WorkorderModel>>> getWorkorders();
  Future<ApiResponse<WorkorderModel>> getWorkorderById(String id);
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
}
