import 'dart:async';
import 'package:workorder_company_app/core/constants/app_enums.dart';
import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';
import 'package:workorder_company_app/core/services/cache/list_cache_helper.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/either_helper.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/forms/domain/entities/form_entity.dart';
import 'package:workorder_company_app/features/forms/domain/entities/work_reports_filled_form_entity.dart';
import 'package:workorder_company_app/features/service_request/data/datasources/requester_service_request_remote_datasource.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/repositories/requester_service_request_repository.dart';
import 'package:workorder_company_app/features/submissions/data/model/submissions_model.dart';
import 'package:workorder_company_app/features/submissions/domain/entities/submission_entity.dart';

class RequesterServiceRequestRepositoryImpl
    implements RequesterServiceRequestRepository {
  final RequesterServiceRequestRemoteDatasource
      _requesterServiceRequestDatasource;

  final _refreshController = StreamController<void>.broadcast();

  final Stream<ResourceType> _eventBus;

  final ListCacheHelper<RequesterServiceRequestEntity> _cache =
      ListCacheHelper();

  @override
  Stream<void> get cacheChanged => _refreshController.stream;

  RequesterServiceRequestRepositoryImpl(
    this._requesterServiceRequestDatasource,
    this._eventBus,
  ) {
    _eventBus.listen((event) {
      if (event == ResourceType.serviceRequest) {
        _cache.clear();
        _notifyChanged();
      }
    });
  }

  void _notifyChanged() {
    _refreshController.add(null);
  }

  @override
  FutureEither<RequesterServiceRequestEntity> cancelServiceRequest(
      String id) async {
    final response = await safeCall(() async {
      final payload =
          await _requesterServiceRequestDatasource.cancelServiceRequest(id);
      return payload.data;
    });

    return response.onSuccess((data) {
      _cache.mergeSingle(
        data,
        (a, b) => a.id == b.id,
      );
      _notifyChanged();
    });
  }

  @override
  FutureEitherList<RequesterServiceRequestEntity> getServiceRequests(
      {bool forceRefresh = false}) {
    return _cache.fetchList(
      remoteCall: () async {
        final payload =
            await _requesterServiceRequestDatasource.getServiceRequests();
        return payload.data;
      },
      forceRefresh: forceRefresh,
    );
  }

  @override
  FutureEither<RequesterServiceRequestEntity> getServiceRequestDetail(
      String id) {
    return safeCall(() async {
      final payload =
          await _requesterServiceRequestDatasource.getServiceRequestDetail(id);
      return payload.data;
    });
  }

  @override
  FutureEither<FormEntity> getIntakeForm(String serviceId, UserRole role) {
    if (role == UserRole.client) {
      return safeCall(() async {
        final payload = await _requesterServiceRequestDatasource
            .getIntakeFormForPublic(serviceId);
        return payload.data;
      });
    }

    return safeCall(() async {
      final payload = await _requesterServiceRequestDatasource
          .getIntakeFormForInternal(serviceId);
      return payload.data;
    });
  }

  @override
  FutureEither<RequesterServiceRequestEntity> submitIntakeForm(
      String serviceId, SubmissionEntity submission) async {
    final response = await safeCall(() async {
      final payload = await _requesterServiceRequestDatasource.submitIntakeForm(
          serviceId, SubmissionsModel.fromEntity(submission));
      return payload.data;
    });

    return response.onSuccess((data) {
      _cache.mergeSingle(
        data,
        (a, b) => a.id == b.id,
      );
      _notifyChanged();
    });
  }

  @override
  FutureEither<RequesterServiceRequestEntity> submitReviewForm(
      String serviceRequestId, SubmissionEntity submission) async {
    final response = await safeCall(() async {
      final payload = await _requesterServiceRequestDatasource.submitReviewForm(
          serviceRequestId, SubmissionsModel.fromEntity(submission));

      return payload.data;
    });

    return response.onSuccess((data) {
      _cache.mergeSingle(
        data,
        (a, b) => a.id == b.id,
      );
      _notifyChanged();
    });
  }

  @override
  FutureEither<FormEntity> getReviewForm(String serviceRequestId) {
    return safeCall(() async {
      final payload = await _requesterServiceRequestDatasource
          .getReviewForm(serviceRequestId);
      return payload.data;
    });
  }

  @override
  void clearCache() {
    _cache.clear();
  }

  @override
  FutureEither<WorkReportsFilledFormEntity> getServiceRequestReport(String id) {
    return safeCall(() async {
      final payload =
          await _requesterServiceRequestDatasource.getServiceRequestReport(id);
      return payload.data;
    });
  }
}
