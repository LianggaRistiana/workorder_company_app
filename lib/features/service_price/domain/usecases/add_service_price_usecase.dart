import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/service_price/domain/entities/service_price_entity.dart';
import 'package:workorder_company_app/features/service_price/domain/repositories/service_price_repository.dart';

class AddServicePriceUsecase {
  final ServicePriceRepository _repository;

  AddServicePriceUsecase(this._repository);

  FutureEither<ServicePriceEntity> call(ServicePriceEntity data) async {
    return await _repository.addServicePrice(data);
  }
}
