import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/workorder/data/datasources/workorder_remote_datasource.dart';
import 'package:workorder_company_app/features/workorder/data/repositories/workorder_repository_impl.dart';
import 'package:workorder_company_app/features/workorder/domain/repositories/workorder_repository.dart';
import 'package:workorder_company_app/features/workorder/domain/usecases/get_detail_workorder_usecase.dart';
import 'package:workorder_company_app/features/workorder/domain/usecases/get_workorders_usecases.dart';
import 'package:workorder_company_app/features/workorder/domain/usecases/set_assigned_staff_usecase.dart';
import 'package:workorder_company_app/features/workorder/domain/usecases/set_workorder_submissions_usecase.dart';
import 'package:workorder_company_app/features/workorder/domain/usecases/set_workorder_to_ready_usecase.dart';
import 'package:workorder_company_app/features/workorder/presentation/bloc/workoder_submissions_forms_cubit.dart';
import 'package:workorder_company_app/features/workorder/presentation/bloc/workorder_actions_cubit.dart';
import 'package:workorder_company_app/features/workorder/presentation/bloc/workorder_assigned_staff_cubit.dart';
import 'package:workorder_company_app/features/workorder/presentation/bloc/workorder_bloc.dart';
import 'package:workorder_company_app/features/workorder/presentation/bloc/workorder_detail_cubit.dart';

Future<void> initWorkorderFeature() async {
  sl.registerLazySingleton<WorkorderRemoteDatasource>(
      () => WorkorderRemoteDatasourceImpl(sl()));

  sl.registerLazySingleton<WorkorderRepository>(
      () => WorkorderRepositoryImpl(sl()));

  sl.registerLazySingleton<GetWorkordersUsecases>(
      () => GetWorkordersUsecases(sl()));

  sl.registerLazySingleton<GetDetailWorkorderUsecase>(
      () => GetDetailWorkorderUsecase(sl()));

  sl.registerLazySingleton<SetAssignedStaffUsecase>(
      () => SetAssignedStaffUsecase(sl()));

  sl.registerLazySingleton<SetWorkorderSubmissionsUsecase>(
      () => SetWorkorderSubmissionsUsecase(sl()));


  sl.registerLazySingleton<SetWorkorderToReadyUsecase>(
      () => SetWorkorderToReadyUsecase(sl()));

  sl.registerFactory<WorkorderBloc>(
      () => WorkorderBloc(getWorkordersUsecases: sl()));

  sl.registerFactory<WorkorderDetailCubit>(() => WorkorderDetailCubit(sl()));

  sl.registerFactory<WorkorderActionsCubit>(() => WorkorderActionsCubit(sl()));

  sl.registerFactory<WorkoderSubmissionsFormsCubit>(
      () => WorkoderSubmissionsFormsCubit(sl()));

  sl.registerFactory<WorkorderAssignedStaffCubit>(
      () => WorkorderAssignedStaffCubit(sl()));
}
