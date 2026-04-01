import 'package:workorder_company_app/core/model/property_key.dart';

enum PositionProperty implements PropertyKey {
  name("name"),
  description("description");

  @override
  final String key;
  const PositionProperty(this.key);
}