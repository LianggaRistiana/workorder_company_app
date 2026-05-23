import 'package:faker/faker.dart';
import 'package:workorder_company_app/core/model/mock_factory.dart';
import 'package:workorder_company_app/features/service_price/data/model/service_price_model.dart';
import 'package:workorder_company_app/features/services/data/mock/service_mock_factory.dart';

class ServicePriceFactory implements MockFactory<ServicePriceModel> {
  @override
  Map<String, dynamic> createJson() {
    final ServiceMockFactory serviceMockFactory = ServiceMockFactory();

    return {
      "_id": faker.guid.guid(),
      "serviceId": serviceMockFactory.createJson(),
      "price": faker.randomGenerator.integer(100000),
    };
  }

  @override
  List<ServicePriceModel> createList({int count = 10}) {
    return List.generate(count, (index) => createModel());
  }

  @override
  ServicePriceModel createModel() {
    return ServicePriceModel.fromJson(createJson());
  }
}
