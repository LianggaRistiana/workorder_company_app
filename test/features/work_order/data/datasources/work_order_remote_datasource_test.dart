import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workorder_company_app/core/error/error.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/constants/app_enums/form_enum.dart';
import 'package:workorder_company_app/core/services/network/api_client.dart';
import 'package:workorder_company_app/core/services/network/endpoints.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';
import 'package:workorder_company_app/features/work_order/data/datasources/work_order_remote_datasource.dart';
import 'package:workorder_company_app/features/work_order/domain/draft/assigned_staffs_draft.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late WorkOrderRemoteDatasourceImpl datasource;

  setUp(() {
    mockApiClient = MockApiClient();
    datasource = WorkOrderRemoteDatasourceImpl(mockApiClient);
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

  Map<String, dynamic> workOrderStatusDateJson() => {
        'createdAt': '2026-06-12T03:37:03Z',
        'updatedAt': '2026-06-12T03:40:03Z',
        'sentAt': '2026-06-12T03:45:03Z',
        'approvedAt': '2026-06-12T04:37:03Z',
        'rejectedAt': null,
        'startedAt': null,
        'completedAt': null,
        'cancelledAt': null,
        'failedAt': null,
      };

  Map<String, dynamic> workOrderJson({String id = 'wo-123'}) => {
        '_id': id,
        'code': 'WO-CODE-001',
        'configId': 'cfg-123',
        'service': serviceSummaryJson(),
        'positionsOnDuty': positionJson(),
        'serviceRequestId': 'sr-123',
        'createdBy': userJson(role: 'owner_company'),
        'approvedBy': userJson(role: 'manager_company'),
        'workOrderApprovalAccessType': 'auto',
        'minStaff': 1,
        'maxStaff': 3,
        'status': 'approved',
        'staffPIC': userJson(role: 'staff_company'),
        'assignedStaff': [
          userJson(role: 'staff_company', id: 'uid-staff-1'),
        ],
        'workOrderForm': null,
        'submissions': null,
        'has_issue': false,
        'issue_note': null,
        ...workOrderStatusDateJson(),
      };

  Map<String, dynamic> singleResponseJson({String id = 'wo-123'}) => {
        'message': 'success',
        'data': workOrderJson(id: id),
        'meta': <String, dynamic>{
          'workOrderCapabilities': {'canApprove': true},
        },
      };

  Map<String, dynamic> listResponseJson() => {
        'message': 'success',
        'data': [workOrderJson(id: 'wo-123'), workOrderJson(id: 'wo-456')],
      };

  // ═══════════════════════════════════════════════════════════════════════
  // getWorkOrders  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('getWorkOrders —', () {
    test('R1: returns ApiResponse<List<WorkOrderModel>> on success', () async {
      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => listResponseJson());

      final result = await datasource.getWorkOrders();

      expect(result.message, 'success');
      expect(result.data.length, 2);
      expect(result.data[0].id, 'wo-123');
    });

    test('R2: propagates ApiException when API client fails', () async {
      when(() => mockApiClient.get(any()))
          .thenThrow(ApiException(500, 'Internal Server Error'));

      expect(() => datasource.getWorkOrders(), throwsA(isA<ApiException>()));
    });

    test('R3: calls get with correct endpoint', () async {
      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => listResponseJson());

      await datasource.getWorkOrders();

      verify(() => mockApiClient.get(Endpoints.workorders)).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // getWorkOrderById  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('getWorkOrderById —', () {
    const id = 'wo-123';
    test('R4: returns ApiResponseWithMeta<WorkOrderModel> on success', () async {
      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => singleResponseJson(id: id));

      final result = await datasource.getWorkOrderById(id);

      expect(result.message, 'success');
      expect(result.data!.id, id);
      expect(result.meta!['workOrderCapabilities']['canApprove'], isTrue);
    });

    test('R5: propagates ApiException when API client fails', () async {
      when(() => mockApiClient.get(any()))
          .thenThrow(ApiException(404, 'Not Found'));

      expect(() => datasource.getWorkOrderById(id), throwsA(isA<ApiException>()));
    });

    test('R6: calls get with correct endpoint', () async {
      when(() => mockApiClient.get(any()))
          .thenAnswer((_) async => singleResponseJson(id: id));

      await datasource.getWorkOrderById(id);

      verify(() => mockApiClient.get(Endpoints.workorderDetail.fillId(id))).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // createWorkOrder  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('createWorkOrder —', () {
    const serviceId = 'srv-123';
    test('R7: returns ApiResponseWithMeta<WorkOrderModel> on success', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson());

      final result = await datasource.createWorkOrder(serviceId);

      expect(result.message, 'success');
      expect(result.data, isNotNull);
    });

    test('R8: propagates ApiException when API client fails', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenThrow(ApiException(400, 'Bad Request'));

      expect(() => datasource.createWorkOrder(serviceId), throwsA(isA<ApiException>()));
    });

    test('R9: calls post with correct endpoint', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson());

      await datasource.createWorkOrder(serviceId);

      verify(() => mockApiClient.post(Endpoints.workorderCreate.fillId(serviceId))).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // recreateWorkOrder  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('recreateWorkOrder —', () {
    const id = 'wo-123';
    test('R10: returns ApiResponseWithMeta<WorkOrderModel> on success', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson(id: id));

      final result = await datasource.recreateWorkOrder(id);

      expect(result.message, 'success');
      expect(result.data!.id, id);
    });

    test('R11: propagates ApiException when API client fails', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenThrow(ApiException(400, 'Bad Request'));

      expect(() => datasource.recreateWorkOrder(id), throwsA(isA<ApiException>()));
    });

    test('R12: calls post with correct endpoint', () async {
      when(() => mockApiClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson(id: id));

      await datasource.recreateWorkOrder(id);

      verify(() => mockApiClient.post(Endpoints.workorderRecreate.fillId(id))).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // submitWorkOrderSubmission  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('submitWorkOrderSubmission —', () {
    const id = 'wo-123';
    final submissions = SubmissionsModel(
      id: 'sub-123',
      formId: 'form-123',
      submissionType: FormType.workOrder,
      fieldsData: const [],
      createdAt: DateTime.parse('2026-06-12T03:37:03Z'),
    );

    test('R13: returns ApiResponseWithMeta<WorkOrderModel> on success', () async {
      when(() => mockApiClient.put(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson(id: id));

      final result = await datasource.submitWorkOrderSubmission(id, submissions);

      expect(result.message, 'success');
      expect(result.data!.id, id);
    });

    test('R14: propagates ApiException when API client fails', () async {
      when(() => mockApiClient.put(any(), data: any(named: 'data')))
          .thenThrow(ApiException(422, 'Unprocessable Entity'));

      expect(() => datasource.submitWorkOrderSubmission(id, submissions), throwsA(isA<ApiException>()));
    });

    test('R15: calls put with correct endpoint and payload', () async {
      when(() => mockApiClient.put(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson(id: id));

      await datasource.submitWorkOrderSubmission(id, submissions);

      verify(() => mockApiClient.put(
            Endpoints.workorderSetSubmissions.fillId(id),
            data: submissions.toJson(),
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // assignStaffs  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('assignStaffs —', () {
    const id = 'wo-123';
    final staffPic = UserModel.fromJson(userJson(id: 'uid-staff-1', role: 'staff_company'));
    final staffsDraft = AssignedStaffsDraft(
      staffPic: staffPic,
      assignedStaffs: [staffPic],
    );

    test('R16: returns ApiResponseWithMeta<WorkOrderModel> on success', () async {
      when(() => mockApiClient.put(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson(id: id));

      final result = await datasource.assignStaffs(id, staffsDraft);

      expect(result.message, 'success');
      expect(result.data!.id, id);
    });

    test('R17: propagates ApiException when API client fails', () async {
      when(() => mockApiClient.put(any(), data: any(named: 'data')))
          .thenThrow(ApiException(422, 'Unprocessable'));

      expect(() => datasource.assignStaffs(id, staffsDraft), throwsA(isA<ApiException>()));
    });

    test('R18: calls put with correct endpoint and payload', () async {
      when(() => mockApiClient.put(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson(id: id));

      await datasource.assignStaffs(id, staffsDraft);

      verify(() => mockApiClient.put(
            Endpoints.workorderSetAssignedStaff.fillId(id),
            data: staffsDraft.toJson(),
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // sendWorkOrder  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('sendWorkOrder —', () {
    const id = 'wo-123';
    test('R19: returns ApiResponseWithMeta<WorkOrderModel> on success', () async {
      when(() => mockApiClient.patch(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson(id: id));

      final result = await datasource.sendWorkOrder(id);

      expect(result.message, 'success');
      expect(result.data!.id, id);
    });

    test('R20: propagates ApiException when API client fails', () async {
      when(() => mockApiClient.patch(any(), data: any(named: 'data')))
          .thenThrow(ApiException(400, 'Bad Request'));

      expect(() => datasource.sendWorkOrder(id), throwsA(isA<ApiException>()));
    });

    test('R21: calls patch with correct endpoint', () async {
      when(() => mockApiClient.patch(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson(id: id));

      await datasource.sendWorkOrder(id);

      verify(() => mockApiClient.patch(Endpoints.workorderSent.fillId(id))).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // cancelWorkOrder  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('cancelWorkOrder —', () {
    const id = 'wo-123';
    test('R22: returns ApiResponseWithMeta<WorkOrderModel> on success', () async {
      when(() => mockApiClient.patch(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson(id: id));

      final result = await datasource.cancelWorkOrder(id);

      expect(result.message, 'success');
      expect(result.data!.id, id);
    });

    test('R23: propagates ApiException when API client fails', () async {
      when(() => mockApiClient.patch(any(), data: any(named: 'data')))
          .thenThrow(ApiException(400, 'Bad Request'));

      expect(() => datasource.cancelWorkOrder(id), throwsA(isA<ApiException>()));
    });

    test('R24: calls patch with correct endpoint', () async {
      when(() => mockApiClient.patch(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson(id: id));

      await datasource.cancelWorkOrder(id);

      verify(() => mockApiClient.patch(Endpoints.workorderCancel.fillId(id))).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // approveWorkOrder  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('approveWorkOrder —', () {
    const id = 'wo-123';
    test('R25: returns ApiResponseWithMeta<WorkOrderModel> on success', () async {
      when(() => mockApiClient.patch(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson(id: id));

      final result = await datasource.approveWorkOrder(id);

      expect(result.message, 'success');
      expect(result.data!.id, id);
    });

    test('R26: propagates ApiException when API client fails', () async {
      when(() => mockApiClient.patch(any(), data: any(named: 'data')))
          .thenThrow(ApiException(400, 'Bad Request'));

      expect(() => datasource.approveWorkOrder(id), throwsA(isA<ApiException>()));
    });

    test('R27: calls patch with correct endpoint', () async {
      when(() => mockApiClient.patch(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson(id: id));

      await datasource.approveWorkOrder(id);

      verify(() => mockApiClient.patch(Endpoints.workorderApprove.fillId(id))).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // rejectWorkOrder  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('rejectWorkOrder —', () {
    const id = 'wo-123';
    const issueNote = 'Lack of materials';

    test('R28: returns ApiResponseWithMeta<WorkOrderModel> on success', () async {
      when(() => mockApiClient.patch(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson(id: id));

      final result = await datasource.rejectWorkOrder(id, issueNote);

      expect(result.message, 'success');
      expect(result.data!.id, id);
    });

    test('R29: propagates ApiException when API client fails', () async {
      when(() => mockApiClient.patch(any(), data: any(named: 'data')))
          .thenThrow(ApiException(400, 'Bad Request'));

      expect(() => datasource.rejectWorkOrder(id, issueNote), throwsA(isA<ApiException>()));
    });

    test('R30: calls patch with correct endpoint and payload', () async {
      when(() => mockApiClient.patch(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson(id: id));

      await datasource.rejectWorkOrder(id, issueNote);

      verify(() => mockApiClient.patch(
            Endpoints.workorderReject.fillId(id),
            data: {"issue": issueNote},
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // startWorkOrder  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('startWorkOrder —', () {
    const id = 'wo-123';
    test('R31: returns ApiResponseWithMeta<WorkOrderModel> on success', () async {
      when(() => mockApiClient.patch(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson(id: id));

      final result = await datasource.startWorkOrder(id);

      expect(result.message, 'success');
      expect(result.data!.id, id);
    });

    test('R32: propagates ApiException when API client fails', () async {
      when(() => mockApiClient.patch(any(), data: any(named: 'data')))
          .thenThrow(ApiException(400, 'Bad Request'));

      expect(() => datasource.startWorkOrder(id), throwsA(isA<ApiException>()));
    });

    test('R33: calls patch with correct endpoint', () async {
      when(() => mockApiClient.patch(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson(id: id));

      await datasource.startWorkOrder(id);

      verify(() => mockApiClient.patch(Endpoints.workorderStart.fillId(id))).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // completeWorkOrder  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('completeWorkOrder —', () {
    const id = 'wo-123';
    const issueNote = 'Completed with minor cleanup needed';

    test('R34: returns ApiResponseWithMeta<WorkOrderModel> on success', () async {
      when(() => mockApiClient.patch(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson(id: id));

      final result = await datasource.completeWorkOrder(id, issueNote);

      expect(result.message, 'success');
      expect(result.data!.id, id);
    });

    test('R35: propagates ApiException when API client fails', () async {
      when(() => mockApiClient.patch(any(), data: any(named: 'data')))
          .thenThrow(ApiException(400, 'Bad Request'));

      expect(() => datasource.completeWorkOrder(id, issueNote), throwsA(isA<ApiException>()));
    });

    test('R36: calls patch with correct endpoint and payload', () async {
      when(() => mockApiClient.patch(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson(id: id));

      await datasource.completeWorkOrder(id, issueNote);

      verify(() => mockApiClient.patch(
            Endpoints.workorderComplete.fillId(id),
            data: {"issue": issueNote},
          )).called(1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // failWorkOrder  │  Cyclomatic Complexity = 1
  // ═══════════════════════════════════════════════════════════════════════
  group('failWorkOrder —', () {
    const id = 'wo-123';
    const issueNote = 'Device exploded';

    test('R37: returns ApiResponseWithMeta<WorkOrderModel> on success', () async {
      when(() => mockApiClient.patch(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson(id: id));

      final result = await datasource.failWorkOrder(id, issueNote);

      expect(result.message, 'success');
      expect(result.data!.id, id);
    });

    test('R38: propagates ApiException when API client fails', () async {
      when(() => mockApiClient.patch(any(), data: any(named: 'data')))
          .thenThrow(ApiException(400, 'Bad Request'));

      expect(() => datasource.failWorkOrder(id, issueNote), throwsA(isA<ApiException>()));
    });

    test('R39: calls patch with correct endpoint and payload', () async {
      when(() => mockApiClient.patch(any(), data: any(named: 'data')))
          .thenAnswer((_) async => singleResponseJson(id: id));

      await datasource.failWorkOrder(id, issueNote);

      verify(() => mockApiClient.patch(
            Endpoints.workorderFail.fillId(id),
            data: {"issue": issueNote},
          )).called(1);
    });
  });
}
