import 'package:workorder_company_app/core/model/mock_factory.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/features/positions/data/datasources/positions_remote_datasource.dart';
import 'package:workorder_company_app/features/positions/data/mock/position_mock_factory.dart';
import 'package:workorder_company_app/features/positions/data/models/position_model.dart';

class MockPositionRemoteDatasource implements PositionsRemoteDatasource {
  @override
  Future<ApiResponse<PositionModel>> createPosition(
      PositionModel positionData) {
    // TODO: implement createPosition
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<PositionModel>> getPositionById(String id) async {
    return MockApiResponse.success(PositionModel(id: "1", name: "TES"));
    // return MockApiResponse.success(PositionMockFactory().createModel());
  }

  @override
  Future<ApiResponse<List<PositionModel>>> getPositions() async {
    return MockApiResponse.success(
        PositionMockFactory().createList(count: 100));
  }

  @override
  Future<ApiResponse<PositionModel>> updatePosition(
      PositionModel positionData) {
    // TODO: implement updatePosition
    throw UnimplementedError();
  }
}
