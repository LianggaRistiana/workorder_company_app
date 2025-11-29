import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/workorder/data/datasources/workorder_remote_datasource.dart';
import 'package:workorder_company_app/features/workorder/data/repositories/workorder_repository_impl.dart';
import 'package:workorder_company_app/features/workorder/domain/repositories/workorder_repository.dart';
import 'package:workorder_company_app/features/workorder/domain/usecases/get_detail_workorder_usecase.dart';
import 'package:workorder_company_app/features/workorder/domain/usecases/get_workorders_usecases.dart';
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

  sl.registerFactory<WorkorderBloc>(
      () => WorkorderBloc(getWorkordersUsecases: sl()));

  sl.registerFactory<WorkorderDetailCubit>(() => WorkorderDetailCubit(sl()));
}
