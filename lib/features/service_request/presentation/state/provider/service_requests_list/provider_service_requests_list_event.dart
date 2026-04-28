import 'package:equatable/equatable.dart';

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
