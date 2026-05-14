import 'package:faker/faker.dart';
import 'package:workorder_company_app/core/constants/app_enums/service_enum.dart';
import 'package:workorder_company_app/core/model/mock_factory.dart';
import 'package:workorder_company_app/features/forms/data/mock/forms_mock_factory.dart';
import 'package:workorder_company_app/features/positions/data/mock/position_mock_factory.dart';
import 'package:workorder_company_app/features/services/data/model/service_model.dart';
import 'package:workorder_company_app/features/services/data/model/service_request_config_model.dart';
import 'package:workorder_company_app/features/services/data/model/service_summary_model.dart';
import 'package:workorder_company_app/features/services/data/model/work_order_config_model.dart';

class ServiceSummaryMockFactory extends MockFactory<ServiceSummaryModel> {
  @override
  Map<String, dynamic> createJson() {
    final accessType = faker.randomGenerator.element(ServiceAccessType.values);
    final workOrderMock = WorkOrderConfigMockFactory();

    final generatedFields = List.generate(
      faker.randomGenerator.integer(5) + 1,
      (_) => workOrderMock.createJson(),
    );

    return {
      "_id": faker.guid.guid(),
      "title": faker.conference.name(),
      "description": faker.lorem.sentence(),
      "accessType": accessType.toSnakeCase(),
      "isActive": faker.randomGenerator.boolean(),
      "serviceRequestConfig": ServiceRequestConfigMockFactory().createJson(),
      "workOrdersConfig": generatedFields,
    };
  }

  @override
  List<ServiceSummaryModel> createList({int count = 10}) {
    return List.generate(count, (_) => createModel());
  }

  @override
  createModel() {
    return ServiceSummaryModel.fromJson(createJson());
  }
}

class ServiceMockFactory extends MockFactory<ServiceModel> {
  @override
  Map<String, dynamic> createJson() {
    final accessType = faker.randomGenerator.element(ServiceAccessType.values);
    final draftingType =
        faker.randomGenerator.element(WorkOrderDraftingType.values);
    final workOrderMock = WorkOrderConfigMockFactory();

    final generatedFields = List.generate(
      faker.randomGenerator.integer(5) + 1,
      (_) => workOrderMock.createJson(),
    );

    return {
      "_id": faker.guid.guid(),
      "title": faker.conference.name(),
      "description": faker.lorem.sentence(),
      "accessType": accessType.toSnakeCase(),
      "isActive": faker.randomGenerator.boolean(),
      "serviceRequestConfig": ServiceRequestConfigMockFactory().createJson(),
      "workOrdersConfig": generatedFields,
      "draftingWorkOrderType": draftingType.toSnakeCase()
    };
  }

  @override
  List<ServiceModel> createList({int count = 10}) {
    return List.generate(count, (_) => createModel());
  }

  @override
  createModel() {
    return ServiceModel.fromJson(createJson());
  }
}

class ServiceRequestConfigMockFactory extends MockFactory {
  @override
  Map<String, dynamic> createJson() {
    final formMock = FormsMockFactory();
    final accessType =
        faker.randomGenerator.element(ServiceRequestApprovalAccess.values);

    return {
      "intakeForm": formMock.createJson(),
      "reviewForm": formMock.createJson(),
      "serviceRequestApprovalAccessType": accessType.toSnakeCase(),
      "reviewNeed": faker.randomGenerator.boolean(),
    };
  }

  @override
  List createList({int count = 10}) {
    return List.generate(count, (_) => createModel());
  }

  @override
  createModel() {
    ServiceRequestConfigModel.fromJson(createJson());
  }
}

class WorkOrderConfigMockFactory extends MockFactory {
  @override
  Map<String, dynamic> createJson() {
    final formMock = FormsMockFactory();
    final positionMock = PositionMockFactory();
    final woMockAppAcc =
        faker.randomGenerator.element(WorkOrderAprrovalAccess.values);
    final wrMockAppAcc =
        faker.randomGenerator.element(WorkReportApprovalAccess.values);

    final minStaff = faker.randomGenerator.integer(5);
    final maxStaff = minStaff + faker.randomGenerator.integer(5);

    return {
      "workOrderForm": formMock.createJson(),
      "workReportForm": formMock.createJson(),
      "positionsOnDuty": positionMock.createJson(),
      "workOrderApprovalAccessType": woMockAppAcc.toSnakeCase(),
      "workReportApprovalAccessType": wrMockAppAcc.toSnakeCase(),
      "minStaff": minStaff,
      "maxStaff": maxStaff,
      "showReportToRequester": faker.randomGenerator.boolean(),
    };
  }

  @override
  List createList({int count = 10}) {
    return List.generate(count, (_) => createModel());
  }

  @override
  createModel() {
    return WorkOrderConfigModel.fromJson(createJson());
  }
}
