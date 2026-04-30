import 'package:workorder_company_app/features/submissions/domain/entities/upload_result.dart';

abstract class FileRepository {
  Stream<UploadResult> uploadFile(String filePath);
}
