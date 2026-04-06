import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/company/data/datasources/company_management_remote_datasource.dart';
import 'package:workorder_company_app/features/company/data/datasources/public_companies_remote_datasource.dart';
import 'package:workorder_company_app/features/company/data/repositories/internal_company_repository_impl.dart';
import 'package:workorder_company_app/features/company/data/repositories/public_companies_repository_impl.dart';
import 'package:workorder_company_app/features/company/domain/repositories/internal_company_repository.dart';
import 'package:workorder_company_app/features/company/domain/repositories/public_companies_repository.dart';
import 'package:workorder_company_app/features/company/domain/usecases/internal_get_company_usecase.dart';
import 'package:workorder_company_app/features/company/domain/usecases/internal_update_company_usecase.dart';
import 'package:workorder_company_app/features/company/domain/usecases/public_get_companies_usecase.dart';
import 'package:workorder_company_app/features/company/domain/usecases/public_get_company_detail_usecase.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/internal_company_management/internal_company_get_cubit.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/internal_company_management/internal_update_company_cubit.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/public_companies_list/public_companies_list_bloc.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/public_company_detail/public_company_detail_cubit.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/public_company_services.dart/public_company_services_cubit.dart';

Future<void> initCompanyFeature() async {
  sl.registerLazySingleton<PublicCompaniesRemoteDatasource>(
      () => PublicCompaniesRemoteDatasourceImpl(sl()));

  sl.registerLazySingleton<CompanyManagementRemoteDatasource>(
      () => CompanyManagementRemoteDatasourceImpl(sl()));

  sl.registerLazySingleton<InternalCompanyRepository>(
      () => InternalCompanyRepositoryImpl(sl()));

  sl.registerLazySingleton<PublicCompaniesRepository>(
      () => PublicCompaniesRepositoryImpl(sl()));

  sl.registerLazySingleton<PublicGetCompaniesUsecase>(
      () => PublicGetCompaniesUsecase(sl()));

  sl.registerLazySingleton<PublicGetCompanyDetailUsecase>(
      () => PublicGetCompanyDetailUsecase(sl()));

  sl.registerLazySingleton<InternalGetCompanyUsecase>(
      () => InternalGetCompanyUsecase(sl()));

  sl.registerLazySingleton<InternalUpdateCompanyUsecase>(
      () => InternalUpdateCompanyUsecase(sl()));

  sl.registerFactory<PublicCompaniesListBloc>(
      () => PublicCompaniesListBloc(getCompaniesUsecase: sl()));

  sl.registerFactory<PublicCompanyDetailCubit>(() => PublicCompanyDetailCubit(
        getCompanyDetailUsecase: sl(),
      ));

  sl.registerFactory<PublicCompanyServicesCubit>(
      () => PublicCompanyServicesCubit(sl()));

  sl.registerFactory<InternalGetCompanyCubit>(() => InternalGetCompanyCubit(sl()));

  sl.registerFactory<InternalUpdateCompanyCubit>(
      () => InternalUpdateCompanyCubit(sl()));
}
