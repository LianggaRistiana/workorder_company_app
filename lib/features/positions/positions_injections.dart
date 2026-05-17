import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/positions/data/datasources/positions_remote_datasource.dart';
import 'package:workorder_company_app/features/positions/data/repositories/positions_repositories_impl.dart';
import 'package:workorder_company_app/features/positions/domain/repositories/positions_repository.dart';
import 'package:workorder_company_app/features/positions/domain/usecase/create_position_usecase.dart';
import 'package:workorder_company_app/features/positions/domain/usecase/get_current_user_positions_usecase.dart';
import 'package:workorder_company_app/features/positions/domain/usecase/get_manager_scoped_positions_usecase.dart';
import 'package:workorder_company_app/features/positions/domain/usecase/get_position_byid_usecase.dart';
import 'package:workorder_company_app/features/positions/domain/usecase/get_positions_usecase.dart';
import 'package:workorder_company_app/features/positions/domain/usecase/update_position_usecase.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/create/position_create_cubit.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/detail/position_detail_cubit.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/list/positions_list_bloc.dart';
import 'package:workorder_company_app/features/positions/presentation/bloc/update/position_update_cubit.dart';

Future<void> initPositionsFeature() async {
  sl.registerLazySingleton<PositionsRemoteDatasource>(
      () => PositionsRemoteDatasourceImpl(sl()));

  sl.registerLazySingleton<PositionsRepository>(
      () => PositionsRepositoryImpl(sl()));

  sl.registerLazySingleton<GetManagerScopedPositionUsecase>(
      () => GetManagerScopedPositionUsecase(sl()));
  sl.registerLazySingleton<GetCurrentUserPositionsUsecase>(
      () => GetCurrentUserPositionsUsecase(sl()));
  sl.registerLazySingleton<GetPositionsUsecase>(
      () => GetPositionsUsecase(sl()));
  sl.registerLazySingleton<GetPositionByidUsecase>(
      () => GetPositionByidUsecase(sl()));
  sl.registerLazySingleton<CreatePositionUsecase>(
      () => CreatePositionUsecase(sl()));
  sl.registerLazySingleton<UpdatePositionUsecase>(
      () => UpdatePositionUsecase(sl()));

  sl.registerFactory<PositionsListBloc>(() => PositionsListBloc(
        getPositionsUseCase: sl<GetPositionsUsecase>(),
        cacheChangedStream: sl<PositionsRepository>().cacheChanged,
      ));

  sl.registerFactory<PositionCreateCubit>(
      () => PositionCreateCubit(createPositionUsecase: sl()));
  sl.registerFactory<PositionUpdateCubit>(
      () => PositionUpdateCubit(updatePositionUsecase: sl()));
  sl.registerFactory<PositionDetailCubit>(
      () => PositionDetailCubit(getPositionByidUsecase: sl()));
}
