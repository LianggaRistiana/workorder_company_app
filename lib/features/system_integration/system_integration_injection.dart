import 'package:app_links/app_links.dart';
import 'package:workorder_company_app/core/di/injection.dart';
import 'package:workorder_company_app/features/system_integration/presentation/bloc/account_pairing_bloc.dart';

Future<void> initSystemIntegrationFeature() async {
  sl.registerFactory<AccountPairingBloc>(
    () => AccountPairingBloc(
      AppLinks(),
    ),
  );
}
