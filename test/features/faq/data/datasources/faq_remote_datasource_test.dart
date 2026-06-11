import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/features/faq/data/datasources/faq_remote_datasource.dart';
import 'package:workorder_company_app/features/faq/data/datasources/faq_config_remote_datasource.dart';
import 'package:workorder_company_app/features/faq/data/model/faq_doc_model.dart';
import 'package:workorder_company_app/features/faq/data/model/faq_response_model.dart';
import 'package:workorder_company_app/features/faq/data/model/pdf_faq_doc_model.dart';
import 'package:workorder_company_app/features/faq/data/model/text_faq_doc_model.dart';
import 'package:workorder_company_app/features/company/data/models/company_model.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late FaqRemoteDatasourceImpl faqDatasource;
  late FaqConfigRemoteDatasourceImpl faqConfigDatasource;
  late File dummyPdfFile;

  setUpAll(() {
    registerFallbackValue(const TextFaqDocModel(title: 'T', content: 'C'));
    registerFallbackValue(PdfFaqDocModel(title: 'T', filePath: 'P'));
    registerFallbackValue(FormData());
  });

  setUp(() {
    mockApiClient = MockApiClient();
    faqDatasource = FaqRemoteDatasourceImpl(mockApiClient);
    faqConfigDatasource = FaqConfigRemoteDatasourceImpl(mockApiClient);
    dummyPdfFile = File('test_faq_file.pdf')..writeAsStringSync('pdf content dummy');
  });

  tearDown(() {
    if (dummyPdfFile.existsSync()) {
      dummyPdfFile.deleteSync();
    }
  });

  // ── fixtures ──────────────────────────────────────────────────────────
  Map<String, dynamic> faqDocJson({int id = 101, String title = 'Doc'}) => {
        'id': id,
        'title': title,
        'content': 'Doc content detail',
        'type': 'text',
        'file_url': null,
        'created_at': '2026-06-12T03:00:00.000Z',
      };

  Map<String, dynamic> companyJson() => {
        '_id': 'co-123',
        'name': 'PT Maju Bersama',
        'isActive': true,
        'isFaqActive': true,
      };

  Map<String, dynamic> apiResponseJson({required dynamic data}) => {
        'message': 'OK',
        'data': data,
      };

  // Map<String, dynamic> apiResponseWithMetaJson({
  //   required dynamic data,
  //   required Map<String, dynamic> meta,
  // }) =>
  //     {
  //       'message': 'OK',
  //       'data': data,
  //       'meta': meta,
  //     };

  // ═══════════════════════════════════════════════════════════════════════
  // askQuestion  │  Cyclomatic Complexity = 1
  //              │  Paths: happy path | ApiException propagation | argument verification
  // ═══════════════════════════════════════════════════════════════════════
  group('FaqRemoteDatasourceImpl.askQuestion —', () {
    const q = 'How to use?';
    const cid = 'co-123';

    /// R1 | Branch: happy path
    /// Expected: returns ApiResponse<FaqResponseModel>
    test('R1: askQuestion returns ApiResponse<FaqResponseModel> on success', () async {
      when(() => mockApiClient.post<dynamic>(any(), data: any(named: 'data'), fromJson: any(named: 'fromJson')))
          .thenAnswer((_) async => apiResponseJson(data: {'answer': 'Just use it'}));

      final response = await faqDatasource.askQuestion(cid, q);

      expect(response, isA<ApiResponse<FaqResponseModel>>());
      expect(response.data.answer, 'Just use it');
    });

    /// R2 | Branch: error propagation
    /// Expected: propagates ApiException
    test('R2: askQuestion propagates ApiException on error', () async {
      when(() => mockApiClient.post<dynamic>(any(), data: any(named: 'data'), fromJson: any(named: 'fromJson')))
          .thenThrow(ApiException(500, 'Server Error'));

      await expectLater(
        () => faqDatasource.askQuestion(cid, q),
        throwsA(isA<ApiException>()),
      );
    });

    /// R3 | Branch: argument verification
    /// Expected: post is called with Endpoints.askQuestion and correct query map payload
    test('R3: askQuestion calls API post with correct endpoint and query payload', () async {
      when(() => mockApiClient.post<dynamic>(any(), data: any(named: 'data'), fromJson: any(named: 'fromJson')))
          .thenAnswer((_) async => apiResponseJson(data: {'answer': 'Ok'}));

      await faqDatasource.askQuestion(cid, q);

      verify(() => mockApiClient.post<dynamic>(
            Endpoints.askQuestion,
            data: {'companyId': cid, 'question': q},
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // deleteFaqDoc  │  Cyclomatic Complexity = 1
  //               │  Paths: happy path | ApiException propagation
  // ═══════════════════════════════════════════════════════════════════════
  group('FaqConfigRemoteDatasourceImpl.deleteFaqDoc —', () {
    const docId = '101';

    /// R4 | Branch: happy path
    /// Expected: returns ApiResponse<Empty>
    test('R4: deleteFaqDoc returns ApiResponse<Empty> on success', () async {
      when(() => mockApiClient.delete<dynamic>(any(), data: any(named: 'data'), fromJson: any(named: 'fromJson')))
          .thenAnswer((_) async => apiResponseJson(data: {}));

      final response = await faqConfigDatasource.deleteFaqDoc(docId);

      expect(response, isA<ApiResponse<Empty>>());
      expect(response.data, isA<Empty>());
      verify(() => mockApiClient.delete<dynamic>(Endpoints.faqDeleteDocs.fillId(docId))).called(1);
    });

    /// R5 | Branch: error propagation
    /// Expected: propagates ApiException
    test('R5: deleteFaqDoc propagates ApiException on error', () async {
      when(() => mockApiClient.delete<dynamic>(any(), data: any(named: 'data'), fromJson: any(named: 'fromJson')))
          .thenThrow(ApiException(404, 'Not Found'));

      await expectLater(
        () => faqConfigDatasource.deleteFaqDoc(docId),
        throwsA(isA<ApiException>()),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getFaqDocs  │  Cyclomatic Complexity = 1
  //             │  Paths: happy path | ApiException propagation
  // ═══════════════════════════════════════════════════════════════════════
  group('FaqConfigRemoteDatasourceImpl.getFaqDocs —', () {
    /// R6 | Branch: happy path
    /// Expected: returns ApiResponse<List<FaqDocModel>>
    test('R6: getFaqDocs returns ApiResponse<List<FaqDocModel>> on success', () async {
      when(() => mockApiClient.get<dynamic>(any(), queryParams: any(named: 'queryParams'), options: any(named: 'options'), fromJson: any(named: 'fromJson')))
          .thenAnswer((_) async => apiResponseJson(data: [faqDocJson()]));

      final response = await faqConfigDatasource.getFaqDocs();

      expect(response.data, isA<List<FaqDocModel>>());
      expect(response.data.length, 1);
      expect(response.data[0].id, '101');
    });

    /// R7 | Branch: error propagation
    /// Expected: propagates ApiException
    test('R7: getFaqDocs propagates ApiException on error', () async {
      when(() => mockApiClient.get<dynamic>(any(), queryParams: any(named: 'queryParams'), options: any(named: 'options'), fromJson: any(named: 'fromJson')))
          .thenThrow(ApiException(500, 'Server Error'));

      await expectLater(
        () => faqConfigDatasource.getFaqDocs(),
        throwsA(isA<ApiException>()),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // toggleFaqFeature  │  Cyclomatic Complexity = 1
  //                   │  Paths: happy path | ApiException propagation
  // ═══════════════════════════════════════════════════════════════════════
  group('FaqConfigRemoteDatasourceImpl.toggleFaqFeature —', () {
    /// R8 | Branch: happy path
    /// Expected: returns ApiResponse<CompanyModel>
    test('R8: toggleFaqFeature returns ApiResponse<CompanyModel> on success', () async {
      when(() => mockApiClient.put<dynamic>(any(), data: any(named: 'data'), options: any(named: 'options'), fromJson: any(named: 'fromJson')))
          .thenAnswer((_) async => apiResponseJson(data: companyJson()));

      final response = await faqConfigDatasource.toggleFaqFeature(true);

      expect(response.data, isA<CompanyModel>());
      expect(response.data.id, 'co-123');
      expect(response.data.isFaqActive, isTrue);
      verify(() => mockApiClient.put<dynamic>(Endpoints.faqToggleActive, data: {'isActive': true})).called(1);
    });

    /// R9 | Branch: error propagation
    /// Expected: propagates ApiException
    test('R9: toggleFaqFeature propagates ApiException on error', () async {
      when(() => mockApiClient.put<dynamic>(any(), data: any(named: 'data'), options: any(named: 'options'), fromJson: any(named: 'fromJson')))
          .thenThrow(ApiException(400, 'Bad Request'));

      await expectLater(
        () => faqConfigDatasource.toggleFaqFeature(false),
        throwsA(isA<ApiException>()),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // uploadTextDocs  │  Cyclomatic Complexity = 1
  //                 │  Paths: happy path | ApiException propagation
  // ═══════════════════════════════════════════════════════════════════════
  group('FaqConfigRemoteDatasourceImpl.uploadTextDocs —', () {
    final draft = const TextFaqDocModel(title: 'Guidelines', content: 'Details');

    /// R10 | Branch: happy path
    /// Expected: returns ApiResponse<FaqDocModel>
    test('R10: uploadTextDocs returns ApiResponse<FaqDocModel> on success', () async {
      when(() => mockApiClient.post<dynamic>(any(), data: any(named: 'data'), fromJson: any(named: 'fromJson')))
          .thenAnswer((_) async => apiResponseJson(data: faqDocJson(title: 'Guidelines')));

      final response = await faqConfigDatasource.uploadTextDocs(draft);

      expect(response.data, isA<FaqDocModel>());
      expect(response.data.title, 'Guidelines');
      verify(() => mockApiClient.post<dynamic>(Endpoints.faqTextDocs, data: draft.toJson())).called(1);
    });

    /// R11 | Branch: error propagation
    /// Expected: propagates ApiException
    test('R11: uploadTextDocs propagates ApiException on error', () async {
      when(() => mockApiClient.post<dynamic>(any(), data: any(named: 'data'), fromJson: any(named: 'fromJson')))
          .thenThrow(ApiException(422, 'Validation Error'));

      await expectLater(
        () => faqConfigDatasource.uploadTextDocs(draft),
        throwsA(isA<ApiException>()),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // uploadPdfDoc  │  Cyclomatic Complexity = 1 (handling stream states)
  //               │  Paths: happy path (progress -> success) | api exception | generic exception
  // ═══════════════════════════════════════════════════════════════════════
  group('FaqConfigRemoteDatasourceImpl.uploadPdfDoc —', () {
    late PdfFaqDocModel pdfDraft;

    setUp(() {
      pdfDraft = PdfFaqDocModel(title: 'PDF Doc', filePath: dummyPdfFile.path);
    });

    /// R12 | Branch: happy path (progress -> success)
    /// Expected: stream emits progress and success results
    test('R12: uploadPdfDoc emits progress and success results on successful file upload', () async {
      when(() => mockApiClient.postFormData<dynamic>(
            any(),
            data: any(named: 'data'),
            onSendProgress: any(named: 'onSendProgress'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
            fromJson: any(named: 'fromJson'),
          )).thenAnswer((invocation) async {
        // Retrieve and trigger progress callback
        final progressCallback = invocation.namedArguments[#onSendProgress] as void Function(int, int)?;
        if (progressCallback != null) {
          progressCallback(50, 100);
        }
        return apiResponseJson(data: faqDocJson(title: 'PDF Doc'));
      });

      final stream = faqConfigDatasource.uploadPdfDoc(pdfDraft);

      final results = await stream.toList();

      expect(results.length, 2);
      expect(results[0].isDone, isFalse);
      expect(results[0].progress, 0.5);

      expect(results[1].isDone, isTrue);
      expect(results[1].progress, 1.0);
      expect(results[1].data, isNotNull);
      expect(results[1].data!.title, 'PDF Doc');
      expect(results[1].error, isNull);
    });

    /// R13 | Branch: ApiException
    /// Expected: stream catches ApiException and emits failure result
    test('R13: uploadPdfDoc emits failure result when ApiException is thrown', () async {
      when(() => mockApiClient.postFormData<dynamic>(
            any(),
            data: any(named: 'data'),
            onSendProgress: any(named: 'onSendProgress'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
            fromJson: any(named: 'fromJson'),
          )).thenThrow(ApiException(413, 'File too large'));

      final stream = faqConfigDatasource.uploadPdfDoc(pdfDraft);

      final results = await stream.toList();

      expect(results.length, 1);
      expect(results[0].isDone, isTrue);
      expect(results[0].error, 'File too large');
    });

    /// R14 | Branch: generic exception
    /// Expected: stream catches exception and emits default failure message
    test('R14: uploadPdfDoc emits default failure result when generic exception is thrown', () async {
      when(() => mockApiClient.postFormData<dynamic>(
            any(),
            data: any(named: 'data'),
            onSendProgress: any(named: 'onSendProgress'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
            fromJson: any(named: 'fromJson'),
          )).thenThrow(Exception('Disk read failure'));

      final stream = faqConfigDatasource.uploadPdfDoc(pdfDraft);

      final results = await stream.toList();

      expect(results.length, 1);
      expect(results[0].isDone, isTrue);
      expect(results[0].error, 'Terjadi kesalahan saat upload file');
    });
  });
}
