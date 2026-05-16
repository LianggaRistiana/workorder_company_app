import 'package:app_links/app_links.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/system_integration/data/datasources/provider_integration_remote_datasource.dart';
import 'package:workorder_company_app/features/system_integration/data/mock/mock_provider_integration_remote_datasource.dart';
import 'package:workorder_company_app/features/system_integration/data/repositories/provider_integration_repository_impl.dart';
import 'package:workorder_company_app/features/system_integration/domain/repositories/provider_integration_repository.dart';
import 'package:workorder_company_app/features/system_integration/domain/usecases/get_provider_integration_usecase.dart';
import 'package:workorder_company_app/features/system_integration/domain/usecases/update_provider_integration_usecase.dart';
import 'package:workorder_company_app/features/system_integration/presentation/bloc/account_pairing_bloc.dart';
import 'package:workorder_company_app/features/system_integration/presentation/bloc/system_integration_config.dart/system_integration_config_cubit.dart';

Future<void> initSystemIntegrationFeature() async {
  sl.registerLazySingleton<ProviderIntegrationRemoteDatasource>(
    () => MockProviderIntegrationRemoteDatasource(),
    // () => ProviderIntegrationRemoteDatasourceImpl(sl()),
  );

  sl.registerLazySingleton<ProviderIntegrationRepository>(
    () => ProviderIntegrationRepositoryImpl(
      sl<ProviderIntegrationRemoteDatasource>(),
    ),
  );

  sl.registerLazySingleton<GetProviderIntegrationUsecase>(
    () => GetProviderIntegrationUsecase(
      sl<ProviderIntegrationRepository>(),
    ),
  );

  sl.registerLazySingleton<UpdateProviderIntegrationUsecase>(
    () => UpdateProviderIntegrationUsecase(
      sl<ProviderIntegrationRepository>(),
    ),
  );

  sl.registerFactory<SystemIntegrationConfigCubit>(
    () => SystemIntegrationConfigCubit(
      sl<GetProviderIntegrationUsecase>(),
      sl<UpdateProviderIntegrationUsecase>(),
    ),
  );

  sl.registerFactory<AccountPairingBloc>(
    () => AccountPairingBloc(
      AppLinks(),
    ),
  );
}
