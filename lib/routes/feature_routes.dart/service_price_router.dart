import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/service_price/presentation/pages/service_price_list_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

final servicePriceRouter = [
  GoRoute(
    path: AppRoutes.servicePrice,
    builder: (_, __) => const ServicePriceListPage(),
  ),
];
