import 'dart:async';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/error/exceptions.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/auth/data/model/user_model.dart';
import 'package:workorder_company_app/features/forms/data/model/filled_form_with_history_model.dart';
import 'package:workorder_company_app/features/forms/data/model/form_model.dart';
import 'package:workorder_company_app/features/forms/domain/entities/field_entity.dart';
import 'package:workorder_company_app/features/services/data/model/service_summary_model.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';
import 'package:workorder_company_app/features/work_order/data/datasources/work_order_remote_datasource.dart';
import 'package:workorder_company_app/features/work_order/data/model/work_order_model.dart';
import 'package:workorder_company_app/features/work_order/data/model/work_order_status_date_model.dart';
import 'package:workorder_company_app/features/work_order/domain/draft/assigned_staffs_draft.dart';

class MockWorkOrderRemoteDatasource implements WorkOrderRemoteDatasource {
  static const mockUser = UserModel(
    name: "John Doe",
    email: "john@example.com",
    role: UserRole.staffCompany,
  );

  final List<WorkOrderModel> _storage = [
    WorkOrderModel(
      id: "wo-1",
      code: "WO-001",
      configId: "cfg-1",
      serviceRequestId: "req-1",
      service: const ServiceSummaryModel(
        id: "srv-1",
        title: "Cleaning Service",
        description: "General cleaning",
        isActive: true,
        accessType: ServiceAccessType.public,
      ),
      createdBy: mockUser,
      approvedBy: mockUser,
      approvalAccess: WorkOrderAprrovalAccess.staffPic,
      minStaff: 1,
      maxStaff: 5,
      status: WorkOrderStatus.drafted,
      assignedStaffs: const [mockUser, mockUser, mockUser],
      staffPic: mockUser,
      workOrderForm: const FilledFormWithHistoryModel(
        form: FormModel(
          id: "form-1",
          title: "Work Order Intake",
          description: "Intake description",
          formType: FormType.workOrder,
          fields: [
            FieldEntity(
                order: 1, label: "Name", type: FieldType.text, required: true),
            FieldEntity(
                order: 2,
                label: "Address",
                type: FieldType.text,
                required: true),
            FieldEntity(
                order: 3, label: "Phone", type: FieldType.text, required: true),
            FieldEntity(
                order: 4, label: "Email", type: FieldType.text, required: true),
            FieldEntity(
                order: 5,
                label: "Description",
                type: FieldType.text,
                required: true),
          ],
        ),
        submissionHistory: [],
      ),
      hasIssue: false,
      issueNote: "Initial state without any issue.",
      statusDate: WorkOrderStatusDateModel(
        createdAt: DateTime.now(),
        sentAt: null,
        approvedAt: null,
        rejectedAt: null,
        cancelledAt: null,
        startedAt: null,
        completedAt: null,
        failedAt: null,
      ),
    ),
    WorkOrderModel(
      id: "wo-2",
      code: "WO-002",
      configId: "cfg-2",
      serviceRequestId: "req-2",
      service: const ServiceSummaryModel(
        id: "srv-2",
        title: "Repair HVAC",
        description: "Repair HVAC system",
        isActive: true,
        accessType: ServiceAccessType.public,
      ),
      createdBy: mockUser,
      approvedBy: mockUser,
      approvalAccess: WorkOrderAprrovalAccess.staffPic,
      minStaff: 2,
      maxStaff: 4,
      status: WorkOrderStatus.onProgress,
      assignedStaffs: const [mockUser],
      staffPic: mockUser,
      workOrderForm: const FilledFormWithHistoryModel(
        form: FormModel(
          id: "form-2",
          title: "HVAC Repair Form",
          description: "Repair details",
          formType: FormType.workOrder,
          fields: [],
        ),
        submissionHistory: [],
      ),
      hasIssue: true,
      issueNote: "Condenser coil requires cleaning.",
      statusDate: WorkOrderStatusDateModel(
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        sentAt: DateTime.now().subtract(const Duration(days: 1)),
        approvedAt: DateTime.now(),
        rejectedAt: null,
        cancelledAt: null,
        startedAt: DateTime.now(),
        completedAt: null,
        failedAt: null,
      ),
    ),
    WorkOrderModel(
      id: "wo-3",
      code: "WO-003",
      configId: "cfg-3",
      serviceRequestId: "req-3",
      service: const ServiceSummaryModel(
        id: "srv-3",
        title: "Electrical Inspection",
        description: "Yearly inspection",
        isActive: true,
        accessType: ServiceAccessType.public,
      ),
      createdBy: mockUser,
      approvedBy: mockUser,
      approvalAccess: WorkOrderAprrovalAccess.staffPic,
      minStaff: 1,
      maxStaff: 2,
      status: WorkOrderStatus.completed,
      assignedStaffs: const [mockUser],
      staffPic: mockUser,
      workOrderForm: const FilledFormWithHistoryModel(
        form: FormModel(
          id: "form-3",
          title: "Inspection Details",
          description: "Details for the inspection",
          formType: FormType.workOrder,
          fields: [],
        ),
        submissionHistory: [],
      ),
      hasIssue: false,
      issueNote: "All systems go. No issues.",
      statusDate: WorkOrderStatusDateModel(
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        sentAt: DateTime.now().subtract(const Duration(days: 4)),
        approvedAt: DateTime.now().subtract(const Duration(days: 3)),
        rejectedAt: null,
        cancelledAt: null,
        startedAt: DateTime.now().subtract(const Duration(days: 2)),
        completedAt: DateTime.now().subtract(const Duration(days: 1)),
        failedAt: null,
      ),
    ),
  ];

  void _checkError(String id) {
    if (id == "error") {
      throw ApiException(400, "Simulated Error");
    }
  }

  Map<String, dynamic> _getMockMeta() {
    return {
      "workOrderCapabilities": {
        "can_start": true,
        "can_complete": true,
        "can_fail": true,
      },
      "workOrderSiblings": {
        "_id": "wo-sib-1",
        "code": "WO-SIB-001",
        "status": "drafted",
      }
    };
  }

  WorkOrderModel _updateStatus(
    String id,
    WorkOrderStatus newStatus, {
    String? setIssueNote,
    bool updateHasIssue = false,
  }) {
    _checkError(id);
    final index = _storage.indexWhere((e) => e.id == id);
    if (index == -1) {
      throw ApiException(404, "Not found");
    }

    final existing = _storage[index];
    final updated = WorkOrderModel(
      id: existing.id,
      code: existing.code,
      configId: existing.configId,
      serviceRequestId: existing.serviceRequestId,
      service: existing.service,
      createdBy: existing.createdBy,
      approvedBy: existing.approvedBy,
      approvalAccess: existing.approvalAccess,
      minStaff: existing.minStaff,
      maxStaff: existing.maxStaff,
      status: newStatus,
      assignedStaffs: existing.assignedStaffs,
      staffPic: existing.staffPic,
      workOrderForm: existing.workOrderForm,
      hasIssue: updateHasIssue ? (setIssueNote != null) : existing.hasIssue,
      issueNote: setIssueNote ?? existing.issueNote,
      statusDate: existing.statusDate,
    );

    _storage[index] = updated;
    return updated;
  }

  @override
  ApiFutureList<WorkOrderModel> getWorkOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ApiResponse(
      message: "Success get work orders",
      data: _storage,
    );
  }

  @override
  ApiFutureWithMeta<WorkOrderModel> getWorkOrderById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _checkError(id);
    final index = _storage.indexWhere((e) => e.id == id);
    if (index == -1) {
      throw ApiException(404, "Not found");
    }
    return ApiResponseWithMeta(
      message: "Success get detail",
      data: _storage[index],
      meta: _getMockMeta(),
    );
  }

  @override
  ApiFutureWithMeta<WorkOrderModel> createWorkOrder(String serviceId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _checkError(serviceId);
    return ApiResponseWithMeta(
      message: "Success create work order",
      data: _storage.first, // Just returning the first mock for simplicity
      meta: _getMockMeta(),
    );
  }

  @override
  ApiFutureWithMeta<WorkOrderModel> recreateWorkOrder(
      String workOrderId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _checkError(workOrderId);
    return ApiResponseWithMeta(
      message: "Success recreate work order",
      data: _storage.first,
      meta: _getMockMeta(),
    );
  }

  @override
  ApiFutureWithMeta<WorkOrderModel> submitWorkOrderSubmission(
    String workOrderId,
    SubmissionsModel submissions,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final updated = _updateStatus(workOrderId, WorkOrderStatus.drafted);
    return ApiResponseWithMeta(
      message: "Success set submissions",
      data: updated,
      meta: _getMockMeta(),
    );
  }

  @override
  ApiFutureWithMeta<WorkOrderModel> assignStaffs(
    String workOrderId,
    AssignedStaffsDraft staffsDraft,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final updated = _updateStatus(workOrderId, WorkOrderStatus.drafted);
    return ApiResponseWithMeta(
      message: "Success set assigned staffs",
      data: updated,
      meta: _getMockMeta(),
    );
  }

  @override
  ApiFutureWithMeta<WorkOrderModel> sendWorkOrder(String workOrderId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final updated = _updateStatus(workOrderId, WorkOrderStatus.sent);
    return ApiResponseWithMeta(
      message: "Success send work order",
      data: updated,
      meta: _getMockMeta(),
    );
  }

  @override
  ApiFutureWithMeta<WorkOrderModel> cancelWorkOrder(String workOrderId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final updated = _updateStatus(workOrderId, WorkOrderStatus.cancelled);
    return ApiResponseWithMeta(
      message: "Success cancel work order",
      data: updated,
      meta: _getMockMeta(),
    );
  }

  @override
  ApiFutureWithMeta<WorkOrderModel> approveWorkOrder(String workOrderId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final updated = _updateStatus(workOrderId, WorkOrderStatus.approved);
    return ApiResponseWithMeta(
      message: "Success approve work order",
      data: updated,
      meta: _getMockMeta(),
    );
  }

  @override
  ApiFutureWithMeta<WorkOrderModel> rejectWorkOrder(
    String workOrderId,
    String? issueNote,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final updated = _updateStatus(workOrderId, WorkOrderStatus.rejected,
        setIssueNote: issueNote, updateHasIssue: true);
    return ApiResponseWithMeta(
      message: "Success reject work order",
      data: updated,
      meta: _getMockMeta(),
    );
  }

  @override
  ApiFutureWithMeta<WorkOrderModel> startWorkOrder(String workOrderId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final updated = _updateStatus(workOrderId, WorkOrderStatus.onProgress);
    return ApiResponseWithMeta(
      message: "Success start work order",
      data: updated,
      meta: _getMockMeta(),
    );
  }

  @override
  ApiFutureWithMeta<WorkOrderModel> completeWorkOrder(
    String workOrderId,
    String? issueNote,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final updated = _updateStatus(workOrderId, WorkOrderStatus.completed,
        setIssueNote: issueNote, updateHasIssue: true);
    return ApiResponseWithMeta(
      message: "Success complete work order",
      data: updated,
      meta: _getMockMeta(),
    );
  }

  @override
  ApiFutureWithMeta<WorkOrderModel> failWorkOrder(
    String workOrderId,
    String issueNote,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final updated = _updateStatus(workOrderId, WorkOrderStatus.failed,
        setIssueNote: issueNote, updateHasIssue: true);
    return ApiResponseWithMeta(
      message: "Success fail work order",
      data: updated,
      meta: _getMockMeta(),
    );
  }
}
