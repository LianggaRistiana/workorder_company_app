import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/service_price/domain/entities/service_price_entity.dart';

abstract class ServicePriceRepository {
  FutureEitherList<ServicePriceEntity> getServicePrices();
  FutureEither<ServicePriceEntity> addServicePrice(ServicePriceEntity data);
  FutureEither<ServicePriceEntity> updateServicePrice(ServicePriceEntity data);
  FutureEither<ServicePriceEntity> deleteServicePrice(String id);
}
