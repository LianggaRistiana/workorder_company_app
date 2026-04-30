import 'package:workorder_company_app/features/submissions/domain/entities/upload_result.dart';
import 'package:workorder_company_app/features/submissions/domain/repositories/file_upload_repository.dart';

class UploadFileUseCase {
  final FileRepository repository;

  UploadFileUseCase(this.repository);

  Stream<UploadResult> call(String filePath) {
    return repository.uploadFile(filePath);
  }
}
