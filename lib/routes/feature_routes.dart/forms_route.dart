import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/forms/presentation/pages/create_new_form/create_new_form_page.dart';
import 'package:workorder_company_app/features/forms/presentation/pages/form_detail.page.dart';
import 'package:workorder_company_app/features/forms/presentation/pages/forms/forms_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/wrapper/form_wrapper.dart';

final formsRouter = [
  ShellRoute(
      builder: (context, state, child) => FormWrapper(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.forms,
          builder: (_, __) => const FormsPage(),
        ),
        GoRoute(
          path: AppRoutes.formsCreate,
          builder: (_, __) => const CreateNewFormPage(),
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
