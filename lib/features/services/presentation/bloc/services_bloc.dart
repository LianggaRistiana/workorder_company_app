import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workorder_company_app/features/services/domain/entities/service_entity.dart';
import 'package:workorder_company_app/features/services/domain/usecases/get_services_usecase.dart';

part 'services_event.dart';
part 'services_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final GetServicesUsecase getServicesUsecase;
  // final GetServiceByIdUsecase getServiceByIdUsecase;

  ServicesBloc({
    required this.getServicesUsecase,
    // required this.getServiceByIdUsecase,
  }) : super(ServicesInitial()) {
    on<GetServicesRequested>(_onServicesRequested);
    // on<GetServiceByIdRequested>(_onServiceByIdRequested);
  }

  /// 🔹 Ambil semua services
  Future<void> _onServicesRequested(
    GetServicesRequested event,
    Emitter<ServicesState> emit,
  ) async {
    emit(ServicesLoading());

    final result = await getServicesUsecase();
    result.fold(
      (failure) => emit(ServicesError(failure.message)),
      (services) => emit(ServicesLoaded(services: services)),
    );
  }

  /// 🔹 Ambil detail service berdasarkan ID
  // Future<void> _onServiceByIdRequested(
  //   GetServiceByIdRequested event,
  //   Emitter<ServicesState> emit,
  // ) async {
  //   if (state is ServicesLoaded) {
  //     final current = state as ServicesLoaded;
  //     emit(current.copyWith(isSubLoading: true, errorMessage: null));
  //     Logger().i("Fetching service by id from loaded state");

  //     final result = await getServiceByIdUsecase(event.id);
  //     result.fold(
  //       (failure) => emit(
  //         current.copyWith(
  //           isSubLoading: false,
  //           errorMessage: failure.message,
  //         ),
  //       ),
  //       (service) => emit(
  //         current.copyWith(
  //           isSubLoading: false,
  //           selectedService: service,
  //         ),
  //       ),
  //     );
  //   } else {
  //     emit(ServicesLoading());
  //     final result = await getServiceByIdUsecase(event.id);
  //     result.fold(
  //       (failure) => emit(ServicesError(failure.message)),
  //       (service) {
  //         Logger().i("Fetched ${service.title}");
  //         emit(ServicesLoaded(services: const [], selectedService: service));
  //       },
  //     );
  //   }
  // }
}
