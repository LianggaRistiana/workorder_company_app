import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/positions/data/datasources/positions_remote_datasource.dart';
import 'package:workorder_company_app/features/positions/data/repositories/positions_repositories_impl.dart';
import 'package:workorder_company_app/features/positions/domain/repositories/positions_repository.dart';
import 'package:workorder_company_app/features/positions/domain/usecase/create_position_usecase.dart';
import 'package:workorder_company_app/features/positions/domain/usecase/get_positions_usecase.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/create/position_create_cubit.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_bloc.dart';

Future<void> initPositionsFeature() async {
  sl.registerFactory<PositionsListBloc>(
      () => PositionsListBloc(getPositionsUseCase: sl()));
  sl.registerFactory<PositionCreateCubit>(
      () => PositionCreateCubit(createPositionUsecase: sl()));

  sl.registerLazySingleton<GetPositionsUsecase>(
      () => GetPositionsUsecase(sl()));
  sl.registerLazySingleton<CreatePositionUsecase>(
      () => CreatePositionUsecase(sl()));

  sl.registerLazySingleton<PositionsRepository>(
      () => PositionsRepositoryImpl(sl()));
  sl.registerLazySingleton<PositionsRemoteDatasource>(
      () => PositionsRemoteDatasourceImpl(sl()));
}
