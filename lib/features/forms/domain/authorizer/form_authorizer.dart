import 'package:workorder_company_app/core/authorization/feature/form_permission.dart';
import 'package:workorder_company_app/core/authorization/model/authorization_result.dart';
import 'package:workorder_company_app/core/authorization/rule/authorization_rule.dart';
import 'package:workorder_company_app/core/authorization/rule/composite_rule/composite_rule_helper.dart';
import 'package:workorder_company_app/core/authorization/rule/role_permission_rule/role_permission_helper.dart';
import 'package:workorder_company_app/features/auth/domain/entities/user_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/meta/form_detail_meta.dart';

class FormAuthorizer {
  final FormEntity form;
  final FormDetailMeta? meta;

  const FormAuthorizer({
    required this.form,
    this.meta,
  });

  AuthorizationRule get updateFormRule => rules([
        roleCan(FormPermission.update),
        _DepartemenManagerScope(form),
      ]);

  AuthorizationRule get deleteFormRule => rules([
        roleCan(FormPermission.delete),
        _DepartemenManagerScope(form),
        _MetaDeleteCheck(meta),
      ]);
}

class _MetaDeleteCheck extends AuthorizationRule {
  final FormDetailMeta? meta;

  _MetaDeleteCheck(this.meta);

  @override
  AuthorizationResult evaluate(UserEntity user) {
    if (meta?.canDelete == true) {
      return AuthorizationResult.allowed();
    }

    return AuthorizationResult.denied("Tidak bisa menghapus formulir ini");
  }
}

class _DepartemenManagerScope extends AuthorizationRule {
  final FormEntity form;

  _DepartemenManagerScope(this.form);

  @override
  AuthorizationResult evaluate(UserEntity user) {
    final userPosition = user.position;
    final formPosition = form.position;

    // Super admin / non-department manager
    if (userPosition == null) {
      return AuthorizationResult.allowed();
    }

    final hasAccess =
        formPosition != null && userPosition.id == formPosition.id;

    if (!hasAccess) {
      return AuthorizationResult.denied(
        "Manager departemen tidak bisa mengedit formulir ini",
      );
    }

    return AuthorizationResult.allowed();
  }
}
