import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/template_config/data/datasources/mock_template_config_remote_datasource.dart';
import 'package:workorder_company_app/features/template_config/data/datasources/template_config_remote_datasource.dart';
import 'package:workorder_company_app/features/template_config/data/repositories/template_config_repository_impl.dart';
import 'package:workorder_company_app/features/template_config/domain/repositories/template_config_repository.dart';
import 'package:workorder_company_app/features/template_config/domain/usecases/generate_service_by_templates_usecase.dart';
import 'package:workorder_company_app/features/template_config/domain/usecases/get_company_types_usecase.dart';
import 'package:workorder_company_app/features/template_config/domain/usecases/get_service_preview_usecase.dart';
import 'package:workorder_company_app/features/template_config/domain/usecases/get_service_templates_usecase.dart';
import 'package:workorder_company_app/features/template_config/presentation/bloc/company_type_list/company_type_list_cubit.dart';
import 'package:workorder_company_app/features/template_config/presentation/bloc/generate_service/generate_service_cubit.dart';
import 'package:workorder_company_app/features/template_config/presentation/bloc/service_preview/service_preview_cubit.dart';
import 'package:workorder_company_app/features/template_config/presentation/bloc/service_template_list/service_template_list_cubit.dart';

Future<void> initTemplateConfigFeature() async {
  sl.registerLazySingleton<TemplateConfigRemoteDatasource>(
      () => MockTemplateConfigRemoteDatasourceImpl());

  sl.registerLazySingleton<TemplateConfigRepository>(
    () => TemplateConfigRepositoryImpl(
      sl<TemplateConfigRemoteDatasource>(),
    ),
  );

  sl.registerLazySingleton<GenerateServiceByTemplatesUsecase>(
    () => GenerateServiceByTemplatesUsecase(
      sl<TemplateConfigRepository>(),
    ),
  );

  sl.registerLazySingleton<GetCompanyTypesUsecase>(
    () => GetCompanyTypesUsecase(
      sl<TemplateConfigRepository>(),
    ),
  );

  sl.registerLazySingleton<GetServicePreviewUsecase>(
    () => GetServicePreviewUsecase(
      sl<TemplateConfigRepository>(),
    ),
  );

  sl.registerLazySingleton<GetServiceTemplatesUsecase>(
    () => GetServiceTemplatesUsecase(
      sl<TemplateConfigRepository>(),
    ),
  );

  sl.registerFactory<CompanyTypeListCubit>(
    () => CompanyTypeListCubit(
      getCompanyTypesUsecase: sl<GetCompanyTypesUsecase>(),
    ),
  );

  sl.registerFactory<GenerateServiceCubit>(
    () => GenerateServiceCubit(
      generateServiceUsecase: sl<GenerateServiceByTemplatesUsecase>(),
    ),
  );

  sl.registerFactory<ServicePreviewCubit>(
    () => ServicePreviewCubit(
      getServicePreviewUsecase: sl<GetServicePreviewUsecase>(),
    ),
  );

  sl.registerFactory<ServiceTemplateListCubit>(
    () => ServiceTemplateListCubit(
      getServiceTemplatesUsecase: sl<GetServiceTemplatesUsecase>(),
    ),
  );
}
