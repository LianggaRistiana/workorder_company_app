import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/work_report/data/datasources/work_report_remote_datasource.dart';
import 'package:workorder_company_app/features/work_report/data/repositories/work_report_repository_impl.dart';
import 'package:workorder_company_app/features/work_report/domain/repositories/work_report_repository.dart';
import 'package:workorder_company_app/features/work_report/domain/usecases/approve_work_report_usecase.dart';
import 'package:workorder_company_app/features/work_report/domain/usecases/get_work_report_usecase.dart';
import 'package:workorder_company_app/features/work_report/domain/usecases/reject_work_report_usecase.dart';
import 'package:workorder_company_app/features/work_report/domain/usecases/send_work_report_usecase.dart';
import 'package:workorder_company_app/features/work_report/presentation/state/approval/approval_work_report_cubit.dart';
import 'package:workorder_company_app/features/work_report/presentation/state/send/send_work_report_cubit.dart';
import 'package:workorder_company_app/features/work_report/presentation/state/submit/submit_work_report_submission_cubit.dart';
import 'package:workorder_company_app/features_legacy/workreport_legacy/domain/usecases/submit_work_report_usecase.dart';
import 'package:workorder_company_app/features_legacy/workreport_legacy/presentation/bloc/get_work_report_cubit.dart';

Future<void> initWorkReportFeature() async {
  _initDataSource();
  _initRepositories();
  _initUseCases();
  _initUiStates();
}

Future<void> _initDataSource() async {
  sl.registerLazySingleton<WorkReportRemoteDatasource>(
      () => WorkReportRemoteDatasourceImpl(sl()));
}

Future<void> _initRepositories() async {
  sl.registerLazySingleton<WorkReportRepository>(
      () => WorkReportRepositoryImpl(sl()));
}

Future<void> _initUseCases() async {
  sl.registerLazySingleton<GetWorkReportUsecase>(
      () => GetWorkReportUsecase(sl()));

  sl.registerLazySingleton<SubmitWorkReportUsecase>(
      () => SubmitWorkReportUsecase(sl()));

  sl.registerLazySingleton<ApproveWorkReportUsecase>(
      () => ApproveWorkReportUsecase(sl()));

  sl.registerLazySingleton<RejectWorkReportUsecase>(
      () => RejectWorkReportUsecase(sl()));

  sl.registerLazySingleton<SendWorkReportUsecase>(
      () => SendWorkReportUsecase(sl()));
}

Future<void> _initUiStates() async {
  sl.registerFactory<ApprovalWorkReportCubit>(() => ApprovalWorkReportCubit(
        approveUseCase: sl(),
        rejectUseCase: sl(),
      ));

  sl.registerFactory<GetWorkReportCubit>(() => GetWorkReportCubit(sl()));

  sl.registerFactory<SendWorkReportCubit>(() => SendWorkReportCubit(
        useCase: sl(),
      ));

  sl.registerFactory<SubmitWorkReportSubmissionCubit>(
      () => SubmitWorkReportSubmissionCubit(
            useCase: sl(),
          ));
}
