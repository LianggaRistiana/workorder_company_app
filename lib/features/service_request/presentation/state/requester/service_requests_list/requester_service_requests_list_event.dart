import 'package:equatable/equatable.dart';

abstract class RequesterServiceRequestsListEvent extends Equatable {
  const RequesterServiceRequestsListEvent();

  @override
  List<Object> get props => [];
}

class GetRequesterServiceRequestsRequested
    extends RequesterServiceRequestsListEvent {
  final bool isRefresh;

  const GetRequesterServiceRequestsRequested({this.isRefresh = false});

  @override
  List<Object> get props => [isRefresh];
}
