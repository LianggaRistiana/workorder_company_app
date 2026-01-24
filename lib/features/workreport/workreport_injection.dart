import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/workreport/data/datasources/work_report_remote_datasource.dart';
import 'package:workorder_company_app/features/workreport/data/repositories/work_report_repository_impl.dart';
import 'package:workorder_company_app/features/workreport/domain/repositories/work_report_repository.dart';
import 'package:workorder_company_app/features/workreport/domain/usecases/get_work_report_usecase.dart';
import 'package:workorder_company_app/features/workreport/presentation/bloc/get_work_report_cubit.dart';

Future<void> intiWorkRerportFeature() async {
  sl.registerLazySingleton<WorkReportRemoteDatasource>(
      () => WorkReportRemoteDatasourceImpl(sl()));

  sl.registerLazySingleton<WorkReportRepository>(
      () => WorkReportRepositoryImpl(sl()));

  sl.registerLazySingleton<GetWorkReportUsecase>(
      () => GetWorkReportUsecase(sl()));

  sl.registerFactory<GetWorkReportCubit>(() => GetWorkReportCubit(sl()));
}
