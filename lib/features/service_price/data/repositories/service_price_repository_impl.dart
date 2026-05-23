import 'package:workorder_company_app/core/types/future_either.dart';
import 'package:workorder_company_app/core/utils/safe_call.dart';
import 'package:workorder_company_app/features/service_price/data/datasources/service_price_remote_datasource.dart';
import 'package:workorder_company_app/features/service_price/data/model/service_price_model.dart';
import 'package:workorder_company_app/features/service_price/domain/entities/service_price_entity.dart';
import 'package:workorder_company_app/features/service_price/domain/repositories/service_price_repository.dart';

class ServicePriceRepositoryImpl implements ServicePriceRepository {
  final ServicePriceRemoteDatasource _remoteDatasource;

  const ServicePriceRepositoryImpl(this._remoteDatasource);

  @override
  FutureEither<ServicePriceEntity> addServicePrice(ServicePriceEntity data) {
    return safeCall(() async {
      final response = await _remoteDatasource
          .addServicePrice(ServicePriceModel.fromEntity(data));
      return response.data;
    });
  }

  @override
  FutureEither<ServicePriceEntity> deleteServicePrice(String id) {
    return safeCall(() async {
      final response = await _remoteDatasource.deleteServicePrice(id);
      return response.data;
    });
  }

  @override
  FutureEitherList<ServicePriceEntity> getServicePrices() {
    return safeCall(() async {
      final response = await _remoteDatasource.getServicePrices();
      return response.data;
    });
  }

  @override
  FutureEither<ServicePriceEntity> updateServicePrice(ServicePriceEntity data) {
    return safeCall(() async {
      final response = await _remoteDatasource
          .updateServicePrice(ServicePriceModel.fromEntity(data));
      return response.data;
    });
  }
}
