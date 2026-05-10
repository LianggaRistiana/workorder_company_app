import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/core/services/network/path_helper.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/dashboard/data/model/service_request_stats_model.dart';
import 'package:workorder_company_app/features/dashboard/data/model/work_order_stats_model.dart';

abstract class DashboardRemoteDatasource {
  ApiFuture<ServiceRequestStatsModel> getServiceRequestStats(
    PeriodType periodType,
  );
  ApiFuture<WorkOrderStatsModel> getWorkOrderStats(
    PeriodType periodType,
  );
  // TODO :  Company Stat
}

class DashboardRemoteDatasourceImpl implements DashboardRemoteDatasource {
  final ApiClient _apiClient;

  DashboardRemoteDatasourceImpl(this._apiClient);

  @override
  ApiFuture<ServiceRequestStatsModel> getServiceRequestStats(
    PeriodType periodType,
  ) async {
    final query = <String, String>{}.addQueries(periodType.queryParams);

    final response =
        await _apiClient.get(Endpoints.serviceRequestStat.withQuery(query));
    return ApiResponse.fromJson(
      response,
      (data) => ServiceRequestStatsModel.fromJson(data),
    );
  }

  @override
  ApiFuture<WorkOrderStatsModel> getWorkOrderStats(
      PeriodType periodType) async {
    final query = <String, String>{}.addQueries(periodType.queryParams);

    final response =
        await _apiClient.get(Endpoints.workOrderStat.withQuery(query));
    return ApiResponse.fromJson(
      response,
      (data) => WorkOrderStatsModel.fromJson(data),
    );
  }
}
