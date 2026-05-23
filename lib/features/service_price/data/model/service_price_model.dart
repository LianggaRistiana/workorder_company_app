import 'package:workorder_company_app/core/utils/safe_parse.dart';
import 'package:workorder_company_app/features/service_price/domain/entities/service_price_entity.dart';
import 'package:workorder_company_app/features/services/data/model/service_model.dart';

class ServicePriceModel extends ServicePriceEntity {
  const ServicePriceModel({
    required super.id,
    required super.service,
    required super.price,
  });

  factory ServicePriceModel.fromJson(Map<String, dynamic> json) {
    return ServicePriceModel(
      id: json.field("_id").reqString(),
      service: json.field("service").reqModel(ServiceModel.fromJson),
      price: json.field("price").reqInt(),
    );
  }

  factory ServicePriceModel.fromEntity(ServicePriceEntity entity) {
    return ServicePriceModel(
      id: entity.id,
      service: entity.service,
      price: entity.price,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "serviceId": service.id,
      "price": price,
    };
  }
}
