import 'package:workorder_company_app/core/services/cache/list_cache_helper.dart';
import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/either_helper.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/services/data/datasources/internal_services_management_remote_datasource.dart';
import 'package:workorder_company_app/features/services/data/datasources/public_services_remote_datasource.dart';
import 'package:workorder_company_app/features/services/data/model/service_model.dart';
import 'package:workorder_company_app/features/services/data/model/service_summary_model.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_summary_entity.dart';
import 'package:workorder_company_app/features/services/domain/repositories/services_repository.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  final InternalServicesManagementRemoteDatasource _internalRemoteDatasource;
  final PublicServicesRemoteDatasource _publicRemoteDatasource;

  final ListCacheHelper<ServiceSummaryEntity> _cache = ListCacheHelper();

  ServicesRepositoryImpl(
      this._internalRemoteDatasource, this._publicRemoteDatasource);

  @override
  FutureEither<ServiceEntity> createService(ServiceEntity service) async {
    final result = await safeCall(() async {
      final payload = await _internalRemoteDatasource
          .createService(ServiceModel.fromEntity(service));
      return payload.data;
    });

    return result.onSuccess((updated) {
      _cache.mergeSingle(
        updated.toSummaryEntity(),
        (a, b) => a.id == b.id,
      );
    });
  }

  @override
  FutureEither<ServiceEntity> getPublicServiceDetail(String id) {
    // TODO[High]: implement getPublicServiceById
    throw UnimplementedError();
  }

  @override
  FutureEitherList<ServiceSummaryEntity> getPublicServices(String companyId) {
    return safeCall(() async {
      final payload =
          await _publicRemoteDatasource.getPublicServices(companyId);
      return payload.data;
    });
  }

  @override
  FutureEither<ServiceEntity> getServiceById(String id) {
    return safeCall(() async {
      final service = await _internalRemoteDatasource.getServiceById(id);
      return service.data;
    });
  }

  @override
  FutureEitherList<ServiceSummaryEntity> getServices(
      {bool forceRefresh = false}) {
    return _cache.fetchList(
      remoteCall: () async {
        final response = await _internalRemoteDatasource.getServices();
        return response.data;
      },
      forceRefresh: forceRefresh,
    );
  }

  @override
  FutureEither<ServiceEntity> updateService(ServiceEntity service) async {
    final result = await safeCall(() async {
      final payload = await _internalRemoteDatasource
          .updateService(ServiceModel.fromEntity(service));
      return payload.data;
    });

    return result.onSuccess((updated) {
      _cache.removeSingle(
        ServiceSummaryModel.fromServiceEntity(service),
        (a, b) => a.id == b.id,
      );
      _cache.mergeSingle(
        updated.toSummaryEntity(),
        (a, b) => a.id == b.id,
      );
    });
  }

  @override
  FutureEither<ServiceEntity> removeService(String serviceId) async {
    final result = await safeCall(() async {
      final payload = await _internalRemoteDatasource.removeService(serviceId);
      return payload.data;
    });

    return result.onSuccess((updated) {
      _cache.removeSingle(
        ServiceSummaryModel.fromServiceEntity(updated),
        (a, b) => a.id == b.id,
      );
    });
  }

  @override
  FutureEither<ServiceEntity> toggleActiveStatus(ServiceEntity service) {
    return safeCall(() async {
      final payload = await _internalRemoteDatasource
          .toggleActive(ServiceModel.fromEntity(service));
      return payload.data;
    });
  }

  @override
  void clearCache() {
    _cache.clear();
  }
}
