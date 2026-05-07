import 'dart:async';

import 'package:dio/dio.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/model/multipart_result.dart';
import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/features/faq/data/model/faq_doc_model.dart';
import 'package:workorder_company_app/features/faq/data/model/pdf_faq_doc_model.dart';
import 'package:workorder_company_app/features/faq/data/model/text_faq_doc_model.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';

abstract class FaqConfigRemoteDatasource {
  ApiFutureList<FaqDocModel> getFaqDocs();
  ApiFuture<Empty> deleteFaqDoc(String id);
  ApiFuture<CompanyModel> toggleFaqFeature(bool value);
  ApiFuture<FaqDocModel> uploadTextDocs(TextFaqDocModel draft);
  Stream<MultipartResult<FaqDocModel>> uploadPdfDoc(PdfFaqDocModel draft);
}

class FaqConfigRemoteDatasourceImpl implements FaqConfigRemoteDatasource {
  final ApiClient _apiClient;

  FaqConfigRemoteDatasourceImpl(this._apiClient);

  @override
  ApiFuture<Empty> deleteFaqDoc(String id) async {
    return await _apiClient.delete(Endpoints.faqDeleteDocs.fillId(id));
  }

  @override
  ApiFutureList<FaqDocModel> getFaqDocs() async {
    return await _apiClient.get(Endpoints.faqDocs);
  }

  @override
  ApiFuture<CompanyModel> toggleFaqFeature(bool value) async {
    return await _apiClient.put(Endpoints.faqToggleActive, data: {
      "isActive": value,
    });
  }

  @override
  Stream<MultipartResult<FaqDocModel>> uploadPdfDoc(PdfFaqDocModel draft) {
    final controller = StreamController<MultipartResult<FaqDocModel>>();

    controller.onListen = () async {
      try {
        final formData = FormData.fromMap({
          "title": draft.title,
          "file": await MultipartFile.fromFile(
            draft.filePath,
          ),
        });

        final response = await _apiClient.postFormData(
          Endpoints.faqPDfDocs,
          data: formData,
          onSendProgress: (sent, total) {
            if (total <= 0 || controller.isClosed) return;

            controller.add(
              MultipartResult<FaqDocModel>.progress(sent / total),
            );
          },
        );

        final result = ApiResponse.fromJson(
          response,
          (data) => FaqDocModel.fromJson(data),
        );

        if (!controller.isClosed) {
          controller.add(
            MultipartResult<FaqDocModel>.success(result.data),
          );
        }
      } on ApiException catch (e) {
        if (!controller.isClosed) {
          controller.add(
            MultipartResult<FaqDocModel>.failure(e.message),
          );
        }
      } catch (e) {
        if (!controller.isClosed) {
          controller.add(
            MultipartResult<FaqDocModel>.failure(
              "Terjadi kesalahan saat upload file",
            ),
          );
        }
      } finally {
        await controller.close();
      }
    };

    return controller.stream;
  }

  @override
  ApiFuture<FaqDocModel> uploadTextDocs(TextFaqDocModel draft) async {
    return await _apiClient.post(Endpoints.faqTextDocs, data: draft.toJson());
  }
}
