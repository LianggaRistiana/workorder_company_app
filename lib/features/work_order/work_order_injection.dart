import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/work_order/data/datasources/mock/mock_work_order_remote_datasource.dart';
import 'package:workorder_company_app/features/work_order/data/datasources/work_order_remote_datasource.dart';
import 'package:workorder_company_app/features/work_order/data/repositories/work_order_repository_impl.dart';
import 'package:workorder_company_app/features/work_order/domain/repositories/work_order_repository.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/approve_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/assign_staffs_usecase.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/cancel_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/complete_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/fail_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/get_detail_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/get_work_orders_usecase.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/recreate_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/reject_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/send_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/start_work_order_usecase.dart';
import 'package:workorder_company_app/features/work_order/domain/usecases/submit_work_order_submission_usecase.dart';
import 'package:workorder_company_app/features/work_order/presentation/bloc/list/work_orders_list_bloc.dart';

Future<void> initWorkOrderFeature() async {
  _initDataSource();
  _initRepositories();
  _initUseCases();
  _initUiStates();
}

Future<void> _initDataSource() async {
  sl.registerLazySingleton<WorkOrderRemoteDatasource>(
      () => MockWorkOrderRemoteDatasource());
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
    () => SubmitWorkOrderSubmissionUseCase(sl()),
  );
}

Future<void> _initUiStates() async {
  sl.registerFactory<WorkOrdersListBloc>(() => WorkOrdersListBloc(
        getWorkOrdersUseCase: sl(),
      ));
}
