import 'dart:async';

import 'package:workorder_company_app/core/constants/app_enums/notification_enum.dart';
import 'package:workorder_company_app/core/services/cache/list_cache_helper.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/either_helper.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/service_request/data/datasources/provider_service_request_remote_datasource.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/repositories/provider_service_request_repository.dart';

class ProviderServiceRequestRepositoryImpl
    implements ProviderServiceRequestRepository {
  final ProviderServiceRequestRemoteDatasource
      _providerServiceRequestDatasource;

  final _refreshController = StreamController<void>.broadcast();

  @override
  Stream<void> get cacheChanged => _refreshController.stream;

  final Stream<ResourceType> _eventBus;

  final ListCacheHelper<ProviderServiceRequestEntity> _cache =
      ListCacheHelper();

  ProviderServiceRequestRepositoryImpl(
    this._providerServiceRequestDatasource,
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
  FutureEither<ProviderServiceRequestEntity> approveServiceRequest(
      String id) async {
    final response = await safeCall(() async {
      final payload =
          await _providerServiceRequestDatasource.approveServiceRequest(id);
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
  FutureEitherList<ProviderServiceRequestEntity> getServiceRequests({
    bool forceRefresh = false,
  }) {
    return _cache.fetchList(
      remoteCall: () async {
        final payload =
            await _providerServiceRequestDatasource.getServiceRequests();
        return payload.data;
      },
      forceRefresh: forceRefresh,
    );
  }

  @override
  FutureEither<ProviderServiceRequestEntity> getServiceRequestDetail(
      String id) async {
    return safeCall(() async {
      final payload =
          await _providerServiceRequestDatasource.getServiceRequestDetail(id);
      return payload.data;
    });
  }

  @override
  FutureEither<ProviderServiceRequestEntity> rejectServiceRequest(
      String id) async {
    final response = await safeCall(() async {
      final payload =
          await _providerServiceRequestDatasource.rejectServiceRequest(id);
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
  void clearCache() {
    _cache.clear();
  }
}
