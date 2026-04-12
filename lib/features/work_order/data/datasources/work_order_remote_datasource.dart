import 'package:workorder_company_app/core/network/api_client.dart';
import 'package:workorder_company_app/core/network/api_response.dart';
import 'package:workorder_company_app/core/network/endpoints.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/core/utils/safe_mapper.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';
import 'package:workorder_company_app/features/work_order/data/model/work_order_meta_model.dart';
import 'package:workorder_company_app/features/work_order/data/model/work_order_model.dart';
import 'package:workorder_company_app/features/work_order/domain/draft/assigned_staffs_draft.dart';
import 'package:workorder_company_app/shared/utils/string_route_utils.dart';

abstract class WorkOrderRemoteDatasource {
  ApiFutureList<WorkOrderModel> getWorkOrders();
  ApiFutureWithMeta<WorkOrderModel, WorkOrderMetaModel> getWorkOrderById(
      String id);
  ApiFutureWithMeta<WorkOrderModel, WorkOrderMetaModel> createWorkOrder(
      String serviceId);
  ApiFutureWithMeta<WorkOrderModel, WorkOrderMetaModel> recreateWorkOrder(
      String workOrderId);
  ApiFutureWithMeta<WorkOrderModel, WorkOrderMetaModel>
      submitWorkOrderSubmission(
    String workOrderId,
    SubmissionsModel submissions,
  );
  ApiFutureWithMeta<WorkOrderModel, WorkOrderMetaModel> assignStaffs(
    String workOrderId,
    AssignedStaffsDraft staffsDraft,
  );
  ApiFutureWithMeta<WorkOrderModel, WorkOrderMetaModel> sendWorkOrder(
      String workOrderId);
  ApiFutureWithMeta<WorkOrderModel, WorkOrderMetaModel> cancelWorkOrder(
      String workOrderId);
  ApiFutureWithMeta<WorkOrderModel, WorkOrderMetaModel> approveWorkOrder(
      String workOrderId);
  ApiFutureWithMeta<WorkOrderModel, WorkOrderMetaModel> rejectWorkOrder(
    String workOrderId,
    String? issueNote,
  );
  ApiFutureWithMeta<WorkOrderModel, WorkOrderMetaModel> startWorkOrder(
      String workOrderId);
  ApiFutureWithMeta<WorkOrderModel, WorkOrderMetaModel> completeWorkOrder(
    String workOrderId,
    String? issueNote,
  );
  ApiFutureWithMeta<WorkOrderModel, WorkOrderMetaModel> failWorkOrder(
    String workOrderId,
    String issueNote,
  );
}

class WorkOrderRemoteDatasourceImpl implements WorkOrderRemoteDatasource {
  final ApiClient _apiClient;

  WorkOrderRemoteDatasourceImpl(this._apiClient);

  @override
  ApiFutureWithMeta<WorkOrderModel, WorkOrderMetaModel> approveWorkOrder(
      String workOrderId) async {
    final response =
        await _apiClient.patch(Endpoints.workorderApprove.fillId(workOrderId));
    return ApiResponseWithMeta.fromJson(
      response,
      WorkOrderModel.fromJson,
      WorkOrderMetaModel.fromJson,
    );
  }

  @override
  ApiFutureWithMeta<WorkOrderModel, WorkOrderMetaModel> assignStaffs(
      String workOrderId, AssignedStaffsDraft staffsDraft) async {
    final response = await _apiClient.patch(
        Endpoints.workorderSetAssignedStaff.fillId(workOrderId),
        data: staffsDraft.toJson());
    return ApiResponseWithMeta.fromJson(
      response,
      WorkOrderModel.fromJson,
      WorkOrderMetaModel.fromJson,
    );
  }

  @override
  ApiFutureWithMeta<WorkOrderModel, WorkOrderMetaModel> cancelWorkOrder(
      String workOrderId) async {
    final response =
        await _apiClient.patch(Endpoints.workorderCancel.fillId(workOrderId));
    return ApiResponseWithMeta.fromJson(
      response,
      WorkOrderModel.fromJson,
      WorkOrderMetaModel.fromJson,
    );
  }

  @override
  ApiFutureWithMeta<WorkOrderModel, WorkOrderMetaModel> completeWorkOrder(
      String workOrderId, String? issueNote) async {
    final response = await _apiClient.patch(
        Endpoints.workorderComplete.fillId(workOrderId),
        data: {"issue_note": issueNote});
    return ApiResponseWithMeta.fromJson(
      response,
      WorkOrderModel.fromJson,
      WorkOrderMetaModel.fromJson,
    );
  }

  @override
  ApiFutureWithMeta<WorkOrderModel, WorkOrderMetaModel> createWorkOrder(
      String serviceId) async {
    final response =
        await _apiClient.post(Endpoints.workorderCreate.fillId(serviceId));
    return ApiResponseWithMeta.fromJson(
      response,
      WorkOrderModel.fromJson,
      WorkOrderMetaModel.fromJson,
    );
  }

  @override
  ApiFutureWithMeta<WorkOrderModel, WorkOrderMetaModel> failWorkOrder(
      String workOrderId, String issueNote) async {
    final response = await _apiClient.patch(
        Endpoints.workorderFail.fillId(workOrderId),
        data: {"issue_note": issueNote});
    return ApiResponseWithMeta.fromJson(
      response,
      WorkOrderModel.fromJson,
      WorkOrderMetaModel.fromJson,
    );
  }

  @override
  ApiFutureWithMeta<WorkOrderModel, WorkOrderMetaModel> getWorkOrderById(
      String id) async {
    final response = await _apiClient.get(Endpoints.workorderDetail.fillId(id));
    return ApiResponseWithMeta.fromJson(
      response,
      WorkOrderModel.fromJson,
      WorkOrderMetaModel.fromJson,
    );
  }

  @override
  ApiFutureList<WorkOrderModel> getWorkOrders() async {
    final response = await _apiClient.get(Endpoints.workorders);
    return ApiResponse.fromJson(
      response,
      (json) => SafeMapper.mapList(
        json,
        (data) => WorkOrderModel.fromJson(data),
      ),
    );
  }

  @override
  ApiFutureWithMeta<WorkOrderModel, WorkOrderMetaModel> recreateWorkOrder(
      String workOrderId) async {
    final response =
        await _apiClient.post(Endpoints.workorderRecreate.fillId(workOrderId));
    return ApiResponseWithMeta.fromJson(
      response,
      WorkOrderModel.fromJson,
      WorkOrderMetaModel.fromJson,
    );
  }

  @override
  ApiFutureWithMeta<WorkOrderModel, WorkOrderMetaModel> rejectWorkOrder(
    String workOrderId,
    String? issueNote,
  ) async {
    final response = await _apiClient.patch(
        Endpoints.workorderReject.fillId(workOrderId),
        data: {"issue_note": issueNote});
    return ApiResponseWithMeta.fromJson(
      response,
      WorkOrderModel.fromJson,
      WorkOrderMetaModel.fromJson,
    );
  }

  @override
  ApiFutureWithMeta<WorkOrderModel, WorkOrderMetaModel> sendWorkOrder(
    String workOrderId,
  ) async {
    final response =
        await _apiClient.patch(Endpoints.workorderSent.fillId(workOrderId));
    return ApiResponseWithMeta.fromJson(
      response,
      WorkOrderModel.fromJson,
      WorkOrderMetaModel.fromJson,
    );
  }

  @override
  ApiFutureWithMeta<WorkOrderModel, WorkOrderMetaModel> startWorkOrder(
      String workOrderId) async {
    final response =
        await _apiClient.patch(Endpoints.workorderStart.fillId(workOrderId));
    return ApiResponseWithMeta.fromJson(
      response,
      WorkOrderModel.fromJson,
      WorkOrderMetaModel.fromJson,
    );
  }

  @override
  ApiFutureWithMeta<WorkOrderModel, WorkOrderMetaModel>
      submitWorkOrderSubmission(
          String workOrderId, SubmissionsModel submissions) async {
    final response = await _apiClient.post(
        Endpoints.workorderSetSubmissions.fillId(workOrderId),
        data: {"submission": submissions.toJson()});
    return ApiResponseWithMeta.fromJson(
      response,
      WorkOrderModel.fromJson,
      WorkOrderMetaModel.fromJson,
    );
  }
}
