import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/draft/assigned_staffs_draft.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';

abstract class WorkOrderRepository {
  FutureEitherList<WorkOrderEntity> getWorkOrders({bool forceRefresh = false});
  FutureEitherWithMeta<WorkOrderEntity> getWorkOrderById(String workOrderId);
  FutureEitherWithMeta<WorkOrderEntity> createWorkOrder(String serviceId);
  FutureEitherWithMeta<WorkOrderEntity> recreateWorkOrder(String workOrderId);

  /// Update WorkOrder Data
  FutureEitherWithMeta<WorkOrderEntity> submitWorkOrderSubmission(
    String workOrderId,
    SubmissionEntity submissions,
  );
  FutureEitherWithMeta<WorkOrderEntity> assignStaffs(
    String workOrderId,
    AssignedStaffsDraft staffDraft,
  );

  // WorkOrder Action
  FutureEitherWithMeta<WorkOrderEntity> sendWorkOrder(String workOrderId);
  FutureEitherWithMeta<WorkOrderEntity> cancelWorkOrder(String workOrderId);
  FutureEitherWithMeta<WorkOrderEntity> approveWorkOrder(String workOrderId);
  FutureEitherWithMeta<WorkOrderEntity> rejectWorkOrder(
    String workOrderId,
    String? issueNote,
  );
  FutureEitherWithMeta<WorkOrderEntity> startWorkOrder(String workOrderId);
  FutureEitherWithMeta<WorkOrderEntity> completeWorkOrder(
    String workOrderId,
    String? issueNote,
  );
  FutureEitherWithMeta<WorkOrderEntity> failWorkOrder(
    String workOrderId,
    String issueNote,
  );

  Stream<void> get workOrderChanged; // FIXME : Temp Solution, it dont cover to cancel feature that change more than one work order
}
