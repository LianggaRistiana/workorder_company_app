import 'package:flutter_test/flutter_test.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/service_request/data/model/provider_service_request_model.dart';
import 'package:workorder_company_app/features/service_request/data/model/requester_service_request_model.dart';
import 'package:workorder_company_app/features/service_request/data/model/service_request_status_date_model.dart';

void main() {
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
        'name': ' PT Maju Bersama',
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

  Map<String, dynamic> formJson() => {
        '_id': 'form-123',
        'title': 'Intake Form',
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

  Map<String, dynamic> serviceRequestStatusDateJson() => {
        'createdAt': '2026-06-12T03:37:03Z',
        'approvedAt': '2026-06-12T04:37:03Z',
        'rejectedAt': null,
        'onProgressAt': null,
        'completedAt': null,
        'unprocessableAt': null,
        'closedAt': null,
        'cancelledAt': null,
        'partialCompletedAt': null,
      };

  Map<String, dynamic> providerServiceRequestJson({
    bool includeIntake = true,
    bool includeReview = true,
  }) =>
      {
        '_id': 'sr-123',
        'code': 'SR-CODE-001',
        'serviceRequestStatus': 'approved',
        'service': summaryJson(),
        'requestedBy': userJson(role: 'client'),
        'approvedBy': userJson(role: 'manager_company'),
        'reviewNeed': true,
        'serviceRequestApprovalAccessType': 'manager',
        'intakeForm': includeIntake ? formJson() : null,
        'intakeSubmission': includeIntake ? submissionJson() : null,
        'reviewForm': includeReview ? formJson() : null,
        'reviewSubmission': includeReview ? submissionJson() : null,
        ...serviceRequestStatusDateJson(),
      };

  Map<String, dynamic> requesterServiceRequestJson({
    bool includeIntake = true,
    bool includeReview = true,
  }) =>
      {
        '_id': 'sr-123',
        'code': 'SR-CODE-001',
        'serviceRequestStatus': 'approved',
        'service': summaryJson(),
        'requestedBy': userJson(role: 'client'),
        'approvedBy': userJson(role: 'manager_company'),
        'company': companyJson(),
        'intakeForm': includeIntake ? formJson() : null,
        'intakeSubmission': includeIntake ? submissionJson() : null,
        'reviewForm': includeReview ? formJson() : null,
        'reviewSubmission': includeReview ? submissionJson() : null,
        ...serviceRequestStatusDateJson(),
      };

  // ═══════════════════════════════════════════════════════════════════════
  // ServiceRequestStatusDateModel Tests
  // ═══════════════════════════════════════════════════════════════════════
  group('ServiceRequestStatusDateModel —', () {
    /// M1: fromJson parses dates correctly.
    test('M1: fromJson parses all dates correctly', () {
      final json = serviceRequestStatusDateJson();
      final model = ServiceRequestStatusDateModel.fromJson(json);

      expect(model.createdAt, DateTime.parse('2026-06-12T03:37:03Z'));
      expect(model.approvedAt, DateTime.parse('2026-06-12T04:37:03Z'));
      expect(model.rejectedAt, isNull);
      expect(model.onProgressAt, isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // ProviderServiceRequestModel Tests
  // ═══════════════════════════════════════════════════════════════════════
  group('ProviderServiceRequestModel —', () {
    /// M2: fromJson maps all fields including intake/review forms (Ternary Branch = true)
    test('M2: fromJson parses all fields with intake and review forms', () {
      final json = providerServiceRequestJson(includeIntake: true, includeReview: true);
      final model = ProviderServiceRequestModel.fromJson(json);

      expect(model.id, 'sr-123');
      expect(model.code, 'SR-CODE-001');
      expect(model.status, ServiceRequestStatus.approved);
      expect(model.service.id, 'srv-123');
      expect(model.requestedBy.userId, 'uid-123');
      expect(model.approvedBy!.userId, 'uid-123');
      expect(model.reviewNeed, isTrue);
      expect(model.approvalAccess, ServiceRequestApprovalAccess.manager);
      expect(model.intakeForm, isNotNull);
      expect(model.intakeForm!.form.id, 'form-123');
      expect(model.intakeForm!.submission!.id, 'sub-123');
      expect(model.reviewForm, isNotNull);
      expect(model.reviewForm!.form.id, 'form-123');
      expect(model.reviewForm!.submission!.id, 'sub-123');
      expect(model.statusDate.createdAt, DateTime.parse('2026-06-12T03:37:03Z'));
    });

    /// M3: fromJson maps all fields with null intake/review forms (Ternary Branch = false)
    test('M3: fromJson parses correctly when intake and review forms are null', () {
      final json = providerServiceRequestJson(includeIntake: false, includeReview: false);
      final model = ProviderServiceRequestModel.fromJson(json);

      expect(model.intakeForm, isNull);
      expect(model.reviewForm, isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // RequesterServiceRequestModel Tests
  // ═══════════════════════════════════════════════════════════════════════
  group('RequesterServiceRequestModel —', () {
    /// M4: fromJson maps all fields including intake/review forms (Ternary Branch = true)
    test('M4: fromJson parses all fields with intake and review forms', () {
      final json = requesterServiceRequestJson(includeIntake: true, includeReview: true);
      final model = RequesterServiceRequestModel.fromJson(json);

      expect(model.id, 'sr-123');
      expect(model.code, 'SR-CODE-001');
      expect(model.status, ServiceRequestStatus.approved);
      expect(model.service.id, 'srv-123');
      expect(model.requestedBy.userId, 'uid-123');
      expect(model.approvedBy!.userId, 'uid-123');
      expect(model.company.id, 'co-123');
      expect(model.intakeForm, isNotNull);
      expect(model.intakeForm!.form.id, 'form-123');
      expect(model.intakeForm!.submission!.id, 'sub-123');
      expect(model.reviewForm, isNotNull);
      expect(model.reviewForm!.form.id, 'form-123');
      expect(model.reviewForm!.submission!.id, 'sub-123');
      expect(model.statusDate.createdAt, DateTime.parse('2026-06-12T03:37:03Z'));
    });

    /// M5: fromJson maps all fields with null intake/review forms (Ternary Branch = false)
    test('M5: fromJson parses correctly when intake and review forms are null', () {
      final json = requesterServiceRequestJson(includeIntake: false, includeReview: false);
      final model = RequesterServiceRequestModel.fromJson(json);

      expect(model.intakeForm, isNull);
      expect(model.reviewForm, isNull);
    });
  });
}
