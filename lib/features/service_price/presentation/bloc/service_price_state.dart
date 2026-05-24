import 'package:equatable/equatable.dart';
import 'package:workorder_company_app/features/service_price/domain/entities/service_price_entity.dart';

enum ServicePriceStatus { initial, loading, loaded, success, error }

class ServicePriceState extends Equatable {
  final List<ServicePriceEntity> servicePrices;
  final ServicePriceStatus status;
  final String? errorMessage;
  
  final bool isAction;
  final bool isActionSuccess;
  final String? actionErrorMessage;

  const ServicePriceState({
    this.servicePrices = const [],
    this.status = ServicePriceStatus.initial,
    this.errorMessage,
    this.isAction = false,
    this.isActionSuccess = false,
    this.actionErrorMessage,
  });

  ServicePriceState copyWith({
  List<ServicePriceEntity>? servicePrices,
  ServicePriceStatus? status,
  String? Function()? errorMessage,
  bool? isAction,
  bool? isActionSuccess,
  String? Function()? actionErrorMessage,
}) {
  return ServicePriceState(
    servicePrices: servicePrices ?? this.servicePrices,
    status: status ?? this.status,
    errorMessage:
        errorMessage != null
            ? errorMessage()
            : this.errorMessage,
    isAction: isAction ?? this.isAction,
    isActionSuccess:
        isActionSuccess ?? this.isActionSuccess,
    actionErrorMessage:
        actionErrorMessage != null
            ? actionErrorMessage()
            : this.actionErrorMessage,
  );
}

  @override
  List<Object?> get props => [
        servicePrices,
        status,
        errorMessage,
        isAction,
        isActionSuccess,
        actionErrorMessage,
      ];
}
