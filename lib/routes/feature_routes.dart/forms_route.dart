import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/presentation/pages/form_create_page.dart';
import 'package:workorder_company_app/features/forms/presentation/pages/form_detail_page.dart';
import 'package:workorder_company_app/features/forms/presentation/pages/form_update_page.dart';
import 'package:workorder_company_app/features/forms/presentation/pages/forms_list_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

final formsRouter = [
  GoRoute(
    path: AppRoutes.forms,
    builder: (_, __) => const FormsListPage(),
  ),
  GoRoute(
    path: AppRoutes.formsCreate,
    builder: (_, __) => const FormCreatePage(),
  ),
  GoRoute(
    path: AppRoutes.formsUpdate,
    builder: (_, state) {
      final form = state.extra as FormEntity;
      return FormUpdatePage(form: form);
    },
  ),
  GoRoute(
    path: AppRoutes.formsDetail,
    builder: (_, state) {
      final id = state.pathParameters["id"]!;
      return FormDetailPage(formId: id);
    },
  ),
];
