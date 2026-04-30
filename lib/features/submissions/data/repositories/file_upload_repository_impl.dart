import 'package:workorder_company_app/features/submissions/data/datasources/file_upload_remote_datasource.dart';
import 'package:workorder_company_app/features/submissions/domain/entities/upload_result.dart';
import 'package:workorder_company_app/features/submissions/domain/repositories/file_upload_repository.dart';

class FileRepositoryImpl implements FileRepository {
  final FileRemoteDataSource remote;

  FileRepositoryImpl(this.remote);

  @override
  Stream<UploadResult> uploadFile(String filePath) {
    return remote.uploadFile(filePath);
  }
}
