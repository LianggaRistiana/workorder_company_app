import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/features/forms/data/model/filled_form_with_history_model.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';
import 'package:workorder_company_app/features/submissions/domain/entities/submission_entity.dart';
import 'package:workorder_company_app/features/work_report/data/datasources/work_report_remote_datasource.dart';
import 'package:workorder_company_app/features/work_report/data/model/work_report_model.dart';
import 'package:workorder_company_app/features/work_report/data/model/work_report_status_date_model.dart';
import 'package:workorder_company_app/features/work_report/data/repositories/work_report_repository_impl.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockWorkReportRemoteDatasource extends Mock implements WorkReportRemoteDatasource {}

void main() {
  late MockWorkReportRemoteDatasource mockRemote;
  late WorkReportRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(SubmissionsModel(
      id: 'fallback-sub',
      formId: 'fallback-form',
      submissionType: FormType.report,
      fieldsData: const [],
      createdAt: DateTime(2026, 6, 12),
    ));
  });

  setUp(() {
    mockRemote = MockWorkReportRemoteDatasource();
    repository = WorkReportRepositoryImpl(mockRemote);
  });

  // ── Helpers / Fixtures ──────────────────────────────────────────────────
  Map<String, dynamic> formJson() => {
        '_id': 'form-123',
        'title': 'Form Title',
        'formType': 'report',
        'description': 'Test description',
        'position': null,
        'fields': const [],
      };

  WorkReportModel makeWorkReportModel({
    String id = 'wr-123',
    String workOrderId = 'wo-123',
    WorkReportStatus status = WorkReportStatus.onProgress,
  }) =>
      WorkReportModel(
        id: id,
        workOrderId: workOrderId,
        showReportToRequester: true,
        workReportForm: FilledFormWithHistoryModel(
          form: FormModel.fromJson(formJson()),
          submissionHistory: const [],
        ),
        approvalAccess: WorkReportApprovalAccess.manager,
        status: status,
        approvedBy: null,
        statusDate: const WorkReportStatusDateModel(),
      );

  ApiResponse<WorkReportModel> makeSingleResponse(WorkReportModel data) =>
      ApiResponse(
        message: 'success',
        data: data,
      );

  // ═══════════════════════════════════════════════════════════════════════
  // approveWorkReport  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('approveWorkReport —', () {
    const id = 'wr-123';
    final model = makeWorkReportModel(id: id, status: WorkReportStatus.approved);

    test('I1: returns Right(WorkReportEntity) on success', () async {
      when(() => mockRemote.approveWorkReport(id))
          .thenAnswer((_) async => makeSingleResponse(model));

      final result = await repository.approveWorkReport(id);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('should succeed'),
        (entity) => expect(entity.id, id),
      );
    });

    test('I2: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemote.approveWorkReport(id))
          .thenThrow(ApiException(400, 'Bad Request'));

      final result = await repository.approveWorkReport(id);

      expect(result.isLeft(), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getWorkReport  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('getWorkReport —', () {
    const workOrderId = 'wo-123';
    final model = makeWorkReportModel(workOrderId: workOrderId);

    test('I3: returns Right(WorkReportEntity) on success', () async {
      when(() => mockRemote.getWorkReport(workOrderId))
          .thenAnswer((_) async => makeSingleResponse(model));

      final result = await repository.getWorkReport(workOrderId);

      expect(result.isRight(), isTrue);
    });

    test('I4: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemote.getWorkReport(workOrderId))
          .thenThrow(ApiException(404, 'Not Found'));

      final result = await repository.getWorkReport(workOrderId);

      expect(result.isLeft(), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // rejectWorkReport  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('rejectWorkReport —', () {
    const id = 'wr-123';
    final model = makeWorkReportModel(id: id, status: WorkReportStatus.rejected);

    test('I5: returns Right(WorkReportEntity) on success', () async {
      when(() => mockRemote.rejectWorkReport(id))
          .thenAnswer((_) async => makeSingleResponse(model));

      final result = await repository.rejectWorkReport(id);

      expect(result.isRight(), isTrue);
    });

    test('I6: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemote.rejectWorkReport(id))
          .thenThrow(ApiException(400, 'Bad Request'));

      final result = await repository.rejectWorkReport(id);

      expect(result.isLeft(), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // sendWorkReport  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('sendWorkReport —', () {
    const id = 'wr-123';
    final model = makeWorkReportModel(id: id, status: WorkReportStatus.sent);

    test('I7: returns Right(WorkReportEntity) on success', () async {
      when(() => mockRemote.sendWorkReport(id))
          .thenAnswer((_) async => makeSingleResponse(model));

      final result = await repository.sendWorkReport(id);

      expect(result.isRight(), isTrue);
    });

    test('I8: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemote.sendWorkReport(id))
          .thenThrow(ApiException(400, 'Bad Request'));

      final result = await repository.sendWorkReport(id);

      expect(result.isLeft(), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // submitWorkReportSubmission  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('submitWorkReportSubmission —', () {
    const id = 'wr-123';
    final submission = SubmissionEntity(
      id: 'sub-123',
      formId: 'form-123',
      submissionType: FormType.report,
      fieldsData: const [],
      createdAt: DateTime(2026, 6, 12),
    );
    final model = makeWorkReportModel(id: id);

    test('I9: returns Right(WorkReportEntity) on success', () async {
      when(() => mockRemote.submitWorkReportSubmission(id, any()))
          .thenAnswer((_) async => makeSingleResponse(model));

      final result = await repository.submitWorkReportSubmission(id, submission);

      expect(result.isRight(), isTrue);
    });

    test('I10: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemote.submitWorkReportSubmission(id, any()))
          .thenThrow(ApiException(422, 'Unprocessable'));

      final result = await repository.submitWorkReportSubmission(id, submission);

      expect(result.isLeft(), isTrue);
    });
  });
}
