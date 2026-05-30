import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/service_request/domain/params/service_request_params.dart';

abstract class ProviderServiceRequestsListEvent extends Equatable {
  const ProviderServiceRequestsListEvent();

  @override
  List<Object> get props => [];
}

class GetProviderServiceRequestsRequested
    extends ProviderServiceRequestsListEvent {
  final bool forceRefresh;

  const GetProviderServiceRequestsRequested({this.forceRefresh = false});

  @override
  List<Object> get props => [forceRefresh];
}

class SetServiceRequestFilter extends ProviderServiceRequestsListEvent {
  final ServiceRequestParams params;

  const SetServiceRequestFilter(this.params);

  @override
  List<Object> get props => [params];
}
