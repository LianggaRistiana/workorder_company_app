import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';

class SystemIntegrationPermission {
  static const view =
      AppPermission(AppFeature.pairingAccount, PermissionAction.view);
  static const connectAccount =
      AppPermission(AppFeature.pairingAccount, PermissionAction.create);
  static const detachConnection =
      AppPermission(AppFeature.pairingAccount, PermissionAction.delete);

  static const updateConfig =
      AppPermission(AppFeature.systemIntegration, PermissionAction.update);

  static final Set<AppPermission> pairing = {
    view,
    connectAccount,
    detachConnection
  };

  static final Set<AppPermission> config = {
    updateConfig,
  };
}
