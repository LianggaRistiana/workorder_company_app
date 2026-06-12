import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';
import 'package:workorder_company_app/features/work_report/data/datasources/work_report_remote_datasource.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late WorkReportRemoteDatasourceImpl datasource;

  setUp(() {
    mockApiClient = MockApiClient();
    datasource = WorkReportRemoteDatasourceImpl(mockApiClient);
  });

  // ── Helpers / Fixtures ──────────────────────────────────────────────────
  // Map<String, dynamic> userJson({String id = 'uid-123', String role = 'client'}) => {
  //       '_id': id,
  //       'name': 'John Doe',
  //       'email': 'john@example.com',
  //       'role': role,
  //       'position': null,
  //     };

  Map<String, dynamic> formJson() => {
        '_id': 'form-123',
        'title': 'Work Report Form',
        'formType': 'report',
        'description': 'Regular report form',
        'position': null,
        'fields': const <dynamic>[],
      };

  Map<String, dynamic> submissionJson() => {
        '_id': 'sub-123',
        'formId': 'form-123',
        'submissionType': 'report',
        'fieldsData': const <dynamic>[],
        'createdAt': '2026-06-12T03:37:03Z',
      };

  Map<String, dynamic> workReportStatusDateJson() => {
        'createdAt': '2026-06-12T03:37:03Z',
        'submittedAt': '2026-06-12T03:45:03Z',
        'approvedAt': null,
        'rejectedAt': null,
      };

  Map<String, dynamic> workReportJson({String id = 'wr-123', String status = 'on_progress'}) => {
        '_id': id,
        'workOrderId': 'wo-123',
        'show_report_to_requester': true,
        'reportFormDetail': formJson(),
        'submissions': [submissionJson()],
        'workReportApprovalAccessType': 'manager',
        'status': status,
        'approvedBy': null,
        ...workReportStatusDateJson(),
      };

  Map<String, dynamic> singleResponseJson({String id = 'wr-123', String status = 'on_progress'}) => {
        'message': 'success',
        'data': workReportJson(id: id, status: status),
      };

  // ═══════════════════════════════════════════════════════════════════════
  // getWorkReport  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('getWorkReport —', () {
    const workOrderId = 'wo-123';
    test('R1: returns ApiResponse<WorkReportModel> on success', () async {
      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => singleResponseJson());

      final result = await datasource.getWorkReport(workOrderId);

      expect(result.message, 'success');
      expect(result.data.id, 'wr-123');
    });

    test('R2: propagates ApiException when API client fails', () async {
      when(() => mockApiClient.get(any()))
          .thenThrow(ApiException(404, 'Not Found'));

      expect(() => datasource.getWorkReport(workOrderId), throwsA(isA<ApiException>()));
    });

    test('R3: calls get with correct endpoint', () async {
      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => singleResponseJson());

      await datasource.getWorkReport(workOrderId);

      verify(() => mockApiClient.get(Endpoints.workReportDetail.fillId(workOrderId))).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // submitWorkReportSubmission  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('submitWorkReportSubmission —', () {
    const reportId = 'wr-123';
    final submission = SubmissionsModel(
      id: 'sub-123',
      formId: 'form-123',
      submissionType: FormType.report,
      fieldsData: const [],
      createdAt: DateTime.parse('2026-06-12T03:37:03Z'),
    );

    test('R4: returns ApiResponse<WorkReportModel> on success', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson(id: reportId));

      final result = await datasource.submitWorkReportSubmission(reportId, submission);

      expect(result.message, 'success');
      expect(result.data.id, reportId);
    });

    test('R5: propagates ApiException when API client fails', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenThrow(ApiException(422, 'Unprocessable'));

      expect(() => datasource.submitWorkReportSubmission(reportId, submission), throwsA(isA<ApiException>()));
    });

    test('R6: calls post with correct endpoint and payload', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson(id: reportId));

      await datasource.submitWorkReportSubmission(reportId, submission);

      verify(() => mockApiClient.post(
            Endpoints.workReportSetSubmissions.fillId(reportId),
            data: submission.toJson(),
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // sendWorkReport  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('sendWorkReport —', () {
    const reportId = 'wr-123';
    test('R7: returns ApiResponse<WorkReportModel> on success', () async {
      when(() => mockApiClient.patch(any()))
          .thenAnswer((_) async => singleResponseJson(id: reportId, status: 'submitted'));

      final result = await datasource.sendWorkReport(reportId);

      expect(result.message, 'success');
      expect(result.data.status, WorkReportStatus.sent);
    });

    test('R8: propagates ApiException when API client fails', () async {
      when(() => mockApiClient.patch(any()))
          .thenThrow(ApiException(400, 'Bad Request'));

      expect(() => datasource.sendWorkReport(reportId), throwsA(isA<ApiException>()));
    });

    test('R9: calls patch with correct endpoint', () async {
      when(() => mockApiClient.patch(any()))
          .thenAnswer((_) async => singleResponseJson(id: reportId));

      await datasource.sendWorkReport(reportId);

      verify(() => mockApiClient.patch(Endpoints.workReportSent.fillId(reportId))).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // approveWorkReport  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('approveWorkReport —', () {
    const reportId = 'wr-123';
    test('R10: returns ApiResponse<WorkReportModel> on success', () async {
      when(() => mockApiClient.patch(any()))
          .thenAnswer((_) async => singleResponseJson(id: reportId, status: 'approved'));

      final result = await datasource.approveWorkReport(reportId);

      expect(result.message, 'success');
      expect(result.data.status, WorkReportStatus.approved);
    });

    test('R11: propagates ApiException when API client fails', () async {
      when(() => mockApiClient.patch(any()))
          .thenThrow(ApiException(400, 'Bad Request'));

      expect(() => datasource.approveWorkReport(reportId), throwsA(isA<ApiException>()));
    });

    test('R12: calls patch with correct endpoint', () async {
      when(() => mockApiClient.patch(any()))
          .thenAnswer((_) async => singleResponseJson(id: reportId));

      await datasource.approveWorkReport(reportId);

      verify(() => mockApiClient.patch(Endpoints.workReportApprove.fillId(reportId))).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // rejectWorkReport  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('rejectWorkReport —', () {
    const reportId = 'wr-123';
    test('R13: returns ApiResponse<WorkReportModel> on success', () async {
      when(() => mockApiClient.patch(any()))
          .thenAnswer((_) async => singleResponseJson(id: reportId, status: 'rejected'));

      final result = await datasource.rejectWorkReport(reportId);

      expect(result.message, 'success');
      expect(result.data.status, WorkReportStatus.rejected);
    });

    test('R14: propagates ApiException when API client fails', () async {
      when(() => mockApiClient.patch(any()))
          .thenThrow(ApiException(400, 'Bad Request'));

      expect(() => datasource.rejectWorkReport(reportId), throwsA(isA<ApiException>()));
    });

    test('R15: calls patch with correct endpoint', () async {
      when(() => mockApiClient.patch(any()))
          .thenAnswer((_) async => singleResponseJson(id: reportId));

      await datasource.rejectWorkReport(reportId);

      verify(() => mockApiClient.patch(Endpoints.workReportReject.fillId(reportId))).called(1);
    });
  });
}
