import 'package:flutter_test/flutter_test.dart';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/positions/data/models/position_model.dart';
import 'package:workorder_company_app/features/services/data/model/service_model.dart';
import 'package:workorder_company_app/features/services/data/model/service_request_config_model.dart';
import 'package:workorder_company_app/features/services/data/model/service_summary_model.dart';
import 'package:workorder_company_app/features/services/data/model/work_order_config_model.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_request_config_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/work_order_config_entity.dart';

void main() {
  // ── Helpers / Fixtures ──────────────────────────────────────────────────
  FormModel makeFormModel({String id = 'form-123', String title = 'Form Title'}) {
    return FormModel(
      id: id,
      title: title,
      formType: FormType.workOrder,
      description: 'Test description',
      position: null,
      fields: const [],
    );
  }

  PositionModel makePositionModel({String id = 'pos-123', String name = 'Tech'}) {
    return PositionModel(
      id: id,
      name: name,
      description: 'Test position',
      isActive: true,
    );
  }

  Map<String, dynamic> formJson({String id = 'form-123'}) => {
        '_id': id,
        'title': 'Form Title',
        'formType': 'work_order',
        'description': 'Test description',
        'position': null,
        'fields': const <dynamic>[],
      };

  Map<String, dynamic> positionJson({String id = 'pos-123'}) => {
        '_id': id,
        'name': 'Tech',
        'description': 'Test position',
        'isActive': true,
      };

  // ═══════════════════════════════════════════════════════════════════════
  // ServiceSummaryModel Tests
  // ═══════════════════════════════════════════════════════════════════════
  group('ServiceSummaryModel —', () {
    /// M1: fromJson parses all fields correctly.
    test('M1: fromJson parses all fields correctly', () {
      final json = {
        '_id': 'srv-summary-123',
        'title': 'AC Service',
        'description': 'Regular maintenance',
        'accessType': 'public',
        'isActive': true,
        'price': 150000,
      };

      final model = ServiceSummaryModel.fromJson(json);

      expect(model.id, 'srv-summary-123');
      expect(model.title, 'AC Service');
      expect(model.description, 'Regular maintenance');
      expect(model.accessType, ServiceAccessType.public);
      expect(model.isActive, isTrue);
      expect(model.price, 150000);
    });

    /// M2: toEntity maps fields correctly.
    test('M2: toEntity maps fields correctly', () {
      const model = ServiceSummaryModel(
        id: 'srv-summary-123',
        title: 'AC Service',
        description: 'Regular maintenance',
        accessType: ServiceAccessType.public,
        isActive: true,
        price: 150000,
      );

      final entity = model.toEntity();

      expect(entity.id, model.id);
      expect(entity.title, model.title);
      expect(entity.description, model.description);
      expect(entity.accessType, model.accessType);
      expect(entity.isActive, model.isActive);
      expect(entity.price, model.price);
    });

    /// M3: fromServiceEntity maps fields correctly.
    test('M3: fromServiceEntity maps fields correctly', () {
      final serviceEntity = ServiceEntity(
        id: 'srv-123',
        title: 'AC Repair',
        description: 'Fixing AC units',
        accessType: ServiceAccessType.public,
        isActive: true,
        price: 250000,
        workOrderDraftingType: WorkOrderDraftingType.manual,
        serviceRequestConfig: ServiceRequestConfigEntity(
          intakeForm: makeFormModel(id: 'form-intake'),
          reviewForm: makeFormModel(id: 'form-review'),
          serviceRequestApprovalAccessType: ServiceRequestApprovalAccess.manager,
          reviewNeed: true,
        ),
        workOrdersConfig: [
          WorkOrderConfigEntity(
            workOrderForm: makeFormModel(id: 'form-wo'),
            workReportForm: makeFormModel(id: 'form-wr'),
            positionOnDuty: makePositionModel(),
            workOrderAprrovalAccessType: WorkOrderAprrovalAccess.staffPic,
            workReportApprovalAccessType: WorkReportApprovalAccess.manager,
            minStaff: 1,
            maxStaff: 3,
            showReportToRequester: true,
          ),
        ],
      );

      final model = ServiceSummaryModel.fromServiceEntity(serviceEntity);

      expect(model.id, 'srv-123');
      expect(model.title, 'AC Repair');
      expect(model.description, 'Fixing AC units');
      expect(model.accessType, ServiceAccessType.public);
      expect(model.isActive, isTrue);
      expect(model.price, 250000);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // ServiceRequestConfigModel Tests
  // ═══════════════════════════════════════════════════════════════════════
  group('ServiceRequestConfigModel —', () {
    final intakeModel = makeFormModel(id: 'f-intake');
    final reviewModel = makeFormModel(id: 'f-review');

    /// M4: fromJson parses intakeForm, reviewForm, serviceRequestApprovalAccessType, and reviewNeed.
    test('M4: fromJson parses all fields correctly', () {
      final json = {
        'intakeForm': formJson(id: 'f-intake'),
        'reviewForm': formJson(id: 'f-review'),
        'serviceRequestApprovalAccessType': 'manager',
        'reviewNeed': true,
      };

      final model = ServiceRequestConfigModel.fromJson(json);

      expect(model.intakeForm.id, 'f-intake');
      expect(model.reviewForm.id, 'f-review');
      expect(model.serviceRequestApprovalAccessType, ServiceRequestApprovalAccess.manager);
      expect(model.reviewNeed, isTrue);
    });

    /// M5: fromJsonTemplate parses forms templates correctly.
    test('M5: fromJsonTemplate parses correctly', () {
      final json = {
        'intakeForm': formJson(id: 'f-intake'),
        'reviewForm': formJson(id: 'f-review'),
        'serviceRequestApprovalAccessType': 'manager',
        'reviewNeed': false,
      };

      final model = ServiceRequestConfigModel.fromJsonTemplate(json);

      expect(model.intakeForm.id, isNotEmpty);
      expect(model.reviewForm.id, isNotEmpty);
      expect(model.serviceRequestApprovalAccessType, ServiceRequestApprovalAccess.manager);
      expect(model.reviewNeed, isFalse);
    });

    /// M6: fromEntity maps fields correctly.
    test('M6: fromEntity maps fields correctly', () {
      final entity = ServiceRequestConfigEntity(
        intakeForm: intakeModel,
        reviewForm: reviewModel,
        serviceRequestApprovalAccessType: ServiceRequestApprovalAccess.manager,
        reviewNeed: true,
      );

      final model = ServiceRequestConfigModel.fromEntity(entity);

      expect(model.intakeForm, intakeModel);
      expect(model.reviewForm, reviewModel);
      expect(model.serviceRequestApprovalAccessType, ServiceRequestApprovalAccess.manager);
      expect(model.reviewNeed, isTrue);
    });

    /// M7: toJson serializes config correctly.
    test('M7: toJson serializes correctly', () {
      final model = ServiceRequestConfigModel(
        intakeForm: intakeModel,
        reviewForm: reviewModel,
        serviceRequestApprovalAccessType: ServiceRequestApprovalAccess.manager,
        reviewNeed: true,
      );

      final json = model.toJson();

      expect(json, {
        'intakeFormId': 'f-intake',
        'reviewFormId': 'f-review',
        'serviceRequestApprovalAccessType': 'manager',
        'reviewNeed': true,
      });
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // WorkOrderConfigModel Tests
  // ═══════════════════════════════════════════════════════════════════════
  group('WorkOrderConfigModel —', () {
    final woForm = makeFormModel(id: 'f-wo');
    final wrForm = makeFormModel(id: 'f-wr');
    final position = makePositionModel(id: 'p-duty');

    /// M8: fromJson parses forms, position, access type, staff sizes, and show report.
    test('M8: fromJson parses all fields correctly', () {
      final json = {
        'workOrderForm': formJson(id: 'f-wo'),
        'workReportForm': formJson(id: 'f-wr'),
        'positionsOnDuty': positionJson(id: 'p-duty'),
        'workOrderApprovalAccessType': 'staff_pic',
        'workReportApprovalAccessType': 'manager',
        'minStaff': 1,
        'maxStaff': 5,
        'showReportToRequester': true,
      };

      final model = WorkOrderConfigModel.fromJson(json);

      expect(model.workOrderForm!.id, 'f-wo');
      expect(model.workReportForm.id, 'f-wr');
      expect(model.positionOnDuty.id, 'p-duty');
      expect(model.workOrderAprrovalAccessType, WorkOrderAprrovalAccess.staffPic);
      expect(model.workReportApprovalAccessType, WorkReportApprovalAccess.manager);
      expect(model.minStaff, 1);
      expect(model.maxStaff, 5);
      expect(model.showReportToRequester, isTrue);
    });

    /// M9: fromJsonTemplate parses correctly.
    test('M9: fromJsonTemplate parses correctly', () {
      final json = {
        'workOrderForm': formJson(id: 'f-wo'),
        'workReportForm': formJson(id: 'f-wr'),
        'positionsOnDuty': positionJson(id: 'p-duty'),
        'workOrderApprovalAccessType': 'staff_pic',
        'workReportApprovalAccessType': 'manager',
        'minStaff': 2,
        'maxStaff': 4,
        'showReportToRequester': false,
      };

      final model = WorkOrderConfigModel.fromJsonTemplate(json);

      expect(model.workOrderForm!.id, isNotEmpty);
      expect(model.workReportForm.id, isNotEmpty);
      expect(model.positionOnDuty.id, isNotEmpty);
      expect(model.minStaff, 2);
      expect(model.maxStaff, 4);
      expect(model.showReportToRequester, isFalse);
    });

    /// M10: fromEntity maps all properties correctly.
    test('M10: fromEntity maps all fields correctly', () {
      final entity = WorkOrderConfigEntity(
        workOrderForm: woForm,
        workReportForm: wrForm,
        positionOnDuty: position,
        workOrderAprrovalAccessType: WorkOrderAprrovalAccess.staffPic,
        workReportApprovalAccessType: WorkReportApprovalAccess.manager,
        minStaff: 1,
        maxStaff: 5,
        showReportToRequester: true,
      );

      final model = WorkOrderConfigModel.fromEntity(entity);

      expect(model.workOrderForm, woForm);
      expect(model.workReportForm, wrForm);
      expect(model.positionOnDuty, position);
      expect(model.workOrderAprrovalAccessType, WorkOrderAprrovalAccess.staffPic);
      expect(model.workReportApprovalAccessType, WorkReportApprovalAccess.manager);
      expect(model.minStaff, 1);
      expect(model.maxStaff, 5);
      expect(model.showReportToRequester, isTrue);
    });

    /// M11: toJson serializes configurations correctly.
    test('M11: toJson serializes correctly', () {
      final model = WorkOrderConfigModel(
        workOrderForm: woForm,
        workReportForm: wrForm,
        positionOnDuty: position,
        workOrderAprrovalAccessType: WorkOrderAprrovalAccess.staffPic,
        workReportApprovalAccessType: WorkReportApprovalAccess.manager,
        minStaff: 1,
        maxStaff: 5,
        showReportToRequester: true,
      );

      final json = model.toJson();

      expect(json, {
        'workOrderFormId': 'f-wo',
        'workReportFormId': 'f-wr',
        'positionId': 'p-duty',
        'workOrderApprovalAccessType': 'staff_pic',
        'workReportApprovalAccessType': 'manager',
        'minStaff': 1,
        'maxStaff': 5,
        'showReportToRequester': true,
      });
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // ServiceModel Tests
  // ═══════════════════════════════════════════════════════════════════════
  group('ServiceModel —', () {
    final intakeModel = makeFormModel(id: 'f-intake');
    final reviewModel = makeFormModel(id: 'f-review');
    final srvReqConfig = ServiceRequestConfigModel(
      intakeForm: intakeModel,
      reviewForm: reviewModel,
      serviceRequestApprovalAccessType: ServiceRequestApprovalAccess.manager,
      reviewNeed: true,
    );

    final woConfig = WorkOrderConfigModel(
      workOrderForm: makeFormModel(id: 'f-wo'),
      workReportForm: makeFormModel(id: 'f-wr'),
      positionOnDuty: makePositionModel(),
      workOrderAprrovalAccessType: WorkOrderAprrovalAccess.staffPic,
      workReportApprovalAccessType: WorkReportApprovalAccess.manager,
      minStaff: 1,
      maxStaff: 3,
      showReportToRequester: true,
    );

    Map<String, dynamic> requestConfigJson() => {
          'intakeForm': formJson(id: 'f-intake'),
          'reviewForm': formJson(id: 'f-review'),
          'serviceRequestApprovalAccessType': 'manager',
          'reviewNeed': true,
        };

    Map<String, dynamic> woConfigJson() => {
          'workOrderForm': formJson(id: 'f-wo'),
          'workReportForm': formJson(id: 'f-wr'),
          'positionsOnDuty': positionJson(id: 'p-duty'),
          'workOrderApprovalAccessType': 'staff_pic',
          'workReportApprovalAccessType': 'manager',
          'minStaff': 1,
          'maxStaff': 3,
          'showReportToRequester': true,
        };

    /// M12: fromJson parses ServiceModel from JSON correctly.
    test('M12: fromJson parses all fields correctly', () {
      final json = {
        '_id': 'srv-123',
        'title': 'Plumbing',
        'description': 'Plumbing service',
        'accessType': 'public',
        'isActive': true,
        'serviceRequestConfig': requestConfigJson(),
        'draftingWorkOrderType': 'manual',
        'workOrdersConfig': [woConfigJson()],
        'price': 200000,
      };

      final model = ServiceModel.fromJson(json);

      expect(model.id, 'srv-123');
      expect(model.title, 'Plumbing');
      expect(model.description, 'Plumbing service');
      expect(model.accessType, ServiceAccessType.public);
      expect(model.isActive, isTrue);
      expect(model.serviceRequestConfig.intakeForm.id, 'f-intake');
      expect(model.workOrderDraftingType, WorkOrderDraftingType.manual);
      expect(model.workOrdersConfig.length, 1);
      expect(model.workOrdersConfig.first.minStaff, 1);
      expect(model.price, 200000);
    });

    /// M13: fromJsonTemplate parses correctly.
    test('M13: fromJsonTemplate parses correctly', () {
      final json = {
        'title': 'Plumbing Template',
        'description': 'Plumbing service template',
        'accessType': 'public',
        'isActive': true,
        'serviceRequestConfig': requestConfigJson(),
        'draftingWorkOrderType': 'manual',
        'workOrdersConfig': [woConfigJson()],
        'price': 200000,
      };

      final model = ServiceModel.fromJsonTemplate(json);

      expect(model.id, isNotEmpty);
      expect(model.title, 'Plumbing Template');
      expect(model.serviceRequestConfig.intakeForm.id, isNotEmpty);
      expect(model.workOrdersConfig.length, 1);
    });

    /// M14: fromEntity maps all properties correctly.
    test('M14: fromEntity maps all fields correctly', () {
      final entity = ServiceEntity(
        id: 'srv-123',
        title: 'Plumbing',
        description: 'Plumbing service',
        accessType: ServiceAccessType.public,
        isActive: true,
        serviceRequestConfig: srvReqConfig,
        workOrdersConfig: [woConfig],
        workOrderDraftingType: WorkOrderDraftingType.manual,
        price: 200000,
      );

      final model = ServiceModel.fromEntity(entity);

      expect(model.id, 'srv-123');
      expect(model.title, 'Plumbing');
      expect(model.serviceRequestConfig.intakeForm.id, 'f-intake');
      expect(model.workOrdersConfig.first.workOrderForm!.id, 'f-wo');
      expect(model.price, 200000);
    });

    /// M15: toJson serializes ServiceModel correctly.
    test('M15: toJson serializes correctly', () {
      final model = ServiceModel(
        id: 'srv-123',
        title: 'Plumbing',
        description: 'Plumbing service',
        accessType: ServiceAccessType.public,
        isActive: true,
        serviceRequestConfig: srvReqConfig,
        workOrdersConfig: [woConfig],
        workOrderDraftingType: WorkOrderDraftingType.manual,
        price: 200000,
      );

      final json = model.toJson();

      expect(json, {
        '_id': 'srv-123',
        'title': 'Plumbing',
        'description': 'Plumbing service',
        'accessType': 'public',
        'isActive': true,
        'draftingWorkOrderType': 'manual',
        'serviceRequestConfig': {
          'intakeFormId': 'f-intake',
          'reviewFormId': 'f-review',
          'serviceRequestApprovalAccessType': 'manager',
          'reviewNeed': true,
        },
        'workOrdersConfig': [
          {
            'workOrderFormId': 'f-wo',
            'workReportFormId': 'f-wr',
            'positionId': model.workOrdersConfig.first.positionOnDuty.id,
            'workOrderApprovalAccessType': 'staff_pic',
            'workReportApprovalAccessType': 'manager',
            'minStaff': 1,
            'maxStaff': 3,
            'showReportToRequester': true,
          }
        ],
      });
    });

    /// M16: toSummaryEntity maps correctly.
    test('M16: toSummaryEntity maps fields correctly', () {
      final model = ServiceModel(
        id: 'srv-123',
        title: 'Plumbing',
        description: 'Plumbing service',
        accessType: ServiceAccessType.public,
        isActive: true,
        serviceRequestConfig: srvReqConfig,
        workOrdersConfig: [woConfig],
        workOrderDraftingType: WorkOrderDraftingType.manual,
        price: 200000,
      );

      final summary = model.toSummaryEntity();

      expect(summary.id, 'srv-123');
      expect(summary.title, 'Plumbing');
      expect(summary.description, 'Plumbing service');
      expect(summary.accessType, ServiceAccessType.public);
      expect(summary.isActive, isTrue);
      expect(summary.price, 200000);
    });
  });
}
