import 'package:flutter_test/flutter_test.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/forms/domain/entities/filled_form_with_history_entity.dart';
import 'package:workorder_company_app/features/work_order/data/model/work_order_model.dart';
import 'package:workorder_company_app/features/work_order/data/model/work_order_status_date_model.dart';

void main() {
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

  Map<String, dynamic> formJson() => {
        '_id': 'form-123',
        'title': 'Work Order Intake Form',
        'formType': 'work_order',
        'description': 'Regular intake',
        'position': null,
        'fields': const <dynamic>[],
      };

  Map<String, dynamic> submissionJson() => {
        '_id': 'sub-123',
        'formId': 'form-123',
        'submissionType': 'work_order',
        'fieldsData': const <dynamic>[],
        'createdAt': '2026-06-12T03:37:03Z',
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

  Map<String, dynamic> workOrderJson({
    bool includeForm = true,
  }) =>
      {
        '_id': 'wo-123',
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
          userJson(role: 'staff_company', id: 'uid-staff-2'),
        ],
        'workOrderForm': includeForm ? formJson() : null,
        'submissions': includeForm ? [submissionJson()] : null,
        'has_issue': false,
        'issue_note': null,
        ...workOrderStatusDateJson(),
      };

  // ═══════════════════════════════════════════════════════════════════════
  // WorkOrderStatusDateModel Tests
  // ═══════════════════════════════════════════════════════════════════════
  group('WorkOrderStatusDateModel —', () {
    /// M1: fromJson parses dates correctly.
    test('M1: fromJson parses all dates correctly', () {
      final json = workOrderStatusDateJson();
      final model = WorkOrderStatusDateModel.fromJson(json);

      expect(model.createdAt, DateTime.parse('2026-06-12T03:37:03Z'));
      expect(model.updatedAt, DateTime.parse('2026-06-12T03:40:03Z'));
      expect(model.sentAt, DateTime.parse('2026-06-12T03:45:03Z'));
      expect(model.approvedAt, DateTime.parse('2026-06-12T04:37:03Z'));
      expect(model.rejectedAt, isNull);
      expect(model.startedAt, isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // WorkOrderModel Tests
  // ═══════════════════════════════════════════════════════════════════════
  group('WorkOrderModel —', () {
    /// M2: fromJson maps all fields including workOrderForm (Ternary Branch = true)
    test('M2: fromJson parses all fields with workOrderForm and submissions', () {
      final json = workOrderJson(includeForm: true);
      final model = WorkOrderModel.fromJson(json);

      expect(model.id, 'wo-123');
      expect(model.code, 'WO-CODE-001');
      expect(model.configId, 'cfg-123');
      expect(model.service.id, 'srv-123');
      expect(model.positionOnDuty.id, 'pos-123');
      expect(model.serviceRequestId, 'sr-123');
      expect(model.createdBy!.userId, 'uid-123');
      expect(model.approvedBy!.userId, 'uid-123');
      expect(model.approvalAccess, WorkOrderAprrovalAccess.auto);
      expect(model.minStaff, 1);
      expect(model.maxStaff, 3);
      expect(model.status, WorkOrderStatus.sent);
      expect(model.staffPic!.userId, 'uid-123');
      expect(model.assignedStaffs.length, 2);
      expect(model.assignedStaffs[0].userId, 'uid-staff-1');
      expect(model.workOrderForm, isNotNull);
      expect(model.workOrderForm!.form.id, 'form-123');
      expect(model.workOrderForm!.history.length, 1);
      expect(model.workOrderForm!.history[0].id, 'sub-123');
      expect(model.hasIssue, isFalse);
      expect(model.issueNote, isNull);
      expect(model.statusDate.createdAt, DateTime.parse('2026-06-12T03:37:03Z'));
    });

    /// M3: fromJson maps all fields with null workOrderForm (Ternary Branch = false)
    test('M3: fromJson parses correctly when workOrderForm is null', () {
      final json = workOrderJson(includeForm: false);
      final model = WorkOrderModel.fromJson(json);

      expect(model.workOrderForm, isNull);
    });
  });
}
