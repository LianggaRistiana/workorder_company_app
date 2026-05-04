import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/faq/presentation/pages/add_pdf_faq_doc_page.dart';
import 'package:workorder_company_app/features/faq/presentation/pages/add_text_faq_doc_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';

final faqRouter = [
  GoRoute(
    path: AppRoutes.addTextFaqDoc,
    builder: (_, __) => const AddTextFaqDocPage(),
  ),
  GoRoute(
    path: AppRoutes.addPdfFaqDoc,
    builder: (_, __) => const AddPdfFaqDocPage(),
  ),
];
