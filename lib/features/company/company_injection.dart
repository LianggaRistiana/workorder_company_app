
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/company/data/datasources/company_remote_datasource.dart';
import 'package:workorder_company_app/features/company/data/repositories/company_repository_impl.dart';
import 'package:workorder_company_app/features/company/domain/repositories/company_repository.dart';
import 'package:workorder_company_app/features/company/domain/usecases/public_get_companies_usecase.dart';
import 'package:workorder_company_app/features/company/domain/usecases/public_get_company_detail_usecase.dart';
import 'package:workorder_company_app/features/company/domain/usecases/public_get_company_services.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/fetch_company/company_bloc.dart';

Future<void> initCompanyFeature() async {
  sl.registerLazySingleton<CompanyRemoteDatasource>(
      () => CompanyRemoteDatasourceImpl(sl()));

  sl.registerLazySingleton<CompanyRepository>(
      () => CompanyRepositoryImpl(sl()));

  sl.registerLazySingleton<PublicGetCompaniesUsecase>(
      () => PublicGetCompaniesUsecase(sl()));

  sl.registerLazySingleton<PublicGetCompanyDetailUsecase>(
      () => PublicGetCompanyDetailUsecase(sl()));

  sl.registerLazySingleton<PublicGetCompanyServicesUsecase>(
      () => PublicGetCompanyServicesUsecase(sl()));

  sl.registerFactory<CompanyBloc>(() => CompanyBloc(getCompaniesUsecase: sl(), getCompanyServicesUsecase: sl(), getCompanyDetailUsecase: sl()));
}
