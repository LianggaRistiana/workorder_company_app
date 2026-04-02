import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_summary_entity.dart';

abstract class ServicesRepository {
  // Public Service
  FutureEitherList<ServiceSummaryEntity> getPublicServices(String companyId);
  FutureEither<ServiceEntity> getPublicServiceById(String id);

  // Internal Service Management
  FutureEitherList<ServiceSummaryEntity> getServices({bool forceRefresh = false});
  FutureEither<ServiceEntity> getServiceById(String id);
  FutureEither<ServiceEntity> createService(ServiceEntity service);
  FutureEither<ServiceEntity> updateService(ServiceEntity service);
  FutureEither<ServiceEntity> removeService(String serviceId);
  FutureEither<ServiceEntity> toggleActiveStatus(ServiceEntity service);
}
