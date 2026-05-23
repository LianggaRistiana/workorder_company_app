import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/service_price/domain/entities/service_price_entity.dart';
import 'package:workorder_company_app/features/service_price/domain/repositories/service_price_repository.dart';

class GetServicePricesUsecase {
  final ServicePriceRepository _repository;

  GetServicePricesUsecase(this._repository);

  FutureEitherList<ServicePriceEntity> call() async {
    return await _repository.getServicePrices();
  }
}
