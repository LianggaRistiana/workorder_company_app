import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/forms/data/model/work_reports_filled_form_model.dart';
import 'package:workorder_company_app/features/service_request/data/datasources/requester_service_request_remote_datasource.dart';
import 'package:workorder_company_app/features/service_request/data/model/requester_service_request_model.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late RequesterServiceRequestRemoteDatasourceImpl datasource;

  setUp(() {
    mockApiClient = MockApiClient();
    datasource = RequesterServiceRequestRemoteDatasourceImpl(mockApiClient);
  });

  // ── Helpers / Fixtures ──────────────────────────────────────────────────
  Map<String, dynamic> userJson({String id = 'uid-123', String role = 'client'}) => {
        '_id': id,
        'name': 'John Doe',
        'email': 'john@example.com',
        'role': role,
        'position': null,
      };

  Map<String, dynamic> companyJson() => {
        '_id': 'co-123',
        'name': 'PT Maju Bersama',
        'address': 'Jl. Sudirman No.1',
        'description': 'Perusahaan logistik',
        'isActive': true,
        'isFaqActive': true,
      };

  Map<String, dynamic> summaryJson() => {
        '_id': 'srv-123',
        'title': 'AC Service',
        'description': 'Regular maintenance',
        'accessType': 'public',
        'isActive': true,
        'price': 150000,
      };

  Map<String, dynamic> serviceRequestJson({String id = 'sr-123'}) => {
        '_id': id,
        'code': 'SR-CODE-001',
        'serviceRequestStatus': 'approved',
        'service': summaryJson(),
        'requestedBy': userJson(role: 'client'),
        'approvedBy': userJson(role: 'manager_company'),
        'company': companyJson(),
        'intakeForm': null,
        'reviewForm': null,
        'createdAt': '2026-06-12T03:37:03Z',
      };

  Map<String, dynamic> singleResponseJson({String id = 'sr-123'}) => {
        'message': 'success',
        'data': serviceRequestJson(id: id),
      };

  Map<String, dynamic> listResponseJson() => {
        'message': 'success',
        'data': [serviceRequestJson()],
      };

  Map<String, dynamic> formJson({String id = 'form-123'}) => {
        '_id': id,
        'title': 'Intake Form',
        'formType': 'work_order',
        'description': 'Regular intake',
        'position': null,
        'fields': const <dynamic>[],
      };

  Map<String, dynamic> formResponseJson({String id = 'form-123'}) => {
        'message': 'success',
        'data': formJson(id: id),
      };

  Map<String, dynamic> reportResponseJson() => {
        'message': 'success',
        'data': {
          'workReportForms': [
            {
              '_id': 'form-report-1',
              'title': 'Work Report',
              'formType': 'report',
              'description': 'Report Form',
            }
          ],
          'submissions': const <dynamic>[],
        }
      };

  SubmissionsModel makeSubmissionModel() => SubmissionsModel(
        id: 'sub-123',
        formId: 'form-123',
        submissionType: FormType.workOrder,
        fieldsData: const [],
        createdAt: DateTime.parse('2026-06-12T03:37:03Z'),
      );

  // ═══════════════════════════════════════════════════════════════════════
  // cancelServiceRequest  │  Cyclomatic Complexity = 1
  //                       │  Paths: success returns model, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('cancelServiceRequest —', () {
    const id = 'sr-123';

    /// R13: returns ApiResponse<RequesterServiceRequestModel> on success.
    test('R13: returns ApiResponse<RequesterServiceRequestModel> on success', () async {
      // arrange
      when(() => mockApiClient.patch<dynamic>(any()))
          .thenAnswer((_) async => singleResponseJson());

      // act
      final result = await datasource.cancelServiceRequest(id);

      // assert
      expect(result.data, isA<RequesterServiceRequestModel>());
      expect(result.data.id, id);
    });

    /// R14: propagates ApiException.
    test('R14: propagates ApiException when API client fails', () async {
      // arrange
      when(() => mockApiClient.patch<dynamic>(any()))
          .thenThrow(ApiException(400, 'Bad Request'));

      // act & assert
      await expectLater(
        () async => datasource.cancelServiceRequest(id),
        throwsA(isA<ApiException>()),
      );
    });

    /// R15: calls patch with correct endpoint.
    test('R15: calls patch with correct endpoint', () async {
      // arrange
      when(() => mockApiClient.patch<dynamic>(any()))
          .thenAnswer((_) async => singleResponseJson());

      // act
      await datasource.cancelServiceRequest(id);

      // assert
      verify(() => mockApiClient.patch<dynamic>(
            Endpoints.serviceRequestCancel.fillId(id),
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getServiceRequests  │  Cyclomatic Complexity = 1
  //                     │  Paths: success returns list, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('getServiceRequests —', () {
    /// R16: returns ApiResponse<List<RequesterServiceRequestModel>> on success.
    test('R16: returns ApiResponse<List<RequesterServiceRequestModel>> on success', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => listResponseJson());

      // act
      final result = await datasource.getServiceRequests();

      // assert
      expect(result.data, isA<List<RequesterServiceRequestModel>>());
      expect(result.data.length, 1);
      expect(result.data.first.id, 'sr-123');
    });

    /// R17: propagates ApiException.
    test('R17: propagates ApiException when API client fails', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenThrow(ApiException(500, 'Server Error'));

      // act & assert
      await expectLater(
        () async => datasource.getServiceRequests(),
        throwsA(isA<ApiException>()),
      );
    });

    /// R18: calls get with correct endpoint.
    test('R18: calls get with correct endpoint', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => listResponseJson());

      // act
      await datasource.getServiceRequests();

      // assert
      verify(() => mockApiClient.get<dynamic>(
            Endpoints.serviceRequestSent,
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getServiceRequestDetail  │  Cyclomatic Complexity = 1
  //                          │  Paths: success returns model, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('getServiceRequestDetail —', () {
    const id = 'sr-123';

    /// R19: returns ApiResponse<RequesterServiceRequestModel> on success.
    test('R19: returns ApiResponse<RequesterServiceRequestModel> on success', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => singleResponseJson());

      // act
      final result = await datasource.getServiceRequestDetail(id);

      // assert
      expect(result.data, isA<RequesterServiceRequestModel>());
      expect(result.data.id, id);
    });

    /// R20: propagates ApiException.
    test('R20: propagates ApiException when API client fails', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenThrow(ApiException(404, 'Not Found'));

      // act & assert
      await expectLater(
        () async => datasource.getServiceRequestDetail(id),
        throwsA(isA<ApiException>()),
      );
    });

    /// R21: calls get with correct endpoint.
    test('R21: calls get with correct endpoint', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => singleResponseJson());

      // act
      await datasource.getServiceRequestDetail(id);

      // assert
      verify(() => mockApiClient.get<dynamic>(
            Endpoints.serviceRequestDetail.fillId(id),
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // submitIntakeForm  │  Cyclomatic Complexity = 1
  //                   │  Paths: success returns model, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('submitIntakeForm —', () {
    const serviceId = 'srv-123';
    final submission = makeSubmissionModel();

    /// R22: returns ApiResponse<RequesterServiceRequestModel> on success.
    test('R22: returns ApiResponse<RequesterServiceRequestModel> on success', () async {
      // arrange
      when(() => mockApiClient.post<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson());

      // act
      final result = await datasource.submitIntakeForm(serviceId, submission);

      // assert
      expect(result.data, isA<RequesterServiceRequestModel>());
      expect(result.data.id, 'sr-123');
    });

    /// R23: propagates ApiException.
    test('R23: propagates ApiException when API client fails', () async {
      // arrange
      when(() => mockApiClient.post<dynamic>(any(), data: any(named: 'data')))
          .thenThrow(ApiException(400, 'Bad Request'));

      // act & assert
      await expectLater(
        () async => datasource.submitIntakeForm(serviceId, submission),
        throwsA(isA<ApiException>()),
      );
    });

    /// R24: calls post with correct endpoint and payload.
    test('R24: calls post with correct endpoint and payload', () async {
      // arrange
      when(() => mockApiClient.post<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson());

      // act
      await datasource.submitIntakeForm(serviceId, submission);

      // assert
      verify(() => mockApiClient.post<dynamic>(
            Endpoints.serviceRequestCreate.fillId(serviceId),
            data: {'submission': submission.toJson()},
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // submitReviewForm  │  Cyclomatic Complexity = 1
  //                   │  Paths: success returns model, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('submitReviewForm —', () {
    const serviceRequestId = 'sr-123';
    final submission = makeSubmissionModel();

    /// R25: returns ApiResponse<RequesterServiceRequestModel> on success.
    test('R25: returns ApiResponse<RequesterServiceRequestModel> on success', () async {
      // arrange
      when(() => mockApiClient.post<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson());

      // act
      final result = await datasource.submitReviewForm(serviceRequestId, submission);

      // assert
      expect(result.data, isA<RequesterServiceRequestModel>());
      expect(result.data.id, 'sr-123');
    });

    /// R26: propagates ApiException.
    test('R26: propagates ApiException when API client fails', () async {
      // arrange
      when(() => mockApiClient.post<dynamic>(any(), data: any(named: 'data')))
          .thenThrow(ApiException(400, 'Bad Request'));

      // act & assert
      await expectLater(
        () async => datasource.submitReviewForm(serviceRequestId, submission),
        throwsA(isA<ApiException>()),
      );
    });

    /// R27: calls post with correct endpoint and payload.
    test('R27: calls post with correct endpoint and payload', () async {
      // arrange
      when(() => mockApiClient.post<dynamic>(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson());

      // act
      await datasource.submitReviewForm(serviceRequestId, submission);

      // assert
      verify(() => mockApiClient.post<dynamic>(
            Endpoints.serviceRequestReview.fillId(serviceRequestId),
            data: {'submission': submission.toJson()},
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getIntakeFormForPublic  │  Cyclomatic Complexity = 1
  //                         │  Paths: success returns FormModel, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('getIntakeFormForPublic —', () {
    const serviceId = 'srv-123';

    /// R28: returns ApiResponse<FormModel> on success.
    test('R28: returns ApiResponse<FormModel> on success', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => formResponseJson());

      // act
      final result = await datasource.getIntakeFormForPublic(serviceId);

      // assert
      expect(result.data, isA<FormModel>());
      expect(result.data.id, 'form-123');
    });

    /// R29: propagates ApiException.
    test('R29: propagates ApiException when API client fails', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenThrow(ApiException(404, 'Not Found'));

      // act & assert
      await expectLater(
        () async => datasource.getIntakeFormForPublic(serviceId),
        throwsA(isA<ApiException>()),
      );
    });

    /// R30: calls get with correct public endpoint.
    test('R30: calls get with correct public endpoint', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => formResponseJson());

      // act
      await datasource.getIntakeFormForPublic(serviceId);

      // assert
      verify(() => mockApiClient.get<dynamic>(
            Endpoints.serviceRequestIntakePublic.fillId(serviceId),
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getIntakeFormForInternal  │  Cyclomatic Complexity = 1
  //                           │  Paths: success returns FormModel, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('getIntakeFormForInternal —', () {
    const serviceId = 'srv-123';

    /// R31: returns ApiResponse<FormModel> on success.
    test('R31: returns ApiResponse<FormModel> on success', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => formResponseJson());

      // act
      final result = await datasource.getIntakeFormForInternal(serviceId);

      // assert
      expect(result.data, isA<FormModel>());
      expect(result.data.id, 'form-123');
    });

    /// R32: propagates ApiException.
    test('R32: propagates ApiException when API client fails', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenThrow(ApiException(404, 'Not Found'));

      // act & assert
      await expectLater(
        () async => datasource.getIntakeFormForInternal(serviceId),
        throwsA(isA<ApiException>()),
      );
    });

    /// R33: calls get with correct internal endpoint.
    test('R33: calls get with correct internal endpoint', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => formResponseJson());

      // act
      await datasource.getIntakeFormForInternal(serviceId);

      // assert
      verify(() => mockApiClient.get<dynamic>(
            Endpoints.serviceRequestIntakeInternal.fillId(serviceId),
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getReviewForm  │  Cyclomatic Complexity = 1
  //                │  Paths: success returns FormModel, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('getReviewForm —', () {
    const serviceRequestId = 'sr-123';

    /// R34: returns ApiResponse<FormModel> on success.
    test('R34: returns ApiResponse<FormModel> on success', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => formResponseJson());

      // act
      final result = await datasource.getReviewForm(serviceRequestId);

      // assert
      expect(result.data, isA<FormModel>());
      expect(result.data.id, 'form-123');
    });

    /// R35: propagates ApiException.
    test('R35: propagates ApiException when API client fails', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenThrow(ApiException(404, 'Not Found'));

      // act & assert
      await expectLater(
        () async => datasource.getReviewForm(serviceRequestId),
        throwsA(isA<ApiException>()),
      );
    });

    /// R36: calls get with correct review endpoint.
    test('R36: calls get with correct review endpoint', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => formResponseJson());

      // act
      await datasource.getReviewForm(serviceRequestId);

      // assert
      verify(() => mockApiClient.get<dynamic>(
            Endpoints.serviceRequestReview.fillId(serviceRequestId),
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getServiceRequestReport  │  Cyclomatic Complexity = 1
  //                          │  Paths: success returns WorkReportsFilledFormModel, failure propagates
  // ═══════════════════════════════════════════════════════════════════════
  group('getServiceRequestReport —', () {
    const id = 'sr-123';

    /// R37: returns ApiResponse<WorkReportsFilledFormModel> on success.
    test('R37: returns ApiResponse<WorkReportsFilledFormModel> on success', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => reportResponseJson());

      // act
      final result = await datasource.getServiceRequestReport(id);

      // assert
      expect(result.data, isA<WorkReportsFilledFormModel>());
      expect(result.data.filledForms.length, 1);
      expect(result.data.filledForms.first.form.id, 'form-report-1');
    });

    /// R38: propagates ApiException.
    test('R38: propagates ApiException when API client fails', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenThrow(ApiException(404, 'Not Found'));

      // act & assert
      await expectLater(
        () async => datasource.getServiceRequestReport(id),
        throwsA(isA<ApiException>()),
      );
    });

    /// R39: calls get with correct report endpoint.
    test('R39: calls get with correct report endpoint', () async {
      // arrange
      when(() => mockApiClient.get<dynamic>(any()))
          .thenAnswer((_) async => reportResponseJson());

      // act
      await datasource.getServiceRequestReport(id);

      // assert
      verify(() => mockApiClient.get<dynamic>(
            Endpoints.serviceRequestReport.fillId(id),
          )).called(1);
    });
  });
}
