import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/auth/presentation/pages/profile_page.dart';
import 'package:workorder_company_app/features/company/presentation/pages/owner_company_page.dart';
import 'package:workorder_company_app/features/employees/presentation/page/employees_page.dart';
import 'package:workorder_company_app/features/employees/presentation/page/invite_employees_page.dart';
import 'package:workorder_company_app/features/forms/presentation/pages/create_new_form/create_new_form_page.dart';
import 'package:workorder_company_app/features/forms/presentation/pages/form_detail.page.dart';
import 'package:workorder_company_app/features/forms/presentation/pages/forms/forms_page.dart';
import 'package:workorder_company_app/features/home/presentation/pages/homepage/owner_company_homepage.dart';
import 'package:workorder_company_app/features/positions/presentation/pages/positions_page.dart';
import 'package:workorder_company_app/features/services/presentation/pages/create_new_service/create_new_service_page.dart';
import 'package:workorder_company_app/features/services/presentation/pages/service_detail/service_detail_page.dart';
import 'package:workorder_company_app/features/services/presentation/pages/services/services_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/shared/layout/owner_company_layout.dart';

final ownerRouter = [
  ShellRoute(
    builder: (context, state, child) => OwnerCompanyLayout(child: child),
    routes: [
      GoRoute(
        path: '/owner',
        redirect: (_, __) => AppRoutes.home,
      ),
      GoRoute(
        path: AppRoutes.ownerHome,
        builder: (_, __) => const OwnerCompanyHomepage(),
      ),
      GoRoute(
        path: AppRoutes.ownerCompany,
        builder: (_, __) => const OwnerCompanyPage(),
      ),
      GoRoute(
        path: AppRoutes.ownerEmployee,
        builder: (_, __) => const EmployeesPage(),
      ),
      GoRoute(
        path: AppRoutes.ownerProfile,
        builder: (_, __) => const ProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.ownerPositions,
        builder: (_, __) => const PositionsPage(),
      ),
      GoRoute(
        path: AppRoutes.ownerForms,
        builder: (_, __) => const FormsPage(),
      ),
      GoRoute(
        path: AppRoutes.ownerInviteEmployees,
        builder: (_, __) => const InviteEmployeePage(),
      ),
      GoRoute(
        path: AppRoutes.ownerServices,
        builder: (_, __) => const ServicesPage(),
      ),
    ],
  ),
  GoRoute(
    path: AppRoutes.ownerNewForm,
    builder: (_, __) => const CreateNewFormPage(),
  ),
  GoRoute(
    path: '${AppRoutes.ownerForms}/:id',
    builder: (context, state) {
      final id = state.pathParameters['id']!;
      return FormDetailPage(formId: id);
    },
  ),
  GoRoute(
    path: AppRoutes.ownerNewService,
    builder: (_, __) => const CreateServicePage(),
  ),
  GoRoute(
    path: '${AppRoutes.ownerServices}/:id',
    builder: (context, state) {
      final id = state.pathParameters['id']!;
      return ServiceDetailPage(serviceId: id);
    },
  ),
];
