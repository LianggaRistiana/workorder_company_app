import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features_legacy/workreport_legacy/data/datasources/work_report_remote_datasource.dart';
import 'package:workorder_company_app/features_legacy/workreport_legacy/data/repositories/work_report_repository_impl.dart';
import 'package:workorder_company_app/features_legacy/workreport_legacy/domain/repositories/work_report_repository.dart';
import 'package:workorder_company_app/features_legacy/workreport_legacy/domain/usecases/get_work_report_usecase.dart';
import 'package:workorder_company_app/features_legacy/workreport_legacy/domain/usecases/submit_work_report_usecase.dart';
import 'package:workorder_company_app/features_legacy/workreport_legacy/presentation/bloc/get_work_report_cubit.dart';
import 'package:workorder_company_app/features_legacy/workreport_legacy/presentation/bloc/submit_work_report_cubit.dart';

Future<void> intiWorkRerportFeature() async {
  sl.registerLazySingleton<WorkReportRemoteDatasource>(
      () => WorkReportRemoteDatasourceImpl(sl()));

  sl.registerLazySingleton<WorkReportRepository>(
      () => WorkReportRepositoryImpl(sl()));

  sl.registerLazySingleton<GetWorkReportUsecase>(
      () => GetWorkReportUsecase(sl()));

  sl.registerLazySingleton<SubmitWorkReportUsecase>(
      () => SubmitWorkReportUsecase(sl()));

  sl.registerFactory<GetWorkReportCubit>(() => GetWorkReportCubit(sl()));
  sl.registerFactory<SubmitWorkReportCubit>(() => SubmitWorkReportCubit(sl()));
}
