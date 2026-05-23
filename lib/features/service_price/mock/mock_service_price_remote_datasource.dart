import 'package:workorder_company_app/core/model/mock_factory.dart';
import 'package:workorder_company_app/core/types/future_api.dart';
import 'package:workorder_company_app/features/service_price/data/datasources/service_price_remote_datasource.dart';
import 'package:workorder_company_app/features/service_price/data/model/service_price_model.dart';
import 'package:workorder_company_app/features/service_price/mock/service_price_factory.dart';

class MockServicePriceRemoteDatasource implements ServicePriceRemoteDatasource {
  final MockFactory<ServicePriceModel> _factory = ServicePriceFactory();

  @override
  ApiFuture<ServicePriceModel> addServicePrice(ServicePriceModel model) async {
    await Future.delayed(Duration(seconds: 2));
    return MockApiResponse.success(
      _factory.createModel(),
    );
  }

  @override
  ApiFuture<ServicePriceModel> deleteServicePrice(String id) async {
    await Future.delayed(Duration(seconds: 2));
    return MockApiResponse.success(
      _factory.createModel(),
    );
  }

  @override
  ApiFutureList<ServicePriceModel> getServicePrices() async {
    await Future.delayed(Duration(seconds: 2));
    return MockApiResponse.success(
      _factory.createList(),
    );
  }

  @override
  ApiFuture<ServicePriceModel> updateServicePrice(
      ServicePriceModel model) async {
    await Future.delayed(Duration(seconds: 2));
    return MockApiResponse.success(
      _factory.createModel(),
    );
  }
}
