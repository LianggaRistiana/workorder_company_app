import 'package:workorder_company_app/core/services/network/api_response.dart';

abstract class MockFactory<T> {
  T createModel();
  Map<String, dynamic> createJson();
  List<T> createList({int count = 10});
}

class MockApiResponse<T> extends ApiResponse<T> {
  MockApiResponse({required super.message, required super.data});

  /// ✅ Simple mock (tanpa JSON)
  factory MockApiResponse.success(T data) {
    return MockApiResponse<T>(
      message: "Success",
      data: data,
    );
  }

  factory MockApiResponse.error(T data) {
    return MockApiResponse<T>(
      message: "Error",
      data: data,
    );
  }
}
