
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/company/data/datasources/company_local_datasource.dart';
import 'package:workorder_company_app/features/company/data/repositories/company_repository_impl.dart';
import 'package:workorder_company_app/features/company/domain/repositories/company_repository.dart';
import 'package:workorder_company_app/features/company/domain/usecases/get_companies_usecase.dart';
import 'package:workorder_company_app/features/company/domain/usecases/get_company_with_service.dart';

Future<void> initCompanyFeature() async {
  sl.registerLazySingleton<CompanyLocalDatasource>(
      () => CompanyLocalDatasourceImpl(sl()));

  sl.registerLazySingleton<CompanyRepository>(
      () => CompanyRepositoryImpl(sl()));

  sl.registerLazySingleton<GetCompaniesUsecase>(
      () => GetCompaniesUsecase(sl()));

  sl.registerLazySingleton<GetCompanyWithService>(
      () => GetCompanyWithService(sl()));
}
