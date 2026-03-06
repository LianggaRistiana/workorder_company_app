import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/company/data/datasources/company_management_remote_datasource.dart';
import 'package:workorder_company_app/features/company/data/datasources/company_remote_datasource.dart';
import 'package:workorder_company_app/features/company/data/repositories/company_repository_impl.dart';
import 'package:workorder_company_app/features/company/domain/policies/company_management_policy.dart';
import 'package:workorder_company_app/features/company/domain/repositories/company_repository.dart';
import 'package:workorder_company_app/features/company/domain/usecases/internal_get_company_usecase.dart';
import 'package:workorder_company_app/features/company/domain/usecases/internal_update_company_usecase.dart';
import 'package:workorder_company_app/features/company/domain/usecases/public_get_companies_usecase.dart';
import 'package:workorder_company_app/features/company/domain/usecases/public_get_company_detail_usecase.dart';
import 'package:workorder_company_app/features/company/domain/usecases/public_get_company_services.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/fetch_company/company_bloc.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/internal_company_management/internal_company_get_cubit.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/internal_company_management/internal_update_company_cubit.dart';

Future<void> initCompanyFeature() async {
  sl.registerLazySingleton<CompanyManagementPolicy>(
      () => CompanyManagementPolicy());

  sl.registerLazySingleton<CompanyRemoteDatasource>(
      () => CompanyRemoteDatasourceImpl(sl()));

  sl.registerLazySingleton<CompanyManagementRemoteDatasource>(
      () => CompanyManagementRemoteDatasourceImpl(sl()));

  sl.registerLazySingleton<CompanyRepository>(
      () => CompanyRepositoryImpl(sl(), sl()));

  sl.registerLazySingleton<PublicGetCompaniesUsecase>(
      () => PublicGetCompaniesUsecase(sl()));

  sl.registerLazySingleton<PublicGetCompanyDetailUsecase>(
      () => PublicGetCompanyDetailUsecase(sl()));

  sl.registerLazySingleton<PublicGetCompanyServicesUsecase>(
      () => PublicGetCompanyServicesUsecase(sl()));

  sl.registerLazySingleton<InternalGetCompanyUsecase>(
      () => InternalGetCompanyUsecase(sl(), sl()));

  sl.registerLazySingleton<InternalUpdateCompanyUsecase>(
      () => InternalUpdateCompanyUsecase(sl()));

  sl.registerFactory<CompanyBloc>(() => CompanyBloc(
      getCompaniesUsecase: sl(),
      getCompanyServicesUsecase: sl(),
      getCompanyDetailUsecase: sl()));

  sl.registerFactory<InternalCompanyCubit>(() => InternalCompanyCubit(sl()));
  sl.registerFactory<InternalUpdateCompanyCubit>(() => InternalUpdateCompanyCubit(sl()));
}
