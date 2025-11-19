import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/client_service_request/data/datasources/client_service_request_remote_datasource.dart';
import 'package:workorder_company_app/features/client_service_request/data/repositories/client_service_request_repository_impl.dart';
import 'package:workorder_company_app/features/client_service_request/domain/repositories/client_service_request_repository.dart';
import 'package:workorder_company_app/features/client_service_request/domain/usecases/public_get_csr_usecase.dart';
import 'package:workorder_company_app/features/client_service_request/domain/usecases/public_get_detail_csr_usecase.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/public_client_service_request/csr_bloc.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/public_client_service_request/csr_detail_cubit.dart';

Future<void> initClientServiceRequestFeature() async {
  sl.registerLazySingleton<ClientServiceRequestRemoteDatasource>(
      () => ClientServiceRequestRemoteDatasourceImpl(sl()));

  sl.registerLazySingleton<ClientServiceRequestRepository>(
      () => ClientServiceRequestRepositoryImpl(sl()));

  sl.registerLazySingleton<PublicGetCsrUsecase>(
      () => PublicGetCsrUsecase(sl()));

  sl.registerLazySingleton<PublicGetDetailCsrUsecase>(
      () => PublicGetDetailCsrUsecase(sl()));

  sl.registerFactory<CsrBloc>(() => CsrBloc(publicGetCsrUsecase: sl()));
  sl.registerFactory<CsrDetailCubit>(() => CsrDetailCubit(sl()));
}
