import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:workorder_company_app/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:workorder_company_app/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:workorder_company_app/features/dashboard/domain/usecases/get_company_stats_usecase.dart';
import 'package:workorder_company_app/features/dashboard/domain/usecases/get_service_request_stats_usecase.dart';
import 'package:workorder_company_app/features/dashboard/domain/usecases/get_work_order_stats_usecase.dart';
import 'package:workorder_company_app/features/dashboard/presentation/bloc/company_stat/company_stat_cubit.dart';
import 'package:workorder_company_app/features/dashboard/presentation/bloc/service_request_stat/service_request_stats_cubit.dart';
import 'package:workorder_company_app/features/dashboard/presentation/bloc/work_order_stat/work_order_stats_cubit.dart';

Future<void> initDashboardFeature() async {
  sl.registerLazySingleton<DashboardRemoteDatasource>(
    () => DashboardRemoteDatasourceImpl(
      sl<ApiClient>(),
    ),
  );

  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      sl<DashboardRemoteDatasource>(),
    ),
  );

  sl.registerLazySingleton<GetServiceRequestStatsUsecase>(
    () => GetServiceRequestStatsUsecase(
      sl<DashboardRepository>(),
    ),
  );

  sl.registerLazySingleton<GetWorkOrderStatsUsecase>(
    () => GetWorkOrderStatsUsecase(
      sl<DashboardRepository>(),
    ),
  );

  sl.registerLazySingleton<GetCompanyStatsUsecase>(
    () => GetCompanyStatsUsecase(
      sl<DashboardRepository>(),
    ),
  );

  sl.registerLazySingleton<ServiceRequestStatsCubit>(
    () => ServiceRequestStatsCubit(
      sl<GetServiceRequestStatsUsecase>(),
    ),
  );

  sl.registerLazySingleton<WorkOrderStatsCubit>(
    () => WorkOrderStatsCubit(
      sl<GetWorkOrderStatsUsecase>(),
    ),
  );

  sl.registerLazySingleton<CompanyStatCubit>(
    () => CompanyStatCubit(
      sl<GetCompanyStatsUsecase>(),
    ),
  );
}
