import 'package:workorder_company_app/core/network/api_response.dart';

// TODO : refactor all remote datasource using this
typedef ApiFuture<T> = Future<ApiResponse<T>>;
typedef ApiFutureList<T> = Future<ApiResponse<List<T>>>;
