import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';
import 'package:workorder_company_app/features/work_order/data/model/work_order_model.dart';
import 'package:workorder_company_app/features/work_order/domain/draft/assigned_staffs_draft.dart';

abstract class WorkOrderRemoteDatasource {
  ApiFutureList<WorkOrderModel> getWorkOrders({bool forceRefresh = false});
  ApiFuture<WorkOrderModel> getWorkOrderById(String id);
  ApiFuture<WorkOrderModel> createWorkOrder(String serviceId);
  ApiFuture<WorkOrderModel> recreateWorkOrder(String workOrderId);
  ApiFuture<WorkOrderModel> submitWorkOrderSubmission(
    String workOrderId,
    SubmissionsModel submissions,
  );
  ApiFuture<WorkOrderModel> assignStaffs(
    String workOrderId,
    AssignedStaffsDraft staffsDrat,
  );
  ApiFuture<WorkOrderModel> sendWorkOrder(String workOrderId);
  ApiFuture<WorkOrderModel> cancelWorkOrder(String workOrderId);
  ApiFuture<WorkOrderModel> approveWorkOrder(String workOrderId);
  ApiFuture<WorkOrderModel> rejectWorkOrder(String workOrderId);
  ApiFuture<WorkOrderModel> startWorkOrder(String workOrderId);
  ApiFuture<WorkOrderModel> completeWorkOrder(
    String workOrderId,
    String? issueNote,
  );
  ApiFuture<WorkOrderModel> failWorkOrder(
    String workOrderId,
    String issueNote,
  );
}
