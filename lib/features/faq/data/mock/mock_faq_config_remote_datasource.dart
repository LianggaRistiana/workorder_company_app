import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/model/multipart_result.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/features/faq/data/datasources/faq_config_remote_datasource.dart';
import 'package:workorder_company_app/features/faq/data/model/faq_doc_model.dart';
import 'package:workorder_company_app/features/faq/data/model/text_faq_doc_model.dart';
import 'dart:async';
import 'dart:math';
import 'package:faker/faker.dart';

import 'fac_doc_mock_factory.dart';

class MockFaqConfigRemoteDatasource implements FaqConfigRemoteDatasource {
  final faker = Faker();
  final factory = FacDocMockFactory();

  final List<FaqDocModel> _storage = [];

  @override
  ApiFuture<Empty> deleteFaqDoc(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    _storage.removeWhere((e) => e.id == id);

    return ApiResponse(
      message: "Deleted successfully",
      data: Empty(),
    );
  }

  @override
  ApiFutureList<FaqDocModel> getFaqDocs() async {
    await Future.delayed(const Duration(seconds: 1));

    if (_storage.isEmpty) {
      _storage.addAll(factory.createList(count: 10));
    }

    return ApiResponse(
      message: "Success",
      data: _storage,
    );
  }

  @override
  ApiFuture<CompanyModel> toggleFaqFeature(bool value) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final isError = Random().nextBool(); // true / false random

    if (isError) {
      throw ApiException(
        500,
        "Mock Server Error",
      );
    }

    return ApiResponse(
      message: "Success",
      data: CompanyModel(
        id: faker.guid.guid(),
        name: faker.company.name(),
        isActive: value,
      ),
    );
  }

  @override
  Stream<MultipartResult<FaqDocModel>> uploadPdfDoc(String filePath) async* {
    final random = Random();

    double progress = 0;

    while (progress < 1) {
      await Future.delayed(const Duration(milliseconds: 300));

      progress += random.nextDouble() * 0.2;
      if (progress > 1) progress = 1;

      yield MultipartResult<FaqDocModel>(
        progress: progress,
        isDone: false,
      );
    }

    // selesai upload
    final doc = factory.createModel();
    _storage.add(doc);

    yield MultipartResult<FaqDocModel>(
      progress: 1,
      isDone: true,
      data: doc,
    );
  }

  @override
  ApiFuture<FaqDocModel> uploadTextDocs(TextFaqDocModel draft) async {
    await Future.delayed(const Duration(seconds: 1));

    final doc = FacDocMockFactory().createModel();

    _storage.add(doc);

    return ApiResponse(
      message: "Success",
      data: doc,
    );
  }
}
