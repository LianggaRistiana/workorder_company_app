import 'package:flutter_test/flutter_test.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/forms/domain/entities/filled_form_with_history_entity.dart';
import 'package:workorder_company_app/features/work_report/data/model/work_report_model.dart';
import 'package:workorder_company_app/features/work_report/data/model/work_report_status_date_model.dart';

void main() {
  // ── Helpers / Fixtures ──────────────────────────────────────────────────
  Map<String, dynamic> userJson({String id = 'uid-123', String role = 'client'}) => {
        '_id': id,
        'name': 'John Doe',
        'email': 'john@example.com',
        'role': role,
        'position': null,
      };

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
        'approvedAt': '2026-06-12T04:37:03Z',
        'rejectedAt': null,
      };

  Map<String, dynamic> workReportJson({
    bool includeApprovedBy = true,
  }) =>
      {
        '_id': 'wr-123',
        'workOrderId': 'wo-123',
        'show_report_to_requester': true,
        'reportFormDetail': formJson(),
        'submissions': [submissionJson()],
        'workReportApprovalAccessType': 'manager',
        'status': 'approved',
        'approvedBy': includeApprovedBy ? userJson(role: 'manager_company') : null,
        ...workReportStatusDateJson(),
      };

  // ═══════════════════════════════════════════════════════════════════════
  // WorkReportStatusDateModel Tests
  // ═══════════════════════════════════════════════════════════════════════
  group('WorkReportStatusDateModel —', () {
    /// M1: fromJson parses dates correctly.
    test('M1: fromJson parses all dates correctly', () {
      final json = workReportStatusDateJson();
      final model = WorkReportStatusDateModel.fromJson(json);

      expect(model.createdAt, DateTime.parse('2026-06-12T03:37:03Z'));
      expect(model.sentAt, DateTime.parse('2026-06-12T03:45:03Z'));
      expect(model.approvedAt, DateTime.parse('2026-06-12T04:37:03Z'));
      expect(model.rejectedAt, isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // WorkReportModel Tests
  // ═══════════════════════════════════════════════════════════════════════
  group('WorkReportModel —', () {
    /// M2: fromJson maps all fields including approvedBy
    test('M2: fromJson parses all fields with approvedBy', () {
      final json = workReportJson(includeApprovedBy: true);
      final model = WorkReportModel.fromJson(json);

      expect(model.id, 'wr-123');
      expect(model.workOrderId, 'wo-123');
      expect(model.showReportToRequester, isTrue);
      expect(model.workReportForm.form.id, 'form-123');
      expect(model.workReportForm.history.length, 1);
      expect(model.workReportForm.history[0].id, 'sub-123');
      expect(model.approvalAccess, WorkReportApprovalAccess.manager);
      expect(model.status, WorkReportStatus.approved);
      expect(model.approvedBy!.userId, 'uid-123');
      expect(model.statusDate.createdAt, DateTime.parse('2026-06-12T03:37:03Z'));
    });

    /// M3: fromJson maps correctly when approvedBy is null
    test('M3: fromJson parses correctly when approvedBy is null', () {
      final json = workReportJson(includeApprovedBy: false);
      final model = WorkReportModel.fromJson(json);

      expect(model.approvedBy, isNull);
    });
  });
}
