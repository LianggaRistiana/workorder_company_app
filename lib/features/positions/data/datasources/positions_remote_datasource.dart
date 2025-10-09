import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/features/positions/data/models/position_model.dart';

abstract class PositionsRemoteDatasource {
  Future<ApiResponse<List<PositionModel>>> getPositions();
  Future<ApiResponse<PositionModel>> createPosition(String name);
  Future<ApiResponse<PositionModel>> updatePosition();
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
  Future<ApiResponse<PositionModel>> updatePosition() {
    // TODO: implement updatePosition
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<PositionModel>> createPosition(String name) async {
    final response = await _apiClient.post(Endpoints.positions, data: name);
    return ApiResponse.fromJson(
        response, (data) => PositionModel.fromJson(data));
  }
}
