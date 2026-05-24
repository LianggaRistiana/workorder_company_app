import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/service_price/domain/entities/service_price_entity.dart';
import 'package:workorder_company_app/features/service_price/domain/usecases/add_service_price_usecase.dart';
import 'package:workorder_company_app/features/service_price/domain/usecases/delete_service_price_usecase.dart';
import 'package:workorder_company_app/features/service_price/domain/usecases/get_service_prices_usecase.dart';
import 'package:workorder_company_app/features/service_price/domain/usecases/update_service_price_usecase.dart';
import 'package:workorder_company_app/features/service_price/presentation/bloc/service_price_state.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_summary_entity.dart';

class ServicePriceCubit extends Cubit<ServicePriceState> {
  final GetServicePricesUsecase _getServicePricesUsecase;
  final AddServicePriceUsecase _addServicePriceUsecase;
  final UpdateServicePriceUsecase _updateServicePriceUsecase;
  final DeleteServicePriceUsecase _deleteServicePriceUsecase;

  ServicePriceCubit({
    required GetServicePricesUsecase getServicePricesUsecase,
    required AddServicePriceUsecase addServicePriceUsecase,
    required UpdateServicePriceUsecase updateServicePriceUsecase,
    required DeleteServicePriceUsecase deleteServicePriceUsecase,
  })  : _getServicePricesUsecase = getServicePricesUsecase,
        _addServicePriceUsecase = addServicePriceUsecase,
        _updateServicePriceUsecase = updateServicePriceUsecase,
        _deleteServicePriceUsecase = deleteServicePriceUsecase,
        super(const ServicePriceState());

  Future<void> getServicePrices() async {
    emit(state.copyWith(
      status: ServicePriceStatus.loading,
      errorMessage: () => null,
    ));

    final result = await _getServicePricesUsecase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: ServicePriceStatus.error,
        errorMessage: () => failure.message,
        actionErrorMessage: () => null,
      )),
      (prices) => emit(state.copyWith(
        status: ServicePriceStatus.loaded,
        servicePrices: prices,
      )),
    );
  }

  Future<void> addServicePrice(ServiceSummaryEntity service, int price) async {
    final data = ServicePriceEntity(
      id: '',
      service: service,
      price: price,
    );

    emit(state.copyWith(
      isAction: true,
      isActionSuccess: false,
      actionErrorMessage: () => null,
      errorMessage: () => null,
    ));

    final result = await _addServicePriceUsecase(data);

    result.fold(
      (failure) => emit(state.copyWith(
        isAction: false,
        isActionSuccess: false,
        actionErrorMessage: () => failure.message,
      )),
      (newPrice) {
        final updatedList = List<ServicePriceEntity>.from(state.servicePrices)
          ..add(newPrice);
        emit(state.copyWith(
          isAction: false,
          isActionSuccess: true,
          servicePrices: updatedList,
        ));
      },
    );
  }

  Future<void> updateServicePrice(
      String priceId, ServiceSummaryEntity service, int price) async {
    emit(state.copyWith(
      isAction: true,
      isActionSuccess: false,
      actionErrorMessage: () => null,
      errorMessage: () => null,
    ));

    final data = ServicePriceEntity(
      id: priceId,
      service: service,
      price: price,
    );

    final result = await _updateServicePriceUsecase(data);

    result.fold(
      (failure) => emit(state.copyWith(
        isAction: false,
        isActionSuccess: false,
        actionErrorMessage: () => failure.message,
      )),
      (updatedPrice) {
        final updatedList = state.servicePrices.map((item) {
          return item.id == updatedPrice.id ? updatedPrice : item;
        }).toList();

        emit(state.copyWith(
          isAction: false,
          isActionSuccess: true,
          servicePrices: updatedList,
        ));
      },
    );
  }

  Future<void> deleteServicePrice(String id) async {
    emit(state.copyWith(
      isAction: true,
      isActionSuccess: false,
      actionErrorMessage: () => null,
      errorMessage: () => null,
    ));

    final result = await _deleteServicePriceUsecase(id);

    result.fold(
      (failure) => emit(state.copyWith(
        isAction: false,
        isActionSuccess: false,
        actionErrorMessage: () => failure.message,
      )),
      (deletedPrice) {
        final updatedList =
            state.servicePrices.where((item) => item.id != id).toList();
        emit(state.copyWith(
          isAction: false,
          isActionSuccess: true,
          servicePrices: updatedList,
        ));
      },
    );
  }

  void resetActionStatus() {
    emit(state.copyWith(
      isAction: false,
      isActionSuccess: false,
    ));
  }
}
