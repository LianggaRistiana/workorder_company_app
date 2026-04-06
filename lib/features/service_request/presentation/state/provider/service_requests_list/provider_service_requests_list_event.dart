import 'package:equatable/equatable.dart';

abstract class ProviderServiceRequestsListEvent extends Equatable {
  const ProviderServiceRequestsListEvent();

  @override
  List<Object> get props => [];
}

class GetProviderServiceRequestsRequested extends ProviderServiceRequestsListEvent {}
