import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';

class WorkReportPermissions {
  static const view =
      AppPermission(AppFeature.workReport, PermissionAction.view);
  static const fill =
      AppPermission(AppFeature.workReport, PermissionAction.fill);
  static const approve =
      AppPermission(AppFeature.workReport, PermissionAction.approve);
  static const reject =
      AppPermission(AppFeature.workReport, PermissionAction.reject);
  static const send =
      AppPermission(AppFeature.workReport, PermissionAction.send);

  static final Set<AppPermission> all = {
    view,
    fill,
    approve,
    reject,
    send,
  };

  static final Set<AppPermission> reviewer = {
    view,
    approve,
    reject,
  };

  static final Set<AppPermission> worker = {
    view,
    send,
    fill,
  };
}
