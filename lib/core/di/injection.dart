import 'package:get_it/get_it.dart';
import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/storage/token_storage.dart';
import 'package:workorder_company_app/features/auth/auth_injection.dart';
import 'package:workorder_company_app/features/employees/employees_injection.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /// Core
  sl.registerLazySingleton<TokenStorage>(() => TokenStorage());
  sl.registerLazySingleton<ApiClient>(() => ApiClient(tokenStorage: sl()));

  /// Features
  await initAuthFeature();
  await initEmployeesFeature();
}
