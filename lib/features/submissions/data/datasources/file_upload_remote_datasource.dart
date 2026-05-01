import 'dart:async';

import 'package:dio/dio.dart';
import 'package:workorder_company_app/core/services/logger/app_logger.dart';
import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/features/submissions/data/model/upload_payload.dart';
import 'package:workorder_company_app/features/submissions/domain/entities/upload_result.dart';

abstract class FileRemoteDataSource {
  Stream<UploadResult> uploadFile(String filePath);
}

class FileRemoteDataSourceImpl implements FileRemoteDataSource {
  final ApiClient _apiClient;

  FileRemoteDataSourceImpl(this._apiClient);

  @override
  Stream<UploadResult> uploadFile(String filePath) {
    final controller = StreamController<UploadResult>();
    () async {
      appLogger.i("Upload started");

      double lastProgress = 0;

      try {
        final formData = FormData.fromMap({
          "file": await MultipartFile.fromFile(filePath),
        });

        final response = await _apiClient.postFormData(
          Endpoints.fileUpload,
          data: formData,
          onSendProgress: (sent, total) {
            if (total <= 0) return;

            final progress = sent / total;
            lastProgress = progress;

            controller.add(
              UploadResult.progress(progress),
            );
          },
        );

        final result = ApiResponse.fromJson(
            response, (data) => UploadPayload.fromMap(data));

        controller.add(
          UploadResult.success(result.data.url),
        );

        await controller.close();
      } catch (e) {
        appLogger.e(e);
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
