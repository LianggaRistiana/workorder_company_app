import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/forms/presentation/pages/create/create_form_page.dart';
import 'package:workorder_company_app/features/forms/presentation/pages/form_detail.page.dart';
import 'package:workorder_company_app/features/forms/presentation/pages/forms_list_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/wrapper/form_wrapper.dart';

final formsRouter = [
  ShellRoute(
      builder: (context, state, child) => FormWrapper(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.forms,
          builder: (_, __) => const FormsListPage(),
        ),
        GoRoute(
          path: AppRoutes.formsCreate,
          builder: (_, __) => const CreateFormPage(),
        ),
        GoRoute(
          path: AppRoutes.formsDetail,
          builder: (_, state) {
            final id = state.pathParameters["id"]!;
            return FormDetailPage(formId: id);
          },
        ),
      ])
];
