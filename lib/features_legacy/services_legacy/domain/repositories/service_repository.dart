import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features_legacy/services_legacy/domain/entities/service_entity.dart';

abstract class ServiceRepository {
  FutureEitherList<ServiceEntity> getServices();
  FutureEither<ServiceEntity> getService(String id);
  FutureEither<void> createService(ServiceEntity service);
}
