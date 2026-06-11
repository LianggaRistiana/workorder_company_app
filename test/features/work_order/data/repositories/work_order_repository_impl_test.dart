import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/positions/data/models/position_model.dart';
import 'package:workorder_company_app/features/services/data/model/service_summary_model.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';
import 'package:workorder_company_app/features/submissions/domain/entities/submission_entity.dart';
import 'package:workorder_company_app/features/work_order/data/datasources/work_order_remote_datasource.dart';
import 'package:workorder_company_app/features/work_order/data/model/work_order_model.dart';
import 'package:workorder_company_app/features/work_order/data/model/work_order_status_date_model.dart';
import 'package:workorder_company_app/features/work_order/data/repositories/work_order_repository_impl.dart';
import 'package:workorder_company_app/features/work_order/domain/draft/assigned_staffs_draft.dart';
import 'package:workorder_company_app/features/work_order/domain/meta/work_order_meta.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockWorkOrderRemoteDatasource extends Mock implements WorkOrderRemoteDatasource {}

void main() {
  late MockWorkOrderRemoteDatasource mockRemote;
  late WorkOrderRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(SubmissionsModel(
      id: 'fallback-sub',
      formId: 'fallback-form',
      submissionType: FormType.workOrder,
      fieldsData: const [],
      createdAt: DateTime(2026, 6, 12),
    ));
    registerFallbackValue(AssignedStaffsDraft(
      assignedStaffs: const [],
    ));
  });

  setUp(() {
    mockRemote = MockWorkOrderRemoteDatasource();
    repository = WorkOrderRepositoryImpl(mockRemote);
  });

  // ── Helpers / Fixtures ──────────────────────────────────────────────────
  Map<String, dynamic> userJson({String id = 'uid-123', String role = 'client'}) => {
        '_id': id,
        'name': 'John Doe',
        'email': 'john@example.com',
        'role': role,
        'position': null,
      };

  Map<String, dynamic> positionJson() => {
        '_id': 'pos-123',
        'name': 'Technician',
        'description': 'Main technician',
        'isActive': true,
      };

  Map<String, dynamic> serviceSummaryJson() => {
        '_id': 'srv-123',
        'title': 'AC Service',
        'description': 'Regular maintenance',
        'accessType': 'public',
        'isActive': true,
        'price': 150000,
      };

  WorkOrderModel makeWorkOrderModel({
    String id = 'wo-123',
    WorkOrderStatus status = WorkOrderStatus.drafted,
  }) =>
      WorkOrderModel(
        id: id,
        code: 'WO-CODE-001',
        configId: 'cfg-123',
        service: ServiceSummaryModel.fromJson(serviceSummaryJson()),
        positionOnDuty: PositionModel.fromJson(positionJson()),
        serviceRequestId: 'sr-123',
        createdBy: UserModel.fromJson(userJson(role: 'owner_company')),
        approvedBy: null,
        approvalAccess: WorkOrderAprrovalAccess.auto,
        minStaff: 1,
        maxStaff: 3,
        status: status,
        staffPic: null,
        assignedStaffs: const [],
        workOrderForm: null,
        hasIssue: false,
        issueNote: null,
        statusDate: const WorkOrderStatusDateModel(),
      );

  ApiResponse<List<WorkOrderModel>> makeListResponse(List<WorkOrderModel> list) =>
      ApiResponse(message: 'success', data: list);

  ApiResponseWithMeta<WorkOrderModel> makeSingleResponse(WorkOrderModel data) =>
      ApiResponseWithMeta(
        message: 'success',
        data: data,
        meta: const {
          'workOrderCapabilities': {
            'can_start': true,
            'can_complete': true,
            'can_fail': false,
            'can_recreate': false,
            'can_cancel': true,
          }
        },
      );

  // ═══════════════════════════════════════════════════════════════════════
  // getWorkOrders  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('getWorkOrders —', () {
    final model = makeWorkOrderModel();

    test('I1: returns cached list without calling remote when cache is valid and forceRefresh is false', () async {
      when(() => mockRemote.getWorkOrders())
          .thenAnswer((_) async => makeListResponse([model]));

      // Seed cache
      await repository.getWorkOrders(forceRefresh: false);
      verify(() => mockRemote.getWorkOrders()).called(1);
      clearInteractions(mockRemote);

      // Call again
      final result = await repository.getWorkOrders(forceRefresh: false);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('should succeed'),
        (list) => expect(list.length, 1),
      );
      verifyNever(() => mockRemote.getWorkOrders());
    });

    test('I2: calls remote, returns Right(data), and updates cache when cache is empty', () async {
      when(() => mockRemote.getWorkOrders())
          .thenAnswer((_) async => makeListResponse([model]));

      final result = await repository.getWorkOrders(forceRefresh: false);

      expect(result.isRight(), isTrue);
      verify(() => mockRemote.getWorkOrders()).called(1);
    });

    test('I3: calls remote even if cache is seeded when forceRefresh is true', () async {
      when(() => mockRemote.getWorkOrders())
          .thenAnswer((_) async => makeListResponse([model]));

      await repository.getWorkOrders(forceRefresh: false);
      clearInteractions(mockRemote);

      final result = await repository.getWorkOrders(forceRefresh: true);

      expect(result.isRight(), isTrue);
      verify(() => mockRemote.getWorkOrders()).called(1);
    });

    test('I4: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemote.getWorkOrders())
          .thenThrow(ApiException(500, 'Server Error'));

      final result = await repository.getWorkOrders(forceRefresh: true);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('should fail'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getWorkOrderById  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('getWorkOrderById —', () {
    const id = 'wo-123';
    final model = makeWorkOrderModel(id: id);

    test('I5: returns Right(Result<WorkOrderEntity>) with parsed metadata on success', () async {
      when(() => mockRemote.getWorkOrderById(id))
          .thenAnswer((_) async => makeSingleResponse(model));

      final result = await repository.getWorkOrderById(id);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('should succeed'),
        (res) {
          expect(res.data.id, id);
          final capabilities = res.meta[WorkOrderCapabilities] as WorkOrderCapabilities;
          expect(capabilities.canStart, isTrue);
          expect(capabilities.canCancel, isTrue);
        },
      );
    });

    test('I6: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemote.getWorkOrderById(id))
          .thenThrow(ApiException(404, 'Not Found'));

      final result = await repository.getWorkOrderById(id);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('should fail'),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // createWorkOrder  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('createWorkOrder —', () {
    const serviceId = 'srv-123';
    final model = makeWorkOrderModel();

    test('I7: returns Right(Result<WorkOrderEntity>), clears cache, and emits cacheChanged event on success', () async {
      when(() => mockRemote.getWorkOrders())
          .thenAnswer((_) async => makeListResponse([model]));
      when(() => mockRemote.createWorkOrder(serviceId))
          .thenAnswer((_) async => makeSingleResponse(model));

      // Seed cache
      await repository.getWorkOrders(forceRefresh: false);
      clearInteractions(mockRemote);

      final expectation = expectLater(repository.cacheChanged, emits(null));

      final result = await repository.createWorkOrder(serviceId);

      expect(result.isRight(), isTrue);
      await expectation;

      // Verify cache cleared by confirming subsequent get hits remote
      await repository.getWorkOrders(forceRefresh: false);
      verify(() => mockRemote.getWorkOrders()).called(1);
    });

    test('I8: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemote.createWorkOrder(serviceId))
          .thenThrow(ApiException(500, 'Server Error'));

      final result = await repository.createWorkOrder(serviceId);

      expect(result.isLeft(), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // approveWorkOrder  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('approveWorkOrder —', () {
    const id = 'wo-123';
    final model = makeWorkOrderModel(id: id, status: WorkOrderStatus.approved);

    test('I9: returns Right(Result<WorkOrderEntity>), updates cache, and emits cacheChanged event on success', () async {
      when(() => mockRemote.getWorkOrders())
          .thenAnswer((_) async => makeListResponse([makeWorkOrderModel(id: id)]));
      when(() => mockRemote.approveWorkOrder(id))
          .thenAnswer((_) async => makeSingleResponse(model));

      // Seed cache
      await repository.getWorkOrders(forceRefresh: false);
      clearInteractions(mockRemote);

      final expectation = expectLater(repository.cacheChanged, emits(null));

      final result = await repository.approveWorkOrder(id);

      expect(result.isRight(), isTrue);
      await expectation;

      // Verify cache updated (no remote hit, but returns approved status)
      final getResult = await repository.getWorkOrders(forceRefresh: false);
      getResult.fold(
        (_) => fail('should succeed'),
        (list) => expect(list[0].status, WorkOrderStatus.approved),
      );
      verifyNever(() => mockRemote.getWorkOrders());
    });

    test('I10: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemote.approveWorkOrder(id))
          .thenThrow(ApiException(400, 'Bad Request'));

      final result = await repository.approveWorkOrder(id);

      expect(result.isLeft(), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // rejectWorkOrder  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('rejectWorkOrder —', () {
    const id = 'wo-123';
    const issue = 'Too expensive';
    final model = makeWorkOrderModel(id: id, status: WorkOrderStatus.rejected);

    test('I11: returns Right(Result<WorkOrderEntity>) on success', () async {
      when(() => mockRemote.rejectWorkOrder(id, issue))
          .thenAnswer((_) async => makeSingleResponse(model));

      final result = await repository.rejectWorkOrder(id, issue);

      expect(result.isRight(), isTrue);
    });

    test('I12: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemote.rejectWorkOrder(id, issue))
          .thenThrow(ApiException(400, 'Bad Request'));

      final result = await repository.rejectWorkOrder(id, issue);

      expect(result.isLeft(), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // cancelWorkOrder  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('cancelWorkOrder —', () {
    const id = 'wo-123';
    final model = makeWorkOrderModel(id: id, status: WorkOrderStatus.cancelled);

    test('I13: returns Right(Result<WorkOrderEntity>), clears cache, and emits cacheChanged event on success', () async {
      when(() => mockRemote.getWorkOrders())
          .thenAnswer((_) async => makeListResponse([makeWorkOrderModel(id: id)]));
      when(() => mockRemote.cancelWorkOrder(id))
          .thenAnswer((_) async => makeSingleResponse(model));

      await repository.getWorkOrders(forceRefresh: false);
      clearInteractions(mockRemote);

      final expectation = expectLater(repository.cacheChanged, emits(null));

      final result = await repository.cancelWorkOrder(id);

      expect(result.isRight(), isTrue);
      await expectation;

      // Verify cache cleared
      await repository.getWorkOrders(forceRefresh: false);
      verify(() => mockRemote.getWorkOrders()).called(1);
    });

    test('I14: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemote.cancelWorkOrder(id))
          .thenThrow(ApiException(400, 'Bad Request'));

      final result = await repository.cancelWorkOrder(id);

      expect(result.isLeft(), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // recreateWorkOrder  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('recreateWorkOrder —', () {
    const id = 'wo-123';
    final model = makeWorkOrderModel(id: id);

    test('I15: returns Right(Result<WorkOrderEntity>) on success', () async {
      when(() => mockRemote.recreateWorkOrder(id))
          .thenAnswer((_) async => makeSingleResponse(model));

      final result = await repository.recreateWorkOrder(id);

      expect(result.isRight(), isTrue);
    });

    test('I16: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemote.recreateWorkOrder(id))
          .thenThrow(ApiException(400, 'Bad Request'));

      final result = await repository.recreateWorkOrder(id);

      expect(result.isLeft(), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // sendWorkOrder  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('sendWorkOrder —', () {
    const id = 'wo-123';
    final model = makeWorkOrderModel(id: id, status: WorkOrderStatus.sent);

    test('I17: returns Right(Result<WorkOrderEntity>) on success', () async {
      when(() => mockRemote.sendWorkOrder(id))
          .thenAnswer((_) async => makeSingleResponse(model));

      final result = await repository.sendWorkOrder(id);

      expect(result.isRight(), isTrue);
    });

    test('I18: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemote.sendWorkOrder(id))
          .thenThrow(ApiException(400, 'Bad Request'));

      final result = await repository.sendWorkOrder(id);

      expect(result.isLeft(), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // startWorkOrder  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('startWorkOrder —', () {
    const id = 'wo-123';
    final model = makeWorkOrderModel(id: id, status: WorkOrderStatus.onProgress);

    test('I19: returns Right(Result<WorkOrderEntity>) on success', () async {
      when(() => mockRemote.startWorkOrder(id))
          .thenAnswer((_) async => makeSingleResponse(model));

      final result = await repository.startWorkOrder(id);

      expect(result.isRight(), isTrue);
    });

    test('I20: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemote.startWorkOrder(id))
          .thenThrow(ApiException(400, 'Bad Request'));

      final result = await repository.startWorkOrder(id);

      expect(result.isLeft(), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // completeWorkOrder  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('completeWorkOrder —', () {
    const id = 'wo-123';
    const issue = 'Minor clean up';
    final model = makeWorkOrderModel(id: id, status: WorkOrderStatus.completed);

    test('I21: returns Right(Result<WorkOrderEntity>) on success', () async {
      when(() => mockRemote.completeWorkOrder(id, issue))
          .thenAnswer((_) async => makeSingleResponse(model));

      final result = await repository.completeWorkOrder(id, issue);

      expect(result.isRight(), isTrue);
    });

    test('I22: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemote.completeWorkOrder(id, issue))
          .thenThrow(ApiException(400, 'Bad Request'));

      final result = await repository.completeWorkOrder(id, issue);

      expect(result.isLeft(), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // failWorkOrder  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('failWorkOrder —', () {
    const id = 'wo-123';
    const issue = 'Explosion';
    final model = makeWorkOrderModel(id: id, status: WorkOrderStatus.failed);

    test('I23: returns Right(Result<WorkOrderEntity>) on success', () async {
      when(() => mockRemote.failWorkOrder(id, issue))
          .thenAnswer((_) async => makeSingleResponse(model));

      final result = await repository.failWorkOrder(id, issue);

      expect(result.isRight(), isTrue);
    });

    test('I24: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemote.failWorkOrder(id, issue))
          .thenThrow(ApiException(400, 'Bad Request'));

      final result = await repository.failWorkOrder(id, issue);

      expect(result.isLeft(), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // assignStaffs  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('assignStaffs —', () {
    const id = 'wo-123';
    final draft = AssignedStaffsDraft(assignedStaffs: const []);
    final model = makeWorkOrderModel(id: id);

    test('I25: returns Right(Result<WorkOrderEntity>) on success', () async {
      when(() => mockRemote.assignStaffs(id, any()))
          .thenAnswer((_) async => makeSingleResponse(model));

      final result = await repository.assignStaffs(id, draft);

      expect(result.isRight(), isTrue);
    });

    test('I26: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemote.assignStaffs(id, any()))
          .thenThrow(ApiException(422, 'Unprocessable'));

      final result = await repository.assignStaffs(id, draft);

      expect(result.isLeft(), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // submitWorkOrderSubmission  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('submitWorkOrderSubmission —', () {
    const id = 'wo-123';
    final submission = SubmissionEntity(
      id: 'sub-123',
      formId: 'form-123',
      submissionType: FormType.workOrder,
      fieldsData: const [],
      createdAt: DateTime(2026, 6, 12),
    );
    final model = makeWorkOrderModel(id: id);

    test('I27: returns Right(Result<WorkOrderEntity>) on success', () async {
      when(() => mockRemote.submitWorkOrderSubmission(id, any()))
          .thenAnswer((_) async => makeSingleResponse(model));

      final result = await repository.submitWorkOrderSubmission(id, submission);

      expect(result.isRight(), isTrue);
    });

    test('I28: returns Left(ServerFailure) when remote fails', () async {
      when(() => mockRemote.submitWorkOrderSubmission(id, any()))
          .thenThrow(ApiException(422, 'Unprocessable'));

      final result = await repository.submitWorkOrderSubmission(id, submission);

      expect(result.isLeft(), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // clearCache  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('clearCache —', () {
    final model = makeWorkOrderModel();
    test('I29: clears cache causing subsequent getWorkOrders to hit remote', () async {
      when(() => mockRemote.getWorkOrders())
          .thenAnswer((_) async => makeListResponse([model]));

      await repository.getWorkOrders(forceRefresh: false);
      verify(() => mockRemote.getWorkOrders()).called(1);
      clearInteractions(mockRemote);

      repository.clearCache();

      await repository.getWorkOrders(forceRefresh: false);
      verify(() => mockRemote.getWorkOrders()).called(1);
    });
  });
}
