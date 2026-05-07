import 'package:workorder_company_app/core/authorization/enums/app_feature.dart';
import 'package:workorder_company_app/core/authorization/enums/permission_action.dart';
import 'package:workorder_company_app/core/authorization/model/app_permission.dart';

class FaqConfigPermission {
  static const view =
      AppPermission(AppFeature.faqConfig, PermissionAction.view);
  static const createDocs =
      AppPermission(AppFeature.faqConfig, PermissionAction.create);
  static const updateFeature =
      AppPermission(AppFeature.faqConfig, PermissionAction.update);
  static const deleteDocs =
      AppPermission(AppFeature.faqConfig, PermissionAction.delete);

  static final Set<AppPermission> all = {
    view,
    createDocs,
    updateFeature,
    deleteDocs,
  };
}
