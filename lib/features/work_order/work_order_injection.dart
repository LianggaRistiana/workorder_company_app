import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/submissions/core/file_upload_manager.dart';
import 'package:workorder_company_app/features/work_order/data/datasources/work_order_remote_datasource.dart';
import 'package:workorder_company_app/features/work_order/data/repositories/work_order_repository_impl.dart';
import 'package:workorder_company_app/features/work_order/domain/repositories/work_order_repository.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/approve_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/assign_staffs_usecase.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/cancel_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/complete_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/create_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/fail_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/get_detail_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/get_work_orders_usecase.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/recreate_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/reject_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/send_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/start_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/submit_work_order_submission_usecase.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/approval/approval_work_order_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/cancel/cancel_work_order_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/create/work_order_create_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/detail/work_order_detail_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/fill/fill_work_order_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/finalize/finalize_work_order_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/list/work_orders_list_bloc.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/recreate/recreate_work_order_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/send/send_work_order_cubit.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/start/start_work_order_cubit.dart';

Future<void> initWorkOrderFeature() async {
  _initDataSource();
  _initRepositories();
  _initUseCases();
  _initUiStates();
}

Future<void> _initDataSource() async {
  sl.registerLazySingleton<WorkOrderRemoteDatasource>(
      () => WorkOrderRemoteDatasourceImpl(sl()));
  // () => MockWorkOrderRemoteDatasource());
}

Future<void> _initRepositories() async {
  sl.registerLazySingleton<WorkOrderRepository>(
      () => WorkOrderRepositoryImpl(sl()));
}

Future<void> _initUseCases() async {
  sl.registerLazySingleton<GetWorkOrdersUsecase>(
      () => GetWorkOrdersUsecase(sl()));

  sl.registerLazySingleton<GetDetailWorkOrderUsecase>(
    () => GetDetailWorkOrderUsecase(sl()),
  );

  sl.registerLazySingleton<ApproveWorkOrderUseCase>(
    () => ApproveWorkOrderUseCase(sl()),
  );

  sl.registerLazySingleton<AssignStaffsUseCase>(
    () => AssignStaffsUseCase(sl()),
  );

  sl.registerLazySingleton<CancelWorkOrderUseCase>(
    () => CancelWorkOrderUseCase(sl()),
  );

  sl.registerLazySingleton<CompleteWorkOrderUseCase>(
    () => CompleteWorkOrderUseCase(sl()),
  );

  sl.registerLazySingleton<FailWorkOrderUseCase>(
    () => FailWorkOrderUseCase(sl()),
  );

  sl.registerLazySingleton<RejectWorkOrderUseCase>(
    () => RejectWorkOrderUseCase(sl()),
  );

  sl.registerLazySingleton<RecreateWorkOrderUseCase>(
    () => RecreateWorkOrderUseCase(sl()),
  );

  sl.registerLazySingleton<SendWorkOrderUseCase>(
    () => SendWorkOrderUseCase(sl()),
  );

  sl.registerLazySingleton<StartWorkOrderUseCase>(
    () => StartWorkOrderUseCase(sl()),
  );

  sl.registerLazySingleton<SubmitWorkOrderSubmissionUseCase>(
    () => SubmitWorkOrderSubmissionUseCase(
      sl<WorkOrderRepository>(),
      sl<UploadManager>(),
    ),
  );

  sl.registerLazySingleton<CreateWorkOrderUsecase>(
    () => CreateWorkOrderUsecase(sl()),
  );
}

Future<void> _initUiStates() async {
  sl.registerFactory<WorkOrdersListBloc>(() => WorkOrdersListBloc(
        getWorkOrdersUseCase: sl(),
        workOrderChangedStream: sl<WorkOrderRepository>().cacheChanged,
      ));

  sl.registerFactory<WorkOrderDetailCubit>(() => WorkOrderDetailCubit(
        getDetailWorkOrderUseCase: sl(),
      ));

  sl.registerFactory<FillWorkOrderCubit>(() => FillWorkOrderCubit(
        assignStaffsUseCase: sl(),
        submitUsecase: sl(),
      ));

  sl.registerFactory<CancelWorkOrderCubit>(() => CancelWorkOrderCubit(
        useCase: sl(),
      ));

  sl.registerFactory<StartWorkOrderCubit>(() => StartWorkOrderCubit(
        useCase: sl(),
      ));

  sl.registerFactory<RecreateWorkOrderCubit>(() => RecreateWorkOrderCubit(
        useCase: sl(),
      ));

  sl.registerFactory<SendWorkOrderCubit>(() => SendWorkOrderCubit(
        useCase: sl(),
      ));

  sl.registerFactory<FinalizeWorkOrderCubit>(() => FinalizeWorkOrderCubit(
        completeUseCase: sl(),
        failUseCase: sl(),
      ));

  sl.registerFactory<ApprovalWorkOrderCubit>(() => ApprovalWorkOrderCubit(
        approveUseCase: sl(),
        rejectUseCase: sl(),
      ));

  sl.registerFactory<WorkOrderCreateCubit>(() => WorkOrderCreateCubit(
        createWorkOrderUsecase: sl(),
      ));
}
