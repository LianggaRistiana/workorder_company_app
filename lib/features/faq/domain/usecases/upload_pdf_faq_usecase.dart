import 'package:workorder_company_app/core/model/multipart_result.dart';
import 'package:workorder_company_app/features/faq/domain/entitties/faq_doc_entity.dart';
import 'package:workorder_company_app/features/faq/domain/repositories/faq_config_repository.dart';

class UploadPdfFaqUsecase {
  final FaqConfigRepository repository;

  UploadPdfFaqUsecase(this.repository);

  Stream<MultipartResult<FaqDocEntity>> call(String filePath) {
    return repository.uploadPdfDoc(filePath);
  }
}
