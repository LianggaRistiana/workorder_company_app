import 'package:go_router/go_router.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/pdf_item.dart';
import 'package:workorder_company_app/features/faq/presentation/pages/add_pdf_faq_doc_page.dart';
import 'package:workorder_company_app/features/faq/presentation/pages/add_text_faq_doc_page.dart';
import 'package:workorder_company_app/routes/app_routes.dart';
import 'package:workorder_company_app/routes/guards/route_guard.dart';
import 'package:workorder_company_app/shared/page/pdf_viewer_page.dart';

// TODO : add permission to access this page
final faqRouter = [
  GoRoute(
    path: AppRoutes.addTextFaqDoc,
    builder: (_, __) => const AddTextFaqDocPage(),
  ),
  GoRoute(
    path: AppRoutes.addPdfFaqDoc,
    builder: (_, __) => const AddPdfFaqDocPage(),
  ),
  GoRoute(
    path: AppRoutes.previewPdf,
    redirect: requireExtra<PdfItem>(),
    builder: (_, state) => PdfViewerPage(
      pdfItem: state.extra as PdfItem,
    ),
  ),
];
