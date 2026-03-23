import 'package:workorder_company_app/core/constants/app_enums.dart';

abstract class BaseServiceEntity{
  String get id;
  String get title;
  String get description;
  ServiceAccessType get accessType;
  bool get isActive;
}