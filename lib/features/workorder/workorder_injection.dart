import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/workorder/data/datasources/workorder_remote_datasource.dart';
import 'package:workorder_company_app/features/workorder/data/repositories/workorder_repository_impl.dart';
import 'package:workorder_company_app/features/workorder/domain/repositories/workorder_repository.dart';
import 'package:workorder_company_app/features/workorder/domain/usecases/get_workorders_usecases.dart';
import 'package:workorder_company_app/features/workorder/presentation/bloc/workorder_bloc.dart';

Future<void> initWorkorderFeature() async {
  sl.registerLazySingleton<WorkorderRemoteDatasource>(
      () => WorkorderRemoteDatasourceImpl(sl()));

  sl.registerLazySingleton<WorkorderRepository>(
      () => WorkorderRepositoryImpl(sl()));

  sl.registerLazySingleton<GetWorkordersUsecases>(
      () => GetWorkordersUsecases(sl()));

  sl.registerFactory<WorkorderBloc>(() => WorkorderBloc(getWorkordersUsecases: sl()));
}
