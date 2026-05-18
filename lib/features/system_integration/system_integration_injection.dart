import 'package:app_links/app_links.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/system_integration/data/datasources/customer_account_integration_remote_datasource.dart';
import 'package:workorder_company_app/features/system_integration/data/datasources/provider_integration_remote_datasource.dart';
import 'package:workorder_company_app/features/system_integration/data/repositories/customer_account_integration_repository_impl.dart';
import 'package:workorder_company_app/features/system_integration/data/repositories/provider_integration_repository_impl.dart';
import 'package:workorder_company_app/features/system_integration/domain/repositories/customer_account_integration_repository.dart';
import 'package:workorder_company_app/features/system_integration/domain/repositories/provider_integration_repository.dart';
import 'package:workorder_company_app/features/system_integration/domain/usecases/complete_pairing_usecase.dart';
import 'package:workorder_company_app/features/system_integration/domain/usecases/detach_account_usecase.dart';
import 'package:workorder_company_app/features/system_integration/domain/usecases/get_account_pairing_usecase.dart';
import 'package:workorder_company_app/features/system_integration/domain/usecases/get_all_paired_account_usecase.dart';
import 'package:workorder_company_app/features/system_integration/domain/usecases/get_provider_integration_usecase.dart';
import 'package:workorder_company_app/features/system_integration/domain/usecases/start_pairing_usecase.dart';
import 'package:workorder_company_app/features/system_integration/domain/usecases/update_provider_integration_usecase.dart';
import 'package:workorder_company_app/features/system_integration/presentation/bloc/customer/account_action/account_action_cubit.dart';
import 'package:workorder_company_app/features/system_integration/presentation/bloc/customer/account_pairing/account_pairing_bloc.dart';
import 'package:workorder_company_app/features/system_integration/presentation/bloc/customer/accounts/external_accounts_cubit.dart';
import 'package:workorder_company_app/features/system_integration/presentation/bloc/system_integration_config.dart/system_integration_config_cubit.dart';

Future<void> initSystemIntegrationFeature() async {
  sl.registerLazySingleton<ProviderIntegrationRemoteDatasource>(
    () => ProviderIntegrationRemoteDatasourceImpl(sl()),
  );

  sl.registerLazySingleton<CustomerAccountIntegrationRemoteDatasource>(
    () => CustomerAccountIntegrationRemoteDatasourceImpl(sl()),
  );

  sl.registerLazySingleton<ProviderIntegrationRepository>(
    () => ProviderIntegrationRepositoryImpl(
      sl<ProviderIntegrationRemoteDatasource>(),
    ),
  );

  sl.registerLazySingleton<CustomerAccountIntegrationRepository>(
    () => CustomerAccountIntegrationRepositoryImpl(
      sl<CustomerAccountIntegrationRemoteDatasource>(),
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

  sl.registerLazySingleton<StartPairingUsecase>(
    () => StartPairingUsecase(
      sl<CustomerAccountIntegrationRepository>(),
    ),
  );

  sl.registerLazySingleton<GetAccountPairingUsecase>(
    () => GetAccountPairingUsecase(
      sl<CustomerAccountIntegrationRepository>(),
    ),
  );

  sl.registerLazySingleton<GetAllPairedAccountUsecase>(
    () => GetAllPairedAccountUsecase(
      sl<CustomerAccountIntegrationRepository>(),
    ),
  );

  sl.registerLazySingleton<DetachAccountUsecase>(
    () => DetachAccountUsecase(
      sl<CustomerAccountIntegrationRepository>(),
    ),
  );

  sl.registerLazySingleton<CompletePairingUsecase>(
    () => CompletePairingUsecase(
      sl<CustomerAccountIntegrationRepository>(),
    ),
  );

  sl.registerFactory<SystemIntegrationConfigCubit>(
    () => SystemIntegrationConfigCubit(
      sl<GetProviderIntegrationUsecase>(),
      sl<UpdateProviderIntegrationUsecase>(),
    ),
  );

  sl.registerFactory<AccountActionCubit>(
    () => AccountActionCubit(
      sl<GetAccountPairingUsecase>(),
      sl<DetachAccountUsecase>(),
    ),
  );

  sl.registerFactory<ExternalAccountsCubit>(
    () => ExternalAccountsCubit(
      sl<GetAllPairedAccountUsecase>(),
      sl<DetachAccountUsecase>(),
    ),
  );

  sl.registerFactory<AccountPairingBloc>(
    () => AccountPairingBloc(
      sl<StartPairingUsecase>(),
      sl<CompletePairingUsecase>(),
      AppLinks(),
    ),
  );
}
