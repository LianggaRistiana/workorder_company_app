import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/features/faq/data/model/faq_doc_model.dart';
import 'package:workorder_company_app/features/faq/data/model/text_faq_doc_model.dart';
import 'package:workorder_company_app/features/submissions/domain/entities/upload_result.dart';

abstract class FaqConfigRemoteDatasource {
  ApiFutureList<FaqDocModel> getFaqDocs();
  ApiFuture<Empty> deleteFaqDoc(String id);
  ApiFuture<CompanyModel> toggleFaqFeature(bool value);
  ApiFuture<FaqDocModel> uploadTextDocs(TextFaqDocModel draft);
  Stream<UploadResult> uploadPdfDoc(String filePath);
}

class FaqConfigRemoteDatasourceImpl implements FaqConfigRemoteDatasource {
  @override
  ApiFuture<Empty> deleteFaqDoc(String id) {
    // TODO: implement deleteFaqDoc
    throw UnimplementedError();
  }

  @override
  ApiFutureList<FaqDocModel> getFaqDocs() {
    // TODO: implement getFaqDocs
    throw UnimplementedError();
  }

  @override
  ApiFuture<CompanyModel> toggleFaqFeature(bool value) {
    // TODO: implement toggleFaqFeature
    throw UnimplementedError();
  }

  @override
  Stream<UploadResult> uploadPdfDoc(String filePath) {
    // TODO: implement uploadPdfDoc
    throw UnimplementedError();
  }

  @override
  ApiFuture<FaqDocModel> uploadTextDocs(TextFaqDocModel draft) {
    // TODO: implement uploadTextDocs
    throw UnimplementedError();
  }
}
