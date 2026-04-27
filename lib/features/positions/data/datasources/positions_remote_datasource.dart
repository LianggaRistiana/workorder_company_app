import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/features/positions/data/models/position_model.dart';

abstract class PositionsRemoteDatasource {
  Future<ApiResponse<List<PositionModel>>> getPositions();
  Future<ApiResponse<PositionModel>> getPositionById(String id);
  Future<ApiResponse<PositionModel>> createPosition(PositionModel positionData);
  Future<ApiResponse<PositionModel>> updatePosition(PositionModel positionData);
}

class PositionsRemoteDatasourceImpl implements PositionsRemoteDatasource {
  final ApiClient _apiClient;

  PositionsRemoteDatasourceImpl(this._apiClient);

  @override
  Future<ApiResponse<List<PositionModel>>> getPositions() async {
    return _apiClient.get<ApiResponse<List<PositionModel>>>(Endpoints.positions,
        fromJson: (json) =>
            ApiResponse<List<PositionModel>>.fromJson(json, (data) {
              final positions = (data as List?) ?? [];
              return positions.map((e) => PositionModel.fromJson(e)).toList();
            }));
  }

  @override
  Future<ApiResponse<PositionModel>> createPosition(
      PositionModel positionData) async {
    final response =
        await _apiClient.post(Endpoints.positions, data: positionData.toJson());
    return ApiResponse<PositionModel>.fromJson(
      response,
      (data) => PositionModel.fromJson(data),
    );
  }

  @override
  Future<ApiResponse<PositionModel>> updatePosition(
      PositionModel positionData) async {
    final response = await _apiClient.put(
        Endpoints.positions.byId(positionData.id),
        data: positionData.toJson());
    return ApiResponse<PositionModel>.fromJson(
      response,
      (data) => PositionModel.fromJson(data),
    );
  }

  @override
  Future<ApiResponse<PositionModel>> getPositionById(String id) async {
    final response = await _apiClient.get(Endpoints.positions.byId(id));
    return ApiResponse<PositionModel>.fromJson(
      response,
      (data) => PositionModel.fromJson(data),
    );
  }
}
