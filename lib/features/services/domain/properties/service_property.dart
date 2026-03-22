import 'package:workorder_company_app/core/model/property_key.dart';

enum ServiceProperty implements PropertyKey {
  title("title"),
  description("description"),
  requiredStaff("requiredStaff");

  @override
  final String key;
  const ServiceProperty(this.key);
}
