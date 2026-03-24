sealed class ServicesListEvent {}

class GetServicesRequested extends ServicesListEvent {
  final bool forceRefresh;
  GetServicesRequested({this.forceRefresh = false});
}
