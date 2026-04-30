import 'dart:async';

import 'package:dio/dio.dart';
import 'package:workorder_company_app/features/submissions/domain/entities/upload_result.dart';

abstract class FileRemoteDataSource {
  Stream<UploadResult> uploadFile(String filePath);
}

class FileRemoteDataSourceImpl implements FileRemoteDataSource {
  final Dio dio;

  FileRemoteDataSourceImpl(this.dio);

  @override
  Stream<UploadResult> uploadFile(String filePath) {
    final controller = StreamController<UploadResult>();

    () async {
      double lastProgress = 0;

      try {
        final formData = FormData.fromMap({
          "file": await MultipartFile.fromFile(filePath),
        });

        final response = await dio.post(
          "/files",
          data: formData,
          options: Options(
            contentType: "multipart/form-data",
          ),
          onSendProgress: (sent, total) {
            if (total <= 0) return;

            final progress = sent / total;
            lastProgress = progress;

            controller.add(
              UploadResult.progress(progress),
            );
          },
        );

        final url = response.data["data"]["url"];

        controller.add(
          UploadResult.success(url),
        );

        await controller.close();
      } catch (e) {
        controller.add(
          UploadResult.failure(
            _mapError(e),
            progress: lastProgress,
          ),
        );

        await controller.close();
      }
    }();

    return controller.stream;
  }

  String _mapError(Object e) {
    if (e is DioException) {
      return e.response?.data?["message"] ?? e.message ?? "Upload failed";
    }
    return "Unexpected error";
  }
}
