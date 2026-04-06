import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/service_request/data/datasources/provider_service_request_datasource.dart';
import 'package:workorder_company_app/features/service_request/domain/entities/service_request_entity.dart';
import 'package:workorder_company_app/features/service_request/domain/repositories/provider_service_request_repository.dart';

class ProviderServiceRequestRepositoryImpl
    implements InternalServiceRequestRepository {
  final ProviderServiceRequestDatasource _providerServiceRequestDatasource;

  const ProviderServiceRequestRepositoryImpl(
      this._providerServiceRequestDatasource);

  @override
  FutureEither<ProviderServiceRequestEntity> approveServiceRequest(String id) {
    return safeCall(() async {
      final payload =
          await _providerServiceRequestDatasource.approveServiceRequest(id);
      return payload.data!;
    });
  }

  @override
  FutureEitherList<ProviderServiceRequestEntity> getServiceRequests() {
    return safeCall(() async {
      final payload =
          await _providerServiceRequestDatasource.getServiceRequests();
      return payload.data ?? [];
    });
  }

  @override
  FutureEither<ProviderServiceRequestEntity> getServiceRequestDetail(
      String id) {
    return safeCall(() async {
      final payload =
          await _providerServiceRequestDatasource.getServiceRequestDetail(id);
      return payload.data!;
    });
  }

  @override
  FutureEither<ProviderServiceRequestEntity> rejectServiceRequest(String id) {
    return safeCall(() async {
      final payload =
          await _providerServiceRequestDatasource.rejectServiceRequest(id);
      return payload.data!;
    });
  }
}
