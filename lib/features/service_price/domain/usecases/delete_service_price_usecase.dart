import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/features/service_price/domain/entities/service_price_entity.dart';
import 'package:workorder_company_app/features/service_price/domain/repositories/service_price_repository.dart';

class DeleteServicePriceUsecase {
  final ServicePriceRepository _repository;

  DeleteServicePriceUsecase(this._repository);

  FutureEither<ServicePriceEntity> call(String id) async {
    return await _repository.deleteServicePrice(id);
  }
}
