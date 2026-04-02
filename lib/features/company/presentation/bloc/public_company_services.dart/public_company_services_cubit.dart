import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/company/presentation/bloc/public_company_services.dart/public_company_services_state.dart';
import 'package:workorder_company_app/features/services/domain/usecases/public_get_services_usecase.dart';

class PublicCompanyServicesCubit extends Cubit<PublicCompanyServicesState> {
  final PublicGetServicesUsecase _getServicesUsecase;

  PublicCompanyServicesCubit(this._getServicesUsecase)
      : super(const PublicCompanyServicesState());

  Future<void> getServices(String companyId) async {
    emit(state.copyWith(status: PublicCompanyServicesStatus.loading));

    final result = await _getServicesUsecase(companyId);

    result.fold(
      (failure) => emit(state.copyWith(
        status: PublicCompanyServicesStatus.error,
        errorMessage: failure.message,
      )),
      (services) => emit(state.copyWith(
        status: PublicCompanyServicesStatus.loaded,
        services: services,
      )),
    );
  }
}
