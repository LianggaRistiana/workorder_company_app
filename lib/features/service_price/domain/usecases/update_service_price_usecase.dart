import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/service_price/domain/entities/service_price_entity.dart';
import 'package:workorder_company_app/features/service_price/domain/repositories/service_price_repository.dart';

class UpdateServicePriceUsecase {
  final ServicePriceRepository _repository;

  UpdateServicePriceUsecase(this._repository);

  FutureEither<ServicePriceEntity> call(ServicePriceEntity data) async {
    return await _repository.updateServicePrice(data);
  }
}
