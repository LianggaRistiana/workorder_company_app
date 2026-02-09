import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/client_service_request/data/datasources/client_service_request_remote_datasource.dart';
import 'package:workorder_company_app/features/client_service_request/data/repositories/client_service_request_repository_impl.dart';
import 'package:workorder_company_app/features/client_service_request/domain/repositories/client_service_request_repository.dart';
import 'package:workorder_company_app/features/client_service_request/domain/usecases/approve_csr_usecase.dart';
import 'package:workorder_company_app/features/client_service_request/domain/usecases/get_csr_detail_usecase.dart';
import 'package:workorder_company_app/features/client_service_request/domain/usecases/get_csr_usecase.dart';
import 'package:workorder_company_app/features/client_service_request/domain/usecases/public_get_csr_usecase.dart';
import 'package:workorder_company_app/features/client_service_request/domain/usecases/public_get_detail_csr_usecase.dart';
import 'package:workorder_company_app/features/client_service_request/domain/usecases/reject_csr_usecase.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/internal_client_service_request/internal_csr_actions_cubit.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/internal_client_service_request/internal_csr_bloc.dart';
import 'package:workorder_company_app/features/client_service_request/presentation/bloc/internal_client_service_request/internal_csr_detail_cubit.dart';
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

  sl.registerLazySingleton<GetCsrUsecase>(() => GetCsrUsecase(sl()));

  sl.registerLazySingleton<GetCsrDetailUsecase>(
      () => GetCsrDetailUsecase(sl()));

  sl.registerLazySingleton<ApproveCsrUsecase>(() => ApproveCsrUsecase(sl()));
  sl.registerLazySingleton<RejectCsrUsecase>(() => RejectCsrUsecase(sl()));

  sl.registerLazySingleton<InternalCsrBloc>(
      () => InternalCsrBloc(usecase: sl(), authBloc: sl()));
      
  sl.registerFactory<InternalCsrDetailCubit>(
      () => InternalCsrDetailCubit(sl()));

  sl.registerFactory<CsrBloc>(() => CsrBloc(publicGetCsrUsecase: sl()));
  sl.registerFactory<CsrDetailCubit>(() => CsrDetailCubit(sl()));
  sl.registerFactory<InternalCsrActionsCubit>(
      () => InternalCsrActionsCubit(sl(), sl()));
}
