import 'package:workorder_company_app/core/model/meta_model.dart';
import 'package:workorder_company_app/core/network/api_response.dart';

typedef ApiFuture<T> = Future<ApiResponse<T>>;
typedef ApiFutureList<T> = Future<ApiResponse<List<T>>>;

typedef ApiFutureWithMeta<T, M extends MetaModel>
    = Future<ApiResponseWithMeta<T, M>>;
