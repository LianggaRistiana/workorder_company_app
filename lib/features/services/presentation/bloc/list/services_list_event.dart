import 'package:workorder_company_app/features/services/domain/params/service_params.dart';

sealed class ServicesListEvent {}

class GetServicesRequested extends ServicesListEvent {
  final bool forceRefresh;
  GetServicesRequested({this.forceRefresh = false});
}

class SetServiceFilterRequested extends ServicesListEvent {
  final ServiceParams filter;
  SetServiceFilterRequested(this.filter);
}
