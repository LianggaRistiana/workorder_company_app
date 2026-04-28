import 'dart:async';

import 'package:workorder_company_app/core/services/cache/list_cache_helper.dart';
import 'package:workorder_company_app/core/services/network/api_response.dart';
import 'package:workorder_company_app/core/result/result.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/either_helper.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';
import 'package:workorder_company_app/features/submissions/domain/entitties/submission_entity.dart';
import 'package:workorder_company_app/features/work_order/data/datasources/work_order_remote_datasource.dart';
import 'package:workorder_company_app/features/work_order/domain/draft/assigned_staffs_draft.dart';
import 'package:workorder_company_app/features/work_order/domain/entities/work_order_entity.dart';
import 'package:workorder_company_app/features/work_order/domain/meta/work_order_meta.dart';
import 'package:workorder_company_app/features/work_order/domain/repositories/work_order_repository.dart';

class WorkOrderRepositoryImpl implements WorkOrderRepository {
  final WorkOrderRemoteDatasource _remoteDatasource;

  final _refreshController = StreamController<void>.broadcast();

  @override
  Stream<void> get cacheChanged => _refreshController.stream;

  final ListCacheHelper<WorkOrderEntity> _cache = ListCacheHelper();

  WorkOrderRepositoryImpl(this._remoteDatasource);

  void _notifyChanged() {
    _refreshController.add(null);
  }

  late final Map<String, ResultMeta Function(dynamic)> _metaFactories = {
    "workOrderCapabilities": (json) => WorkOrderCapabilities.fromJson(json),
    "workOrderSiblings": (json) => WorkOrderSiblings.fromJson(json),
  };

  FutureEitherWithMeta<WorkOrderEntity> _handleMetaCall(
    Future<ApiResponseWithMeta<WorkOrderEntity>> Function() remoteCall, {
    bool clearCache = false,
  }) async {
    final result = await safeCall(() async {
      final response = await remoteCall();
      return response.toResultDynamic(metaFactories: _metaFactories);
    });

    return result.onSuccess((updated) {
      if (clearCache) {
        _cache.clear();
      } else {
        _cache.mergeSingle(
          updated.data,
          (a, b) => a.id == b.id,
        );
      }
      _notifyChanged();
    });
  }

  // ==============================
  // List
  // ==============================

  @override
  FutureEitherList<WorkOrderEntity> getWorkOrders({
    bool forceRefresh = false,
  }) {
    return _cache.fetchList(
      remoteCall: () async {
        final response = await _remoteDatasource.getWorkOrders();
        return response.data;
      },
      forceRefresh: forceRefresh,
    );
  }

  // ==============================
  // Single WorkOrder Operations
  // ==============================

  @override
  FutureEitherWithMeta<WorkOrderEntity> getWorkOrderById(
    String workOrderId,
  ) {
    return _handleMetaCall(
      () => _remoteDatasource.getWorkOrderById(workOrderId),
    );
  }

  @override
  FutureEitherWithMeta<WorkOrderEntity> createWorkOrder(
    String serviceId,
  ) {
    return _handleMetaCall(
      () => _remoteDatasource.createWorkOrder(serviceId),
      clearCache: true,
    );
  }

  @override
  FutureEitherWithMeta<WorkOrderEntity> approveWorkOrder(
    String workOrderId,
  ) {
    return _handleMetaCall(
      () => _remoteDatasource.approveWorkOrder(workOrderId),
    );
  }

  @override
  FutureEitherWithMeta<WorkOrderEntity> rejectWorkOrder(
    String workOrderId,
    String? issueNote,
  ) {
    return _handleMetaCall(
      () => _remoteDatasource.rejectWorkOrder(workOrderId, issueNote),
    );
  }

  @override
  FutureEitherWithMeta<WorkOrderEntity> cancelWorkOrder(
    String workOrderId,
  ) {
    return _handleMetaCall(
      () => _remoteDatasource.cancelWorkOrder(workOrderId),
      clearCache: true,
    );
  }

  @override
  FutureEitherWithMeta<WorkOrderEntity> recreateWorkOrder(
    String workOrderId,
  ) {
    return _handleMetaCall(
      () => _remoteDatasource.recreateWorkOrder(workOrderId),
    );
  }

  @override
  FutureEitherWithMeta<WorkOrderEntity> sendWorkOrder(
    String workOrderId,
  ) {
    return _handleMetaCall(
      () => _remoteDatasource.sendWorkOrder(workOrderId),
    );
  }

  @override
  FutureEitherWithMeta<WorkOrderEntity> startWorkOrder(
    String workOrderId,
  ) {
    return _handleMetaCall(
      () => _remoteDatasource.startWorkOrder(workOrderId),
    );
  }

  @override
  FutureEitherWithMeta<WorkOrderEntity> completeWorkOrder(
    String workOrderId,
    String? issueNote,
  ) {
    return _handleMetaCall(
      () => _remoteDatasource.completeWorkOrder(workOrderId, issueNote),
    );
  }

  @override
  FutureEitherWithMeta<WorkOrderEntity> failWorkOrder(
    String workOrderId,
    String issueNote,
  ) {
    return _handleMetaCall(
      () => _remoteDatasource.failWorkOrder(workOrderId, issueNote),
    );
  }

  @override
  FutureEitherWithMeta<WorkOrderEntity> assignStaffs(
    String workOrderId,
    AssignedStaffsDraft staffDraft,
  ) {
    return _handleMetaCall(
      () => _remoteDatasource.assignStaffs(workOrderId, staffDraft),
    );
  }

  @override
  FutureEitherWithMeta<WorkOrderEntity> submitWorkOrderSubmission(
    String workOrderId,
    SubmissionEntity submissions,
  ) {
    return _handleMetaCall(
      () => _remoteDatasource.submitWorkOrderSubmission(
        workOrderId,
        SubmissionsModel.fromEntity(submissions),
      ),
    );
  }

  @override
  void clearCache() {
    _cache.clear();
  }
}
